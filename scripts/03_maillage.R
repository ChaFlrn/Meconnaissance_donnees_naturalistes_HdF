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

## oise
oise_shape <- sf::st_read("data/data_geo/oise.shp")

## aisne

## somme

## nord

## pas-de-calais

#----------------------------------------------------------------#
## b) création des mailles avec la fonction dédiée 'creation_maille' ####

oise_maille_5km <- 
  creation_maille(oise_shape, taille = 5000) %>% 
  dplyr::select(id_maille_dpt, code_insee, nom_officiel = nom_offici)

#----------------------------------------------------------------#
## c) jointure des couches mailles et especes ####

base::load("output/output_rdata/data_tout_esp.RData")

data_tout_esp <- data_tout_esp %>% 
  sf::st_as_sf(crs = 2154)

oise_points_dans_mailles<- 
  data_tout_esp %>%
  sf::st_crop(sf::st_bbox(oise_maille_5km)) %>% 
  sf::st_join(oise_maille_5km)




