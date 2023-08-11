library(dplyr)
library(sf) 

# Chargement des valeurs seuils #
table_seuil_departement <- read.csv(file="Data_brutes/valeurs_seuils.csv", h=T, dec=",", sep=";")

#### Aisne ####
##### Tous groupes taxonomiques confondus #####
taxo_maille_aisne<- st_read("Data_brutes/Toutes_especes/taxo_regroup_aisne.shp")

taxo_regroup_aisne <- taxo_maille_aisne %>%
  group_by(id,groupe_tax)%>%
  summarise(nb = n(), .groups = 'drop')

taxo_table_aisne <- merge(taxo_regroup_aisne, table_seuil_departement, by.x="groupe_tax", by.y="groupe")

for (i in 1:nrow(taxo_table_aisne)){
  if ((taxo_table_aisne$nb[i]) < taxo_table_aisne$seuil_dept[i]){
    taxo_table_aisne$div_spec[i]<-0
  }else taxo_table_aisne$div_spec[i] <- 1
}

taxo_indice_aisne <- taxo_table_aisne %>%
  group_by(id)%>%
  summarise(ind = mean(div_spec))

for (i in 1:nrow(taxo_indice_aisne)){
  if ((taxo_indice_aisne$ind[i]) == 0){
   taxo_indice_aisne$div_spec[i]<- "Tres mauvaise"}
  if((taxo_indice_aisne$ind[i]) > 0 && (taxo_indice_aisne$ind[i] < 0.50)){
    taxo_indice_aisne$div_spec[i] <- "Moyenne"}
  if ((taxo_indice_aisne$ind[i]) >= 0.50 && (taxo_indice_aisne$ind[i] < 1)){
    taxo_indice_aisne$div_spec[i] <- "Bonne"}
  if ((taxo_indice_aisne$ind[i]) == 1){
    taxo_indice_aisne$div_spec[i] <- "Tres bonne"}
}

save(taxo_indice_aisne, file="Data_analyses/Toutes_especes/indice_maille_aisne.RData")

st_write(taxo_indice_aisne,
         "Output_qgis/Toutes_especes/indice_maille_aisne.shp")

##### Par groupes taxonomiques #####
##### Amphibiens #####
amphi_maille_aisne<- st_read("Data_brutes/Toutes_especes/amphi_regroup_aisne.shp")

amphi_regroup_aisne <- amphi_maille_aisne %>%
  group_by(id,groupe_tax)%>%
  summarise(nb = n(), .groups = 'drop')

amphi_regroup_aisne <- amphi_regroup_aisne%>% filter(!is.na(groupe_tax))

amphi_table_aisne <- merge(amphi_regroup_aisne, table_seuil_departement, by.x="groupe_tax", by.y="groupe")

for (i in 1:nrow(amphi_table_aisne)){
  if ((amphi_table_aisne$nb[i]) < amphi_table_aisne$seuil_dept[i]){
    amphi_table_aisne$div_spec[i]<-"mauvais"
  }else amphi_table_aisne$div_spec[i] <- "bon"
}

save(amphi_table_aisne, file="Data_brutes/Toutes_especes/indice_amphi_aisne.RData")

st_write(amphi_table_aisne,
         "Data_brutes/Toutes_especes/indice_amphi_aisne.shp")

##### Chiropteres #####
chiro_maille_aisne<- st_read("Data_brutes/Toutes_especes/chiro_regroup_aisne.shp")

chiro_regroup_aisne <- chiro_maille_aisne %>%
  group_by(id,groupe_tax)%>%
  summarise(nb = n(), .groups = 'drop')

chiro_regroup_aisne <- chiro_regroup_aisne%>% filter(!is.na(groupe_tax))

chiro_table_aisne <- merge(chiro_regroup_aisne, table_seuil_departement, by.x="groupe_tax", by.y="groupe")

for (i in 1:nrow(chiro_table_aisne)){
  if ((chiro_table_aisne$nb[i]) < chiro_table_aisne$seuil_dept[i]){
    chiro_table_aisne$div_spec[i]<-"mauvais"
  }else chiro_table_aisne$div_spec[i] <- "bon"
}

save(chiro_table_aisne, file="Data_brutes/Toutes_especes/indice_chiro_aisne.RData")

st_write(chiro_table_aisne,
         "Data_brutes/Toutes_especes/indice_chiro_aisne.shp")

##### Mammiferes #####
mammi_maille_aisne<- st_read("Data_brutes/Toutes_especes/mammi_regroup_aisne.shp")

mammi_regroup_aisne <- mammi_maille_aisne %>%
  group_by(id,groupe_tax)%>%
  summarise(nb = n(), .groups = 'drop')

mammi_regroup_aisne <- mammi_regroup_aisne%>% filter(!is.na(groupe_tax))

mammi_table_aisne <- merge(mammi_regroup_aisne, table_seuil_departement, by.x="groupe_tax", by.y="groupe")

for (i in 1:nrow(mammi_table_aisne)){
  if ((mammi_table_aisne$nb[i]) < mammi_table_aisne$seuil_dept[i]){
    mammi_table_aisne$div_spec[i]<-"mauvais"
  }else mammi_table_aisne$div_spec[i] <- "bon"
}

save(mammi_table_aisne, file="Data_brutes/Toutes_especes/indice_mammi_aisne.RData")

st_write(mammi_table_aisne,
         "Data_brutes/Toutes_especes/indice_mammi_aisne.shp")


##### Odonates #####
odon_maille_aisne<- st_read("Data_brutes/Toutes_especes/odon_regroup_aisne.shp")

odon_regroup_aisne <- odon_maille_aisne %>%
  group_by(id,groupe_tax)%>%
  summarise(nb = n(), .groups = 'drop')

odon_regroup_aisne <- odon_regroup_aisne%>% filter(!is.na(groupe_tax))

odon_table_aisne <- merge(odon_regroup_aisne, table_seuil_departement, by.x="groupe_tax", by.y="groupe")

for (i in 1:nrow(odon_table_aisne)){
  if ((odon_table_aisne$nb[i]) < odon_table_aisne$seuil_dept[i]){
    odon_table_aisne$div_spec[i]<-"mauvais"
  }else odon_table_aisne$div_spec[i] <- "bon"
}

save(odon_table_aisne, file="Data_brutes/Toutes_especes/indice_odon_aisne.RData")

st_write(odon_table_aisne,
         "Data_brutes/Toutes_especes/indice_odon_aisne.shp")


##### Orthopteres #####
orthop_maille_aisne<- st_read("Data_brutes/Toutes_especes/orthop_regroup_aisne.shp")

orthop_regroup_aisne <- orthop_maille_aisne %>%
  group_by(id,groupe_tax)%>%
  summarise(nb = n(), .groups = 'drop')

orthop_regroup_aisne <- orthop_regroup_aisne%>% filter(!is.na(groupe_tax))

orthop_table_aisne <- merge(orthop_regroup_aisne, table_seuil_departement, by.x="groupe_tax", by.y="groupe")

for (i in 1:nrow(orthop_table_aisne)){
  if ((orthop_table_aisne$nb[i]) < orthop_table_aisne$seuil_dept[i]){
    orthop_table_aisne$div_spec[i]<-"mauvais"
  }else orthop_table_aisne$div_spec[i] <- "bon"
}

save(orthop_table_aisne, file="Data_brutes/Toutes_especes/indice_orthop_aisne.RData")

st_write(orthop_table_aisne,
         "Data_brutes/Toutes_especes/indice_orthop_aisne.shp")


##### Oiseaux #####
oiseaux_maille_aisne<- st_read("Data_brutes/Toutes_especes/oiseaux_regroup_aisne.shp")

oiseaux_regroup_aisne <- oiseaux_maille_aisne %>%
  group_by(id,groupe_tax)%>%
  summarise(nb = n(), .groups = 'drop')

oiseaux_regroup_aisne <- oiseaux_regroup_aisne%>% filter(!is.na(groupe_tax))

oiseaux_table_aisne <- merge(oiseaux_regroup_aisne, table_seuil_departement, by.x="groupe_tax", by.y="groupe")

for (i in 1:nrow(oiseaux_table_aisne)){
  if ((oiseaux_table_aisne$nb[i]) < oiseaux_table_aisne$seuil_dept[i]){
    oiseaux_table_aisne$div_spec[i]<-"mauvais"
  }else oiseaux_table_aisne$div_spec[i] <- "bon"
}

save(oiseaux_table_aisne, file="Data_brutes/Toutes_especes/indice_oiseaux_aisne.RData")

st_write(oiseaux_table_aisne,
         "Data_brutes/Toutes_especes/indice_oiseaux_aisne.shp")


##### Poissons #####
poissons_maille_aisne<- st_read("Data_brutes/Toutes_especes/poissons_regroup_aisne.shp")

poissons_regroup_aisne <- poissons_maille_aisne %>%
  group_by(id,groupe_tax)%>%
  summarise(nb = n(), .groups = 'drop')

poissons_regroup_aisne <- poissons_regroup_aisne%>% filter(!is.na(groupe_tax))

poissons_table_aisne <- merge(poissons_regroup_aisne, table_seuil_departement, by.x="groupe_tax", by.y="groupe")

for (i in 1:nrow(poissons_table_aisne)){
  if ((poissons_table_aisne$nb[i]) < poissons_table_aisne$seuil_dept[i]){
    poissons_table_aisne$div_spec[i]<-"mauvais"
  }else poissons_table_aisne$div_spec[i] <- "bon"
}

save(poissons_table_aisne, file="Data_brutes/Toutes_especes/indice_poissons_aisne.RData")

st_write(poissons_table_aisne,
         "Data_brutes/Toutes_especes/indice_poissons_aisne.shp")

##### Reptiles #####
reptiles_maille_aisne<- st_read("Data_brutes/Toutes_especes/reptiles_regroup_aisne.shp")

reptiles_regroup_aisne <- reptiles_maille_aisne %>%
  group_by(id,groupe_tax)%>%
  summarise(nb = n(), .groups = 'drop')

reptiles_regroup_aisne <- reptiles_regroup_aisne%>% filter(!is.na(groupe_tax))

reptiles_table_aisne <- merge(reptiles_regroup_aisne, table_seuil_departement, by.x="groupe_tax", by.y="groupe")

for (i in 1:nrow(reptiles_table_aisne)){
  if ((reptiles_table_aisne$nb[i]) < reptiles_table_aisne$seuil_dept[i]){
    reptiles_table_aisne$div_spec[i]<-"mauvais"
  }else reptiles_table_aisne$div_spec[i] <- "bon"
}

save(reptiles_table_aisne, file="Data_brutes/Toutes_especes/indice_reptiles_aisne.RData")

st_write(reptiles_table_aisne,
         "Data_brutes/Toutes_especes/indice_reptiles_aisne.shp")


##### Rhopaloceres #####
rhopa_maille_aisne<- st_read("Data_brutes/Toutes_especes/rhopa_regroup_aisne.shp")

rhopa_regroup_aisne <- rhopa_maille_aisne %>%
  group_by(id,groupe_tax)%>%
  summarise(nb = n(), .groups = 'drop')

rhopa_regroup_aisne <- rhopa_regroup_aisne%>% filter(!is.na(groupe_tax))

rhopa_table_aisne <- merge(rhopa_regroup_aisne, table_seuil_departement, by.x="groupe_tax", by.y="groupe")

for (i in 1:nrow(rhopa_table_aisne)){
  if ((rhopa_table_aisne$nb[i]) < rhopa_table_aisne$seuil_dept[i]){
    rhopa_table_aisne$div_spec[i]<-"mauvais"
  }else rhopa_table_aisne$div_spec[i] <- "bon"
}

save(rhopa_table_aisne, file="Data_brutes/Toutes_especes/indice_rhopa_aisne.RData")

st_write(rhopa_table_aisne,
         "Data_brutes/Toutes_especes/indice_rhopa_aisne.shp")


#### Nord ####
##### Tous groupes taxonomiques confondus #####
taxo_maille_nord<- st_read("Data_brutes/Toutes_especes/taxo_regroup_nord.shp")

taxo_regroup_nord <- taxo_maille_nord %>%
  group_by(id,groupe_tax)%>%
  summarise(nb = n(), .groups = 'drop')

taxo_table_nord <- merge(taxo_regroup_nord, table_seuil_departement, by.x="groupe_tax", by.y="groupe")

for (i in 1:nrow(taxo_table_nord)){
  if ((taxo_table_nord$nb[i]) < taxo_table_nord$seuil_dept[i]){
    taxo_table_nord$div_spec[i]<-0
  }else taxo_table_nord$div_spec[i] <- 1
}

taxo_indice_nord <- taxo_table_nord %>%
  group_by(id)%>%
  summarise(ind = mean(div_spec))

for (i in 1:nrow(taxo_indice_nord)){
  if ((taxo_indice_nord$ind[i]) == 0){
    taxo_indice_nord$div_spec[i]<- "Tres mauvaise"}
  if((taxo_indice_nord$ind[i]) > 0 && (taxo_indice_nord$ind[i] < 0.50)){
    taxo_indice_nord$div_spec[i] <- "Moyenne"}
  if ((taxo_indice_nord$ind[i]) >= 0.50 && (taxo_indice_nord$ind[i] < 1)){
    taxo_indice_nord$div_spec[i] <- "Bonne"}
  if ((taxo_indice_nord$ind[i]) == 1){
    taxo_indice_nord$div_spec[i] <- "Tres bonne"}
}

save(taxo_indice_nord, file="Data_analyses/Toutes_especes/indice_maille_nord.RData")

st_write(taxo_indice_nord,
         "Output_qgis/Toutes_especes/indice_maille_nord.shp")

##### Par groupes taxonomiques #####
##### Amphibiens #####
amphi_maille_nord<- st_read("Data_brutes/Toutes_especes/amphi_regroup_nord.shp")

amphi_regroup_nord <- amphi_maille_nord %>%
  group_by(id,groupe_tax)%>%
  summarise(nb = n(), .groups = 'drop')

amphi_regroup_nord <- amphi_regroup_nord%>% filter(!is.na(groupe_tax))

amphi_table_nord <- merge(amphi_regroup_nord, table_seuil_departement, by.x="groupe_tax", by.y="groupe")

for (i in 1:nrow(amphi_table_nord)){
  if ((amphi_table_nord$nb[i]) < amphi_table_nord$seuil_dept[i]){
    amphi_table_nord$div_spec[i]<-"mauvais"
  }else amphi_table_nord$div_spec[i] <- "bon"
}

save(amphi_table_nord, file="Data_brutes/Toutes_especes/indice_amphi_nord.RData")

st_write(amphi_table_nord,
         "Data_brutes/Toutes_especes/indice_amphi_nord.shp")

##### Chiropteres #####
chiro_maille_nord<- st_read("Data_brutes/Toutes_especes/chiro_regroup_nord.shp")

chiro_regroup_nord <- chiro_maille_nord %>%
  group_by(id,groupe_tax)%>%
  summarise(nb = n(), .groups = 'drop')

chiro_regroup_nord <- chiro_regroup_nord%>% filter(!is.na(groupe_tax))

chiro_table_nord <- merge(chiro_regroup_nord, table_seuil_departement, by.x="groupe_tax", by.y="groupe")

for (i in 1:nrow(chiro_table_nord)){
  if ((chiro_table_nord$nb[i]) < chiro_table_nord$seuil_dept[i]){
    chiro_table_nord$div_spec[i]<-"mauvais"
  }else chiro_table_nord$div_spec[i] <- "bon"
}

save(chiro_table_nord, file="Data_brutes/Toutes_especes/indice_chiro_nord.RData")

st_write(chiro_table_nord,
         "Data_brutes/Toutes_especes/indice_chiro_nord.shp")

##### Mammiferes #####
mammi_maille_nord<- st_read("Data_brutes/Toutes_especes/mammi_regroup_nord.shp")

mammi_regroup_nord <- mammi_maille_nord %>%
  group_by(id,groupe_tax)%>%
  summarise(nb = n(), .groups = 'drop')

mammi_regroup_nord <- mammi_regroup_nord%>% filter(!is.na(groupe_tax))

mammi_table_nord <- merge(mammi_regroup_nord, table_seuil_departement, by.x="groupe_tax", by.y="groupe")

for (i in 1:nrow(mammi_table_nord)){
  if ((mammi_table_nord$nb[i]) < mammi_table_nord$seuil_dept[i]){
    mammi_table_nord$div_spec[i]<-"mauvais"
  }else mammi_table_nord$div_spec[i] <- "bon"
}

save(mammi_table_nord, file="Data_brutes/Toutes_especes/indice_mammi_nord.RData")

st_write(mammi_table_nord,
         "Data_brutes/Toutes_especes/indice_mammi_nord.shp")


##### Odonates #####
odon_maille_nord<- st_read("Data_brutes/Toutes_especes/odon_regroup_nord.shp")

odon_regroup_nord <- odon_maille_nord %>%
  group_by(id,groupe_tax)%>%
  summarise(nb = n(), .groups = 'drop')

odon_regroup_nord <- odon_regroup_nord%>% filter(!is.na(groupe_tax))

odon_table_nord <- merge(odon_regroup_nord, table_seuil_departement, by.x="groupe_tax", by.y="groupe")

for (i in 1:nrow(odon_table_nord)){
  if ((odon_table_nord$nb[i]) < odon_table_nord$seuil_dept[i]){
    odon_table_nord$div_spec[i]<-"mauvais"
  }else odon_table_nord$div_spec[i] <- "bon"
}

save(odon_table_nord, file="Data_brutes/Toutes_especes/indice_odon_nord.RData")

st_write(odon_table_nord,
         "Data_brutes/Toutes_especes/indice_odon_nord.shp")


##### Orthopteres #####
orthop_maille_nord<- st_read("Data_brutes/Toutes_especes/orthop_regroup_nord.shp")

orthop_regroup_nord <- orthop_maille_nord %>%
  group_by(id,groupe_tax)%>%
  summarise(nb = n(), .groups = 'drop')

orthop_regroup_nord <- orthop_regroup_nord%>% filter(!is.na(groupe_tax))

orthop_table_nord <- merge(orthop_regroup_nord, table_seuil_departement, by.x="groupe_tax", by.y="groupe")

for (i in 1:nrow(orthop_table_nord)){
  if ((orthop_table_nord$nb[i]) < orthop_table_nord$seuil_dept[i]){
    orthop_table_nord$div_spec[i]<-"mauvais"
  }else orthop_table_nord$div_spec[i] <- "bon"
}

save(orthop_table_nord, file="Data_brutes/Toutes_especes/indice_orthop_nord.RData")

st_write(orthop_table_nord,
         "Data_brutes/Toutes_especes/indice_orthop_nord.shp")


##### Oiseaux #####
oiseaux_maille_nord<- st_read("Data_brutes/Toutes_especes/oiseaux_regroup_nord.shp")

oiseaux_regroup_nord <- oiseaux_maille_nord %>%
  group_by(id,groupe_tax)%>%
  summarise(nb = n(), .groups = 'drop')

oiseaux_regroup_nord <- oiseaux_regroup_nord%>% filter(!is.na(groupe_tax))

oiseaux_table_nord <- merge(oiseaux_regroup_nord, table_seuil_departement, by.x="groupe_tax", by.y="groupe")

for (i in 1:nrow(oiseaux_table_nord)){
  if ((oiseaux_table_nord$nb[i]) < oiseaux_table_nord$seuil_dept[i]){
    oiseaux_table_nord$div_spec[i]<-"mauvais"
  }else oiseaux_table_nord$div_spec[i] <- "bon"
}

save(oiseaux_table_nord, file="Data_brutes/Toutes_especes/indice_oiseaux_nord.RData")

st_write(oiseaux_table_nord,
         "Data_brutes/Toutes_especes/indice_oiseaux_nord.shp")


##### Poissons #####
poissons_maille_nord<- st_read("Data_brutes/Toutes_especes/poissons_regroup_nord.shp")

poissons_regroup_nord <- poissons_maille_nord %>%
  group_by(id,groupe_tax)%>%
  summarise(nb = n(), .groups = 'drop')

poissons_regroup_nord <- poissons_regroup_nord%>% filter(!is.na(groupe_tax))

poissons_table_nord <- merge(poissons_regroup_nord, table_seuil_departement, by.x="groupe_tax", by.y="groupe")

for (i in 1:nrow(poissons_table_nord)){
  if ((poissons_table_nord$nb[i]) < poissons_table_nord$seuil_dept[i]){
    poissons_table_nord$div_spec[i]<-"mauvais"
  }else poissons_table_nord$div_spec[i] <- "bon"
}

save(poissons_table_nord, file="Data_brutes/Toutes_especes/indice_poissons_nord.RData")

st_write(poissons_table_nord,
         "Data_brutes/Toutes_especes/indice_poissons_nord.shp")

##### Reptiles #####
reptiles_maille_nord<- st_read("Data_brutes/Toutes_especes/reptiles_regroup_nord.shp")

reptiles_regroup_nord <- reptiles_maille_nord %>%
  group_by(id,groupe_tax)%>%
  summarise(nb = n(), .groups = 'drop')

reptiles_regroup_nord <- reptiles_regroup_nord%>% filter(!is.na(groupe_tax))

reptiles_table_nord <- merge(reptiles_regroup_nord, table_seuil_departement, by.x="groupe_tax", by.y="groupe")

for (i in 1:nrow(reptiles_table_nord)){
  if ((reptiles_table_nord$nb[i]) < reptiles_table_nord$seuil_dept[i]){
    reptiles_table_nord$div_spec[i]<-"mauvais"
  }else reptiles_table_nord$div_spec[i] <- "bon"
}

save(reptiles_table_nord, file="Data_brutes/Toutes_especes/indice_reptiles_nord.RData")

st_write(reptiles_table_nord,
         "Data_brutes/Toutes_especes/indice_reptiles_nord.shp")


##### Rhopaloceres #####
rhopa_maille_nord<- st_read("Data_brutes/Toutes_especes/rhopa_regroup_nord.shp")

rhopa_regroup_nord <- rhopa_maille_nord %>%
  group_by(id,groupe_tax)%>%
  summarise(nb = n(), .groups = 'drop')

rhopa_regroup_nord <- rhopa_regroup_nord%>% filter(!is.na(groupe_tax))

rhopa_table_nord <- merge(rhopa_regroup_nord, table_seuil_departement, by.x="groupe_tax", by.y="groupe")

for (i in 1:nrow(rhopa_table_nord)){
  if ((rhopa_table_nord$nb[i]) < rhopa_table_nord$seuil_dept[i]){
    rhopa_table_nord$div_spec[i]<-"mauvais"
  }else rhopa_table_nord$div_spec[i] <- "bon"
}

save(rhopa_table_nord, file="Data_brutes/Toutes_especes/indice_rhopa_nord.RData")

st_write(rhopa_table_nord,
         "Data_brutes/Toutes_especes/indice_rhopa_nord.shp")


#### Oise ####
##### Tous groupes taxonomiques confondus #####
taxo_maille_oise<- st_read("Data_brutes/Toutes_especes/taxo_regroup_oise.shp")

taxo_regroup_oise <- taxo_maille_oise %>%
  group_by(id,groupe_tax)%>%
  summarise(nb = n(), .groups = 'drop')

taxo_table_oise <- merge(taxo_regroup_oise, table_seuil_departement, by.x="groupe_tax", by.y="groupe")

for (i in 1:nrow(taxo_table_oise)){
  if ((taxo_table_oise$nb[i]) < taxo_table_oise$seuil_dept[i]){
    taxo_table_oise$div_spec[i]<-0
  }else taxo_table_oise$div_spec[i] <- 1
}

taxo_indice_oise <- taxo_table_oise %>%
  group_by(id)%>%
  summarise(ind = mean(div_spec))

for (i in 1:nrow(taxo_indice_oise)){
  if ((taxo_indice_oise$ind[i]) == 0){
    taxo_indice_oise$div_spec[i]<- "Tres mauvaise"}
  if((taxo_indice_oise$ind[i]) > 0 && (taxo_indice_oise$ind[i] < 0.50)){
    taxo_indice_oise$div_spec[i] <- "Moyenne"}
  if ((taxo_indice_oise$ind[i]) >= 0.50 && (taxo_indice_oise$ind[i] < 1)){
    taxo_indice_oise$div_spec[i] <- "Bonne"}
  if ((taxo_indice_oise$ind[i]) == 1){
    taxo_indice_oise$div_spec[i] <- "Tres bonne"}
}

save(taxo_indice_oise, file="Data_analyses/Toutes_especes/indice_maille_oise.RData")

st_write(taxo_indice_oise,
         "Output_qgis/Toutes_especes/indice_maille_oise.shp")

##### Par groupes taxonomiques #####
##### Amphibiens #####
amphi_maille_oise<- st_read("Data_brutes/Toutes_especes/amphi_regroup_oise.shp")

amphi_regroup_oise <- amphi_maille_oise %>%
  group_by(id,groupe_tax)%>%
  summarise(nb = n(), .groups = 'drop')

amphi_regroup_oise <- amphi_regroup_oise%>% filter(!is.na(groupe_tax))

amphi_table_oise <- merge(amphi_regroup_oise, table_seuil_departement, by.x="groupe_tax", by.y="groupe")

for (i in 1:nrow(amphi_table_oise)){
  if ((amphi_table_oise$nb[i]) < amphi_table_oise$seuil_dept[i]){
    amphi_table_oise$div_spec[i]<-"mauvais"
  }else amphi_table_oise$div_spec[i] <- "bon"
}

save(amphi_table_oise, file="Data_brutes/Toutes_especes/indice_amphi_oise.RData")

st_write(amphi_table_oise,
         "Data_brutes/Toutes_especes/indice_amphi_oise.shp")

##### Chiropteres #####
chiro_maille_oise<- st_read("Data_brutes/Toutes_especes/chiro_regroup_oise.shp")

chiro_regroup_oise <- chiro_maille_oise %>%
  group_by(id,groupe_tax)%>%
  summarise(nb = n(), .groups = 'drop')

chiro_regroup_oise <- chiro_regroup_oise%>% filter(!is.na(groupe_tax))

chiro_table_oise <- merge(chiro_regroup_oise, table_seuil_departement, by.x="groupe_tax", by.y="groupe")

for (i in 1:nrow(chiro_table_oise)){
  if ((chiro_table_oise$nb[i]) < chiro_table_oise$seuil_dept[i]){
    chiro_table_oise$div_spec[i]<-"mauvais"
  }else chiro_table_oise$div_spec[i] <- "bon"
}

save(chiro_table_oise, file="Data_brutes/Toutes_especes/indice_chiro_oise.RData")

st_write(chiro_table_oise,
         "Data_brutes/Toutes_especes/indice_chiro_oise.shp")

##### Mammiferes #####
mammi_maille_oise<- st_read("Data_brutes/Toutes_especes/mammi_regroup_oise.shp")

mammi_regroup_oise <- mammi_maille_oise %>%
  group_by(id,groupe_tax)%>%
  summarise(nb = n(), .groups = 'drop')

mammi_regroup_oise <- mammi_regroup_oise%>% filter(!is.na(groupe_tax))

mammi_table_oise <- merge(mammi_regroup_oise, table_seuil_departement, by.x="groupe_tax", by.y="groupe")

for (i in 1:nrow(mammi_table_oise)){
  if ((mammi_table_oise$nb[i]) < mammi_table_oise$seuil_dept[i]){
    mammi_table_oise$div_spec[i]<-"mauvais"
  }else mammi_table_oise$div_spec[i] <- "bon"
}

save(mammi_table_oise, file="Data_brutes/Toutes_especes/indice_mammi_oise.RData")

st_write(mammi_table_oise,
         "Data_brutes/Toutes_especes/indice_mammi_oise.shp")


##### Odonates #####
odon_maille_oise<- st_read("Data_brutes/Toutes_especes/odon_regroup_oise.shp")

odon_regroup_oise <- odon_maille_oise %>%
  group_by(id,groupe_tax)%>%
  summarise(nb = n(), .groups = 'drop')

odon_regroup_oise <- odon_regroup_oise%>% filter(!is.na(groupe_tax))

odon_table_oise <- merge(odon_regroup_oise, table_seuil_departement, by.x="groupe_tax", by.y="groupe")

for (i in 1:nrow(odon_table_oise)){
  if ((odon_table_oise$nb[i]) < odon_table_oise$seuil_dept[i]){
    odon_table_oise$div_spec[i]<-"mauvais"
  }else odon_table_oise$div_spec[i] <- "bon"
}

save(odon_table_oise, file="Data_brutes/Toutes_especes/indice_odon_oise.RData")

st_write(odon_table_oise,
         "Data_brutes/Toutes_especes/indice_odon_oise.shp")


##### Orthopteres #####
orthop_maille_oise<- st_read("Data_brutes/Toutes_especes/orthop_regroup_oise.shp")

orthop_regroup_oise <- orthop_maille_oise %>%
  group_by(id,groupe_tax)%>%
  summarise(nb = n(), .groups = 'drop')

orthop_regroup_oise <- orthop_regroup_oise%>% filter(!is.na(groupe_tax))

orthop_table_oise <- merge(orthop_regroup_oise, table_seuil_departement, by.x="groupe_tax", by.y="groupe")

for (i in 1:nrow(orthop_table_oise)){
  if ((orthop_table_oise$nb[i]) < orthop_table_oise$seuil_dept[i]){
    orthop_table_oise$div_spec[i]<-"mauvais"
  }else orthop_table_oise$div_spec[i] <- "bon"
}

save(orthop_table_oise, file="Data_brutes/Toutes_especes/indice_orthop_oise.RData")

st_write(orthop_table_oise,
         "Data_brutes/Toutes_especes/indice_orthop_oise.shp")


##### Oiseaux #####
oiseaux_maille_oise<- st_read("Data_brutes/Toutes_especes/oiseaux_regroup_oise.shp")

oiseaux_regroup_oise <- oiseaux_maille_oise %>%
  group_by(id,groupe_tax)%>%
  summarise(nb = n(), .groups = 'drop')

oiseaux_regroup_oise <- oiseaux_regroup_oise%>% filter(!is.na(groupe_tax))

oiseaux_table_oise <- merge(oiseaux_regroup_oise, table_seuil_departement, by.x="groupe_tax", by.y="groupe")

for (i in 1:nrow(oiseaux_table_oise)){
  if ((oiseaux_table_oise$nb[i]) < oiseaux_table_oise$seuil_dept[i]){
    oiseaux_table_oise$div_spec[i]<-"mauvais"
  }else oiseaux_table_oise$div_spec[i] <- "bon"
}

save(oiseaux_table_oise, file="Data_brutes/Toutes_especes/indice_oiseaux_oise.RData")

st_write(oiseaux_table_oise,
         "Data_brutes/Toutes_especes/indice_oiseaux_oise.shp")


##### Poissons #####
poissons_maille_oise<- st_read("Data_brutes/Toutes_especes/poissons_regroup_oise.shp")

poissons_regroup_oise <- poissons_maille_oise %>%
  group_by(id,groupe_tax)%>%
  summarise(nb = n(), .groups = 'drop')

poissons_regroup_oise <- poissons_regroup_oise%>% filter(!is.na(groupe_tax))

poissons_table_oise <- merge(poissons_regroup_oise, table_seuil_departement, by.x="groupe_tax", by.y="groupe")

for (i in 1:nrow(poissons_table_oise)){
  if ((poissons_table_oise$nb[i]) < poissons_table_oise$seuil_dept[i]){
    poissons_table_oise$div_spec[i]<-"mauvais"
  }else poissons_table_oise$div_spec[i] <- "bon"
}

save(poissons_table_oise, file="Data_brutes/Toutes_especes/indice_poissons_oise.RData")

st_write(poissons_table_oise,
         "Data_brutes/Toutes_especes/indice_poissons_oise.shp")

##### Reptiles #####
reptiles_maille_oise<- st_read("Data_brutes/Toutes_especes/reptiles_regroup_oise.shp")

reptiles_regroup_oise <- reptiles_maille_oise %>%
  group_by(id,groupe_tax)%>%
  summarise(nb = n(), .groups = 'drop')

reptiles_regroup_oise <- reptiles_regroup_oise%>% filter(!is.na(groupe_tax))

reptiles_table_oise <- merge(reptiles_regroup_oise, table_seuil_departement, by.x="groupe_tax", by.y="groupe")

for (i in 1:nrow(reptiles_table_oise)){
  if ((reptiles_table_oise$nb[i]) < reptiles_table_oise$seuil_dept[i]){
    reptiles_table_oise$div_spec[i]<-"mauvais"
  }else reptiles_table_oise$div_spec[i] <- "bon"
}

save(reptiles_table_oise, file="Data_brutes/Toutes_especes/indice_reptiles_oise.RData")

st_write(reptiles_table_oise,
         "Data_brutes/Toutes_especes/indice_reptiles_oise.shp")


##### Rhopaloceres #####
rhopa_maille_oise<- st_read("Data_brutes/Toutes_especes/rhopa_regroup_oise.shp")

rhopa_regroup_oise <- rhopa_maille_oise %>%
  group_by(id,groupe_tax)%>%
  summarise(nb = n(), .groups = 'drop')

rhopa_regroup_oise <- rhopa_regroup_oise%>% filter(!is.na(groupe_tax))

rhopa_table_oise <- merge(rhopa_regroup_oise, table_seuil_departement, by.x="groupe_tax", by.y="groupe")

for (i in 1:nrow(rhopa_table_oise)){
  if ((rhopa_table_oise$nb[i]) < rhopa_table_oise$seuil_dept[i]){
    rhopa_table_oise$div_spec[i]<-"mauvais"
  }else rhopa_table_oise$div_spec[i] <- "bon"
}

save(rhopa_table_oise, file="Data_brutes/Toutes_especes/indice_rhopa_oise.RData")

st_write(rhopa_table_oise,
         "Data_brutes/Toutes_especes/indice_rhopa_oise.shp")




#### Pas-de-Calais ####
##### Tous groupes taxonomiques confondus #####
taxo_maille_pascalais<- st_read("Data_brutes/Toutes_especes/taxo_regroup_pascalais.shp")

taxo_regroup_pascalais <- taxo_maille_pascalais %>%
  group_by(id,groupe_tax)%>%
  summarise(nb = n(), .groups = 'drop')

taxo_table_pascalais <- merge(taxo_regroup_pascalais, table_seuil_departement, by.x="groupe_tax", by.y="groupe")

for (i in 1:nrow(taxo_table_pascalais)){
  if ((taxo_table_pascalais$nb[i]) < taxo_table_pascalais$seuil_dept[i]){
    taxo_table_pascalais$div_spec[i]<-0
  }else taxo_table_pascalais$div_spec[i] <- 1
}

taxo_indice_pascalais <- taxo_table_pascalais %>%
  group_by(id)%>%
  summarise(ind = mean(div_spec))

for (i in 1:nrow(taxo_indice_pascalais)){
  if ((taxo_indice_pascalais$ind[i]) == 0){
    taxo_indice_pascalais$div_spec[i]<- "Tres mauvaise"}
  if((taxo_indice_pascalais$ind[i]) > 0 && (taxo_indice_pascalais$ind[i] < 0.50)){
    taxo_indice_pascalais$div_spec[i] <- "Moyenne"}
  if ((taxo_indice_pascalais$ind[i]) >= 0.50 && (taxo_indice_pascalais$ind[i] < 1)){
    taxo_indice_pascalais$div_spec[i] <- "Bonne"}
  if ((taxo_indice_pascalais$ind[i]) == 1){
    taxo_indice_pascalais$div_spec[i] <- "Tres bonne"}
}

save(taxo_indice_pascalais, file="Data_analyses/Toutes_especes/indice_maille_pascalais.RData")

st_write(taxo_indice_pascalais,
         "Output_qgis/Toutes_especes/indice_maille_pascalais.shp")

##### Par groupes taxonomiques #####
##### Amphibiens #####
amphi_maille_pascalais<- st_read("Data_brutes/Toutes_especes/amphi_regroup_pascalais.shp")

amphi_regroup_pascalais <- amphi_maille_pascalais %>%
  group_by(id,groupe_tax)%>%
  summarise(nb = n(), .groups = 'drop')

amphi_regroup_pascalais <- amphi_regroup_pascalais%>% filter(!is.na(groupe_tax))

amphi_table_pascalais <- merge(amphi_regroup_pascalais, table_seuil_departement, by.x="groupe_tax", by.y="groupe")

for (i in 1:nrow(amphi_table_pascalais)){
  if ((amphi_table_pascalais$nb[i]) < amphi_table_pascalais$seuil_dept[i]){
    amphi_table_pascalais$div_spec[i]<-"mauvais"
  }else amphi_table_pascalais$div_spec[i] <- "bon"
}

save(amphi_table_pascalais, file="Data_brutes/Toutes_especes/indice_amphi_pascalais.RData")

st_write(amphi_table_pascalais,
         "Data_brutes/Toutes_especes/indice_amphi_pascalais.shp")

##### Chiropteres #####
chiro_maille_pascalais<- st_read("Data_brutes/Toutes_especes/chiro_regroup_pascalais.shp")

chiro_regroup_pascalais <- chiro_maille_pascalais %>%
  group_by(id,groupe_tax)%>%
  summarise(nb = n(), .groups = 'drop')

chiro_regroup_pascalais <- chiro_regroup_pascalais%>% filter(!is.na(groupe_tax))

chiro_table_pascalais <- merge(chiro_regroup_pascalais, table_seuil_departement, by.x="groupe_tax", by.y="groupe")

for (i in 1:nrow(chiro_table_pascalais)){
  if ((chiro_table_pascalais$nb[i]) < chiro_table_pascalais$seuil_dept[i]){
    chiro_table_pascalais$div_spec[i]<-"mauvais"
  }else chiro_table_pascalais$div_spec[i] <- "bon"
}

save(chiro_table_pascalais, file="Data_brutes/Toutes_especes/indice_chiro_pascalais.RData")

st_write(chiro_table_pascalais,
         "Data_brutes/Toutes_especes/indice_chiro_pascalais.shp")

##### Mammiferes #####
mammi_maille_pascalais<- st_read("Data_brutes/Toutes_especes/mammi_regroup_pascalais.shp")

mammi_regroup_pascalais <- mammi_maille_pascalais %>%
  group_by(id,groupe_tax)%>%
  summarise(nb = n(), .groups = 'drop')

mammi_regroup_pascalais <- mammi_regroup_pascalais%>% filter(!is.na(groupe_tax))

mammi_table_pascalais <- merge(mammi_regroup_pascalais, table_seuil_departement, by.x="groupe_tax", by.y="groupe")

for (i in 1:nrow(mammi_table_pascalais)){
  if ((mammi_table_pascalais$nb[i]) < mammi_table_pascalais$seuil_dept[i]){
    mammi_table_pascalais$div_spec[i]<-"mauvais"
  }else mammi_table_pascalais$div_spec[i] <- "bon"
}

save(mammi_table_pascalais, file="Data_brutes/Toutes_especes/indice_mammi_pascalais.RData")

st_write(mammi_table_pascalais,
         "Data_brutes/Toutes_especes/indice_mammi_pascalais.shp")


##### Odonates #####
odon_maille_pascalais<- st_read("Data_brutes/Toutes_especes/odon_regroup_pascalais.shp")

odon_regroup_pascalais <- odon_maille_pascalais %>%
  group_by(id,groupe_tax)%>%
  summarise(nb = n(), .groups = 'drop')

odon_regroup_pascalais <- odon_regroup_pascalais%>% filter(!is.na(groupe_tax))

odon_table_pascalais <- merge(odon_regroup_pascalais, table_seuil_departement, by.x="groupe_tax", by.y="groupe")

for (i in 1:nrow(odon_table_pascalais)){
  if ((odon_table_pascalais$nb[i]) < odon_table_pascalais$seuil_dept[i]){
    odon_table_pascalais$div_spec[i]<-"mauvais"
  }else odon_table_pascalais$div_spec[i] <- "bon"
}

save(odon_table_pascalais, file="Data_brutes/Toutes_especes/indice_odon_pascalais.RData")

st_write(odon_table_pascalais,
         "Data_brutes/Toutes_especes/indice_odon_pascalais.shp")


##### Orthopteres #####
orthop_maille_pascalais<- st_read("Data_brutes/Toutes_especes/orthop_regroup_pascalais.shp")

orthop_regroup_pascalais <- orthop_maille_pascalais %>%
  group_by(id,groupe_tax)%>%
  summarise(nb = n(), .groups = 'drop')

orthop_regroup_pascalais <- orthop_regroup_pascalais%>% filter(!is.na(groupe_tax))

orthop_table_pascalais <- merge(orthop_regroup_pascalais, table_seuil_departement, by.x="groupe_tax", by.y="groupe")

for (i in 1:nrow(orthop_table_pascalais)){
  if ((orthop_table_pascalais$nb[i]) < orthop_table_pascalais$seuil_dept[i]){
    orthop_table_pascalais$div_spec[i]<-"mauvais"
  }else orthop_table_pascalais$div_spec[i] <- "bon"
}

save(orthop_table_pascalais, file="Data_brutes/Toutes_especes/indice_orthop_pascalais.RData")

st_write(orthop_table_pascalais,
         "Data_brutes/Toutes_especes/indice_orthop_pascalais.shp")


##### Oiseaux #####
oiseaux_maille_pascalais<- st_read("Data_brutes/Toutes_especes/oiseaux_regroup_pascalais.shp")

oiseaux_regroup_pascalais <- oiseaux_maille_pascalais %>%
  group_by(id,groupe_tax)%>%
  summarise(nb = n(), .groups = 'drop')

oiseaux_regroup_pascalais <- oiseaux_regroup_pascalais%>% filter(!is.na(groupe_tax))

oiseaux_table_pascalais <- merge(oiseaux_regroup_pascalais, table_seuil_departement, by.x="groupe_tax", by.y="groupe")

for (i in 1:nrow(oiseaux_table_pascalais)){
  if ((oiseaux_table_pascalais$nb[i]) < oiseaux_table_pascalais$seuil_dept[i]){
    oiseaux_table_pascalais$div_spec[i]<-"mauvais"
  }else oiseaux_table_pascalais$div_spec[i] <- "bon"
}

save(oiseaux_table_pascalais, file="Data_brutes/Toutes_especes/indice_oiseaux_pascalais.RData")

st_write(oiseaux_table_pascalais,
         "Data_brutes/Toutes_especes/indice_oiseaux_pascalais.shp")


##### Poissons #####
poissons_maille_pascalais<- st_read("Data_brutes/Toutes_especes/poissons_regroup_pascalais.shp")

poissons_regroup_pascalais <- poissons_maille_pascalais %>%
  group_by(id,groupe_tax)%>%
  summarise(nb = n(), .groups = 'drop')

poissons_regroup_pascalais <- poissons_regroup_pascalais%>% filter(!is.na(groupe_tax))

poissons_table_pascalais <- merge(poissons_regroup_pascalais, table_seuil_departement, by.x="groupe_tax", by.y="groupe")

for (i in 1:nrow(poissons_table_pascalais)){
  if ((poissons_table_pascalais$nb[i]) < poissons_table_pascalais$seuil_dept[i]){
    poissons_table_pascalais$div_spec[i]<-"mauvais"
  }else poissons_table_pascalais$div_spec[i] <- "bon"
}

save(poissons_table_pascalais, file="Data_brutes/Toutes_especes/indice_poissons_pascalais.RData")

st_write(poissons_table_pascalais,
         "Data_brutes/Toutes_especes/indice_poissons_pascalais.shp")

##### Reptiles #####
reptiles_maille_pascalais<- st_read("Data_brutes/Toutes_especes/reptiles_regroup_pascalais.shp")

reptiles_regroup_pascalais <- reptiles_maille_pascalais %>%
  group_by(id,groupe_tax)%>%
  summarise(nb = n(), .groups = 'drop')

reptiles_regroup_pascalais <- reptiles_regroup_pascalais%>% filter(!is.na(groupe_tax))

reptiles_table_pascalais <- merge(reptiles_regroup_pascalais, table_seuil_departement, by.x="groupe_tax", by.y="groupe")

for (i in 1:nrow(reptiles_table_pascalais)){
  if ((reptiles_table_pascalais$nb[i]) < reptiles_table_pascalais$seuil_dept[i]){
    reptiles_table_pascalais$div_spec[i]<-"mauvais"
  }else reptiles_table_pascalais$div_spec[i] <- "bon"
}

save(reptiles_table_pascalais, file="Data_brutes/Toutes_especes/indice_reptiles_pascalais.RData")

st_write(reptiles_table_pascalais,
         "Data_brutes/Toutes_especes/indice_reptiles_pascalais.shp")


##### Rhopaloceres #####
rhopa_maille_pascalais<- st_read("Data_brutes/Toutes_especes/rhopa_regroup_pascalais.shp")

rhopa_regroup_pascalais <- rhopa_maille_pascalais %>%
  group_by(id,groupe_tax)%>%
  summarise(nb = n(), .groups = 'drop')

rhopa_regroup_pascalais <- rhopa_regroup_pascalais%>% filter(!is.na(groupe_tax))

rhopa_table_pascalais <- merge(rhopa_regroup_pascalais, table_seuil_departement, by.x="groupe_tax", by.y="groupe")

for (i in 1:nrow(rhopa_table_pascalais)){
  if ((rhopa_table_pascalais$nb[i]) < rhopa_table_pascalais$seuil_dept[i]){
    rhopa_table_pascalais$div_spec[i]<-"mauvais"
  }else rhopa_table_pascalais$div_spec[i] <- "bon"
}

save(rhopa_table_pascalais, file="Data_brutes/Toutes_especes/indice_rhopa_pascalais.RData")

st_write(rhopa_table_pascalais,
         "Data_brutes/Toutes_especes/indice_rhopa_pascalais.shp")



#### Somme ####
##### Tous groupes taxonomiques confondus #####
taxo_maille_somme<- st_read("Data_brutes/Toutes_especes/taxo_regroup_somme.shp")

taxo_regroup_somme <- taxo_maille_somme %>%
  group_by(id,groupe_tax)%>%
  summarise(nb = n(), .groups = 'drop')

taxo_table_somme <- merge(taxo_regroup_somme, table_seuil_departement, by.x="groupe_tax", by.y="groupe")

for (i in 1:nrow(taxo_table_somme)){
  if ((taxo_table_somme$nb[i]) < taxo_table_somme$seuil_dept[i]){
    taxo_table_somme$div_spec[i]<-0
  }else taxo_table_somme$div_spec[i] <- 1
}

taxo_indice_somme <- taxo_table_somme %>%
  group_by(id)%>%
  summarise(ind = mean(div_spec))

for (i in 1:nrow(taxo_indice_somme)){
  if ((taxo_indice_somme$ind[i]) == 0){
    taxo_indice_somme$div_spec[i]<- "Tres mauvaise"}
  if((taxo_indice_somme$ind[i]) > 0 && (taxo_indice_somme$ind[i] < 0.50)){
    taxo_indice_somme$div_spec[i] <- "Moyenne"}
  if ((taxo_indice_somme$ind[i]) >= 0.50 && (taxo_indice_somme$ind[i] < 1)){
    taxo_indice_somme$div_spec[i] <- "Bonne"}
  if ((taxo_indice_somme$ind[i]) == 1){
    taxo_indice_somme$div_spec[i] <- "Tres bonne"}
}

save(taxo_indice_somme, file="Data_analyses/Toutes_especes/indice_maille_somme.RData")

st_write(taxo_indice_somme,
         "Output_qgis/Toutes_especes/indice_maille_somme.shp")

##### Par groupes taxonomiques #####
##### Amphibiens #####
amphi_maille_somme<- st_read("Data_brutes/Toutes_especes/amphi_regroup_somme.shp")

amphi_regroup_somme <- amphi_maille_somme %>%
  group_by(id,groupe_tax)%>%
  summarise(nb = n(), .groups = 'drop')

amphi_regroup_somme <- amphi_regroup_somme%>% filter(!is.na(groupe_tax))

amphi_table_somme <- merge(amphi_regroup_somme, table_seuil_departement, by.x="groupe_tax", by.y="groupe")

for (i in 1:nrow(amphi_table_somme)){
  if ((amphi_table_somme$nb[i]) < amphi_table_somme$seuil_dept[i]){
    amphi_table_somme$div_spec[i]<-"mauvais"
  }else amphi_table_somme$div_spec[i] <- "bon"
}

save(amphi_table_somme, file="Data_brutes/Toutes_especes/indice_amphi_somme.RData")

st_write(amphi_table_somme,
         "Data_brutes/Toutes_especes/indice_amphi_somme.shp")

##### Chiropteres #####
chiro_maille_somme<- st_read("Data_brutes/Toutes_especes/chiro_regroup_somme.shp")

chiro_regroup_somme <- chiro_maille_somme %>%
  group_by(id,groupe_tax)%>%
  summarise(nb = n(), .groups = 'drop')

chiro_regroup_somme <- chiro_regroup_somme%>% filter(!is.na(groupe_tax))

chiro_table_somme <- merge(chiro_regroup_somme, table_seuil_departement, by.x="groupe_tax", by.y="groupe")

for (i in 1:nrow(chiro_table_somme)){
  if ((chiro_table_somme$nb[i]) < chiro_table_somme$seuil_dept[i]){
    chiro_table_somme$div_spec[i]<-"mauvais"
  }else chiro_table_somme$div_spec[i] <- "bon"
}

save(chiro_table_somme, file="Data_brutes/Toutes_especes/indice_chiro_somme.RData")

st_write(chiro_table_somme,
         "Data_brutes/Toutes_especes/indice_chiro_somme.shp")

##### Mammiferes #####
mammi_maille_somme<- st_read("Data_brutes/Toutes_especes/mammi_regroup_somme.shp")

mammi_regroup_somme <- mammi_maille_somme %>%
  group_by(id,groupe_tax)%>%
  summarise(nb = n(), .groups = 'drop')

mammi_regroup_somme <- mammi_regroup_somme%>% filter(!is.na(groupe_tax))

mammi_table_somme <- merge(mammi_regroup_somme, table_seuil_departement, by.x="groupe_tax", by.y="groupe")

for (i in 1:nrow(mammi_table_somme)){
  if ((mammi_table_somme$nb[i]) < mammi_table_somme$seuil_dept[i]){
    mammi_table_somme$div_spec[i]<-"mauvais"
  }else mammi_table_somme$div_spec[i] <- "bon"
}

save(mammi_table_somme, file="Data_brutes/Toutes_especes/indice_mammi_somme.RData")

st_write(mammi_table_somme,
         "Data_brutes/Toutes_especes/indice_mammi_somme.shp")


##### Odonates #####
odon_maille_somme<- st_read("Data_brutes/Toutes_especes/odon_regroup_somme.shp")

odon_regroup_somme <- odon_maille_somme %>%
  group_by(id,groupe_tax)%>%
  summarise(nb = n(), .groups = 'drop')

odon_regroup_somme <- odon_regroup_somme%>% filter(!is.na(groupe_tax))

odon_table_somme <- merge(odon_regroup_somme, table_seuil_departement, by.x="groupe_tax", by.y="groupe")

for (i in 1:nrow(odon_table_somme)){
  if ((odon_table_somme$nb[i]) < odon_table_somme$seuil_dept[i]){
    odon_table_somme$div_spec[i]<-"mauvais"
  }else odon_table_somme$div_spec[i] <- "bon"
}

save(odon_table_somme, file="Data_brutes/Toutes_especes/indice_odon_somme.RData")

st_write(odon_table_somme,
         "Data_brutes/Toutes_especes/indice_odon_somme.shp")


##### Orthopteres #####
orthop_maille_somme<- st_read("Data_brutes/Toutes_especes/orthop_regroup_somme.shp")

orthop_regroup_somme <- orthop_maille_somme %>%
  group_by(id,groupe_tax)%>%
  summarise(nb = n(), .groups = 'drop')

orthop_regroup_somme <- orthop_regroup_somme%>% filter(!is.na(groupe_tax))

orthop_table_somme <- merge(orthop_regroup_somme, table_seuil_departement, by.x="groupe_tax", by.y="groupe")

for (i in 1:nrow(orthop_table_somme)){
  if ((orthop_table_somme$nb[i]) < orthop_table_somme$seuil_dept[i]){
    orthop_table_somme$div_spec[i]<-"mauvais"
  }else orthop_table_somme$div_spec[i] <- "bon"
}

save(orthop_table_somme, file="Data_brutes/Toutes_especes/indice_orthop_somme.RData")

st_write(orthop_table_somme,
         "Data_brutes/Toutes_especes/indice_orthop_somme.shp")


##### Oiseaux #####
oiseaux_maille_somme<- st_read("Data_brutes/Toutes_especes/oiseaux_regroup_somme.shp")

oiseaux_regroup_somme <- oiseaux_maille_somme %>%
  group_by(id,groupe_tax)%>%
  summarise(nb = n(), .groups = 'drop')

oiseaux_regroup_somme <- oiseaux_regroup_somme%>% filter(!is.na(groupe_tax))

oiseaux_table_somme <- merge(oiseaux_regroup_somme, table_seuil_departement, by.x="groupe_tax", by.y="groupe")

for (i in 1:nrow(oiseaux_table_somme)){
  if ((oiseaux_table_somme$nb[i]) < oiseaux_table_somme$seuil_dept[i]){
    oiseaux_table_somme$div_spec[i]<-"mauvais"
  }else oiseaux_table_somme$div_spec[i] <- "bon"
}

save(oiseaux_table_somme, file="Data_brutes/Toutes_especes/indice_oiseaux_somme.RData")

st_write(oiseaux_table_somme,
         "Data_brutes/Toutes_especes/indice_oiseaux_somme.shp")


##### Poissons #####
poissons_maille_somme<- st_read("Data_brutes/Toutes_especes/poissons_regroup_somme.shp")

poissons_regroup_somme <- poissons_maille_somme %>%
  group_by(id,groupe_tax)%>%
  summarise(nb = n(), .groups = 'drop')

poissons_regroup_somme <- poissons_regroup_somme%>% filter(!is.na(groupe_tax))

poissons_table_somme <- merge(poissons_regroup_somme, table_seuil_departement, by.x="groupe_tax", by.y="groupe")

for (i in 1:nrow(poissons_table_somme)){
  if ((poissons_table_somme$nb[i]) < poissons_table_somme$seuil_dept[i]){
    poissons_table_somme$div_spec[i]<-"mauvais"
  }else poissons_table_somme$div_spec[i] <- "bon"
}

save(poissons_table_somme, file="Data_brutes/Toutes_especes/indice_poissons_somme.RData")

st_write(poissons_table_somme,
         "Data_brutes/Toutes_especes/indice_poissons_somme.shp")

##### Reptiles #####
reptiles_maille_somme<- st_read("Data_brutes/Toutes_especes/reptiles_regroup_somme.shp")

reptiles_regroup_somme <- reptiles_maille_somme %>%
  group_by(id,groupe_tax)%>%
  summarise(nb = n(), .groups = 'drop')

reptiles_regroup_somme <- reptiles_regroup_somme%>% filter(!is.na(groupe_tax))

reptiles_table_somme <- merge(reptiles_regroup_somme, table_seuil_departement, by.x="groupe_tax", by.y="groupe")

for (i in 1:nrow(reptiles_table_somme)){
  if ((reptiles_table_somme$nb[i]) < reptiles_table_somme$seuil_dept[i]){
    reptiles_table_somme$div_spec[i]<-"mauvais"
  }else reptiles_table_somme$div_spec[i] <- "bon"
}

save(reptiles_table_somme, file="Data_brutes/Toutes_especes/indice_reptiles_somme.RData")

st_write(reptiles_table_somme,
         "Data_brutes/Toutes_especes/indice_reptiles_somme.shp")


##### Rhopaloceres #####
rhopa_maille_somme<- st_read("Data_brutes/Toutes_especes/rhopa_regroup_somme.shp")

rhopa_regroup_somme <- rhopa_maille_somme %>%
  group_by(id,groupe_tax)%>%
  summarise(nb = n(), .groups = 'drop')

rhopa_regroup_somme <- rhopa_regroup_somme%>% filter(!is.na(groupe_tax))

rhopa_table_somme <- merge(rhopa_regroup_somme, table_seuil_departement, by.x="groupe_tax", by.y="groupe")

for (i in 1:nrow(rhopa_table_somme)){
  if ((rhopa_table_somme$nb[i]) < rhopa_table_somme$seuil_dept[i]){
    rhopa_table_somme$div_spec[i]<-"mauvais"
  }else rhopa_table_somme$div_spec[i] <- "bon"
}

save(rhopa_table_somme, file="Data_brutes/Toutes_especes/indice_rhopa_somme.RData")

st_write(rhopa_table_somme,
         "Data_brutes/Toutes_especes/indice_rhopa_somme.shp")


