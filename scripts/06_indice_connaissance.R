##%######################################################%##
#                                                          #
####       Script pour créer l'indice connaissance      ####
####                (version 2023-08-10)                ####
#                                                          #
##%######################################################%##
#------------------------------------------------------------------------------#
# Toutes espèces ####
# Tous groupes taxonomiques ####
# Chargement des deux indices #
base::load("output/output_rdata/resultat_indice_pression_total_classe.Rdata")
base::load("output/output_rdata/resultat_indice_espece_maille.Rdata")

#------------------------------------------------------------------------------#
# Jointure des deux fichiers et calcul de l'indice connaissance, toutes espèces #
cli::cli_h1("Toutes espèces, tous groupes")

jointure_indices <-
  resultat_indice_pression_total_classe %>% 
  sf::st_drop_geometry() %>%
  dplyr::select(code_insee, id_maille_dpt, classe_id) %>% 
  left_join(resultat_indice_espece_maille %>% 
              sf::st_drop_geometry() %>%
              dplyr::select(code_insee, id_maille_dpt, moy_div_spec_class)) %>% 
  # reclassification
  mutate(indice_connaissance = case_when(between(classe_id, 0, 2) & moy_div_spec_class == 'Tres mauvaise' ~ 'Tres mauvaise',
                                         between(classe_id, 0, 2) & moy_div_spec_class == 'Moyenne' ~ 'Mauvaise',
                                         between(classe_id, 0, 2) & moy_div_spec_class == 'Bonne' ~ 'Mauvaise',
                                         between(classe_id, 0, 2) & moy_div_spec_class == 'Tres bonne' ~ 'Moyenne',
                                         
                                         between(classe_id, 2, 4) & moy_div_spec_class == 'Tres mauvaise' ~ 'Mauvaise',
                                         between(classe_id, 2, 4) & moy_div_spec_class == 'Moyenne' ~ 'Moyenne',
                                         between(classe_id, 2, 4) & moy_div_spec_class == 'Bonne' ~ 'Moyenne',
                                         between(classe_id, 2, 4) & moy_div_spec_class == 'Tres bonne' ~ 'Bonne',
                                         
                                         between(classe_id, 4, 6) & moy_div_spec_class == 'Tres mauvaise' ~ 'Mauvaise',
                                         between(classe_id, 4, 6) & moy_div_spec_class == 'Moyenne' ~ 'Moyenne',
                                         between(classe_id, 4, 6) & moy_div_spec_class == 'Bonne' ~ 'Bonne',
                                         between(classe_id, 4, 6) & moy_div_spec_class == 'Tres bonne' ~ 'Bonne',
                                         
                                         between(classe_id, 6, 8) & moy_div_spec_class == 'Tres mauvaise' ~ 'Moyenne',
                                         between(classe_id, 6, 8) & moy_div_spec_class == 'Moyenne' ~ 'Bonne',
                                         between(classe_id, 6, 8) & moy_div_spec_class == 'Bonne' ~ 'Bonne',
                                         between(classe_id, 6, 8) & moy_div_spec_class == 'Tres bonne' ~ 'Tres bonne',
                                         
                                         classe_id >= 8 & moy_div_spec_class == 'Tres mauvaise' ~ 'Moyenne',
                                         classe_id >= 8 & moy_div_spec_class == 'Moyenne' ~ 'Bonne',
                                         classe_id >= 8 & moy_div_spec_class == 'Bonne' ~ 'Tres bonne',
                                         classe_id >= 8 & moy_div_spec_class == 'Tres bonne' ~ 'Tres bonne',
                                         ))


#------------------------------------------------------------------------------#
# Jointure aux coordonnées des mailles
resultat_indice_connaissance <-
  jointure_indices %>% 
  left_join(total_mailles %>% select(code_insee, id_maille_dpt))

#------------------------------------------------------------------------------#
## Sauvegarde
save(resultat_indice_connaissance, file="output/output_rdata/resultat_indice_connaissance.Rdata")
#sf::write_sf(resultat_indice_connaissance, "output/output_qgis/resultat_indice_connaissance.gpkg")

#------------------------------------------------------------------------------#

# Par groupes taxonomiques ####
# Chargement des deux indices #
base::load("output/output_rdata/resultat_indice_pression_grp_classe.Rdata")
base::load("output/output_rdata/resultat_indice_espece_maille_grp.Rdata")

#------------------------------------------------------------------------------#
# Jointure des deux fichiers et calcul de l'indice connaissance, toutes espèces #
cli::cli_h1("Toutes espèces, par groupes")

jointure_indice <-
  resultat_indice_pression_grp_classe %>% 
  sf::st_drop_geometry() %>%
  dplyr::select(code_insee, id_maille_dpt, classe_id) %>% 
  left_join(resultat_indice_espece_maille_grp %>% 
              sf::st_drop_geometry() %>%
              dplyr::select(code_insee, id_maille_dpt, div_spec)) %>% 
  # reclassification
  mutate(indice_connaissance = case_when(between(classe_id, 0, 2) & div_spec == 0 ~ 'Tres mauvaise',
                                         between(classe_id, 0, 2) & div_spec == 1 ~ 'Mauvaise',
                                         
                                         
                                         between(classe_id, 2, 4) & div_spec == 0 ~ 'Mauvaise',
                                         between(classe_id, 2, 4) & div_spec == 1 ~ 'Moyenne',
                         
                                         
                                         between(classe_id, 4, 6) & div_spec == 0 ~ 'Moyenne',
                                         between(classe_id, 4, 6) & div_spec == 1 ~ 'Bonne',
                                    
                                         
                                         between(classe_id, 6, 8) & div_spec == 0 ~ 'Moyenne',
                                         between(classe_id, 6, 8) & div_spec == 1 ~ 'Tres bonne',
                                     
                                         classe_id >= 8 & div_spec == 0 ~ 'Bonne',
                                         classe_id >= 8 & div_spec == 1 ~ 'Tres bonne'))
                                       
#------------------------------------------------------------------------------#
# Jointure aux coordonnées des mailles
resultat_indice_connaissance_grp <-
  jointure_indices %>% 
  left_join(total_mailles %>% select(code_insee, id_maille_dpt))

#------------------------------------------------------------------------------#
## Sauvegarde
save(resultat_indice_connaissance_grp, file="output/output_rdata/resultat_indice_connaissance_grp.Rdata")
#sf::write_sf(resultat_indice_connaissance_grp, "output/output_qgis/resultat_indice_connaissance_grp.gpkg")







# Espèces protégées ####
# Chargement des deux indices #
base::load("output/output_rdata/resultat_indice_pression_total_classe_pro.Rdata")
base::load("output/output_rdata/resultat_indice_espece_maille_pro.Rdata")

#------------------------------------------------------------------------------#
# Jointure des deux fichiers et calcul de l'indice connaissance, toutes espèces #
cli::cli_h1("Espèces protégées, tous groupes")

jointure_indices <-
  resultat_indice_pression_total_classe_pro %>% 
  sf::st_drop_geometry() %>%
  dplyr::select(code_insee, id_maille_dpt, classe_id) %>% 
  left_join(resultat_indice_espece_maille_pro %>% 
              sf::st_drop_geometry() %>%
              dplyr::select(code_insee, id_maille_dpt, moy_div_spec_class)) %>% 
  # reclassification
  mutate(indice_connaissance = case_when(between(classe_id, 0, 2) & moy_div_spec_class == 'Tres mauvaise' ~ 'Tres mauvaise',
                                         between(classe_id, 0, 2) & moy_div_spec_class == 'Moyenne' ~ 'Mauvaise',
                                         between(classe_id, 0, 2) & moy_div_spec_class == 'Bonne' ~ 'Mauvaise',
                                         between(classe_id, 0, 2) & moy_div_spec_class == 'Tres bonne' ~ 'Moyenne',
                                         
                                         between(classe_id, 2, 4) & moy_div_spec_class == 'Tres mauvaise' ~ 'Mauvaise',
                                         between(classe_id, 2, 4) & moy_div_spec_class == 'Moyenne' ~ 'Moyenne',
                                         between(classe_id, 2, 4) & moy_div_spec_class == 'Bonne' ~ 'Moyenne',
                                         between(classe_id, 2, 4) & moy_div_spec_class == 'Tres bonne' ~ 'Bonne',
                                         
                                         between(classe_id, 4, 6) & moy_div_spec_class == 'Tres mauvaise' ~ 'Mauvaise',
                                         between(classe_id, 4, 6) & moy_div_spec_class == 'Moyenne' ~ 'Moyenne',
                                         between(classe_id, 4, 6) & moy_div_spec_class == 'Bonne' ~ 'Bonne',
                                         between(classe_id, 4, 6) & moy_div_spec_class == 'Tres bonne' ~ 'Bonne',
                                         
                                         between(classe_id, 6, 8) & moy_div_spec_class == 'Tres mauvaise' ~ 'Moyenne',
                                         between(classe_id, 6, 8) & moy_div_spec_class == 'Moyenne' ~ 'Bonne',
                                         between(classe_id, 6, 8) & moy_div_spec_class == 'Bonne' ~ 'Bonne',
                                         between(classe_id, 6, 8) & moy_div_spec_class == 'Tres bonne' ~ 'Tres bonne',
                                         
                                         classe_id >= 8 & moy_div_spec_class == 'Tres mauvaise' ~ 'Moyenne',
                                         classe_id >= 8 & moy_div_spec_class == 'Moyenne' ~ 'Bonne',
                                         classe_id >= 8 & moy_div_spec_class == 'Bonne' ~ 'Tres bonne',
                                         classe_id >= 8 & moy_div_spec_class == 'Tres bonne' ~ 'Tres bonne',
  ))


#------------------------------------------------------------------------------#
# Jointure aux coordonnées des mailles
resultat_indice_connaissance_pro <-
  jointure_indices %>% 
  left_join(total_mailles %>% select(code_insee, id_maille_dpt))

#------------------------------------------------------------------------------#
## Sauvegarde
save(resultat_indice_connaissance_pro, file="output/output_rdata/resultat_indice_connaissance_pro.Rdata")
#sf::write_sf(resultat_indice_connaissance_pro, "output/output_qgis/resultat_indice_connaissance_pro.gpkg")


# Par groupes taxonomiques ####
# Chargement des deux indices #
base::load("output/output_rdata/resultat_indice_pression_grp_classe_pro.Rdata")
base::load("output/output_rdata/resultat_indice_espece_maille_grp_pro.Rdata")

#------------------------------------------------------------------------------#
# Jointure des deux fichiers et calcul de l'indice connaissance, toutes espèces #
cli::cli_h1("Toutes espèces, par groupes")

jointure_indice <-
  resultat_indice_pression_grp_classe_pro %>% 
  sf::st_drop_geometry() %>%
  dplyr::select(code_insee, id_maille_dpt, classe_id) %>% 
  left_join(resultat_indice_espece_maille_grp_pro %>% 
              sf::st_drop_geometry() %>%
              dplyr::select(code_insee, id_maille_dpt, div_spec)) %>% 
  # reclassification
  mutate(indice_connaissance = case_when(between(classe_id, 0, 2) & div_spec == 0 ~ 'Tres mauvaise',
                                         between(classe_id, 0, 2) & div_spec == 1 ~ 'Mauvaise',
                                         
                                         
                                         between(classe_id, 2, 4) & div_spec == 0 ~ 'Mauvaise',
                                         between(classe_id, 2, 4) & div_spec == 1 ~ 'Moyenne',
                                         
                                         
                                         between(classe_id, 4, 6) & div_spec == 0 ~ 'Moyenne',
                                         between(classe_id, 4, 6) & div_spec == 1 ~ 'Bonne',
                                         
                                         
                                         between(classe_id, 6, 8) & div_spec == 0 ~ 'Moyenne',
                                         between(classe_id, 6, 8) & div_spec == 1 ~ 'Tres bonne',
                                         
                                         classe_id >= 8 & div_spec == 0 ~ 'Bonne',
                                         classe_id >= 8 & div_spec == 1 ~ 'Tres bonne'))

#------------------------------------------------------------------------------#
# Jointure aux coordonnées des mailles
resultat_indice_connaissance_grp_pro <-
  jointure_indices %>% 
  left_join(total_mailles %>% select(code_insee, id_maille_dpt))

#------------------------------------------------------------------------------#
## Sauvegarde
save(resultat_indice_connaissance_grp_pro, file="output/output_rdata/resultat_indice_connaissance_grp_pro.Rdata")
#sf::write_sf(resultat_indice_connaissance_grp_pro, "output/output_qgis/resultat_indice_connaissance_grp_pro.gpkg")

