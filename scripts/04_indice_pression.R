##%######################################################%##
#                                                          #
####        Script pour créer l'indice pression         ####
####                (version 2023-08-10)                ####
#                                                          #
##%######################################################%##

base::load("output/output_rdata/total_points_dans_mailles.Rdata")

## Calcul nb passage, tous groupes confondus, toutes espèces ####
cli::cli_h1("Calcul du nombre de passages par mailles, tous groupes, toutes espèces")

indice_pression_total <-
  total_points_dans_mailles %>% 
  sf::st_drop_geometry() %>% 
  dplyr::mutate(annees = as.numeric(substr(date, 1,4))) %>% 
  dplyr::group_by(code_insee, id_maille_dpt, annees) %>% 
  dplyr::summarise(passage = n()) %>%
  dplyr::ungroup() %>% 
  tidyr::complete(annees, nesting(code_insee, id_maille_dpt), fill = list(passage = 0)) %>% 
  dplyr::group_by(code_insee, id_maille_dpt)%>%
  dplyr::summarise(nb_moy = mean(passage),
            nb_moy = round(nb_moy, 0)) %>% 
  dplyr::arrange(code_insee, id_maille_dpt)

## Jointure aux mailles ####
cli::cli_h1("Jointure aux mailles")

resultat_indice_pression_total <-
  dplyr::left_join(indice_pression_total, 
                   total_mailles %>% select(code_insee, id_maille_dpt)) %>% 
  dplyr::ungroup() %>% 
  sf::st_as_sf()

## Boucle pour discretiser les valeurs de l'indice pression par départements ####
cli::cli_h1("Boucle pour discretiser les valeurs de l'indice pression par départements")

resultat_indice_pression_total_classe <- NULL

for(val in unique(resultat_indice_pression_total$code_insee)) {
  
  tableau <- resultat_indice_pression_total %>%
    filter(code_insee %in% val)
  
  k_class <- round(1 + 3.22 * log10(nrow(tableau)), 0)
  
  classe <- classInt::classIntervals(tableau$nb_moy,
                                     n = k_class+1,
                                     style = "jenks",
                                     dataPrecision = 0
  )
  
  tableau$classe <- cut(tableau$nb_moy, classe$brks, include.lowest = FALSE)
  
  tableau <-
    tableau %>%
    mutate(classe_id = as.numeric(classe)) %>%
    mutate(classe_id = if_else(is.na(classe_id), 0, classe_id))
  
  resultat_indice_pression_total_classe <- 
    rbind(resultat_indice_pression_total_classe, tableau)
  
}

## Sauvegarde ####
cli::cli_h1("Sauvegarde")

save(resultat_indice_pression_total_classe, file="output/output_rdata/resultat_indice_pression_total_classe.Rdata")
sf::write_sf(resultat_indice_pression_total_classe, "output/output_qgis/resultat_indice_pression_total_classe.gpkg")


## Calcul nb passage, par groupes taxonomiques, toutes espèces ####
cli::cli_h1("Calcul du nombre de passages par mailles, par groupes taxonomiques, toutes espèces")

indice_pression_total_group <-
  total_points_dans_mailles %>% 
  sf::st_drop_geometry() %>% 
  dplyr::mutate(annees = as.numeric(substr(date, 1,4))) %>% 
  dplyr::group_by(code_insee, id_maille_dpt, annees,groupe_taxo) %>% 
  dplyr::summarise(passage = n()) %>%
  dplyr::ungroup() %>% 
  tidyr::complete(annees, nesting(code_insee, id_maille_dpt), fill = list(passage = 0)) %>% 
  dplyr::group_by(code_insee, id_maille_dpt, groupe_taxo)%>%
  dplyr::summarise(nb_moy = mean(passage),
                   nb_moy = round(nb_moy, 0)) %>% 
  dplyr::arrange(code_insee, id_maille_dpt)

## Jointure aux mailles ####
cli::cli_h1("Jointure aux mailles")

resultat_indice_pression_total_group <-
  dplyr::left_join(indice_pression_total_group, 
                   total_mailles %>% select(code_insee, id_maille_dpt)) %>% 
  dplyr::ungroup() %>% 
  dplyr::mutate(id_maille_group = paste(groupe_taxo, code_insee, sep = "_"))%>%
  sf::st_as_sf()



## Boucle pour discretiser les valeurs de l'indice pression par groupes taxonomiques et départements ####
cli::cli_h1("Boucle pour discretiser les valeurs de l'indice pression par groupes taxonomiques et départements")

resultat_indice_pression_group_classe <- NULL

for(val in unique(resultat_indice_pression_total_group$id_maille_group)) {
  
  tableau <- resultat_indice_pression_total_group %>% 
    filter(id_maille_group %in% val)
  
  k_class <- round(1 + 3.22 * log10(nrow(tableau)), 0)
  
  classe <- classInt::classIntervals(tableau$nb_moy, n = k_class+1, style = "jenks")
  
  tableau$classe <- cut(tableau$nb_moy, classe$brks)
  
  resultat_indice_pression_group_classe <- rbind(resultat_indice_pression_group_classe, tableau)
  
}

tableau <- resultat_indice_pression_total_group %>% 
  filter(id_maille_group %in% val)


## Sauvegarde ####
cli::cli_h1("Sauvegarde")

save(resultat_indice_pression_group_classe, file="output/output_rdata/resultat_indice_pression_group_classe.Rdata")
sf::write_sf(resultat_indice_pression_group_classe, "output/output_qgis/resultat_indice_pression_group_classe.gpkg")





## Calcul nb passage, tous groupes confondus, espèces protégées ####
cli::cli_h1("Calcul du nombre de passages par mailles, tous groupes, espèces protégées")

indice_pression_total_pro <-
  total_points_dans_mailles_esp_pro %>% 
  sf::st_drop_geometry() %>% 
  dplyr::mutate(annees = as.numeric(substr(date, 1,4))) %>% 
  dplyr::group_by(code_insee, id_maille_dpt, annees) %>% 
  dplyr::summarise(passage = n()) %>%
  dplyr::ungroup() %>% 
  tidyr::complete(annees, nesting(code_insee, id_maille_dpt), fill = list(passage = 0)) %>% 
  dplyr::group_by(code_insee, id_maille_dpt)%>%
  dplyr::summarise(nb_moy = mean(passage),
                   nb_moy = round(nb_moy, 0)) %>% 
  dplyr::arrange(code_insee, id_maille_dpt)

## Jointure aux mailles ####
cli::cli_h1("Jointure aux mailles")

resultat_indice_pression_total_pro <-
  dplyr::left_join(indice_pression_total_pro, 
                   total_mailles %>% select(code_insee, id_maille_dpt)) %>% 
  dplyr::ungroup() %>% 
  sf::st_as_sf()

## Boucle pour discretiser les valeurs de l'indice pression par départements ####
cli::cli_h1("Boucle pour discretiser les valeurs de l'indice pression par départements")

resultat_indice_pression_total_classe_pro <- NULL

for(val in unique(resultat_indice_pression_total_pro$code_insee)) {
  
  tableau <- resultat_indice_pression_total_pro %>% 
    filter(code_insee %in% val)
  
  k_class <- round(1 + 3.22 * log10(nrow(tableau)), 0)
  
  classe <- classInt::classIntervals(tableau$nb_moy, n = k_class+1, style = "jenks")
  
  tableau$classe <- cut(tableau$nb_moy, classe$brks)
  
  resultat_indice_pression_total_classe_pro <- rbind(resultat_indice_pression_total_classe_pro, tableau)
  
}

## Sauvegarde ####
cli::cli_h1("Sauvegarde")

save(resultat_indice_pression_total_classe_pro, file="output/output_rdata/resultat_indice_pression_total_classe_pro.Rdata")
sf::write_sf(resultat_indice_pression_total_classe_pro, "output/output_qgis/resultat_indice_pression_total_classe_pro.gpkg")








## Calcul nb passage, par groupes taxonomiques, toutes espèces ####
cli::cli_h1("Calcul du nombre de passages par mailles, par groupes taxonomiques, toutes espèces")

indice_pression_total_group_pro <-
  total_points_dans_mailles_esp_pro %>% 
  sf::st_drop_geometry() %>% 
  dplyr::mutate(annees = as.numeric(substr(date, 1,4))) %>% 
  dplyr::group_by(code_insee, id_maille_dpt, annees,groupe_taxo) %>% 
  dplyr::summarise(passage = n()) %>%
  dplyr::ungroup() %>% 
  tidyr::complete(annees, nesting(code_insee, id_maille_dpt), fill = list(passage = 0)) %>% 
  dplyr::group_by(code_insee, id_maille_dpt, groupe_taxo)%>%
  dplyr::summarise(nb_moy = mean(passage),
                   nb_moy = round(nb_moy, 0)) %>% 
  dplyr::arrange(code_insee, id_maille_dpt)

## Jointure aux mailles ####
cli::cli_h1("Jointure aux mailles")

resultat_indice_pression_total_group_pro <-
  dplyr::left_join(indice_pression_total_group_pro, 
                   total_mailles %>% select(code_insee, id_maille_dpt)) %>% 
  dplyr::ungroup() %>% 
  dplyr::mutate(id_maille_group = paste(groupe_taxo, code_insee, sep = "_"))%>%
  sf::st_as_sf()



## Boucle pour discretiser les valeurs de l'indice pression par départements ####
cli::cli_h1("Boucle pour discretiser les valeurs de l'indice pression par départements")

resultat_indice_pression_group_classe_pro <- NULL

for(val in unique(resultat_indice_pression_total_group_pro$id_maille_group)) {
  
  tableau <- resultat_indice_pression_total_group_pro %>% 
    filter(id_maille_group %in% val)
  
  k_class <- round(1 + 3.22 * log10(nrow(tableau)), 0)
  
  classe <- classInt::classIntervals(tableau$nb_moy, n = k_class+1, style = "jenks")
  
  #tableau$classe <- cut(tableau$nb_moy, classe$brks)
  
  resultat_indice_pression_group_classe_pro <- rbind(resultat_indice_pression_group_classe_pro, tableau)
  
}

## Sauvegarde ####
cli::cli_h1("Sauvegarde")

save(resultat_indice_pression_group_classe_pro, file="output/output_rdata/resultat_indice_pression_group_classe_pro.Rdata")
sf::write_sf(resultat_indice_pression_group_classe_pro, "output/output_qgis/resultat_indice_pression_group_classe_pro.gpkg")







