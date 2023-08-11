library("dplyr")
library(sf)

#### Aisne ####
load(file="indice_pression/Data_analyses/Toutes_especes/indice_pression_aisne")
load(file="indice_especes/Data_analyses/Toutes_especes/indice_maille_aisne.RData")

##### Tous groupes taxonomiques confondus #####

indice_pression_aisne <- as.data.frame(indice_pression_aisne)
taxo_indice_aisne <- as.data.frame(taxo_indice_aisne)
fusion_aisne <- merge(indice_pression_aisne, taxo_indice_aisne, by.x="id_2", by.y="id")

for (i in 1:nrow(fusion_aisne)){
  if ((fusion_aisne$pression[i]) >= "0" && 
      (fusion_aisne$pression[i]) < "2" && 
      (fusion_aisne$div_spec[i]) =="Tres mauvaise"){
    fusion_aisne$indice[i]<- "Tres mauvaise"}

  if ((fusion_aisne$pression[i]) >= "0" && 
      (fusion_aisne$pression[i]) < "2" && 
      (fusion_aisne$div_spec[i])=="Moyenne"){
   fusion_aisne$indice[i]<- "Mauvaise"} 
  
  if ((fusion_aisne$pression[i]) >= "0" && 
      (fusion_aisne$pression[i]) < "2" && 
      (fusion_aisne$div_spec[i])=="Bonne"){
   fusion_aisne$indice[i]<- "Mauvaise"} 
  
  if ((fusion_aisne$pression[i]) >= "0" && 
      (fusion_aisne$pression[i]) < "2" && 
      (fusion_aisne$div_spec[i])=="Tres bonne"){
   fusion_aisne$indice[i]<- "Moyenne"} 
  
  
  if ((fusion_aisne$pression[i]) >= "2" && 
      (fusion_aisne$pression[i]) < "4" && 
      (fusion_aisne$div_spec[i]) =="Tres mauvaise"){
    fusion_aisne$indice[i]<- "Mauvaise"}

  if ((fusion_aisne$pression[i]) >= "2" && 
      (fusion_aisne$pression[i]) < "4" && 
      (fusion_aisne$div_spec[i])=="Moyenne"){
   fusion_aisne$indice[i]<- "Moyenne"} 
  
  if ((fusion_aisne$pression[i]) >= "2" && 
      (fusion_aisne$pression[i]) < "4" &&
      (fusion_aisne$div_spec[i])=="Bonne"){
   fusion_aisne$indice[i]<- "Moyenne"} 
  
  if ((fusion_aisne$pression[i]) >= "2" && 
      (fusion_aisne$pression[i]) < "4" &&
      (fusion_aisne$div_spec[i])=="Tres bonne"){
   fusion_aisne$indice[i]<- "Bonne"} 
  

  if ((fusion_aisne$pression[i]) >= "4" && 
      (fusion_aisne$pression[i]) < "6" && 
      (fusion_aisne$div_spec[i]) =="Tres mauvaise"){
    fusion_aisne$indice[i]<- "Mauvaise"}

  if ((fusion_aisne$pression[i]) >= "4" && 
      (fusion_aisne$pression[i]) < "6" &&  
      (fusion_aisne$div_spec[i])=="Moyenne"){
   fusion_aisne$indice[i]<- "Moyenne"} 
  
  if ((fusion_aisne$pression[i]) >= "4" && 
      (fusion_aisne$pression[i]) < "6" && 
      (fusion_aisne$div_spec[i])=="Bonne"){
   fusion_aisne$indice[i]<- "Bonne"} 
  
  if ((fusion_aisne$pression[i]) >= "4" && 
      (fusion_aisne$pression[i]) < "6" && 
      (fusion_aisne$div_spec[i])=="Tres bonne"){
   fusion_aisne$indice[i]<- "Bonne"} 
  
  
  if ((fusion_aisne$pression[i]) >= "6" && 
      (fusion_aisne$pression[i]) < "8" && 
      (fusion_aisne$div_spec[i]) =="Tres mauvaise"){
    fusion_aisne$indice[i]<- "Moyenne"}

  if ((fusion_aisne$pression[i]) >= "6" && 
      (fusion_aisne$pression[i]) < "8" &&  
      (fusion_aisne$div_spec[i])=="Moyenne"){
   fusion_aisne$indice[i]<- "Bonne"} 
  
  if ((fusion_aisne$pression[i]) >= "6" && 
      (fusion_aisne$pression[i]) < "8" && 
      (fusion_aisne$div_spec[i])=="Bonne"){
   fusion_aisne$indice[i]<- "Bonne"} 
  
  if ((fusion_aisne$pression[i]) >= "6" && 
      (fusion_aisne$pression[i]) < "8" && 
      (fusion_aisne$div_spec[i])=="Tres bonne"){
   fusion_aisne$indice[i]<- "Tres bonne"}
  
  
  if ((fusion_aisne$pression[i]) >= "8" && 
      (fusion_aisne$div_spec[i]) =="Tres mauvaise"){
    fusion_aisne$indice[i]<- "Moyenne"}

  if ((fusion_aisne$pression[i]) >= "8" && 
      (fusion_aisne$div_spec[i])=="Moyenne"){
   fusion_aisne$indice[i]<- "Bonne"} 
  
  if ((fusion_aisne$pression[i]) >= "8" && 
      (fusion_aisne$div_spec[i])=="Bonne"){
   fusion_aisne$indice[i]<- "Tres bonne"} 
  
  if ((fusion_aisne$pression[i]) >= "8" && 
      (fusion_aisne$div_spec[i])=="Tres bonne"){
   fusion_aisne$indice[i]<- "Tres bonne"} 
}

indice_connaissance_aisne <- fusion_aisne %>%
  select(id_2, pression, div_spec, indice, geometry.x)
  
colnames(indice_connaissance_aisne)<-c("id_maille","indic_pression","indic_especes","indic_connaissance","geom")

save(indice_connaissance_aisne, file="Data_analyses/Toutes_especes/indice_connaissance_aisne.RData")

st_write(indice_connaissance_aisne,
         "Output_qgis/Toutes_especes/indice_connaissance_aisne.shp")

##### Par groupes taxonomiques #####



