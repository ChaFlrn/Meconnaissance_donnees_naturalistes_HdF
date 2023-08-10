# Description des scripts du projet

## 00_chargement_packages

Ce script permet de charger l'ensemble des packages nécessaires au lancement du projet. L'utilisation du package 'renv' facilite cela en les stockant.

#### Commandes pour le package renv :


-   renv::init() : initialiser renv dans projet (renv::init(bare = TRUE) pour un projet existant)
-   renv::status() : check le statut du lockfile, packages présents/absents, packages dans renv.lock non utilisés dans le code
-   renv::dependencies() : quels packages utilisés dans le code ?
-   renv::snapshot() : sauvergarder l'état des packages utilisés dans le fichier renv.lock
-   renv::restore() : revenir à l'état du renv.lock. i.e. désinstalle les packages en trop, réinstalle les packages manquant
-   renv::install() : installer un package en utilisant renv (CRAN, version spécifique, github, commit spécifique, Bioconductor, ...).

## 01_import_data_brutes
Ce script a pour but d'ouvrir les fichiers de données brutes, de les nettoyer et de les homogénéiser pour pouvoir les assembler par la suite. 

## 02_assemblage_bases
L'assemblage des différents fichiers des bases de données se réalise à partir de ce script. Dans un premier temps, la réunification des données, toutes espèces confondues. Puis, le même processus pour les espèces protégées seulement.
