##%######################################################%##
#                                                          #
####        Script pour créer l'indice pression         ####
####                (version 2023-08-10)                ####
#                                                          #
##%######################################################%##

base::load("output/output_rdata/total_points_dans_mailles.Rdata")

## calcul nb passage
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

## jointure aux mailles
resultat_indice_pression_total <-
  dplyr::left_join(indice_pression_total, 
                   total_maille_5km %>% select(code_insee, id_maille_dpt)) %>% 
  dplyr::ungroup() %>% 
  sf::st_as_sf()


####
### Boucle pour discretiser les valeurs de l'indice pression par départements 

resultat_indice_pression_total_classe <- NULL

for(val in unique(resultat_indice_pression_total$code_insee)) {
  
  tableau <- resultat_indice_pression_total %>% 
    filter(code_insee %in% val)
  
  k_class <- round(1 + 3.22 * log10(nrow(tableau)), 0)
    
  classe <- classInt::classIntervals(tableau$nb_moy, n = k_class+1, style = "jenks")
  
  tableau$classe <- cut(tableau$nb_moy, classe$brks)
  
  resultat_indice_pression_total_classe <- rbind(resultat_indice_pression_total_classe, tableau)
    
}

## sauvegarde
save(resultat_indice_pression_total_classe, file="output/output_rdata/resultat_indice_pression_total_classe.Rdata")
sf::write_sf(resultat_indice_pression_total_classe, "output/output_qgis/resultat_indice_pression_total_classe.gpkg")









