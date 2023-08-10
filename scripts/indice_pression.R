library(dplyr)
library(sf)
library(tidyverse)


#### Tous groupes taxonomiques confondus ####
##### Préparation des fichiers #####
###### Aisne #####
pression_aisne <- sf :: st_read("Data_brutes/Toutes_especes/pression_aisne_maille.shp")

pression_aisne$annees <- substr(pression_aisne$date, 1,4)

pression_annees_aisne <- pression_aisne %>%
  group_by(id_2, annees)%>%
  summarise(passage = n(),.groups="drop")

indice_pression_aisne <- pression_annees_aisne %>%
  group_by(id_2)%>%
  summarise(nb_moy = mean(passage))

indice_pression_aisne$nb_moy <- round(indice_pression_aisne$nb_moy, 0)

save(indice_pression_aisne, file="Data_analyses/Toutes_especes/indice_pression_aisne")


###### Nord #####
pression_nord <- sf :: st_read("Data_brutes/Toutes_especes/pression_nord_maille.shp")

pression_nord$annees <- substr(pression_nord$date, 1,4)

pression_annees_nord <- pression_nord %>%
  group_by(id_2, annees)%>%
  summarise(passage = n(),.groups="drop")

indice_pression_nord <- pression_annees_nord %>%
  group_by(id_2)%>%
  summarise(nb_moy = mean(passage))

indice_pression_nord$nb_moy <- round(indice_pression_nord$nb_moy, 0)

save(indice_pression_nord, file="Data_analyses/Toutes_especes/indice_pression_nord")



###### Oise #####
pression_oise <- sf :: st_read("Data_brutes/Toutes_especes/pression_oise_maille.shp")

pression_oise$annees <- substr(pression_oise$date, 1,4)

pression_annees_oise <- pression_oise %>%
  group_by(id_2, annees)%>%
  summarise(passage = n(),.groups="drop")

indice_pression_oise <- pression_annees_oise %>%
  group_by(id_2)%>%
  summarise(nb_moy = mean(passage))

indice_pression_oise$nb_moy <- round(indice_pression_oise$nb_moy, 0)

save(indice_pression_oise, file="Data_analyses/Toutes_especes/indice_pression_oise")


###### Pas-de-Calais #####
pression_pascalais <- sf :: st_read("Data_brutes/Toutes_especes/pression_pascalais_maille.shp")

pression_pascalais$annees <- substr(pression_pascalais$date, 1,4)

pression_annees_pascalais <- pression_pascalais %>%
  group_by(id_2, annees)%>%
  summarise(passage = n(),.groups="drop")

indice_pression_pascalais <- pression_annees_pascalais %>%
  group_by(id_2)%>%
  summarise(nb_moy = mean(passage))

indice_pression_pascalais$nb_moy <- round(indice_pression_pascalais$nb_moy, 0)

save(indice_pression_pascalais, file="Data_analyses/Toutes_especes/indice_pression_pascalais")



###### Somme #####
pression_somme <- sf :: st_read("Data_brutes/Toutes_especes/pression_somme_maille.shp")

pression_somme$annees <- substr(pression_somme$date, 1,4)

pression_annees_somme <- pression_somme %>%
  group_by(id_2, annees)%>%
  summarise(passage = n(),.groups="drop")

indice_pression_somme <- pression_annees_somme %>%
  group_by(id_2)%>%
  summarise(nb_moy = mean(passage))

indice_pression_somme$nb_moy <- round(indice_pression_somme$nb_moy, 0)

save(indice_pression_somme, file="Data_analyses/Toutes_especes/indice_pression_somme")


##### Détermination des classes ####
###### Calcul nombre de classes - Règle de Sturges ######
k_aisne = round(1 + 3.22*log10(nrow(indice_pression_aisne)), 0)
k_aisne

k_nord = round(1 + 3.22*log10(nrow(indice_pression_nord)), 0)
k_nord

k_oise = round(1 + 3.22*log10(nrow(indice_pression_oise)), 0)
k_oise

k_pascalais = round(1 + 3.22*log10(nrow(indice_pression_pascalais)), 0)
k_pascalais

k_somme = round(1 + 3.22*log10(nrow(indice_pression_somme)), 0)
k_somme

###### Calcul des bornes intervalles ######

amp_aisne = (max(indice_pression_aisne$nb_moy) - min(indice_pression_aisne$nb_moy))/k_aisne


indice_pression_aisne_classe <- cut(indice_pression_aisne$nb_moy, 9)



##### Enregistrer les fichiers QGIS #####
st_write(indice_pression_aisne,
         "Output_qgis/Toutes_especes/indice_pression_aisne.shp")

st_write(indice_pression_nord,
         "Output_qgis/Toutes_especes/indice_pression_nord.shp")

st_write(indice_pression_oise,
         "Output_qgis/Toutes_especes/indice_pression_oise.shp")

st_write(indice_pression_pascalais,
         "Output_qgis/Toutes_especes/indice_pression_pascalais.shp")

st_write(indice_pression_somme,
         "Output_qgis/Toutes_especes/indice_pression_somme.shp")




#### Par groupes taxonomiques ####
##### Amphibiens #####
###### Préparer les fichiers ######
pression_aisne_amphi <- st_read("Data_brutes/Toutes_especes/amphi_regroup_aisne.shp")
pression_nord_amphi <- st_read("Data_brutes/Toutes_especes/amphi_regroup_nord.shp")
pression_oise_amphi <- st_read("Data_brutes/Toutes_especes/amphi_regroup_oise.shp")
pression_pascalais_amphi <- st_read("Data_brutes/Toutes_especes/amphi_regroup_pascalais.shp")
pression_somme_amphi <- st_read("Data_brutes/Toutes_especes/amphi_regroup_somme.shp")

# Aisne

pression_aisne_amphi$annees <- substr(pression_aisne_amphi$date, 1,4)

pression_annees_aisne_amphi <- pression_aisne_amphi %>%
  group_by(id, annees)%>%
  summarise(passage = n(),.groups="drop")

indice_pression_aisne_amphi <- pression_annees_aisne_amphi %>%
  filter(!is.na(annees)) %>%
  group_by(id)%>%
  summarise(nb_moy = mean(passage))

indice_pression_aisne_amphi$nb_moy <- round(indice_pression_aisne_amphi$nb_moy, 0)

save(indice_pression_aisne_amphi, file="Data_analyses/Toutes_especes/indice_pression_aisne_amphi")

# Nord
pression_nord_amphi$annees <- substr(pression_nord_amphi$date, 1,4)

pression_annees_nord_amphi <- pression_nord_amphi %>%
  group_by(id, annees)%>%
  summarise(passage = n(),.groups="drop")

indice_pression_nord_amphi <- pression_annees_nord_amphi %>%
  filter(!is.na(annees)) %>%
  group_by(id)%>%
  summarise(nb_moy = mean(passage))

indice_pression_nord_amphi$nb_moy <- round(indice_pression_nord_amphi$nb_moy, 0)

save(indice_pression_nord_amphi, file="Data_analyses/Toutes_especes/indice_pression_nord_amphi")

# Oise

pression_oise_amphi$annees <- substr(pression_oise_amphi$date, 1,4)

pression_annees_oise_amphi <- pression_oise_amphi %>%
  group_by(id, annees)%>%
  summarise(passage = n(),.groups="drop")

indice_pression_oise_amphi <- pression_annees_oise_amphi %>%
  filter(!is.na(annees)) %>%
  group_by(id)%>%
  summarise(nb_moy = mean(passage))

indice_pression_oise_amphi$nb_moy <- round(indice_pression_oise_amphi$nb_moy, 0)

save(indice_pression_oise_amphi, file="Data_analyses/Toutes_especes/indice_pression_oise_amphi")

# Pas-de-Calais
pression_pascalais_amphi$annees <- substr(pression_pascalais_amphi$date, 1,4)

pression_annees_pascalais_amphi <- pression_pascalais_amphi %>%
  group_by(id, annees)%>%
  summarise(passage = n(),.groups="drop")

indice_pression_pascalais_amphi <- pression_annees_pascalais_amphi %>%
  filter(!is.na(annees)) %>%
  group_by(id)%>%
  summarise(nb_moy = mean(passage))

indice_pression_pascalais_amphi$nb_moy <- round(indice_pression_pascalais_amphi$nb_moy, 0)

save(indice_pression_pascalais_amphi, file="Data_analyses/Toutes_especes/indice_pression_pascalais_amphi")



# Somme
pression_somme_amphi$annees <- substr(pression_somme_amphi$date, 1,4)

pression_annees_somme_amphi <- pression_somme_amphi %>%
  group_by(id, annees)%>%
  summarise(passage = n(),.groups="drop")

indice_pression_somme_amphi <- pression_annees_somme_amphi %>%
  filter(!is.na(annees)) %>%
  group_by(id)%>%
  summarise(nb_moy = mean(passage))

indice_pression_somme_amphi$nb_moy <- round(indice_pression_somme_amphi$nb_moy, 0)

save(indice_pression_somme_amphi, file="Data_analyses/Toutes_especes/indice_pression_somme_amphi")


###### Définition des classes ######
###### Calcul nombre de classes - Règle de Sturges ######
k_aisne_amphi = round(1 + 3.22*log10(nrow(indice_pression_aisne_amphi)), 0)
k_aisne_amphi

k_nord_amphi = round(1 + 3.22*log10(nrow(indice_pression_nord_amphi)), 0)
k_nord_amphi

k_oise_amphi = round(1 + 3.22*log10(nrow(indice_pression_oise_amphi)), 0)
k_oise_amphi

k_pascalais_amphi = round(1 + 3.22*log10(nrow(indice_pression_pascalais_amphi)), 0)
k_pascalais_amphi

k_somme_amphi = round(1 + 3.22*log10(nrow(indice_pression_somme_amphi)), 0)
k_somme_amphi

###### Calcul des bornes intervalles ######

amp_aisne_amphi = (max(indice_pression_aisne_amphi$nb_moy) - min(indice_pression_aisne_amphi$nb_moy))/k_aisne_amphi


indice_pression_aisne_classe_amphi <- cut(indice_pression_aisne_amphi$nb_moy, 9)


##### Enregistrer les fichiers QGIS #####
st_write(indice_pression_aisne_amphi,
         "Output_qgis/Toutes_especes/indice_pression_aisne_amphi.shp")

st_write(indice_pression_nord_amphi,
         "Output_qgis/Toutes_especes/indice_pression_nord_amphi.shp")

st_write(indice_pression_oise_amphi,
         "Output_qgis/Toutes_especes/indice_pression_oise_amphi.shp")

st_write(indice_pression_pascalais_amphi,
         "Output_qgis/Toutes_especes/indice_pression_pascalais_amphi.shp")

st_write(indice_pression_somme_amphi,
         "Output_qgis/Toutes_especes/indice_pression_somme_amphi.shp")








##### Chiroptères #####
###### Préparer les fichiers ######
pression_aisne_chiro <- st_read("Data_brutes/Toutes_especes/chiro_regroup_aisne.shp")
pression_nord_chiro <- st_read("Data_brutes/Toutes_especes/chiro_regroup_nord.shp")
pression_oise_chiro <- st_read("Data_brutes/Toutes_especes/chiro_regroup_oise.shp")
pression_pascalais_chiro <- st_read("Data_brutes/Toutes_especes/chiro_regroup_pascalais.shp")
pression_somme_chiro <- st_read("Data_brutes/Toutes_especes/chiro_regroup_somme.shp")

# Aisne

pression_aisne_chiro$annees <- substr(pression_aisne_chiro$date, 1,4)

pression_annees_aisne_chiro <- pression_aisne_chiro %>%
  group_by(id, annees)%>%
  summarise(passage = n(),.groups="drop")

indice_pression_aisne_chiro <- pression_annees_aisne_chiro %>%
  filter(!is.na(annees)) %>%
  group_by(id)%>%
  summarise(nb_moy = mean(passage))

indice_pression_aisne_chiro$nb_moy <- round(indice_pression_aisne_chiro$nb_moy, 0)

save(indice_pression_aisne_chiro, file="Data_analyses/Toutes_especes/indice_pression_aisne_chiro")

# Nord
pression_nord_chiro$annees <- substr(pression_nord_chiro$date, 1,4)

pression_annees_nord_chiro <- pression_nord_chiro %>%
  group_by(id, annees)%>%
  summarise(passage = n(),.groups="drop")

indice_pression_nord_chiro <- pression_annees_nord_chiro %>%
  filter(!is.na(annees)) %>%
  group_by(id)%>%
  summarise(nb_moy = mean(passage))

indice_pression_nord_chiro$nb_moy <- round(indice_pression_nord_chiro$nb_moy, 0)

save(indice_pression_nord_chiro, file="Data_analyses/Toutes_especes/indice_pression_nord_chiro")

# Oise

pression_oise_chiro$annees <- substr(pression_oise_chiro$date, 1,4)

pression_annees_oise_chiro <- pression_oise_chiro %>%
  group_by(id, annees)%>%
  summarise(passage = n(),.groups="drop")

indice_pression_oise_chiro <- pression_annees_oise_chiro %>%
  filter(!is.na(annees)) %>%
  group_by(id)%>%
  summarise(nb_moy = mean(passage))

indice_pression_oise_chiro$nb_moy <- round(indice_pression_oise_chiro$nb_moy, 0)

save(indice_pression_oise_chiro, file="Data_analyses/Toutes_especes/indice_pression_oise_chiro")

# Pas-de-Calais
pression_pascalais_chiro$annees <- substr(pression_pascalais_chiro$date, 1,4)

pression_annees_pascalais_chiro <- pression_pascalais_chiro %>%
  group_by(id, annees)%>%
  summarise(passage = n(),.groups="drop")

indice_pression_pascalais_chiro <- pression_annees_pascalais_chiro %>%
  filter(!is.na(annees)) %>%
  group_by(id)%>%
  summarise(nb_moy = mean(passage))

indice_pression_pascalais_chiro$nb_moy <- round(indice_pression_pascalais_chiro$nb_moy, 0)

save(indice_pression_pascalais_chiro, file="Data_analyses/Toutes_especes/indice_pression_pascalais_chiro")



# Somme
pression_somme_chiro$annees <- substr(pression_somme_chiro$date, 1,4)

pression_annees_somme_chiro <- pression_somme_chiro %>%
  group_by(id, annees)%>%
  summarise(passage = n(),.groups="drop")

indice_pression_somme_chiro <- pression_annees_somme_chiro %>%
  filter(!is.na(annees)) %>%
  group_by(id)%>%
  summarise(nb_moy = mean(passage))

indice_pression_somme_chiro$nb_moy <- round(indice_pression_somme_chiro$nb_moy, 0)

save(indice_pression_somme_chiro, file="Data_analyses/Toutes_especes/indice_pression_somme_chiro")


###### Définition des classes ######
###### Calcul nombre de classes - Règle de Sturges ######
k_aisne_chiro = round(1 + 3.22*log10(nrow(indice_pression_aisne_chiro)), 0)
k_aisne_chiro

k_nord_chiro = round(1 + 3.22*log10(nrow(indice_pression_nord_chiro)), 0)
k_nord_chiro

k_oise_chiro = round(1 + 3.22*log10(nrow(indice_pression_oise_chiro)), 0)
k_oise_chiro

k_pascalais_chiro = round(1 + 3.22*log10(nrow(indice_pression_pascalais_chiro)), 0)
k_pascalais_chiro

k_somme_chiro = round(1 + 3.22*log10(nrow(indice_pression_somme_chiro)), 0)
k_somme_chiro

###### Calcul des bornes intervalles ######

amp_aisne_chiro = (max(indice_pression_aisne_chiro$nb_moy) - min(indice_pression_aisne_chiro$nb_moy))/k_aisne_chiro


indice_pression_aisne_classe_chiro <- cut(indice_pression_aisne_chiro$nb_moy, 9)


##### Enregistrer les fichiers QGIS #####
st_write(indice_pression_aisne_chiro,
         "Output_qgis/Toutes_especes/indice_pression_aisne_chiro.shp")

st_write(indice_pression_nord_chiro,
         "Output_qgis/Toutes_especes/indice_pression_nord_chiro.shp")

st_write(indice_pression_oise_chiro,
         "Output_qgis/Toutes_especes/indice_pression_oise_chiro.shp")

st_write(indice_pression_pascalais_chiro,
         "Output_qgis/Toutes_especes/indice_pression_pascalais_chiro.shp")

st_write(indice_pression_somme_chiro,
         "Output_qgis/Toutes_especes/indice_pression_somme_chiro.shp")








##### Mammifères #####
###### Préparer les fichiers ######
pression_aisne_mammi <- st_read("Data_brutes/Toutes_especes/mammi_regroup_aisne.shp")
pression_nord_mammi <- st_read("Data_brutes/Toutes_especes/mammi_regroup_nord.shp")
pression_oise_mammi <- st_read("Data_brutes/Toutes_especes/mammi_regroup_oise.shp")
pression_pascalais_mammi <- st_read("Data_brutes/Toutes_especes/mammi_regroup_pascalais.shp")
pression_somme_mammi <- st_read("Data_brutes/Toutes_especes/mammi_regroup_somme.shp")

# Aisne

pression_aisne_mammi$annees <- substr(pression_aisne_mammi$date, 1,4)

pression_annees_aisne_mammi <- pression_aisne_mammi %>%
  group_by(id, annees)%>%
  summarise(passage = n(),.groups="drop")

indice_pression_aisne_mammi <- pression_annees_aisne_mammi %>%
  filter(!is.na(annees)) %>%
  group_by(id)%>%
  summarise(nb_moy = mean(passage))

indice_pression_aisne_mammi$nb_moy <- round(indice_pression_aisne_mammi$nb_moy, 0)

save(indice_pression_aisne_mammi, file="Data_analyses/Toutes_especes/indice_pression_aisne_mammi")

# Nord
pression_nord_mammi$annees <- substr(pression_nord_mammi$date, 1,4)

pression_annees_nord_mammi <- pression_nord_mammi %>%
  group_by(id, annees)%>%
  summarise(passage = n(),.groups="drop")

indice_pression_nord_mammi <- pression_annees_nord_mammi %>%
  filter(!is.na(annees)) %>%
  group_by(id)%>%
  summarise(nb_moy = mean(passage))

indice_pression_nord_mammi$nb_moy <- round(indice_pression_nord_mammi$nb_moy, 0)

save(indice_pression_nord_mammi, file="Data_analyses/Toutes_especes/indice_pression_nord_mammi")

# Oise

pression_oise_mammi$annees <- substr(pression_oise_mammi$date, 1,4)

pression_annees_oise_mammi <- pression_oise_mammi %>%
  group_by(id, annees)%>%
  summarise(passage = n(),.groups="drop")

indice_pression_oise_mammi <- pression_annees_oise_mammi %>%
  filter(!is.na(annees)) %>%
  group_by(id)%>%
  summarise(nb_moy = mean(passage))

indice_pression_oise_mammi$nb_moy <- round(indice_pression_oise_mammi$nb_moy, 0)

save(indice_pression_oise_mammi, file="Data_analyses/Toutes_especes/indice_pression_oise_mammi")

# Pas-de-Calais
pression_pascalais_mammi$annees <- substr(pression_pascalais_mammi$date, 1,4)

pression_annees_pascalais_mammi <- pression_pascalais_mammi %>%
  group_by(id, annees)%>%
  summarise(passage = n(),.groups="drop")

indice_pression_pascalais_mammi <- pression_annees_pascalais_mammi %>%
  filter(!is.na(annees)) %>%
  group_by(id)%>%
  summarise(nb_moy = mean(passage))

indice_pression_pascalais_mammi$nb_moy <- round(indice_pression_pascalais_mammi$nb_moy, 0)

save(indice_pression_pascalais_mammi, file="Data_analyses/Toutes_especes/indice_pression_pascalais_mammi")



# Somme
pression_somme_mammi$annees <- substr(pression_somme_mammi$date, 1,4)

pression_annees_somme_mammi <- pression_somme_mammi %>%
  group_by(id, annees)%>%
  summarise(passage = n(),.groups="drop")

indice_pression_somme_mammi <- pression_annees_somme_mammi %>%
  filter(!is.na(annees)) %>%
  group_by(id)%>%
  summarise(nb_moy = mean(passage))

indice_pression_somme_mammi$nb_moy <- round(indice_pression_somme_mammi$nb_moy, 0)

save(indice_pression_somme_mammi, file="Data_analyses/Toutes_especes/indice_pression_somme_mammi")


###### Définition des classes ######
###### Calcul nombre de classes - Règle de Sturges ######
k_aisne_mammi = round(1 + 3.22*log10(nrow(indice_pression_aisne_mammi)), 0)
k_aisne_mammi

k_nord_mammi = round(1 + 3.22*log10(nrow(indice_pression_nord_mammi)), 0)
k_nord_mammi

k_oise_mammi = round(1 + 3.22*log10(nrow(indice_pression_oise_mammi)), 0)
k_oise_mammi

k_pascalais_mammi = round(1 + 3.22*log10(nrow(indice_pression_pascalais_mammi)), 0)
k_pascalais_mammi

k_somme_mammi = round(1 + 3.22*log10(nrow(indice_pression_somme_mammi)), 0)
k_somme_mammi

###### Calcul des bornes intervalles ######

amp_aisne_mammi = (max(indice_pression_aisne_mammi$nb_moy) - min(indice_pression_aisne_mammi$nb_moy))/k_aisne_mammi


indice_pression_aisne_classe_mammi <- cut(indice_pression_aisne_mammi$nb_moy, 9)


##### Enregistrer les fichiers QGIS #####
st_write(indice_pression_aisne_mammi,
         "Output_qgis/Toutes_especes/indice_pression_aisne_mammi.shp")

st_write(indice_pression_nord_mammi,
         "Output_qgis/Toutes_especes/indice_pression_nord_mammi.shp")

st_write(indice_pression_oise_mammi,
         "Output_qgis/Toutes_especes/indice_pression_oise_mammi.shp")

st_write(indice_pression_pascalais_mammi,
         "Output_qgis/Toutes_especes/indice_pression_pascalais_mammi.shp")

st_write(indice_pression_somme_mammi,
         "Output_qgis/Toutes_especes/indice_pression_somme_mammi.shp")






##### Odonates #####
###### Préparer les fichiers ######
pression_aisne_odon <- st_read("Data_brutes/Toutes_especes/odon_regroup_aisne.shp")
pression_nord_odon <- st_read("Data_brutes/Toutes_especes/odon_regroup_nord.shp")
pression_oise_odon <- st_read("Data_brutes/Toutes_especes/odon_regroup_oise.shp")
pression_pascalais_odon <- st_read("Data_brutes/Toutes_especes/odon_regroup_pascalais.shp")
pression_somme_odon <- st_read("Data_brutes/Toutes_especes/odon_regroup_somme.shp")

# Aisne

pression_aisne_odon$annees <- substr(pression_aisne_odon$date, 1,4)

pression_annees_aisne_odon <- pression_aisne_odon %>%
  group_by(id, annees)%>%
  summarise(passage = n(),.groups="drop")

indice_pression_aisne_odon <- pression_annees_aisne_odon %>%
  filter(!is.na(annees)) %>%
  group_by(id)%>%
  summarise(nb_moy = mean(passage))

indice_pression_aisne_odon$nb_moy <- round(indice_pression_aisne_odon$nb_moy, 0)

save(indice_pression_aisne_odon, file="Data_analyses/Toutes_especes/indice_pression_aisne_odon")

# Nord
pression_nord_odon$annees <- substr(pression_nord_odon$date, 1,4)

pression_annees_nord_odon <- pression_nord_odon %>%
  group_by(id, annees)%>%
  summarise(passage = n(),.groups="drop")

indice_pression_nord_odon <- pression_annees_nord_odon %>%
  filter(!is.na(annees)) %>%
  group_by(id)%>%
  summarise(nb_moy = mean(passage))

indice_pression_nord_odon$nb_moy <- round(indice_pression_nord_odon$nb_moy, 0)

save(indice_pression_nord_odon, file="Data_analyses/Toutes_especes/indice_pression_nord_odon")

# Oise

pression_oise_odon$annees <- substr(pression_oise_odon$date, 1,4)

pression_annees_oise_odon <- pression_oise_odon %>%
  group_by(id, annees)%>%
  summarise(passage = n(),.groups="drop")

indice_pression_oise_odon <- pression_annees_oise_odon %>%
  filter(!is.na(annees)) %>%
  group_by(id)%>%
  summarise(nb_moy = mean(passage))

indice_pression_oise_odon$nb_moy <- round(indice_pression_oise_odon$nb_moy, 0)

save(indice_pression_oise_odon, file="Data_analyses/Toutes_especes/indice_pression_oise_odon")

# Pas-de-Calais
pression_pascalais_odon$annees <- substr(pression_pascalais_odon$date, 1,4)

pression_annees_pascalais_odon <- pression_pascalais_odon %>%
  group_by(id, annees)%>%
  summarise(passage = n(),.groups="drop")

indice_pression_pascalais_odon <- pression_annees_pascalais_odon %>%
  filter(!is.na(annees)) %>%
  group_by(id)%>%
  summarise(nb_moy = mean(passage))

indice_pression_pascalais_odon$nb_moy <- round(indice_pression_pascalais_odon$nb_moy, 0)

save(indice_pression_pascalais_odon, file="Data_analyses/Toutes_especes/indice_pression_pascalais_odon")



# Somme
pression_somme_odon$annees <- substr(pression_somme_odon$date, 1,4)

pression_annees_somme_odon <- pression_somme_odon %>%
  group_by(id, annees)%>%
  summarise(passage = n(),.groups="drop")

indice_pression_somme_odon <- pression_annees_somme_odon %>%
  filter(!is.na(annees)) %>%
  group_by(id)%>%
  summarise(nb_moy = mean(passage))

indice_pression_somme_odon$nb_moy <- round(indice_pression_somme_odon$nb_moy, 0)

save(indice_pression_somme_odon, file="Data_analyses/Toutes_especes/indice_pression_somme_odon")


###### Définition des classes ######
###### Calcul nombre de classes - Règle de Sturges ######
k_aisne_odon = round(1 + 3.22*log10(nrow(indice_pression_aisne_odon)), 0)
k_aisne_odon

k_nord_odon = round(1 + 3.22*log10(nrow(indice_pression_nord_odon)), 0)
k_nord_odon

k_oise_odon = round(1 + 3.22*log10(nrow(indice_pression_oise_odon)), 0)
k_oise_odon

k_pascalais_odon = round(1 + 3.22*log10(nrow(indice_pression_pascalais_odon)), 0)
k_pascalais_odon

k_somme_odon = round(1 + 3.22*log10(nrow(indice_pression_somme_odon)), 0)
k_somme_odon

###### Calcul des bornes intervalles ######

amp_aisne_odon = (max(indice_pression_aisne_odon$nb_moy) - min(indice_pression_aisne_odon$nb_moy))/k_aisne_odon


indice_pression_aisne_classe_odon <- cut(indice_pression_aisne_odon$nb_moy, 9)


##### Enregistrer les fichiers QGIS #####
st_write(indice_pression_aisne_odon,
         "Output_qgis/Toutes_especes/indice_pression_aisne_odon.shp")

st_write(indice_pression_nord_odon,
         "Output_qgis/Toutes_especes/indice_pression_nord_odon.shp")

st_write(indice_pression_oise_odon,
         "Output_qgis/Toutes_especes/indice_pression_oise_odon.shp")

st_write(indice_pression_pascalais_odon,
         "Output_qgis/Toutes_especes/indice_pression_pascalais_odon.shp")

st_write(indice_pression_somme_odon,
         "Output_qgis/Toutes_especes/indice_pression_somme_odon.shp")






##### Oiseaux #####
###### Préparer les fichiers ######
pression_aisne_oiseaux <- st_read("Data_brutes/Toutes_especes/oiseaux_regroup_aisne.shp")
pression_nord_oiseaux <- st_read("Data_brutes/Toutes_especes/oiseaux_regroup_nord.shp")
pression_oise_oiseaux <- st_read("Data_brutes/Toutes_especes/oiseaux_regroup_oise.shp")
pression_pascalais_oiseaux <- st_read("Data_brutes/Toutes_especes/oiseaux_regroup_pascalais.shp")
pression_somme_oiseaux <- st_read("Data_brutes/Toutes_especes/oiseaux_regroup_somme.shp")

# Aisne

pression_aisne_oiseaux$annees <- substr(pression_aisne_oiseaux$date, 1,4)

pression_annees_aisne_oiseaux <- pression_aisne_oiseaux %>%
  group_by(id, annees)%>%
  summarise(passage = n(),.groups="drop")

indice_pression_aisne_oiseaux <- pression_annees_aisne_oiseaux %>%
  filter(!is.na(annees)) %>%
  group_by(id)%>%
  summarise(nb_moy = mean(passage))

indice_pression_aisne_oiseaux$nb_moy <- round(indice_pression_aisne_oiseaux$nb_moy, 0)

save(indice_pression_aisne_oiseaux, file="Data_analyses/Toutes_especes/indice_pression_aisne_oiseaux")

# Nord
pression_nord_oiseaux$annees <- substr(pression_nord_oiseaux$date, 1,4)

pression_annees_nord_oiseaux <- pression_nord_oiseaux %>%
  group_by(id, annees)%>%
  summarise(passage = n(),.groups="drop")

indice_pression_nord_oiseaux <- pression_annees_nord_oiseaux %>%
  filter(!is.na(annees)) %>%
  group_by(id)%>%
  summarise(nb_moy = mean(passage))

indice_pression_nord_oiseaux$nb_moy <- round(indice_pression_nord_oiseaux$nb_moy, 0)

save(indice_pression_nord_oiseaux, file="Data_analyses/Toutes_especes/indice_pression_nord_oiseaux")

# Oise

pression_oise_oiseaux$annees <- substr(pression_oise_oiseaux$date, 1,4)

pression_annees_oise_oiseaux <- pression_oise_oiseaux %>%
  group_by(id, annees)%>%
  summarise(passage = n(),.groups="drop")

indice_pression_oise_oiseaux <- pression_annees_oise_oiseaux %>%
  filter(!is.na(annees)) %>%
  group_by(id)%>%
  summarise(nb_moy = mean(passage))

indice_pression_oise_oiseaux$nb_moy <- round(indice_pression_oise_oiseaux$nb_moy, 0)

save(indice_pression_oise_oiseaux, file="Data_analyses/Toutes_especes/indice_pression_oise_oiseaux")

# Pas-de-Calais
pression_pascalais_oiseaux$annees <- substr(pression_pascalais_oiseaux$date, 1,4)

pression_annees_pascalais_oiseaux <- pression_pascalais_oiseaux %>%
  group_by(id, annees)%>%
  summarise(passage = n(),.groups="drop")

indice_pression_pascalais_oiseaux <- pression_annees_pascalais_oiseaux %>%
  filter(!is.na(annees)) %>%
  group_by(id)%>%
  summarise(nb_moy = mean(passage))

indice_pression_pascalais_oiseaux$nb_moy <- round(indice_pression_pascalais_oiseaux$nb_moy, 0)

save(indice_pression_pascalais_oiseaux, file="Data_analyses/Toutes_especes/indice_pression_pascalais_oiseaux")



# Somme
pression_somme_oiseaux$annees <- substr(pression_somme_oiseaux$date, 1,4)

pression_annees_somme_oiseaux <- pression_somme_oiseaux %>%
  group_by(id, annees)%>%
  summarise(passage = n(),.groups="drop")

indice_pression_somme_oiseaux <- pression_annees_somme_oiseaux %>%
  filter(!is.na(annees)) %>%
  group_by(id)%>%
  summarise(nb_moy = mean(passage))

indice_pression_somme_oiseaux$nb_moy <- round(indice_pression_somme_oiseaux$nb_moy, 0)

save(indice_pression_somme_oiseaux, file="Data_analyses/Toutes_especes/indice_pression_somme_oiseaux")


###### Définition des classes ######
###### Calcul nombre de classes - Règle de Sturges ######
k_aisne_oiseaux = round(1 + 3.22*log10(nrow(indice_pression_aisne_oiseaux)), 0)
k_aisne_oiseaux

k_nord_oiseaux = round(1 + 3.22*log10(nrow(indice_pression_nord_oiseaux)), 0)
k_nord_oiseaux

k_oise_oiseaux = round(1 + 3.22*log10(nrow(indice_pression_oise_oiseaux)), 0)
k_oise_oiseaux

k_pascalais_oiseaux = round(1 + 3.22*log10(nrow(indice_pression_pascalais_oiseaux)), 0)
k_pascalais_oiseaux

k_somme_oiseaux = round(1 + 3.22*log10(nrow(indice_pression_somme_oiseaux)), 0)
k_somme_oiseaux

###### Calcul des bornes intervalles ######

amp_aisne_oiseaux = (max(indice_pression_aisne_oiseaux$nb_moy) - min(indice_pression_aisne_oiseaux$nb_moy))/k_aisne_oiseaux


indice_pression_aisne_classe_oiseaux <- cut(indice_pression_aisne_oiseaux$nb_moy, 9)


##### Enregistrer les fichiers QGIS #####
st_write(indice_pression_aisne_oiseaux,
         "Output_qgis/Toutes_especes/indice_pression_aisne_oiseaux.shp")

st_write(indice_pression_nord_oiseaux,
         "Output_qgis/Toutes_especes/indice_pression_nord_oiseaux.shp")

st_write(indice_pression_oise_oiseaux,
         "Output_qgis/Toutes_especes/indice_pression_oise_oiseaux.shp")

st_write(indice_pression_pascalais_oiseaux,
         "Output_qgis/Toutes_especes/indice_pression_pascalais_oiseaux.shp")

st_write(indice_pression_somme_oiseaux,
         "Output_qgis/Toutes_especes/indice_pression_somme_oiseaux.shp")





##### Orthopères #####
###### Préparer les fichiers ######
pression_aisne_orthop <- st_read("Data_brutes/Toutes_especes/orthop_regroup_aisne.shp")
pression_nord_orthop <- st_read("Data_brutes/Toutes_especes/orthop_regroup_nord.shp")
pression_oise_orthop <- st_read("Data_brutes/Toutes_especes/orthop_regroup_oise.shp")
pression_pascalais_orthop <- st_read("Data_brutes/Toutes_especes/orthop_regroup_pascalais.shp")
pression_somme_orthop <- st_read("Data_brutes/Toutes_especes/orthop_regroup_somme.shp")

# Aisne

pression_aisne_orthop$annees <- substr(pression_aisne_orthop$date, 1,4)

pression_annees_aisne_orthop <- pression_aisne_orthop %>%
  group_by(id, annees)%>%
  summarise(passage = n(),.groups="drop")

indice_pression_aisne_orthop <- pression_annees_aisne_orthop %>%
  filter(!is.na(annees)) %>%
  group_by(id)%>%
  summarise(nb_moy = mean(passage))

indice_pression_aisne_orthop$nb_moy <- round(indice_pression_aisne_orthop$nb_moy, 0)

save(indice_pression_aisne_orthop, file="Data_analyses/Toutes_especes/indice_pression_aisne_orthop")

# Nord
pression_nord_orthop$annees <- substr(pression_nord_orthop$date, 1,4)

pression_annees_nord_orthop <- pression_nord_orthop %>%
  group_by(id, annees)%>%
  summarise(passage = n(),.groups="drop")

indice_pression_nord_orthop <- pression_annees_nord_orthop %>%
  filter(!is.na(annees)) %>%
  group_by(id)%>%
  summarise(nb_moy = mean(passage))

indice_pression_nord_orthop$nb_moy <- round(indice_pression_nord_orthop$nb_moy, 0)

save(indice_pression_nord_orthop, file="Data_analyses/Toutes_especes/indice_pression_nord_orthop")

# Oise

pression_oise_orthop$annees <- substr(pression_oise_orthop$date, 1,4)

pression_annees_oise_orthop <- pression_oise_orthop %>%
  group_by(id, annees)%>%
  summarise(passage = n(),.groups="drop")

indice_pression_oise_orthop <- pression_annees_oise_orthop %>%
  filter(!is.na(annees)) %>%
  group_by(id)%>%
  summarise(nb_moy = mean(passage))

indice_pression_oise_orthop$nb_moy <- round(indice_pression_oise_orthop$nb_moy, 0)

save(indice_pression_oise_orthop, file="Data_analyses/Toutes_especes/indice_pression_oise_orthop")

# Pas-de-Calais
pression_pascalais_orthop$annees <- substr(pression_pascalais_orthop$date, 1,4)

pression_annees_pascalais_orthop <- pression_pascalais_orthop %>%
  group_by(id, annees)%>%
  summarise(passage = n(),.groups="drop")

indice_pression_pascalais_orthop <- pression_annees_pascalais_orthop %>%
  filter(!is.na(annees)) %>%
  group_by(id)%>%
  summarise(nb_moy = mean(passage))

indice_pression_pascalais_orthop$nb_moy <- round(indice_pression_pascalais_orthop$nb_moy, 0)

save(indice_pression_pascalais_orthop, file="Data_analyses/Toutes_especes/indice_pression_pascalais_orthop")



# Somme
pression_somme_orthop$annees <- substr(pression_somme_orthop$date, 1,4)

pression_annees_somme_orthop <- pression_somme_orthop %>%
  group_by(id, annees)%>%
  summarise(passage = n(),.groups="drop")

indice_pression_somme_orthop <- pression_annees_somme_orthop %>%
  filter(!is.na(annees)) %>%
  group_by(id)%>%
  summarise(nb_moy = mean(passage))

indice_pression_somme_orthop$nb_moy <- round(indice_pression_somme_orthop$nb_moy, 0)

save(indice_pression_somme_orthop, file="Data_analyses/Toutes_especes/indice_pression_somme_orthop")


###### Définition des classes ######
###### Calcul nombre de classes - Règle de Sturges ######
k_aisne_orthop = round(1 + 3.22*log10(nrow(indice_pression_aisne_orthop)), 0)
k_aisne_orthop

k_nord_orthop = round(1 + 3.22*log10(nrow(indice_pression_nord_orthop)), 0)
k_nord_orthop

k_oise_orthop = round(1 + 3.22*log10(nrow(indice_pression_oise_orthop)), 0)
k_oise_orthop

k_pascalais_orthop = round(1 + 3.22*log10(nrow(indice_pression_pascalais_orthop)), 0)
k_pascalais_orthop

k_somme_orthop = round(1 + 3.22*log10(nrow(indice_pression_somme_orthop)), 0)
k_somme_orthop

###### Calcul des bornes intervalles ######

amp_aisne_orthop = (max(indice_pression_aisne_orthop$nb_moy) - min(indice_pression_aisne_orthop$nb_moy))/k_aisne_orthop


indice_pression_aisne_classe_orthop <- cut(indice_pression_aisne_orthop$nb_moy, 9)


##### Enregistrer les fichiers QGIS #####
st_write(indice_pression_aisne_orthop,
         "Output_qgis/Toutes_especes/indice_pression_aisne_orthop.shp")

st_write(indice_pression_nord_orthop,
         "Output_qgis/Toutes_especes/indice_pression_nord_orthop.shp")

st_write(indice_pression_oise_orthop,
         "Output_qgis/Toutes_especes/indice_pression_oise_orthop.shp")

st_write(indice_pression_pascalais_orthop,
         "Output_qgis/Toutes_especes/indice_pression_pascalais_orthop.shp")

st_write(indice_pression_somme_orthop,
         "Output_qgis/Toutes_especes/indice_pression_somme_orthop.shp")




##### Poissons #####
###### Préparer les fichiers ######
pression_aisne_poissons <- st_read("Data_brutes/Toutes_especes/poissons_regroup_aisne.shp")
pression_nord_poissons <- st_read("Data_brutes/Toutes_especes/poissons_regroup_nord.shp")
pression_oise_poissons <- st_read("Data_brutes/Toutes_especes/poissons_regroup_oise.shp")
pression_pascalais_poissons <- st_read("Data_brutes/Toutes_especes/poissons_regroup_pascalais.shp")
pression_somme_poissons <- st_read("Data_brutes/Toutes_especes/poissons_regroup_somme.shp")

# Aisne

pression_aisne_poissons$annees <- substr(pression_aisne_poissons$date, 1,4)

pression_annees_aisne_poissons <- pression_aisne_poissons %>%
  group_by(id, annees)%>%
  summarise(passage = n(),.groups="drop")

indice_pression_aisne_poissons <- pression_annees_aisne_poissons %>%
  filter(!is.na(annees)) %>%
  group_by(id)%>%
  summarise(nb_moy = mean(passage))

indice_pression_aisne_poissons$nb_moy <- round(indice_pression_aisne_poissons$nb_moy, 0)

save(indice_pression_aisne_poissons, file="Data_analyses/Toutes_especes/indice_pression_aisne_poissons")

# Nord
pression_nord_poissons$annees <- substr(pression_nord_poissons$date, 1,4)

pression_annees_nord_poissons <- pression_nord_poissons %>%
  group_by(id, annees)%>%
  summarise(passage = n(),.groups="drop")

indice_pression_nord_poissons <- pression_annees_nord_poissons %>%
  filter(!is.na(annees)) %>%
  group_by(id)%>%
  summarise(nb_moy = mean(passage))

indice_pression_nord_poissons$nb_moy <- round(indice_pression_nord_poissons$nb_moy, 0)

save(indice_pression_nord_poissons, file="Data_analyses/Toutes_especes/indice_pression_nord_poissons")

# Oise

pression_oise_poissons$annees <- substr(pression_oise_poissons$date, 1,4)

pression_annees_oise_poissons <- pression_oise_poissons %>%
  group_by(id, annees)%>%
  summarise(passage = n(),.groups="drop")

indice_pression_oise_poissons <- pression_annees_oise_poissons %>%
  filter(!is.na(annees)) %>%
  group_by(id)%>%
  summarise(nb_moy = mean(passage))

indice_pression_oise_poissons$nb_moy <- round(indice_pression_oise_poissons$nb_moy, 0)

save(indice_pression_oise_poissons, file="Data_analyses/Toutes_especes/indice_pression_oise_poissons")

# Pas-de-Calais
pression_pascalais_poissons$annees <- substr(pression_pascalais_poissons$date, 1,4)

pression_annees_pascalais_poissons <- pression_pascalais_poissons %>%
  group_by(id, annees)%>%
  summarise(passage = n(),.groups="drop")

indice_pression_pascalais_poissons <- pression_annees_pascalais_poissons %>%
  filter(!is.na(annees)) %>%
  group_by(id)%>%
  summarise(nb_moy = mean(passage))

indice_pression_pascalais_poissons$nb_moy <- round(indice_pression_pascalais_poissons$nb_moy, 0)

save(indice_pression_pascalais_poissons, file="Data_analyses/Toutes_especes/indice_pression_pascalais_poissons")



# Somme
pression_somme_poissons$annees <- substr(pression_somme_poissons$date, 1,4)

pression_annees_somme_poissons <- pression_somme_poissons %>%
  group_by(id, annees)%>%
  summarise(passage = n(),.groups="drop")

indice_pression_somme_poissons <- pression_annees_somme_poissons %>%
  filter(!is.na(annees)) %>%
  group_by(id)%>%
  summarise(nb_moy = mean(passage))

indice_pression_somme_poissons$nb_moy <- round(indice_pression_somme_poissons$nb_moy, 0)

save(indice_pression_somme_poissons, file="Data_analyses/Toutes_especes/indice_pression_somme_poissons")


###### Définition des classes ######
###### Calcul nombre de classes - Règle de Sturges ######
k_aisne_poissons = round(1 + 3.22*log10(nrow(indice_pression_aisne_poissons)), 0)
k_aisne_poissons

k_nord_poissons = round(1 + 3.22*log10(nrow(indice_pression_nord_poissons)), 0)
k_nord_poissons

k_oise_poissons = round(1 + 3.22*log10(nrow(indice_pression_oise_poissons)), 0)
k_oise_poissons

k_pascalais_poissons = round(1 + 3.22*log10(nrow(indice_pression_pascalais_poissons)), 0)
k_pascalais_poissons

k_somme_poissons = round(1 + 3.22*log10(nrow(indice_pression_somme_poissons)), 0)
k_somme_poissons

###### Calcul des bornes intervalles ######

amp_aisne_poissons = (max(indice_pression_aisne_poissons$nb_moy) - min(indice_pression_aisne_poissons$nb_moy))/k_aisne_poissons


indice_pression_aisne_classe_poissons <- cut(indice_pression_aisne_poissons$nb_moy, 9)


##### Enregistrer les fichiers QGIS #####
st_write(indice_pression_aisne_poissons,
         "Output_qgis/Toutes_especes/indice_pression_aisne_poissons.shp")

st_write(indice_pression_nord_poissons,
         "Output_qgis/Toutes_especes/indice_pression_nord_poissons.shp")

st_write(indice_pression_oise_poissons,
         "Output_qgis/Toutes_especes/indice_pression_oise_poissons.shp")

st_write(indice_pression_pascalais_poissons,
         "Output_qgis/Toutes_especes/indice_pression_pascalais_poissons.shp")

st_write(indice_pression_somme_poissons,
         "Output_qgis/Toutes_especes/indice_pression_somme_poissons.shp")




##### Reptiles #####
###### Préparer les fichiers ######
pression_aisne_reptiles <- st_read("Data_brutes/Toutes_especes/reptiles_regroup_aisne.shp")
pression_nord_reptiles <- st_read("Data_brutes/Toutes_especes/reptiles_regroup_nord.shp")
pression_oise_reptiles <- st_read("Data_brutes/Toutes_especes/reptiles_regroup_oise.shp")
pression_pascalais_reptiles <- st_read("Data_brutes/Toutes_especes/reptiles_regroup_pascalais.shp")
pression_somme_reptiles <- st_read("Data_brutes/Toutes_especes/reptiles_regroup_somme.shp")

# Aisne

pression_aisne_reptiles$annees <- substr(pression_aisne_reptiles$date, 1,4)

pression_annees_aisne_reptiles <- pression_aisne_reptiles %>%
  group_by(id, annees)%>%
  summarise(passage = n(),.groups="drop")

indice_pression_aisne_reptiles <- pression_annees_aisne_reptiles %>%
  filter(!is.na(annees)) %>%
  group_by(id)%>%
  summarise(nb_moy = mean(passage))

indice_pression_aisne_reptiles$nb_moy <- round(indice_pression_aisne_reptiles$nb_moy, 0)

save(indice_pression_aisne_reptiles, file="Data_analyses/Toutes_especes/indice_pression_aisne_reptiles")

# Nord
pression_nord_reptiles$annees <- substr(pression_nord_reptiles$date, 1,4)

pression_annees_nord_reptiles <- pression_nord_reptiles %>%
  group_by(id, annees)%>%
  summarise(passage = n(),.groups="drop")

indice_pression_nord_reptiles <- pression_annees_nord_reptiles %>%
  filter(!is.na(annees)) %>%
  group_by(id)%>%
  summarise(nb_moy = mean(passage))

indice_pression_nord_reptiles$nb_moy <- round(indice_pression_nord_reptiles$nb_moy, 0)

save(indice_pression_nord_reptiles, file="Data_analyses/Toutes_especes/indice_pression_nord_reptiles")

# Oise

pression_oise_reptiles$annees <- substr(pression_oise_reptiles$date, 1,4)

pression_annees_oise_reptiles <- pression_oise_reptiles %>%
  group_by(id, annees)%>%
  summarise(passage = n(),.groups="drop")

indice_pression_oise_reptiles <- pression_annees_oise_reptiles %>%
  filter(!is.na(annees)) %>%
  group_by(id)%>%
  summarise(nb_moy = mean(passage))

indice_pression_oise_reptiles$nb_moy <- round(indice_pression_oise_reptiles$nb_moy, 0)

save(indice_pression_oise_reptiles, file="Data_analyses/Toutes_especes/indice_pression_oise_reptiles")

# Pas-de-Calais
pression_pascalais_reptiles$annees <- substr(pression_pascalais_reptiles$date, 1,4)

pression_annees_pascalais_reptiles <- pression_pascalais_reptiles %>%
  group_by(id, annees)%>%
  summarise(passage = n(),.groups="drop")

indice_pression_pascalais_reptiles <- pression_annees_pascalais_reptiles %>%
  filter(!is.na(annees)) %>%
  group_by(id)%>%
  summarise(nb_moy = mean(passage))

indice_pression_pascalais_reptiles$nb_moy <- round(indice_pression_pascalais_reptiles$nb_moy, 0)

save(indice_pression_pascalais_reptiles, file="Data_analyses/Toutes_especes/indice_pression_pascalais_reptiles")



# Somme
pression_somme_reptiles$annees <- substr(pression_somme_reptiles$date, 1,4)

pression_annees_somme_reptiles <- pression_somme_reptiles %>%
  group_by(id, annees)%>%
  summarise(passage = n(),.groups="drop")

indice_pression_somme_reptiles <- pression_annees_somme_reptiles %>%
  filter(!is.na(annees)) %>%
  group_by(id)%>%
  summarise(nb_moy = mean(passage))

indice_pression_somme_reptiles$nb_moy <- round(indice_pression_somme_reptiles$nb_moy, 0)

save(indice_pression_somme_reptiles, file="Data_analyses/Toutes_especes/indice_pression_somme_reptiles")


###### Définition des classes ######
###### Calcul nombre de classes - Règle de Sturges ######
k_aisne_reptiles = round(1 + 3.22*log10(nrow(indice_pression_aisne_reptiles)), 0)
k_aisne_reptiles

k_nord_reptiles = round(1 + 3.22*log10(nrow(indice_pression_nord_reptiles)), 0)
k_nord_reptiles

k_oise_reptiles = round(1 + 3.22*log10(nrow(indice_pression_oise_reptiles)), 0)
k_oise_reptiles

k_pascalais_reptiles = round(1 + 3.22*log10(nrow(indice_pression_pascalais_reptiles)), 0)
k_pascalais_reptiles

k_somme_reptiles = round(1 + 3.22*log10(nrow(indice_pression_somme_reptiles)), 0)
k_somme_reptiles

###### Calcul des bornes intervalles ######

amp_aisne_reptiles = (max(indice_pression_aisne_reptiles$nb_moy) - min(indice_pression_aisne_reptiles$nb_moy))/k_aisne_reptiles


indice_pression_aisne_classe_reptiles <- cut(indice_pression_aisne_reptiles$nb_moy, 9)


##### Enregistrer les fichiers QGIS #####
st_write(indice_pression_aisne_reptiles,
         "Output_qgis/Toutes_especes/indice_pression_aisne_reptiles.shp")

st_write(indice_pression_nord_reptiles,
         "Output_qgis/Toutes_especes/indice_pression_nord_reptiles.shp")

st_write(indice_pression_oise_reptiles,
         "Output_qgis/Toutes_especes/indice_pression_oise_reptiles.shp")

st_write(indice_pression_pascalais_reptiles,
         "Output_qgis/Toutes_especes/indice_pression_pascalais_reptiles.shp")

st_write(indice_pression_somme_reptiles,
         "Output_qgis/Toutes_especes/indice_pression_somme_reptiles.shp")




##### Rhopalocères #####
###### Préparer les fichiers ######
pression_aisne_rhopa <- st_read("Data_brutes/Toutes_especes/rhopa_regroup_aisne.shp")
pression_nord_rhopa <- st_read("Data_brutes/Toutes_especes/rhopa_regroup_nord.shp")
pression_oise_rhopa <- st_read("Data_brutes/Toutes_especes/rhopa_regroup_oise.shp")
pression_pascalais_rhopa <- st_read("Data_brutes/Toutes_especes/rhopa_regroup_pascalais.shp")
pression_somme_rhopa <- st_read("Data_brutes/Toutes_especes/rhopa_regroup_somme.shp")

# Aisne

pression_aisne_rhopa$annees <- substr(pression_aisne_rhopa$date, 1,4)

pression_annees_aisne_rhopa <- pression_aisne_rhopa %>%
  group_by(id, annees)%>%
  summarise(passage = n(),.groups="drop")

indice_pression_aisne_rhopa <- pression_annees_aisne_rhopa %>%
  filter(!is.na(annees)) %>%
  group_by(id)%>%
  summarise(nb_moy = mean(passage))

indice_pression_aisne_rhopa$nb_moy <- round(indice_pression_aisne_rhopa$nb_moy, 0)

save(indice_pression_aisne_rhopa, file="Data_analyses/Toutes_especes/indice_pression_aisne_rhopa")

# Nord
pression_nord_rhopa$annees <- substr(pression_nord_rhopa$date, 1,4)

pression_annees_nord_rhopa <- pression_nord_rhopa %>%
  group_by(id, annees)%>%
  summarise(passage = n(),.groups="drop")

indice_pression_nord_rhopa <- pression_annees_nord_rhopa %>%
  filter(!is.na(annees)) %>%
  group_by(id)%>%
  summarise(nb_moy = mean(passage))

indice_pression_nord_rhopa$nb_moy <- round(indice_pression_nord_rhopa$nb_moy, 0)

save(indice_pression_nord_rhopa, file="Data_analyses/Toutes_especes/indice_pression_nord_rhopa")

# Oise

pression_oise_rhopa$annees <- substr(pression_oise_rhopa$date, 1,4)

pression_annees_oise_rhopa <- pression_oise_rhopa %>%
  group_by(id, annees)%>%
  summarise(passage = n(),.groups="drop")

indice_pression_oise_rhopa <- pression_annees_oise_rhopa %>%
  filter(!is.na(annees)) %>%
  group_by(id)%>%
  summarise(nb_moy = mean(passage))

indice_pression_oise_rhopa$nb_moy <- round(indice_pression_oise_rhopa$nb_moy, 0)

save(indice_pression_oise_rhopa, file="Data_analyses/Toutes_especes/indice_pression_oise_rhopa")

# Pas-de-Calais
pression_pascalais_rhopa$annees <- substr(pression_pascalais_rhopa$date, 1,4)

pression_annees_pascalais_rhopa <- pression_pascalais_rhopa %>%
  group_by(id, annees)%>%
  summarise(passage = n(),.groups="drop")

indice_pression_pascalais_rhopa <- pression_annees_pascalais_rhopa %>%
  filter(!is.na(annees)) %>%
  group_by(id)%>%
  summarise(nb_moy = mean(passage))

indice_pression_pascalais_rhopa$nb_moy <- round(indice_pression_pascalais_rhopa$nb_moy, 0)

save(indice_pression_pascalais_rhopa, file="Data_analyses/Toutes_especes/indice_pression_pascalais_rhopa")



# Somme
pression_somme_rhopa$annees <- substr(pression_somme_rhopa$date, 1,4)

pression_annees_somme_rhopa <- pression_somme_rhopa %>%
  group_by(id, annees)%>%
  summarise(passage = n(),.groups="drop")

indice_pression_somme_rhopa <- pression_annees_somme_rhopa %>%
  filter(!is.na(annees)) %>%
  group_by(id)%>%
  summarise(nb_moy = mean(passage))

indice_pression_somme_rhopa$nb_moy <- round(indice_pression_somme_rhopa$nb_moy, 0)

save(indice_pression_somme_rhopa, file="Data_analyses/Toutes_especes/indice_pression_somme_rhopa")


###### Définition des classes ######
###### Calcul nombre de classes - Règle de Sturges ######
k_aisne_rhopa = round(1 + 3.22*log10(nrow(indice_pression_aisne_rhopa)), 0)
k_aisne_rhopa

k_nord_rhopa = round(1 + 3.22*log10(nrow(indice_pression_nord_rhopa)), 0)
k_nord_rhopa

k_oise_rhopa = round(1 + 3.22*log10(nrow(indice_pression_oise_rhopa)), 0)
k_oise_rhopa

k_pascalais_rhopa = round(1 + 3.22*log10(nrow(indice_pression_pascalais_rhopa)), 0)
k_pascalais_rhopa

k_somme_rhopa = round(1 + 3.22*log10(nrow(indice_pression_somme_rhopa)), 0)
k_somme_rhopa

###### Calcul des bornes intervalles ######

amp_aisne_rhopa = (max(indice_pression_aisne_rhopa$nb_moy) - min(indice_pression_aisne_rhopa$nb_moy))/k_aisne_rhopa


indice_pression_aisne_classe_rhopa <- cut(indice_pression_aisne_rhopa$nb_moy, 9)


##### Enregistrer les fichiers QGIS #####
st_write(indice_pression_aisne_rhopa,
         "Output_qgis/Toutes_especes/indice_pression_aisne_rhopa.shp")

st_write(indice_pression_nord_rhopa,
         "Output_qgis/Toutes_especes/indice_pression_nord_rhopa.shp")

st_write(indice_pression_oise_rhopa,
         "Output_qgis/Toutes_especes/indice_pression_oise_rhopa.shp")

st_write(indice_pression_pascalais_rhopa,
         "Output_qgis/Toutes_especes/indice_pression_pascalais_rhopa.shp")

st_write(indice_pression_somme_rhopa,
         "Output_qgis/Toutes_especes/indice_pression_somme_rhopa.shp")


