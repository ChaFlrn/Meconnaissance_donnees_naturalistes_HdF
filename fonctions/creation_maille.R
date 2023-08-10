#' Creation d'une maille pour une couche spatiale
#'
#' @param couche_shape une couche spatiale préalablement chargée
#' @param taille la taille de la maille voulue (en mètre)
#'
#' @return un dataframe avec les mailles et leurs numéros
#' @export
#'
#' @examples
#' \dontrun{
#' creation_maille(couche_shape = somme, taille = 5000)
#' }
#' 
creation_maille <- function(couche_shape, taille){
  
  grille <- sf::st_make_grid(sf::st_bbox(couche_shape), cellsize = c(taille, taille), crs = 2154)
  
  grille <- sf::st_intersection(couche_shape, st_geometry(grille)) %>% 
    dplyr::mutate(id_maille_dpt = row_number()) %>% 
    dplyr::relocate(id_maille_dpt)
  
  return(grille)
}


