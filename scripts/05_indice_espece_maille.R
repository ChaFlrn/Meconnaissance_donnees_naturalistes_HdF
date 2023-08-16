##%######################################################%##
#                                                          #
####        Script pour créer l'indice esp/maille       ####
####                (version 2023-08-10)                ####
#                                                          #
##%######################################################%##

#------------------------------------------------------------------------------#
# Chargement des valeurs seuils ####
table_seuil_departement <- read.csv(file="data/valeurs_seuils.csv", h=T, dec=",", sep=";")

#------------------------------------------------------------------------------#
# Calcul indice espèce maille, toutes espèces, tous groupes taxonomiques ####
cli::cli_h1("Toutes espèces, tous groupes")

base::load("output/output_rdata/total_points_dans_mailles.Rdata")

resultat_indice_espece_maille <-
  total_points_dans_mailles %>% 
  sf::st_drop_geometry() %>% 
  group_by(code_insee, groupe_taxo, id_maille_dpt) %>% 
  summarise(nb_esp = length(unique(cd_nom))) %>% 
  dplyr::ungroup() %>% 
  tidyr::complete(groupe_taxo, nesting(code_insee, id_maille_dpt), fill = list(nb_esp = 0)) 
  

indice_espece_maille_final <-
  # jointure
  left_join(resultat_indice_espece_maille, 
          table_seuil_departement %>% dplyr::select(groupe_taxo = groupe, seuil_dept)) %>%
  # colonne seuil
  mutate(div_spec = if_else(nb_esp < seuil_dept, 0, 1)) %>%
  # calcul par dpt
  group_by(code_insee, id_maille_dpt) %>% 
  summarise(moy_div_spec = mean(div_spec)) %>% 
  ungroup() %>% 
  # classement indice
  mutate(moy_div_spec_class = case_when(moy_div_spec == 0 ~ "Tres mauvaise",
                                        between(moy_div_spec, 0, 0.5) ~ "Moyenne",
                                        between(moy_div_spec, 0.5, 1) ~ "Bonne",
                                        TRUE ~ "Tres bonne"))

# jointure aux coordonnées des mailles
resultat_indice_espece_maille <-
  indice_espece_maille_final %>% 
  left_join(total_mailles %>% select(code_insee, id_maille_dpt))

## sauvegarde
save(resultat_indice_espece_maille, file="output/output_rdata/resultat_indice_espece_maille.Rdata")
#sf::write_sf(resultat_indice_espece_maille, "output/output_qgis/resultat_indice_espece_maille.gpkg")


#------------------------------------------------------------------------------#
# Calcul indice espece maille, toutes espèces, par groupes taxonomiques ####
cli::cli_h1("Toutes espèces, par groupes")

resultat_indice_espece_maille_grp <-
  total_points_dans_mailles %>% 
  sf::st_drop_geometry() %>% 
  group_by(code_insee, groupe_taxo, id_maille_dpt) %>% 
  summarise(nb_esp = length(unique(cd_nom))) %>% 
  dplyr::ungroup() %>% 
  tidyr::complete(groupe_taxo, nesting(code_insee, id_maille_dpt), fill = list(nb_esp = 0)) 

indice_espece_maille_final_grp <-
  # jointure
  left_join(resultat_indice_espece_maille_grp, 
            table_seuil_departement %>% dplyr::select(groupe_taxo = groupe, seuil_dept)) %>%
  # colonne seuil
  mutate(div_spec = if_else(nb_esp < seuil_dept, 0, 1))

# jointure aux coordonnées des mailles
resultat_indice_espece_maille_grp <-
  indice_espece_maille_final_grp %>% 
  left_join(total_mailles %>% select(code_insee, id_maille_dpt))

## sauvegarde
save(resultat_indice_espece_maille_grp, file="output/output_rdata/resultat_indice_espece_maille_grp.Rdata")
#sf::write_sf(resultat_indice_espece_maille_grp, "output/output_qgis/resultat_indice_espece_maille_grp.gpkg")


#------------------------------------------------------------------------------#
# Calcul indice espèce maille, espèces protégées, tous groupes taxonomiques ####
cli::cli_h1("Espèces protégées, tous groupes")

base::load("output/output_rdata/total_points_dans_mailles_esp_pro.Rdata")

resultat_indice_espece_maille_pro <-
  total_points_dans_mailles_esp_pro %>% 
  sf::st_drop_geometry() %>% 
  group_by(code_insee, groupe_taxo, id_maille_dpt) %>% 
  summarise(nb_esp = length(unique(cd_nom))) %>% 
  dplyr::ungroup() %>% 
  tidyr::complete(groupe_taxo, nesting(code_insee, id_maille_dpt), fill = list(nb_esp = 0)) 


indice_espece_maille_final_pro <-
  # jointure
  left_join(resultat_indice_espece_maille_pro, 
            table_seuil_departement %>% dplyr::select(groupe_taxo = groupe, seuil_pro)) %>%
  # colonne seuil
  mutate(div_spec = if_else(nb_esp < seuil_pro, 0, 1)) %>%
  # calcul par dpt
  group_by(code_insee, id_maille_dpt) %>% 
  summarise(moy_div_spec = mean(div_spec)) %>% 
  ungroup() %>% 
  # classement indice
  mutate(moy_div_spec_class = case_when(moy_div_spec == 0 ~ "Tres mauvaise",
                                        between(moy_div_spec, 0, 0.5) ~ "Moyenne",
                                        between(moy_div_spec, 0.5, 1) ~ "Bonne",
                                        TRUE ~ "Tres bonne"))

# jointure aux coordonnées des mailles
resultat_indice_espece_maille_pro <-
  indice_espece_maille_final_pro %>% 
  left_join(total_mailles %>% select(code_insee, id_maille_dpt))

## sauvegarde
save(resultat_indice_espece_maille_pro, file="output/output_rdata/resultat_indice_espece_maille_pro.Rdata")
#sf::write_sf(resultat_indice_espece_maille_pro, "output/output_qgis/resultat_indice_espece_maille_pro.gpkg")

#------------------------------------------------------------------------------#
# Calcul indice espèce maille, espèces protégées, par groupes taxonomiques ####
cli::cli_h1("Espèces protégées, par groupes")

resultat_indice_espece_maille_grp_pro <-
  total_points_dans_mailles_esp_pro %>% 
  sf::st_drop_geometry() %>% 
  group_by(code_insee, groupe_taxo, id_maille_dpt) %>% 
  summarise(nb_esp = length(unique(cd_nom))) %>% 
  dplyr::ungroup() %>% 
  tidyr::complete(groupe_taxo, nesting(code_insee, id_maille_dpt), fill = list(nb_esp = 0)) 

indice_espece_maille_final_grp_pro <-
  # jointure
  left_join(resultat_indice_espece_maille_grp_pro, 
            table_seuil_departement %>% dplyr::select(groupe_taxo = groupe, seuil_pro)) %>%
  # colonne seuil
  mutate(div_spec = if_else(nb_esp < seuil_pro, 0, 1))

# jointure aux coordonnées des mailles
resultat_indice_espece_maille_grp_pro <-
  indice_espece_maille_final_grp_pro %>% 
  left_join(total_mailles %>% select(code_insee, id_maille_dpt))

## sauvegarde
save(resultat_indice_espece_maille_grp_pro, file="output/output_rdata/resultat_indice_espece_maille_grp_pro.Rdata")
#sf::write_sf(resultat_indice_espece_maille_grp_pro, "output/output_qgis/resultat_indice_espece_maille_grp_pro.gpkg")


