##%######################################################%##
#                                                          #
####   Assembler les fichiers des 6 bases de données    ####
#              Version 11/08/2023                          #
##%######################################################%##

# Toutes espèces ---------------------------------------------------------------
cli::cli_h2("Toutes espèces")

## Chargement des fichiers ####
base::load(file = "output/output_rdata/sinp.RData")
base::load(file = "output/output_rdata/aspe.RData")
base::load(file = "output/output_rdata/gon.RData")
base::load(file = "output/output_rdata/oison.RData")
base::load(file = "output/output_rdata/clicnat.RData")
base::load(file = "output/output_rdata/pmcc.RData")

## Rassembler les fichiers ####
str(clicnat)
str(aspe)
str(gon)
str(pmcc)
str(oison)
str(sinp)

data_tout_esp <- bind_rows(aspe,
                           clicnat,
                           gon,
                           pmcc,
                           oison,
                           sinp)

save(data_tout_esp, file = "output/output_rdata/data_tout_esp.RData")


# Espèces protégées ------------------------------------------------------------
cli::cli_h2("Espèces protégées")

## Chargement des fichiers ####
base::load(file = "output/output_rdata/sinp_esp_pro.RData")
base::load(file = "output/output_rdata/aspe_esp_pro.RData")
base::load(file = "output/output_rdata/gon_esp_pro.RData")
base::load(file = "output/output_rdata/pmcc_esp_pro.RData")
base::load(file = "output/output_rdata/clicnat_esp_pro.RData")
base::load(file = "output/output_rdata/oison_esp_pro.RData")

## Rassembler les fichiers ####
str(clicnat_esp_pro)
str(aspe_esp_pro)
str(gon_esp_pro)
str(pmcc_esp_pro)
str(oison_esp_pro)
str(sinp_esp_pro)

data_esp_pro <- bind_rows(
  aspe_esp_pro,
  clicnat_esp_pro,
  gon_esp_pro,
  pmcc_esp_pro,
  sinp_esp_pro,
  oison_esp_pro
)

## Identification des groupes taxonomiques ##

amphibiens_pro <-  subset (data_esp_pro, subset = ordre %in%
                             c("Anura", 
                               "Caudata"))

amphibiens_pro$groupe_taxo <- "amphibiens"

mammiferes_pro <- subset(data_esp_pro,
                         subset = ordre %in%
                           c("Rodentia",
                             "Carnivora", 
                             "Soricomorpha"))

mammiferes_pro$groupe_taxo <- "mammiferes"

chiropteres_pro <- subset(data_esp_pro, subset = ordre %in%
                            c("Chiroptera"))

chiropteres_pro$groupe_taxo <- "chiropteres"

reptiles_pro <- subset(data_esp_pro, subset = ordre %in%
                         c("Squamata"))

reptiles_pro$groupe_taxo <- "reptiles"

odonates_pro <- subset(data_esp_pro, subset = ordre %in%
                         c("Odonata"))

odonates_pro$groupe_taxo <- "odonates"

orthopteres_pro <- subset(data_esp_pro, subset = ordre %in%
                            c("Orthoptera"))

orthopteres_pro$groupe_taxo <- "orthopteres"

rhopaloceres_pro <- subset(data_esp_pro, subset = ordre %in%
                             c("Lepidoptera"))

rhopaloceres_pro$groupe_taxo <- "rhopaloceres"

poissons_pro <- subset(
  data_esp_pro,
  subset = ordre %in%
    c(
      "Petromyzontiformes",
      "Anguilliformes",
      "Cypriniformes",
      "Esociformes",
      "Salmoniformes",
      "Gadiformes",
      "Decapoda"))

poissons_pro$groupe_taxo <- "poissons"

oiseaux_nicheurs_pro <- subset(
  data_esp_pro,
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
      "Bucerotiformes"))

oiseaux_nicheurs_pro$groupe_taxo <- "oiseaux_nicheurs"

data_esp_pro <- bind_rows(
  amphibiens_pro,
  chiropteres_pro,
  mammiferes_pro,
  oiseaux_nicheurs_pro,
  poissons_pro,
  rhopaloceres_pro,
  reptiles_pro,
  odonates_pro,
  orthopteres_pro
)

save(data_esp_pro, file = "output/output_rdata/data_esp_pro.RData")

