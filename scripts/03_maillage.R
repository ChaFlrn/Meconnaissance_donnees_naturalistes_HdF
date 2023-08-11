##%######################################################%##
#                                                          #
####  Script pour créer les maillages pour les entités  ####
####           géographiques (version 2023-08-10)       ####
#                                                          #
##%######################################################%##

### --> Requiert des couches geo importées dans l'environnement
### --> Requiert les couches assemblées des BDD espèces

#----------------------------------------------------------------#
## a) Import des shapes ####
cli::cli_h1("Import des shapes")

## oise
oise_shape <- sf::st_read("data/data_geo/oise.shp")

## aisne
aisne_shape <- sf::st_read("data/data_geo/aisne.shp")

## somme
somme_shape <- sf::st_read("data/data_geo/somme.shp")

## nord
nord_shape <- sf::st_read("data/data_geo/nord.shp")

## pas-de-calais
pas_calais_shape <- sf::st_read("data/data_geo/pas_calais.shp")

#----------------------------------------------------------------#
## b) création des mailles avec la fonction dédiée 'creation_maille' ####
cli::cli_h1("Création des mailles avec la fonction dédiée 'creation_maille'")

## oise
oise_maille_5km <- 
  creation_maille(oise_shape, taille = 5000) %>% 
  dplyr::select(id_maille_dpt,
                code_insee, 
                nom_officiel = nom_offici)

## aisne
aisne_maille_5km <- 
  creation_maille(aisne_shape, taille = 5000) %>% 
  dplyr::select(id_maille_dpt,
                code_insee, 
                nom_officiel = nom_offici)

## somme
somme_maille_5km <- 
  creation_maille(somme_shape, taille = 5000) %>% 
  dplyr::select(id_maille_dpt,
                code_insee, 
                nom_officiel = nom_offici)

## nord
nord_maille_5km <- 
  creation_maille(nord_shape, taille = 5000) %>% 
  dplyr::select(id_maille_dpt,
                code_insee, 
                nom_officiel = nom_offici)


## pas-de-calais
pas_calais_maille_5km <- 
  creation_maille(pas_calais_shape, taille = 5000) %>% 
  dplyr::select(id_maille_dpt,
                code_insee, 
                nom_officiel = nom_offici)

#----------------------------------------------------------------#
## c) jointure des couches mailles et especes ####
cli::cli_h1("Jointure des couches mailles et especes")
### Toutes espèces #####
cli::cli_h2("Toutes espèces")

base::load("output/output_rdata/data_tout_esp.RData")

data_tout_esp <- data_tout_esp %>% sf::st_as_sf(crs = 2154)

## oise
oise_points_dans_mailles<- 
  data_tout_esp %>%
  sf::st_crop(sf::st_bbox(oise_maille_5km)) %>% 
  sf::st_intersection(oise_maille_5km) %>% 
  dplyr::mutate(id_maille_dpt = paste(nom_officiel, id_maille_dpt, sep = "_"))

## aisne
aisne_points_dans_mailles<- 
  data_tout_esp %>%
  sf::st_crop(sf::st_bbox(aisne_maille_5km)) %>% 
  sf::st_intersection(aisne_maille_5km) %>% 
  dplyr::mutate(id_maille_dpt = paste(nom_officiel, id_maille_dpt, sep = "_"))

## somme
somme_points_dans_mailles<- 
  data_tout_esp %>%
  sf::st_crop(sf::st_bbox(somme_maille_5km)) %>% 
  sf::st_intersection(somme_maille_5km) %>% 
  dplyr::mutate(id_maille_dpt = paste(nom_officiel, id_maille_dpt, sep = "_"))

## nord
nord_points_dans_mailles<- 
  data_tout_esp %>%
  sf::st_crop(sf::st_bbox(nord_maille_5km)) %>% 
  sf::st_intersection(nord_maille_5km) %>% 
  dplyr::mutate(id_maille_dpt = paste(nom_officiel, id_maille_dpt, sep = "_"))

## pas-de-calais
pas_calais_points_dans_mailles<- 
  data_tout_esp %>%
  sf::st_crop(sf::st_bbox(pas_calais_maille_5km)) %>% 
  sf::st_intersection(pas_calais_maille_5km) %>% 
  dplyr::mutate(id_maille_dpt = paste(nom_officiel, id_maille_dpt, sep = "_"))

### Espèces protégées ####
cli::cli_h2("Espèces protégées")

base::load("output/output_rdata/data_esp_pro.RData")

data_esp_pro <- data_esp_pro %>% sf::st_as_sf(crs = 2154)

## oise
oise_points_dans_mailles_pro<- 
  data_esp_pro %>%
  sf::st_crop(sf::st_bbox(oise_maille_5km)) %>% 
  sf::st_intersection(oise_maille_5km) %>% 
  dplyr::mutate(id_maille_dpt = paste(nom_officiel, id_maille_dpt, sep = "_"))

## aisne
aisne_points_dans_mailles_pro<- 
  data_esp_pro %>%
  sf::st_crop(sf::st_bbox(aisne_maille_5km)) %>% 
  sf::st_intersection(aisne_maille_5km) %>% 
  dplyr::mutate(id_maille_dpt = paste(nom_officiel, id_maille_dpt, sep = "_"))

## somme
somme_points_dans_mailles_pro<- 
  data_esp_pro %>%
  sf::st_crop(sf::st_bbox(somme_maille_5km)) %>% 
  sf::st_intersection(somme_maille_5km) %>% 
  dplyr::mutate(id_maille_dpt = paste(nom_officiel, id_maille_dpt, sep = "_"))

## nord
nord_points_dans_mailles_pro<- 
  data_esp_pro %>%
  sf::st_crop(sf::st_bbox(nord_maille_5km)) %>% 
  sf::st_intersection(nord_maille_5km) %>% 
  dplyr::mutate(id_maille_dpt = paste(nom_officiel, id_maille_dpt, sep = "_"))

## pas-de-calais
pas_calais_points_dans_mailles_pro<- 
  data_esp_pro %>%
  sf::st_crop(sf::st_bbox(pas_calais_maille_5km)) %>% 
  sf::st_intersection(pas_calais_maille_5km) %>% 
  dplyr::mutate(id_maille_dpt = paste(nom_officiel, id_maille_dpt, sep = "_"))





#----------------------------------------------------------------#
## d) fusion des 5 fichiers ####
cli::cli_h1("Fusion des fichiers")

## Mailles ####
cli::cli_h2("Mailles")
total_mailles <-
  dplyr::bind_rows(oise_maille_5km, 
                   aisne_maille_5km,
                   nord_maille_5km,
                   somme_maille_5km,
                   pas_calais_maille_5km) %>%
  dplyr::mutate(id_maille_dpt = paste(nom_officiel, id_maille_dpt, sep = "_"))

save(total_mailles, file = "output/output_rdata/total_mailles.Rdata")


## Toutes espèces ####
cli::cli_h2("Toutes espèces")

total_points_dans_mailles <-
  dplyr::bind_rows(oise_points_dans_mailles, 
                   aisne_points_dans_mailles,
                   somme_points_dans_mailles,
                   nord_points_dans_mailles,
                   pas_calais_points_dans_mailles)

save(total_points_dans_mailles, file = "output/output_rdata/total_points_dans_mailles.Rdata")

## Espèces protégées ####
cli::cli_h2("Espèces protégées")

total_points_dans_mailles_esp_pro <-
  dplyr::bind_rows(oise_points_dans_mailles_pro, 
                   aisne_points_dans_mailles_pro,
                   somme_points_dans_mailles_pro,
                   nord_points_dans_mailles_pro,
                   pas_calais_points_dans_mailles_pro)

save(total_points_dans_mailles_esp_pro, file = "output/output_rdata/total_points_dans_mailles_esp_pro.Rdata")

