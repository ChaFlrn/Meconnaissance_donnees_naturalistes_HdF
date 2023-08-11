##%######################################################%##
#                                                          #
####        Script pour créer l'indice esp/maille       ####
####                (version 2023-08-10)                ####
#                                                          #
##%######################################################%##


# Chargement des valeurs seuils #
table_seuil_departement <- read.csv(file="data/data_brutes//valeurs_seuils.csv", h=T, dec=",", sep=";")

base::load("output/output_rdata/total_points_dans_mailles.Rdata")

resultat_indice_espece_maille_grp <-
  total_points_dans_mailles %>% 
  sf::st_drop_geometry() %>% 
  group_by(code_insee, groupe_taxo, id_maille_dpt) %>% 
  summarise(nb_esp = length(unique(cd_nom))) %>% 
  dplyr::ungroup() %>% 
  tidyr::complete(groupe_taxo, nesting(code_insee, id_maille_dpt), fill = list(nb_esp = 0)) 
  

indice_espece_maille_grp_final <-
  # jointure
  left_join(resultat_indice_espece_maille_grp, 
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
resultat_indice_espece_maille_grp <-
  indice_espece_maille_grp_final %>% 
  left_join(total_mailles %>% select(code_insee, id_maille_dpt))

## sauvegarde
save(resultat_indice_espece_maille_grp, file="output/output_rdata/resultat_indice_espece_maille_grp.Rdata")
sf::write_sf(resultat_indice_espece_maille_grp, "output/output_qgis/resultat_indice_espece_maille_grp.gpkg")


