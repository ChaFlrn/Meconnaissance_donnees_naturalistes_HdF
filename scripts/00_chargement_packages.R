##%######################################################%##
#                                                          #
####              Chargement des packages               ####
#                                                          #
##%######################################################%##

if (!require("renv")) install.packages("renv")

#### Fonctionnement de renv ------------------------------------
### Commandes pour le package renv :
# renv::init()  # pour initialiser renv dans projet / (# renv::init(bare = TRUE) pour un projet existant)
# renv::status()  # check le statut du lockfile, packages présents/absents, packages dans renv.lock non utilisés dans le code
# renv::dependencies()  # quels packages utilisés dans le code ?
# renv::snapshot()  # Pour sauver l'état des packages utilisés dans le fichier renv.lock
# renv::restore() # Pour revenir à l'état du renv.lock. i.e. désinstalle les packages en trop, réinstalle les packages manquant
# renv::install() # Pour installer un package en utilisant renv (CRAN, version spécifique, github, commit spécifique, Bioconductor, ...).


### Exemple pour configurer renv dans un nouveaux projet :
# a) faire : renv::init(bare = TRUE)
# b) installer les librairies "classiquement"
# c) faire: renv::status()
# d) faire renv::snapshot()
# e) plus tard/sur une autre machine/ faire renv::restore() --> restaure la liste des packages.


#### Fonctionnement de renv ------------------------------------
### Restaure les packages dans le lockfile :
# renv::restore()

### Restaure les packages dans le lockfile :
library("tidyverse")
library("sf")
library("data.table")
library("devtools")
#devtools::install_github("PascalIrz/aspe")
library("aspe")
library("gdata")


### Fonctions perso

source("./fonctions/creation_maille.R")

