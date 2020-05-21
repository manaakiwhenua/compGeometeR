#-------------------------------------------------------------
#' @title Grid Coordinates
#' @description Create an \code{n}-dimensional grid of coordinates across space.
#'
#' @param mins Vector of length \code{n} listing the point space minimum for each
#' dimension.
#' @param maxs Vector of length \code{n} listing the pointspace maximum for each
#' dimension.
#' @param nCoords Number of coordinates across the point space in all dimensions.
#'
#' @details This function creates a grid of coordinates systematically located
#' throughout the specified point space to enable visualisation of alpha shape .
#' The extent of the grid is given by the \code{mins} and \code{maxs}, and the number
#' of coordinates for each dimension is given by \code{nCoords}.
#'
#' @return A matrix with \code{n} columns.
#'
#' @examples
#' # Point space grid coordinates usage
#' xy = grid_coordinates(mins=c(15,0), maxs=c(35,200), nCoords=5)
#' @export
grid_coordinates <- function(mins, maxs, nCoords) {
  
  # Check input data
  if (length(mins) != length(maxs)) {
    stop("Length of mins and maxs differ")
  }
  if (FALSE %in% (mins < maxs)) {
    stop("Maximums not greater than minimums in all dimensions")
  }
  if (nCoords <= 1) {
    stop("Sample size must be greater than one")
  }
  
  # Create list of coordinate locations for each dimension
  dimCoords = list()
  for (n in seq(1, length(mins))) {
    dimCoords[[n]] = seq(mins[n], maxs[n], (maxs[n] - mins[n]) / (nCoords - 1))
  }
  # Create all combinations of coordinates across all dimension
  return(expand.grid(dimCoords))
  
}
