library(dplyr)
library(tidyr)
library(stringr)
library(sf)
library(devtools)
devtools::install_github("PascalIrz/aspe")
library(aspe)
library(gdata)

# Picardie nature ####
## Chargement du fichier ####
data_picnat<- sf::read_sf("data/data_brutes/OFB_clicnat.gpkg") 
load(file="data/data_brutes_rdata/donnees_clicnat.RData")

## Précision des données ####
clicnat <- donnees_clicnat %>%
  select(id_synthese,cd_ref_sp,cd_ref,cd_nom,date_debut, nom_cite, regne, classe, ordre, famille, menace_region, rarete_region, nombre_min, nombre_max,  communes, niveau_validation,niveau_sensibilite, producteur, geom)

clicnat<-clicnat[order(clicnat$date_debut,decreasing=F),]

clicnat[clicnat$date_debut < "2012-01-01" ,"Periode"] <- "historique"  
clicnat[clicnat$date_debut >= "2012-01-01" & clicnat$date_debut <"2023-01-01" ,"Periode"] <- "voulue"
clicnat[clicnat$date_debut >= "2023-01-01","Periode"] <- "futur" 

clicnat<-filter(clicnat,Periode=="voulue") 

## Sélection des données valides ####

clicnat[clicnat$niveau_validation == "Certain - très probable" ,"Validation"] <- "valide" 
clicnat[clicnat$niveau_validation == "Probable","Validation"] <- "valide"
clicnat[clicnat$niveau_validation == "Douteux","Validation"] <- "non_valide"
clicnat[clicnat$niveau_validation == "Invalide","Validation"] <- "non_valide"
clicnat[clicnat$niveau_validation == "En attente de validation","Validation"] <- "valide"

clicnat <- filter(clicnat, Validation=="valide")
clichesite <- filter(clicnat_12_22, niveau_validation=="En attente de validation")

## Identification des groupes taxonomiques ####
levels(as.factor(clicnat$ordre))

amphibiens <-  subset (clicnat, subset= ordre %in%
                         c("Anura","Caudata","Urodela"))
amphibiens$groupe_taxo <- "amphibiens"

mammiferes <- subset(clicnat,subset = ordre %in%
                       c("Rodentia","Carnivora","Soricomorpha","Eulipotyphla","Lagomorpha"))
mammiferes$groupe_taxo <- "mammiferes"

chiropteres <- subset(clicnat,subset = ordre %in%
                        c("Chiroptera"))
chiropteres$groupe_taxo <- "chiropteres"

reptiles <- subset(clicnat,subset = ordre %in%
                     c("Squamata","Chelonii"))
reptiles$groupe_taxo <- "reptiles"

odonates <- subset(clicnat,subset = ordre %in%
                     c("Odonata"))
odonates$groupe_taxo <- "odonates"

orthopteres <- subset(clicnat,subset = ordre %in%
                        c("Orthoptera"))
orthopteres$groupe_taxo <- "orthopteres"

rhopaloceres <- subset(clicnat,subset = ordre %in%
                         c("Lepidoptera"))
rhopaloceres$groupe_taxo <- "rhopaloceres"

poissons <- subset(clicnat,subset= ordre %in%
                     c("Petromyzontiformes","Anguilliformes","Cypriniformes","Esociformes","Salmoniformes","Gadiformes","Decapoda","Atheriniformes","Gasterosteiformes","Perciformes","Pleuronectiformes","Rajiformes","Scorpaeniformes","Siluriformes","Tetraodontiformes"))
poissons$groupe_taxo <- "poissons"

oiseaux_nicheurs <- subset(clicnat, subset= ordre %in%
                             c("Anseriformes","Falconiformes","Ciconiiformes","Galliformes","Gruiformes","Charadriiformes","Passeriformes","Caprimulgiformes","Podicipediformes","Strigiformes","Cuculiformes","Piciformes","Procellariiformes","Apodiformes","Coraciiformes","Pelecaniformes","Accipitriformes","Bucerotiformes","Columbiformes","Gaviiformes","Otidiformes","Phoenicopteriformes","Psittaciformes"))
oiseaux_nicheurs$groupe_taxo <- "oiseaux_nicheurs"

clicnat_groups <- rbind.data.frame(amphibiens,chiropteres)
clicnat_groups <- rbind.data.frame(clicnat_groups,mammiferes)
clicnat_groups <- rbind.data.frame(clicnat_groups,odonates)
clicnat_groups <- rbind.data.frame(clicnat_groups,oiseaux_nicheurs)
clicnat_groups <- rbind.data.frame(clicnat_groups,orthopteres)
clicnat_groups <- rbind.data.frame(clicnat_groups,poissons)
clicnat_groups <- rbind.data.frame(clicnat_groups,reptiles)
clicnat_groups <- rbind.data.frame(clicnat_groups,rhopaloceres)

save(clicnat_groups, file="output/output_rdata/clicnat_groups.RData")

## Toutes espèces confondues ####
#### Vérfication de la présence de doublons ####
clicnat<-clicnat_groups[!duplicated(clicnat_groups$id_synthese), ]

#### Trier et renommer les colonnes ####
clicnat <- clicnat %>%
  select(id_synthese,cd_nom,date_debut, nom_cite,groupe_taxo, geom)
colnames(clicnat) <- c("id","cd_nom","date","nom_scientifique","groupe_taxo","geom")

clicnat$source <- "picnat"  

save(clicnat, file="output/output_rdata/clicnat.RData")

#### Sélection des données géométriques ####
st_write(picnat_pro,
         "picnat_point.gpkg")

picnat_point<- sf::read_sf("clicnat_point.gpkg") 


save(picnat_point, file="Data_analyses/Clicnat/picnat_pro.RData")

## Sélection des espèces protégées ####
especes <- read.csv(file="data/statut_especes.csv",h=T)
especes_pro <- filter(especes, protection=="oui")

clicnat_esp_pro<-merge(clicnat_groups, especes_pro, by.x="cd_nom", by.y="cd_nom")

clicnat_esp_pro <- clicnat_esp_pro %>%
  select(id_synthese,cd_ref_sp,cd_nom,date_debut, nom_cite.y, regne, classe, ordre.y, famille, menace_region.y, rarete_region, nombre_min, nombre_max, niveau_validation,niveau_sensibilite, producteur)

#### Vérfication de la présence de doublons ####
clicnat_esp_pro<-clicnat_esp_pro[!duplicated(clicnat_esp_pro$id_synthese), ]

#### Trier et renommer les colonnes ####
clicnat_esp_pro <- clicnat_esp_pro %>%
  select(id_synthese,cd_nom,date_debut, nom_cite.y, ordre.y, menace_region.y, geometry)
colnames(clicnat_esp_pro) <- c("id","cd_nom","date","nom_scientifique","ordre", "menace_region","geom")

clicnat_esp_pro$source <- "picnat"  

save(clicnat_esp_pro, file="output/output_rdata/clicnat_esp_pro.RData")

#### Sélection des données géométriques ####
st_write(picnat_pro,
         "picnat_point.gpkg")

picnat_point<- sf::read_sf("clicnat_point.gpkg") 

save(picnat_point, file="Data_analyses/Clicnat/picnat_pro.RData")


# Groupe ornithologique et naturaliste ####
## Chargement fichier ####
data_gon <- sf::read_sf("Data_brutes/Sirf/230220_all_expo_deb2012") 
load(file="data/data_brutes_rdata/donnees_Gon.RData")

## Précision des données ####
gon <- donnees_Gon %>%
  select(id_cit,id_taxo,cdref,date_d, nom_lat,ordre, valid, geom,contrib)

gon<-gon[order(gon$date_d,decreasing=F),]

gon[gon$date_d < "2012-01-01" ,"Periode"] <- "historique"  
gon[gon$date_d >= "2012-01-01" & gon$date_d <"2023-01-01" ,"Periode"] <- "voulue"
gon[gon$date_d >= "2023-01-01","Periode"] <- "futur" 

gon<-filter(gon,Periode=="voulue") 

## Sélection des données valides ####
levels(as.factor(gon$valid))

gon <- gon%>% filter(!is.na(valid))

gon[gon$valid == "Certain  ‐ très probable" ,"Validation"] <- "valide" 
gon[gon$valid == "Probable","Validation"] <- "valide"
gon[gon$valid == "Douteux","Validation"] <- "non_valide"
gon[gon$valid == "Non évalué","Validation"] <- "valide"

gon <- filter(gon, Validation=="valide")
gonhesite <- filter(gon, valid=="Non évalué")

## Identification des groupes taxonomiques ####
levels(as.factor(gon$ordre))

amphibiens <-  subset (gon, subset= ordre %in%
                         c("ANURA","CAUDATA","URODELA"))
amphibiens$groupe_taxo <- "amphibiens"

mammiferes <- subset(gon,subset = ordre %in%
                       c("RODENTIA","CARNIVORA","SORICOMORPHA","EULIPOTYPHLA","LAGOMORPHA"))
mammiferes$groupe_taxo <- "mammiferes"

chiropteres <- subset(gon,subset = ordre %in%
                        c("CHIROPTERA"))
chiropteres$groupe_taxo <- "chiropteres"

reptiles <- subset(gon,subset = ordre %in%
                     c("SQUAMATA","CHELONII"))
reptiles$groupe_taxo <- "reptiles"

odonates <- subset(gon,subset = ordre %in%
                     c("ODONATA"))
odonates$groupe_taxo <- "odonates"

orthopteres <- subset(gon,subset = ordre %in%
                        c("ORTHOPTERA"))
orthopteres$groupe_taxo <- "orthopteres"

rhopaloceres <- subset(gon,subset = ordre %in%
                         c("LEPIDOPTERA"))
rhopaloceres$groupe_taxo <- "rhopaloceres"

poissons <- subset(gon,subset= ordre %in%
                     c("PETROMYZONTIFORMES","ANGUILLIFORMES","CYPRINIFORMES","ESOCIFORMES","SALMONIFORMES","GADIFORMES","DECAPODA","ATHERINIFORMES","GASTEROSTEIFORMES","PERCIFORMES","PLEURONECTIFORMES","RAJIFORMES","SCORPAENIFORMES","SILURIFORMES","TETRAODONTIFORMES","AULOPIFORMES"))
poissons$groupe_taxo <- "poissons"

oiseaux_nicheurs <- subset(gon, subset= ordre %in%
                             c("ANSERIFORMES","FALCONIFORMES","CICONIIFORMES","GALLIFORMES","GRUIFORMES","CHARADRIIFORMES","PASSERIFORMES","CAPRIMULGIFORMES","PODICIPEDIFORMES","STRIGIFORMES","CUCULIFORMES","PICIFORMES","PROCELLARIIFORMES","APODIFORMES","CORACIIFORMES","PELECANIFORMES","ACCIPITRIFORMES","BUCEROTIFORMES","COLUMBIFORMES","GAVIIFORMES","OTIDIFORMES","PHOENICOPTERIFORMES","PSITTACIFORMES","APODIFORMES"))
oiseaux_nicheurs$groupe_taxo <- "oiseaux_nicheurs"

gon_groups <- rbind.data.frame(amphibiens,chiropteres)
gon_groups <- rbind.data.frame(gon_groups,mammiferes)
gon_groups <- rbind.data.frame(gon_groups,odonates)
gon_groups <- rbind.data.frame(gon_groups,oiseaux_nicheurs)
gon_groups <- rbind.data.frame(gon_groups,orthopteres)
gon_groups <- rbind.data.frame(gon_groups,poissons)
gon_groups <- rbind.data.frame(gon_groups,reptiles)
gon_groups <- rbind.data.frame(gon_groups,rhopaloceres)

save(gon_groups, file="output/output_rdata/gon_groups.RData")

## Toutes espèces ####
### Vérfication de la présence de doublons ####
gon_groups<-gon_groups[!duplicated(gon_groups$id_cit), ]

### Trier et renommer les colonnes ####
gon <- gon_groups %>%
  select(id_cit,cdref,date_d, nom_lat,groupe_taxo, geom)
colnames(gon) <- c("id","cd_nom","date","nom_scientifique","groupe_taxo","geom")

gon$source <- "gon"  

save(gon, file="output/output_rdata/gon.RData")

### Sélection de la géométrie ####

## Sélection des espèces protégées ####
gon_groups$cd_nom<-as.numeric(gon_groups$id_taxo)

gon_esp_pro<-merge(gon_groups, especes_pro, by.x="cdref", by.y="cd_nom")

### Vérfication de la présence de doublons ####
gon_esp_pro <- gon_esp_pro %>%
  select(id_cit,cdref,date_d, nom_cite,ordre.y, menace_region, valid, geometry)

gon_esp_pro<-gon_esp_pro[!duplicated(gon_esp_pro$id_cit), ]

save(gon_esp_pro, file="output/output_rdata/gon_esp_pro.RData")

### Trier et renommer les colonnes ####
gon_esp_pro <- gon_esp_pro %>%
  select(id_cit,cdref,date_d, nom_cite, ordre.y, menace_region, geometry)
colnames(gon_esp_pro) <- c("id","cd_nom","date","nom_scientifique","ordre", "menace_region","geom")

gon_esp_pro <-as.data.frame(gon_esp_pro)
gon_esp_pro$source <- "gon" 

### Trier géométrie ####

# Enlever géometries sans passer par qgis

st_write(gon_pro,
         "gon_point.gpkg")

gon_point <- sf :: st_read("gon_point.shp")

save(gon_esp_pro, file="output/output_rdata/gon_esp_pro.RData")

 
# OFB ####
## ASPE ####
### Récupération des données ####
passerelle<-mef_creer_passerelle()
passerelle_hdf<-passerelle %>% 
  mef_ajouter_dept() %>%  #ajout d'une colonne numéro de département 
  filter(dept %in% c('02', '59', '60', '62', '80')) %>% #filtrage des départements des Hdf 
  select(dept, ope_id,pop_id,sta_id,pre_id,lop_id) %>%   # selection des colonnes qui m'intéressent 
  distinct() #suppression des lignes doublons (lignes générées à cause des colonnes de lots etc.)

data("dictionnaire")
View(dictionnaire)

gdata::keep(operation,
            ref_espece,
            lot_poissons,
            point_prelevement,
            passerelle_hdf,
            sure = TRUE)

data_aspe <- passerelle_hdf %>% 
  mef_ajouter_ope_date() %>% 
  filter(ope_date > lubridate::dmy("31/12/2011") & ope_date < lubridate::dmy("01/01/2023")) %>% 
  droplevels()

data_op <- operation %>%
  select(ope_pop_id,ope_date)

data_pop <- point_prelevement %>%
  select(pop_id,pop_geometrie, pop_coordonnees_x,pop_coordonnees_y)

data_esp <- ref_espece %>%
  select(esp_id,esp_code_taxref,esp_nom_latin)

data_lot <- lot_poissons %>%
  select(lop_id,lop_esp_id)

croisement_aspe<-merge(data_aspe,data_pop , by.x="pop_id", by.y="pop_id")
lot_esp<-merge(data_lot,data_esp , by.x="lop_esp_id", by.y="esp_id")
aspe<-merge(croisement_aspe,lot_esp , by.x="lop_id", by.y="lop_id")

aspe <- aspe %>%
  select(lop_id,pop_id,ope_id,esp_code_taxref,ope_date,annee, esp_nom_latin,dept, pop_coordonnees_x, pop_coordonnees_y, pop_geometrie)

### Vérification des doublons ####
aspe<-aspe[!duplicated(aspe$lop_id), ]

### Identification du groupe poissons ####
levels(as.factor(aspe$esp_nom_latin))

aspe[aspe$esp_nom_latin =="Astacus leptodactylus" ,"poissons"] <- "non"
aspe[aspe$esp_nom_latin =="Eriocheir sinensis" ,"poissons"] <- "non"
aspe[aspe$esp_nom_latin =="Faxionus limosus" ,"poissons"] <- "non"
aspe[aspe$esp_nom_latin =="Pacifastacus leniusculus" ,"poissons"] <- "non"
aspe[aspe$esp_nom_latin =="Procambarus clarkii" ,"poissons"] <- "non"

aspe_groups <- subset(aspe,is.na(poissons))

aspe_groups$poissons <- "poissons"

save(aspe_groups, file="output/output_rdata/aspe_groups.RData")

### Toutes espèces ####
aspe <- aspe_groups %>%
  select(lop_id,esp_code_taxref,ope_date, esp_nom_latin, poissons,pop_coordonnees_x,pop_coordonnees_y)
colnames(aspe) <- c("id","cd_nom","date","nom_scientifique","groupe_taxo","x","y")

aspe <- st_as_sf(aspe, coords = c("x","y"), crs = 2154, remove =TRUE)

str(aspe)
aspe$Date <- substr(aspe$date, 1,10)
aspe$dat <- ymd(aspe$Date)

aspe <- aspe %>%
  select(id, cd_nom,dat,nom_scient, groupe_tax, geometry)
colnames(aspe) <- c("id","cd_nom","date","nom_scientifique","groupe_taxo","geom")

aspe <- as.data.frame(aspe)
aspe$source <- "ofb" 

save(aspe, file="output/output_rdata/aspe.RData")

### Sélection des espèces protégées ####
aspe_esp_pro<-merge(aspe_groups, especes_pro, by.x="esp_code_taxref", by.y="cd_nom")

#### Trier et renommer les variables ####
aspe_esp_pro <- as.data.frame(aspe_esp_pro)
aspe_esp_pro <- aspe_esp_pro %>%
  select(lop_id,esp_code_taxref,ope_date,nom_cite,ordre,menace_region,dept,pop_coordonnees_x,pop_coordonnees_y,pop_geometrie)

colnames(aspe_esp_pro) <- c("id","cd_nom","date","nom_scientifique","ordre", "menace_region","departements","x","y", "geom")

save(aspe_esp_pro, file="output/output_rdata/aspe_esp_pro.RData")








