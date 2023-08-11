##%######################################################%##
#                                                          #
####   Récupération des bases de données                ####
###     Nettoyage et homogénéisation des variables       ###
##             Date : Août 2023                           ##
#                                                          #
##%######################################################%##

###---------------------------------------------------------#
cli::cli_h1("Import des données naturalistes")

###---------------------------------------------------------#
# Picardie nature ------------------------------------------#
cli::cli_h2("Données Clicnat")

## Chargement du fichier ####
#data_picnat <- sf::read_sf("data/data_brutes/OFB_clicnat.gpkg") 
base::load("./data/data_brutes/donnees_clicnat.RData")

## Précision des données ####
clicnat <- donnees_clicnat %>%
  dplyr::select(
    id_synthese,
    cd_ref_sp,
    cd_ref,
    cd_nom,
    date_debut,
    nom_cite,
    regne,
    classe,
    ordre,
    famille,
    menace_region,
    rarete_region,
    nombre_min,
    nombre_max,
    communes,
    niveau_validation,
    niveau_sensibilite,
    producteur,
    geom
  )


clicnat[clicnat$date_debut < "2012-01-01" , "Periode"] <- "historique"  
clicnat[clicnat$date_debut >= "2012-01-01" & clicnat$date_debut < "2023-01-01", "Periode"] <- "voulue"
clicnat[clicnat$date_debut >= "2023-01-01", "Periode"] <- "futur" 

clicnat <- dplyr::filter(clicnat, Periode == "voulue")

#clicnat <- clicnat[order(clicnat$date_debut, decreasing = FALSE), ]

## Sélection des données valides ####

clicnat[clicnat$niveau_validation == "Certain - très probable", "Validation"] <- "valide" 
clicnat[clicnat$niveau_validation == "Probable", "Validation"] <- "valide"
clicnat[clicnat$niveau_validation == "Douteux", "Validation"] <- "non_valide"
clicnat[clicnat$niveau_validation == "Invalide", "Validation"] <- "non_valide"
clicnat[clicnat$niveau_validation == "En attente de validation", "Validation"] <- "valide"

clicnat <- dplyr::filter(clicnat, Validation == "valide")
#clichesite <- dplyr::filter(clicnat, niveau_validation == "En attente de validation")

## Identification des groupes taxonomiques ####
levels(as.factor(clicnat$ordre))

amphibiens <-
  subset(clicnat, subset = ordre %in% c("Anura", "Caudata", "Urodela"))

amphibiens$groupe_taxo <- "amphibiens"

mammiferes <-
  subset(
    clicnat,
    subset = ordre %in% c(
      "Rodentia",
      "Carnivora",
      "Soricomorpha",
      "Eulipotyphla",
      "Lagomorpha"
    )
  )
mammiferes$groupe_taxo <- "mammiferes"

chiropteres <- subset(clicnat, subset = ordre %in%
                        c("Chiroptera"))
chiropteres$groupe_taxo <- "chiropteres"

reptiles <- subset(clicnat, subset = ordre %in%
                     c("Squamata", 
                       "Chelonii"))
reptiles$groupe_taxo <- "reptiles"

odonates <- subset(clicnat, subset = ordre %in%
                     c("Odonata"))
odonates$groupe_taxo <- "odonates"

orthopteres <- subset(clicnat, subset = ordre %in%
                        c("Orthoptera"))
orthopteres$groupe_taxo <- "orthopteres"

rhopaloceres <- subset(clicnat, subset = ordre %in%
                         c("Lepidoptera"))
rhopaloceres$groupe_taxo <- "rhopaloceres"

poissons <- subset(
  clicnat,
  subset = ordre %in%
    c(
      "Petromyzontiformes",
      "Anguilliformes",
      "Cypriniformes",
      "Esociformes",
      "Salmoniformes",
      "Gadiformes",
      "Decapoda",
      "Atheriniformes",
      "Gasterosteiformes",
      "Perciformes",
      "Pleuronectiformes",
      "Rajiformes",
      "Scorpaeniformes",
      "Siluriformes",
      "Tetraodontiformes"))
poissons$groupe_taxo <- "poissons"

oiseaux_nicheurs <- subset(
  clicnat,
  subset = ordre %in%
    c(
      "Anseriformes",
      "Falconiformes",
      "Ciconiiformes",
      "Galliformes",
      "Gruiformes",
      "Charadriiformes",
      "Passeriformes",
      "Caprimulgiformes",
      "Podicipediformes",
      "Strigiformes",
      "Cuculiformes",
      "Piciformes",
      "Procellariiformes",
      "Apodiformes",
      "Coraciiformes",
      "Pelecaniformes",
      "Accipitriformes",
      "Bucerotiformes",
      "Columbiformes",
      "Gaviiformes",
      "Otidiformes",
      "Phoenicopteriformes",
      "Psittaciformes"))

oiseaux_nicheurs$groupe_taxo <- "oiseaux_nicheurs"

clicnat_groups <- data.table::rbindlist(list(amphibiens,
                                              chiropteres,
                                              mammiferes,
                                              odonates,
                                              oiseaux_nicheurs,
                                              orthopteres,
                                              poissons,
                                              reptiles,
                                              rhopaloceres)) %>% 
  as.data.frame()

## Vérfication de la présence de doublons ####
clicnat_groups <- clicnat_groups[!duplicated(clicnat_groups$id_synthese), ]

## Toutes espèces confondues ####
#### Trier et renommer les colonnes ####
clicnat <- clicnat_groups %>%
  dplyr::select(id = id_synthese,
                cd_nom,
                date = date_debut,
                nom_scientifique = nom_cite,
                groupe_taxo, 
                geom)

clicnat$source <- "picnat"  

#### Sélection des données géométriques pour ne retenir que les points ####
clicnat <- 
  sf::st_as_sf(clicnat) %>% 
  dplyr::filter(sf::st_is(. , "MULTIPOINT")| sf::st_is(. , "POINT"))

## Sélection des espèces protégées ####
especes <- utils::read.csv(file = "data/statut_especes.csv", h = TRUE)

especes_pro <- dplyr::filter(especes, protection == "oui")

clicnat_esp_pro <- merge(clicnat_groups, especes_pro, by.x = "cd_nom", by.y = "cd_nom")

#### Trier et renommer les colonnes ####
clicnat_esp_pro <- clicnat_esp_pro %>%
  dplyr::select(id = id_synthese,
                cd_nom,
                date = date_debut,
                nom_scientifique = nom_cite.y,
                ordre = ordre.y,
                menace_region = menace_region.y,
                geom)

clicnat_esp_pro$source <- "picnat"

#### Sélection des données géométriques pour ne retenir que les points ####
clicnat_esp_pro <- 
  sf::st_as_sf(clicnat_esp_pro) %>% 
  dplyr::filter(sf::st_is(. , "MULTIPOINT") | sf::st_is(. , "POINT"))

clicnat_esp_pro <- clicnat_esp_pro %>%
  select(id,cd_nom,date, nom_scientifique,ordre,menace_region,source, geom)


# Groupe ornithologique et naturaliste  ----------------------------------------
cli::cli_h2("Données Groupe ornithologique et naturaliste")

## Chargement fichier ####
#data_gon <- sf::read_sf("Data_brutes/Sirf/230220_all_expo_deb2012")
base::load(file ="data/data_brutes/donnees_Gon.RData")

## Précision des données ####
gon <- donnees_Gon %>%
  dplyr::select(id_cit,
                id_taxo,
                cdref,
                date_d,
                nom_lat,
                ordre,
                valid,
                geom,
                contrib)

#gon<-gon[order(gon$date_d, decreasing=FALSE), ]

gon[gon$date_d < "2012-01-01" , "Periode"] <- "historique"
gon[gon$date_d >= "2012-01-01" & gon$date_d <"2023-01-01", "Periode"] <- "voulue"
gon[gon$date_d >= "2023-01-01", "Periode"] <- "futur"

gon <- dplyr::filter(gon, Periode == "voulue")

## Sélection des données valides ####
#levels(as.factor(gon$valid))

gon <- gon %>% dplyr::filter(!is.na(valid))

gon[gon$valid == "Certain  ‐ très probable" , "Validation"] <- "valide"
gon[gon$valid == "Probable", "Validation"] <- "valide"
gon[gon$valid == "Douteux", "Validation"] <- "non_valide"
gon[gon$valid == "Non évalué", "Validation"] <- "valide"

gon <- dplyr::filter(gon, Validation == "valide")
#gonhesite <- dplyr::filter(gon, valid == "Non évalué")

## Identification des groupes taxonomiques ####
#levels(as.factor(gon$ordre))

amphibiens <-  subset (gon, subset = ordre %in%
                         c("ANURA", 
                           "CAUDATA", 
                           "URODELA"))
amphibiens$groupe_taxo <- "amphibiens"

mammiferes <- subset(
  gon,
  subset = ordre %in%
    c(
      "RODENTIA",
      "CARNIVORA",
      "SORICOMORPHA",
      "EULIPOTYPHLA",
      "LAGOMORPHA"))
mammiferes$groupe_taxo <- "mammiferes"

chiropteres <- subset(gon, subset = ordre %in%
                        c("CHIROPTERA"))
chiropteres$groupe_taxo <- "chiropteres"

reptiles <- subset(gon, subset = ordre %in%
                     c("SQUAMATA", "CHELONII"))
reptiles$groupe_taxo <- "reptiles"

odonates <- subset(gon, subset = ordre %in%
                     c("ODONATA"))
odonates$groupe_taxo <- "odonates"

orthopteres <- subset(gon, subset = ordre %in%
                        c("ORTHOPTERA"))
orthopteres$groupe_taxo <- "orthopteres"

rhopaloceres <- subset(gon, subset = ordre %in%
                         c("LEPIDOPTERA"))
rhopaloceres$groupe_taxo <- "rhopaloceres"

poissons <- subset(
  gon,
  subset = ordre %in%
    c(
      "PETROMYZONTIFORMES",
      "ANGUILLIFORMES",
      "CYPRINIFORMES",
      "ESOCIFORMES",
      "SALMONIFORMES",
      "GADIFORMES",
      "DECAPODA",
      "ATHERINIFORMES",
      "GASTEROSTEIFORMES",
      "PERCIFORMES",
      "PLEURONECTIFORMES",
      "RAJIFORMES",
      "SCORPAENIFORMES",
      "SILURIFORMES",
      "TETRAODONTIFORMES",
      "AULOPIFORMES"))
poissons$groupe_taxo <- "poissons"

oiseaux_nicheurs <- subset(
  gon,
  subset = ordre %in%
    c(
      "ANSERIFORMES",
      "FALCONIFORMES",
      "CICONIIFORMES",
      "GALLIFORMES",
      "GRUIFORMES",
      "CHARADRIIFORMES",
      "PASSERIFORMES",
      "CAPRIMULGIFORMES",
      "PODICIPEDIFORMES",
      "STRIGIFORMES",
      "CUCULIFORMES",
      "PICIFORMES",
      "PROCELLARIIFORMES",
      "APODIFORMES",
      "CORACIIFORMES",
      "PELECANIFORMES",
      "ACCIPITRIFORMES",
      "BUCEROTIFORMES",
      "COLUMBIFORMES",
      "GAVIIFORMES",
      "OTIDIFORMES",
      "PHOENICOPTERIFORMES",
      "PSITTACIFORMES",
      "APODIFORMES"))
oiseaux_nicheurs$groupe_taxo <- "oiseaux_nicheurs"

gon_groups <- data.table::rbindlist(list(amphibiens,
                                             chiropteres,
                                             mammiferes,
                                             odonates,
                                             oiseaux_nicheurs,
                                             orthopteres,
                                             poissons,
                                             reptiles,
                                             rhopaloceres)) %>% 
  as.data.frame()

## Vérfication de la présence de doublons ####
gon_groups <- gon_groups[!duplicated(gon_groups$id_cit), ]

## Toutes espèces ####
### Trier et renommer les colonnes ####
gon <- gon_groups %>%
  dplyr::select(id = id_cit , 
                cd_nom = cdref, 
                date = date_d, 
                nom_scientifique = nom_lat, 
                groupe_taxo, 
                geom)

gon$source <- "gon"


### Sélection de la géométrie ####
gon <- 
  sf::st_as_sf(gon) %>% 
  dplyr::filter(sf::st_is(. , "MULTIPOINT") | sf::st_is(. , "POINT"))

gon <- gon %>%
  select(id, 
         cd_nom,
         date,
         nom_scientifique,
         groupe_taxo,
         source,
         geom)

## Sélection des espèces protégées ####
gon_groups$cd_nom <- as.numeric(gon_groups$id_taxo)

gon_esp_pro <- merge(gon_groups, especes_pro, by.x = "cdref", by.y = "cd_nom")

### Trier et renommer les colonnes ####
gon_esp_pro <- gon_esp_pro %>%
  select(id = id_cit,
         cd_nom = cdref,
         date = date_d,
         nom_scientifique = nom_cite,
         ordre = ordre.y,
         menace_region,
         geom)

gon_esp_pro <- as.data.frame(gon_esp_pro)
gon_esp_pro$source <- "gon"

### Trier géométrie ####
gon_esp_pro <- 
  sf::st_as_sf(gon_esp_pro) %>% 
  dplyr::filter(sf::st_is(. , "MULTIPOINT") | sf::st_is(. , "POINT"))

gon_esp_pro <- gon_esp_pro %>%
  select(id,
         cd_nom,
         date,
         nom_scientifique,
         ordre,
         menace_region,
         source,
         geom)

# OFB  ------------------------------------------
cli::cli_h2("Office francais de la biodiversité")

## ASPE ####
cli::cli_h3("ASPE")

### Récupération des données ####
base::load(file="data/data_brutes/tables_sauf_mei_2023_04_07_09_39_32.RData")

passerelle <- mef_creer_passerelle()
passerelle_hdf <- passerelle %>%
  aspe::mef_ajouter_dept() %>%  #ajout d'une colonne numéro de département
  dplyr::filter(dept %in% c('02',
                     '59',
                     '60',
                     '62',
                     '80')) %>% #filtrage des départements des Hdf
  dplyr::select(dept,
         ope_id,
         pop_id,
         sta_id,
         pre_id,
         lop_id) %>%   # selection des colonnes qui m'intéressent
  dplyr::distinct() #suppression des lignes doublons (lignes générées à cause des colonnes de lots etc.)

gdata::keep(operation,
            ref_espece,
            lot_poissons,
            point_prelevement,
            passerelle_hdf,
            especes_pro,
            clicnat,
            clicnat_esp_pro,
            gon,
            gon_esp_pro,
            sure = TRUE)

data_aspe <- passerelle_hdf %>%
  aspe::mef_ajouter_ope_date() %>%
  dplyr::filter(ope_date > lubridate::dmy("31/12/2011") & ope_date < lubridate::dmy("01/01/2023")) %>%
  droplevels()

data_op <- operation %>%
  dplyr::select(ope_pop_id,
                ope_date)

data_pop <- point_prelevement %>%
  dplyr::select(pop_id,
                pop_geometrie,
                pop_coordonnees_x,
                pop_coordonnees_y)

data_esp <- ref_espece %>%
  dplyr::select(esp_id,
                esp_code_taxref,
                esp_nom_latin)

data_lot <- lot_poissons %>%
  dplyr::select(lop_id,
                lop_esp_id)

croisement_aspe <- merge(data_aspe, data_pop , by.x = "pop_id", by.y = "pop_id")
lot_esp <- merge(data_lot, data_esp , by.x = "lop_esp_id", by.y = "esp_id")
aspe <- merge(croisement_aspe, lot_esp, by.x = "lop_id", by.y = "lop_id")

aspe <- aspe %>%
  dplyr::select(lop_id,
                pop_id,
                ope_id,
                esp_code_taxref,
                ope_date,annee, 
                esp_nom_latin,
                dept, 
                pop_coordonnees_x, 
                pop_coordonnees_y, 
                pop_geometrie)

### Vérification des doublons ####
aspe <- aspe[!duplicated(aspe$lop_id), ]

### Identification du groupe poissons ####
#levels(as.factor(aspe$esp_nom_latin))

aspe[aspe$esp_nom_latin == "Astacus leptodactylus", "poissons"] <- "non"
aspe[aspe$esp_nom_latin == "Eriocheir sinensis", "poissons"] <- "non"
aspe[aspe$esp_nom_latin == "Faxionus limosus", "poissons"] <- "non"
aspe[aspe$esp_nom_latin == "Pacifastacus leniusculus", "poissons"] <- "non"
aspe[aspe$esp_nom_latin == "Procambarus clarkii", "poissons"] <- "non"

aspe_groups <- subset(aspe, is.na(poissons))

aspe_groups$poissons <- "poissons"


### Toutes espèces ####
aspe <- aspe_groups %>%
  dplyr::select(id = lop_id,
                cd_nom = esp_code_taxref,
                date = ope_date, 
                nom_scientifique = esp_nom_latin,
                groupe_taxo = poissons,
                x = pop_coordonnees_x,
                y = pop_coordonnees_y)

aspe <- sf::st_as_sf(aspe, coords = c("x","y"), crs = 2154, remove =TRUE)

aspe$Date <- substr(aspe$date, 1, 10)
aspe$dat <- lubridate::ymd(aspe$Date)

aspe <- aspe %>%
  dplyr::select(id, 
         cd_nom,
         date = dat,
         nom_scientifique = nom_scient, 
         groupe_taxo = groupe_tax, 
         geom = geometry)

aspe <- as.data.frame(aspe)
aspe$source <- "ofb"

### Sélection des espèces protégées ####
aspe_esp_pro <- merge(aspe_groups, especes_pro, by.x="esp_code_taxref", by.y="cd_nom")

### Trier et renommer les variables ####
aspe_esp_pro <- aspe_esp_pro %>%
  dplyr::select(
    id = lop_id,
    cd_nom = esp_code_taxref,
    date = ope_date,
    nom_scientifique = nom_cite,
    ordre,
    menace_region,
    departements = dept,
    x = pop_coordonnees_x,
    y = pop_coordonnees_y,
    geom = pop_geometrie)

aspe_esp_pro <- sf::st_as_sf(aspe_esp_pro, coords = c("x","y"), crs = 2154, remove =TRUE)

aspe_esp_pro$Date <- substr(aspe_esp_pro$date, 1,10)
aspe_esp_pro$dat <- lubridate::ymd(aspe_esp_pro$Date)

aspe_esp_pro <- aspe_esp_pro %>%
  dplyr::select(id,
                cd_nom,
                date = dat,
                nom_scientifique,
                ordre,
                menace_region,
                geom = geometry)

aspe_esp_pro <- as.data.frame(aspe_esp_pro)
aspe_esp_pro$source <- "ofb"

## PMCC ####
cli::cli_h3("PMCC")

### Chargement du fichier ####
data_pmcc <- sf::read_sf("data/data_brutes/Export_RezoPMCC_DonneesValides.shp")

### Précision des données ####
pmcc <- data_pmcc %>%
  dplyr::select(identifian,
                cd_nom,
                date_obs, 
                nom_vern, 
                insee_dep,
                validation,
                x_l93, 
                y_l93, 
                geom = geometry)

pmcc$date <- lubridate::ymd(pmcc$date_obs)

#pmcc <- pmcc[order(pmcc$date, decreasing=FALSE), ]

pmcc[pmcc$date < "2012-01-01", "Periode"] <- "historique"
pmcc[pmcc$date >= "2012-01-01" & pmcc$date <"2023-01-01", "Periode"] <- "voulue"
pmcc[pmcc$date >= "2023-01-01", "Periode"] <- "futur"

pmcc <- dplyr::filter(pmcc, Periode == "voulue")

### Sélection des départements de la région ####

pmcc[pmcc$insee_dep == "59", "Region"] <- "HdF"
pmcc[pmcc$insee_dep == "60", "Region"] <- "HdF"
pmcc[pmcc$insee_dep == "62", "Region"] <- "HdF"
pmcc[pmcc$insee_dep == "80", "Region"] <- "HdF"
pmcc[pmcc$insee_dep =="02", "Region"] <- "HdF"

pmcc <- dplyr::filter(pmcc, Region == "HdF")

### Identification du groupe taxonomique ####
pmcc$groupe_taxo <- "mammiferes"

### Vérfication de la présence de doublons ####

pmcc_groups <- pmcc[!duplicated(pmcc$identifian), ]

### Toutes espèces ####
#### Trier et renommer les colonnes ####
pmcc <- pmcc_groups %>%
  dplyr::select(id = identifian,
                cd_nom,
                date, 
                nom_scientifique = nom_vern,
                groupe_taxo,
                geom)

pmcc$source <- "ofb"

### Sélection des espèces protégées ####
pmcc_esp_pro <- merge(pmcc_groups, especes_pro, by.x = "cd_nom", by.y = "cd_nom")

pmcc_esp_pro <- pmcc_esp_pro %>%
  dplyr::select(identifian,
                cd_nom,
                date, 
                nom_cite,
                ordre, 
                menace_region,
                insee_dep,
                x_l93,
                y_l93, 
                geometry)

#### Trier et renommer les colonnes ####
pmcc_esp_pro$source <- "ofb"
pmcc_esp_pro <- pmcc_esp_pro %>%
  dplyr::select(id = identifian,
                cd_nom,
                date, 
                nom_scientifique = nom_cite,
                ordre, 
                menace_region, 
                source, 
                geom = geometry)

## OISON ####
cli::cli_h3("OISON")

### Chargement du fichier ####
data_oison <- utils::read.csv(file = "data/data_brutes/oison.csv", h = TRUE, dec = ",", sep = ";")

### Précision du fichier ####
colnames(data_oison) <-
  c(
    "Nature",
    "Co_obsv",
    "Commentaire",
    "Moyen",
    "Obj_rech",
    "Corine",
    "Date",
    "Identifiant",
    "Identifiant_ext",
    "Obsverateur",
    "Identifiant_tax",
    "Heure",
    "Type",
    "Type_rech",
    "Statut",
    "Raison_invalid",
    "Com",
    "Duree",
    "Distance",
    "APPB",
    "Commune",
    "Contexte_piscicole",
    "Departement",
    "Geometrie",
    "Longueur_troncon",
    "Region",
    "SIC",
    "Surface_station",
    "X",
    "Y",
    "ZNIEFF1",
    "ZNIEFF2",
    "Zone_hydro",
    "ZPS",
    "Masse_eau",
    "RNN",
    "Presence",
    "Classe_nb",
    "Nb_individus",
    "Stade_dvt",
    "Vivant")

oison <- data_oison %>%
  dplyr::select(Nature,
                Identifiant,
                Date, 
                Identifiant_tax,
                Departement, 
                Geometrie, 
                X,
                Y)

oison$date <- lubridate::dmy(oison$Date)

#oison <- oison[order(oison$date, decreasing = FALSE), ]

oison[oison$date < "2012-01-01", "Periode"] <- "historique"
oison[oison$date >= "2012-01-01" & oison$date < "2023-01-01", "Periode"] <- "voulue"
oison[oison$date >= "2023-01-01", "Periode"] <- "futur"

oison <- dplyr::filter(oison, Periode == "voulue")

oison[oison$Departement == "AISNE", "Departement"] <- "02"
oison[oison$Departement == "SOMME", "Departement"] <- "80"
oison[oison$Departement == "NORD", "Departement"] <- "59"
oison[oison$Departement == "OISE", "Departement"] <- "60"
oison[oison$Departement == "PAS-DE-CALAIS", "Departement"] <- "62"

### Sélection des données d'observation ####
oison <- dplyr::filter(oison,Nature=="┣ Observation")

### Récupération de la colonne "cd_nom" ##
cd_nom <- utils::read.csv(file = "data/data_brutes/oison_taxon.csv", h = TRUE, dec = ",", sep = ",")

oison <- merge(oison, cd_nom, by.x = "Identifiant", by.y = "observation_id")

oison <- oison %>%
  dplyr::select(Identifiant,
                Date,
                Identifiant_tax,
                cd_nom, 
                Departement, 
                Geometrie, 
                X,
                Y)

### Identification des groupes taxonomiques ####
clic_group <- clicnat_groups %>%
  dplyr::select(cd_nom,
                groupe_taxo)

gon_group <- gon_groups %>%
  dplyr::select(cd_nom = cdref,
                groupe_taxo)

pmcc_groups <- as.data.frame(pmcc_groups)
pmcc_group <- pmcc_groups %>%
  dplyr::select(cd_nom,
                groupe_taxo)

aspe_group <- aspe_groups %>%
  dplyr::select(cd_nom = esp_code_taxref,
                groupe_taxo = poissons)

group_taxo <- data.table::rbindlist(list(clic_group,
                                         gon_group,
                                         pmcc_group,
                                         aspe_group)) %>% 
  as.data.frame()

group_taxo <- group_taxo[!duplicated(group_taxo$cd_nom), ]
oison_groups <- merge(oison, group_taxo, by.x = "cd_nom", by.y = "cd_nom")

### Vérfication de la présence de doublons ####
oison_groups <- oison_groups[!duplicated(oison_groups$Identifiant), ]

### Toutes espèces ####
oison <- oison_groups %>%
  dplyr::select(Identifiant,
         cd_nom,
         Date, 
         Identifiant_tax,
         groupe_taxo, 
         X, 
         Y)

oison <- sf::st_as_sf(oison_groups, coords = c("X","Y"), crs = 2154, remove =TRUE)

oison$date <- substr(oison$Date, 1, 10)
oison$dat <- lubridate::dmy(oison$date)

oison <- oison %>%
  dplyr::select(id = Identifiant, 
                cd_nom,
                date = dat,
                nom_scientifique = Identifiant_tax,
                groupe_taxo,
                geom = geometry)

oison <- as.data.frame(oison)
oison$source <- "ofb"

### Sélection des espèces protégées ####
oison_esp_pro <- merge(oison_groups, especes_pro, by.x = "cd_nom", by.y = "cd_nom")

oison_esp_pro <- oison_esp_pro %>%
  dplyr::select(id = Identifiant,
         cd_nom,
         date = Date, 
         nom_scientifique = nom_cite, 
         ordre, 
         menace_region,
         departements = Departement, 
         geom = Geometrie, 
         x = X, 
         y = Y)

oison_esp_pro$source <- "oison"

oison_esp_pro <- sf::st_as_sf(oison_esp_pro, coords = c("x","y"), crs = 2154, remove =TRUE)

oison_esp_pro <- oison_esp_pro %>%
  dplyr::select(id,
                cd_nom,
                date,
                nom_scientifique,
                ordre, 
                menace_region, 
                source,
                geom = geometry)



# SINP -------------------------------------------------------------------------
cli::cli_h2("SINP")

### Chargement du fichier ####
data_sinp <- utils::read.csv(file = "data/data_brutes/St_Principal.csv", h = TRUE, ";")

### Précision des données ####
sinp <- data_sinp %>%
  dplyr::select(cleObs,
                cdNom,
                dateDebut,
                nomCite, 
                orgGestDat, 
                cleObjet)

sinp$date <- lubridate::ymd(sinp$dateDebut)

sinp <- sinp %>%
  dplyr::filter(!is.na(date))

#sinp <- sinp[order(sinp$date, decreasing = FALSE), ]

sinp[sinp$date < "2012-01-01", "Periode"] <- "historique"
sinp[sinp$date >= "2012-01-01" & sinp$date < "2023-01-01", "Periode"] <- "voulue"
sinp[sinp$date >= "2023-01-01", "Periode"] <- "futur"

sinp <- dplyr::filter(sinp, Periode == "voulue")

### Ajouter les coordonnées GPS ####
#### Récupérer les départements #####
data_dpt <- utils::read.csv(file = "data/data_brutes/St_Departements.csv", h = TRUE, sep = ";")

sinp <- merge(sinp, data_dpt, by.x = "cleObs", by.y = "cleObs")

#### Récupérer les points GPS #####
point <- sf :: st_read("data/data_brutes/point.shp") %>%
  sf::st_transform(crs = 2154)

sinp <- merge(sinp, point, by.x = "cleObjet", by.y = "cleObjet")

sinp <- sinp %>%
  dplyr::select(cleObs,
                cleObjet, 
                cdNom,
                date, 
                nomCite, 
                cdDept, 
                X_PREC, 
                Y_PREC, 
                geometry,
                orgGestDat)

### Vérfication de la présence de doublons ####
sinp <- sinp[!duplicated(sinp$cleObs), ]

### Suppression des bases en double ####
sinp[sinp$orgGestDat == "CONSERVATOIRE D ESPACES NATURELS DE PICARDIE", "Retenue"] <- "non"
sinp[sinp$orgGestDat == "Groupe ornithologique et naturaliste du Nord - Pas-de-Calais", "Retenue"] <- "non"
sinp[sinp$orgGestDat == "GON", "Retenue"] <- "non"
sinp[sinp$orgGestDat == "OFB", "Retenue"] <- "non"
sinp[sinp$orgGestDat == "Picardie Nature", "Retenue"] <- "non"
sinp[sinp$orgGestDat == "Groupe Ornithologique et naturaliste du Nord-Pas-de-Calais (GON)", "Retenue"] <- "non"
sinp[sinp$orgGestDat == "PICARDIE NATURE", "Retenue"] <- "non"

sinp <- subset(sinp, is.na(Retenue))

### Identification des groupes taxonomiques ####
sinp_groups <- merge(sinp, group_taxo, by.x = "cdNom", by.y = "cd_nom")

sinp <- sinp_groups %>%
  dplyr::select(cleObs,
                cdNom,
                date,
                nomCite,
                groupe_taxo,
                geometry)

### Toutes espèces ####
sinp <- sinp_groups %>%
  dplyr::select(id = cleObs,
                cd_nom = cdNom,
                date, 
                nom_scientifique = nomCite,
                groupe_taxo, 
                geom = geometry)

sinp$source <- "sinp"

### Sélection des espèces protégées ####
sinp_esp_pro <- merge(sinp_groups, especes_pro, by.x = "cdNom", by.y = "cd_nom")

sinp_esp_pro <- sinp_esp_pro %>%
  dplyr::select(id = cleObs,
                cd_nom = cdNom,
                date,
                nom_scientifique = nom_cite,
                ordre, 
                menace_region,
                geom = geometry)

sinp_esp_pro$source <- "sinp"



## Sauvegarde des fichiers 
gdata::keep(especes_pro,
            clicnat,
            clicnat_esp_pro,
            gon,
            gon_esp_pro,
            sinp,
            sinp_esp_pro,
            aspe,
            aspe_esp_pro,
            pmcc,
            pmcc_esp_pro,
            oison,
            oison_esp_pro,
            sure = TRUE)


class(clicnat)
clicnat <- as.data.frame(clicnat)
clicnat <- dplyr::relocate(clicnat, source, .after = last_col())
save(clicnat, file = "output/output_rdata/clicnat.RData")

class(clicnat_esp_pro)
clicnat_esp_pro <- as.data.frame(clicnat_esp_pro)
save(clicnat_esp_pro, file = "output/output_rdata/clicnat_esp_pro.RData")

class(gon)
gon <- as.data.frame(gon)
gon <- dplyr::relocate(gon, source, .after = last_col())
save(gon, file = "output/output_rdata/gon.RData")

class(gon_esp_pro)
gon_esp_pro <- as.data.frame(gon_esp_pro)
save(gon_esp_pro, file = "output/output_rdata/gon_esp_pro.RData")

class(aspe)
aspe <- as.data.frame(aspe)
save(aspe, file = "output/output_rdata/aspe.RData")

class(aspe_esp_pro)
aspe_esp_pro <- as.data.frame(aspe_esp_pro)
save(aspe_esp_pro, file = "output/output_rdata/aspe_esp_pro.RData")

class(pmcc)
pmcc <- as.data.frame(pmcc)
pmcc$id <- as.numeric(pmcc$id)
pmcc$cd_nom <- as.numeric(pmcc$cd_nom)
save(pmcc, file = "output/output_rdata/pmcc.RData")

class(pmcc_esp_pro)
pmcc_esp_pro <- as.data.frame(pmcc_esp_pro)
pmcc_esp_pro$id <- as.numeric(pmcc_esp_pro$id)
pmcc_esp_pro$cd_nom <- as.numeric(pmcc_esp_pro$cd_nom)
save(pmcc_esp_pro, file = "output/output_rdata/pmcc_esp_pro.RData")

class(oison)
oison <- as.data.frame(oison)
save(oison, file = "output/output_rdata/oison.RData")

class(oison_esp_pro)
oison_esp_pro <- as.data.frame(oison_esp_pro)
save(oison_esp_pro, file = "output/output_rdata/oison_esp_pro.RData")

class(sinp)
sinp <- as.data.frame(sinp)
sinp$id <- as.numeric(sinp$id)
sinp$cd_nom <- as.numeric(sinp$cd_nom)
save(sinp, file = "output/output_rdata/sinp.RData")

class(sinp_esp_pro)
sinp_esp_pro <- as.data.frame(sinp_esp_pro)
sinp_esp_pro$id <- as.numeric(sinp_esp_pro$id)
sinp_esp_pro$cd_nom <- as.numeric(sinp_esp_pro$cd_nom)
save(sinp_esp_pro, file = "output/output_rdata/sinp_esp_pro.RData")













