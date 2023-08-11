# Projet sur la méconnaissance des données naturalistes dans la région des Hauts-de-France

## Objectif
Faire un premier état des lieux de la connaissance naturaliste dans la région des Hauts-de-France. L'ensemble du projet est restreint à 9 groupes taxonomiques : amphibiens, chiroptères, mammifères (terrestres), odonates, oiseaux nicheurs, orthoptères, poissons, reptiles et rhopalocères. Un second filtre s'applique pour une partie du projet, celui des espèces protégées appartenant aux listes rouges régionales. 

Pour ce faire, 3 indices sont utilisés :
- l'indice de la pression d'observation
- l'indice espèce-maille
- l'indice de la connaissance

L'indice de la connaissance est le croisement des deux autres indices.

Pour chaque indice, deux niveaux d'analyses sont réalisés : 
- toutes espèces confondues
- espèces protégées des listes rouges régionales 

Pour approfondir le sujet, l'indice connaissance peut être mis en relation avec les continuités écologiques. Ceci dans le but d'avoir une vision plus précise de la connaissance naturaliste. 

## Explications de l'arborescence du projet
- data : dossier
    - 'data_brutes' : les données brutes naturalistes
    - 'data_geo' : les couches géographiques (région HdF et départements)
- fonction : dossier qui recense les scripts des différentes fonctions créées
- output : ce dossier regroupe les sorties des analyses, au format RData et aux formats qgis (shapefile et/ou geopackage)
- renv : dossier relatif au package renv, permettant de stocker les packages nécessaires au projet et de connaître leurs versions utilisées
- scripts : dossier qui regroupe tous les scripts utiles pour exécuter le projet


## Explications des indices
### Indice de la pression d'observation
Cet indice représente la moyenne annuelle du nombre d'observations par maille. Les mailles seront ensuite comparées à la valeur de la moyenne régionale de la pression d'observation pour définir une sous-prospection ou un sur-prospection.  

### Indice espèce-maille
Cet indice classe les mailles en fonction du nombre d'espèces différentes présentes. A partir des valeurs seuils définies au préalable, la maille est classée "mauvaise" si son nombre d'espèces est inférieur au seuil et "bonne" s'il est supérieur. 

### Indice de la connaissance
C'est le croisement des deux autres indices pour indiquer un état de connaissance, tant au niveau de la pression d'observation qu'au niveau du nombre d'espèces présentes dans chaque maille. 


## Résultats
Pour chaque indice, un fichier global contenant tous les départements et tous les groupes taxonomiques est créé. Ce fichier est à la fois créé pour toutes les espèces et également pour les espèces protégées. 
A la fin de l'exécution du projet, 2 types de formats ressortent pour les fichiers : 
- .RData
- .gpkg

Le format geopackage permet de pouvoir réaliser les cartographies sous Qgis, mais elles peuvent également être faites directement sous R à l'aide des fichiers en RData. 