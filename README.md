---
editor_options: 
  markdown: 
    wrap: 80
---

# Projet sur la méconnaissance des données naturalistes dans la région des Hauts-de-France

## Objectif

Faire un premier état des lieux de la connaissance naturaliste dans la région
des Hauts-de-France. L'ensemble du projet est restreint à 9 groupes taxonomiques
: amphibiens, chiroptères, mammifères (terrestres), odonates, oiseaux nicheurs,
orthoptères, poissons, reptiles et rhopalocères. Un second filtre s'applique
pour une partie du projet, celui des espèces protégées appartenant aux listes
rouges régionales.

Pour ce faire, 3 indices sont utilisés : - l'indice de la pression
d'observation - l'indice espèce-maille - l'indice de la connaissance

L'indice de la connaissance est le croisement des deux autres indices.

Pour chaque indice, deux niveaux d'analyses sont réalisés : - toutes espèces
confondues - espèces protégées des listes rouges régionales

Pour approfondir le sujet, l'indice connaissance peut être mis en relation avec
les continuités écologiques. Ceci dans le but d'avoir une vision plus précise de
la connaissance naturaliste.

## Explications de l'arborescence du projet
-   make : 
-   data : dossier
    -   'data_brutes' : les données brutes naturalistes
    -   'data_geo' : les couches géographiques (région HdF et départements)
-   fonction : dossier qui recense les scripts des différentes fonctions créées
-   output : ce dossier regroupe les sorties des analyses, au format RData et
    aux formats qgis (shapefile et/ou geopackage)
-   renv : dossier relatif au package renv, permettant de stocker les packages
    nécessaires au projet et de connaître leurs versions utilisées
-   scripts : dossier qui regroupe tous les scripts utiles pour exécuter le
    projet

## Explications des indices

### Indice de la pression d'observation

Cet indice représente la moyenne annuelle du nombre d'observations par maille.
Les mailles seront ensuite comparées à la valeur de la moyenne régionale de la
pression d'observation pour définir une sous-prospection ou un sur-prospection.

### Indice espèce-maille

Cet indice classe les mailles en fonction du nombre d'espèces différentes
présentes. A partir des valeurs seuils définies au préalable, la maille est
classée "mauvaise" si son nombre d'espèces est inférieur au seuil et "bonne"
s'il est supérieur.

### Indice de la connaissance

C'est le croisement des deux autres indices pour indiquer un état de
connaissance, tant au niveau de la pression d'observation qu'au niveau du nombre
d'espèces présentes dans chaque maille.

### Description des scripts du projet

#### 00_chargement_packages

Ce script permet de charger l'ensemble des packages nécessaires au lancement du
projet. L'utilisation du package 'renv' facilite cela en les stockant.

##### Commandes pour le package renv :

-   renv::init() : initialiser renv dans projet (renv::init(bare = TRUE) pour un
    projet existant)
-   renv::status() : check le statut du lockfile, packages présents/absents,
    packages dans renv.lock non utilisés dans le code
-   renv::dependencies() : quels packages utilisés dans le code ?
-   renv::snapshot() : sauvergarder l'état des packages utilisés dans le fichier
    renv.lock
-   renv::restore() : revenir à l'état du renv.lock. i.e. désinstalle les
    packages en trop, réinstalle les packages manquant
-   renv::install() : installer un package en utilisant renv (CRAN, version
    spécifique, github, commit spécifique, Bioconductor, ...).

### 01_import_data_brutes

Ce script a pour but d'ouvrir les fichiers de données brutes, de les nettoyer et
de les homogénéiser pour pouvoir les assembler par la suite.

### 02_assemblage_bases

L'assemblage des différents fichiers des bases de données se réalise à partir de
ce script. Dans un premier temps, la réunification des données, toutes espèces
confondues. Puis, le même processus pour les espèces protégées seulement.

### 03_maillage

Ce troisième script s'occupe de la partie géomtétrique du projet. C'est ici que
les grilles contenant les mailles sont créées en fonction des départements, puis
jointes au fichier global de données. Ceci dans le but d'avoir pour chaque
observation, la maille et le numéro de maille qui lui correspond. Cela permettra
par la suite de calculer les différents indices.

## Résultats

Pour chaque indice, un fichier global contenant tous les départements et tous
les groupes taxonomiques est créé. Ce fichier est à la fois créé pour toutes les
espèces et également pour les espèces protégées. A la fin de l'exécution du
projet, 2 types de formats ressortent pour les fichiers : - .RData - .gpkg

Le format geopackage permet de pouvoir réaliser les cartographies sous Qgis,
mais elles peuvent également être faites directement sous R à l'aide des
fichiers en RData.
