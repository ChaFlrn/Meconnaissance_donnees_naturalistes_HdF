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
aisne_shape <- sf::st_read("data/data_geo/aisne.shp")

## somme

## nord

## pas-de-calais

#----------------------------------------------------------------#
## b) création des mailles avec la fonction dédiée 'creation_maille' ####

## oise

oise_maille_5km <- 
  creation_maille(oise_shape, taille = 5000) %>% 
  dplyr::select(id_maille_dpt, code_insee, nom_officiel = nom_offici)

## aisne

aisne_maille_5km <- 
  creation_maille(aisne_shape, taille = 5000) %>% 
  dplyr::select(id_maille_dpt, code_insee, nom_officiel = nom_offici)

## somme

## nord

## pas-de-calais

#----------------------------------------------------------------#
## c) jointure des couches mailles et especes ####

base::load("output/output_rdata/data_tout_esp.RData")

data_tout_esp <- data_tout_esp %>% sf::st_as_sf(crs = 2154)

## oise
oise_points_dans_mailles<- 
  data_tout_esp %>%
  sf::st_crop(sf::st_bbox(oise_maille_5km)) %>% 
  sf::st_join(oise_maille_5km) %>% 
  dplyr::mutate(id_maille_dpt = paste(nom_officiel, id_maille_dpt, sep = "_"))

## aisne
aisne_points_dans_mailles<- 
  data_tout_esp %>%
  sf::st_crop(sf::st_bbox(aisne_maille_5km)) %>% 
  sf::st_join(aisne_maille_5km) %>% 
  dplyr::mutate(id_maille_dpt = paste(nom_officiel, id_maille_dpt, sep = "_"))


## somme

## nord

## pas-de-calais


#----------------------------------------------------------------#
## c) jointure des couches mailles et especes ####

# -> a completer avec les autres dpts

total_points_dans_mailles <-
  dplyr::bind_rows(oise_points_dans_mailles, 
                   aisne_points_dans_mailles)


save(total_points_dans_mailles, file = "output/output_rdata/total_points_dans_mailles.Rdata")

