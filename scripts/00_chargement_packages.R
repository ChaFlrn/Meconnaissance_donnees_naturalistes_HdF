##%######################################################%##
#                                                          #
####              Chargement des packages               ####
#                                                          #
##%######################################################%##

if (!require("renv")) install.packages("renv")

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

