

base::load("output/output_rdata/resultat_indice_pression_total_classe.Rdata")
base::load("output/output_rdata/resultat_indice_espece_maille_grp.Rdata")

jointure_indices <-
  resultat_indice_pression_total_classe %>% 
  sf::st_drop_geometry() %>%
  dplyr::select(code_insee, id_maille_dpt, classe_id) %>% 
  left_join(resultat_indice_espece_maille_grp %>% 
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



# jointure aux coordonnées des mailles
resultat_indice_connaissance <-
  jointure_indices %>% 
  left_join(total_mailles %>% select(code_insee, id_maille_dpt))

## sauvegarde
save(resultat_indice_connaissance, file="output/output_rdata/resultat_indice_connaissance.Rdata")
sf::write_sf(resultat_indice_connaissance, "output/output_qgis/resultat_indice_connaissance.gpkg")


# Boucle pour sauvegarde multiples
dpt <- resultat_indice_connaissance$code_insee %>% unique()

for(i in 1:length(dpt)){
  tab_a_sauver <- resultat_indice_connaissance %>% filter(code_insee %in% dpt[i])
  sf::write_sf(tab_a_sauver, paste0("output/output_qgis/resultat_indice_connaissance_dpt", dpt[i], ".gpkg"))
}

