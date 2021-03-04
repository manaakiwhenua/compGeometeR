#' @title Grid Coordinates
#' 
#' @description This function creates a \code{n}-dimensional grid of coordinates 
#' systematically spaced throughout the specified spatial extent.
#'
#' @param mins Vector of length \code{n} listing the point space minimum for each
#' dimension.
#' @param maxs Vector of length \code{n} listing the point space maximum for each
#' dimension.
#' @param spacings Vector of length \code{n} listing the spacings between points 
#' in all dimensions.
#'
#' @return A matrix with \code{n} columns - and potentially lots of rows!
#'
#' @examples
#' # Point space grid coordinates usage
#' xy = grid_coordinates(mins=c(0,0), maxs=c(10,15), spacings=c(1,1))
#' 
#' @export
grid_coordinates <- function(mins, maxs, spacings) {
  
  # Check input data
  if (length(mins) != length(maxs)) {
    stop("Length of mins and maxs differ")
  }
  if (length(mins) != length(spacings)) {
    stop("Length of spacings differs from length of mins and maxs")
  }
  if (FALSE %in% (mins < maxs)) {
    stop("Maximums not greater than minimums in all dimensions")
  }
  if (TRUE %in% (spacings <= 0)) {
    stop("All spacings must be greater than zero")
  }
  
  # Create list of coordinate locations for each dimension
  dimCoords = list()
  for (n in seq(1, length(mins))) {
    dimCoords[[n]] <- seq(mins[n], maxs[n], spacings[n])
  }
  # Create all combinations of coordinates across all dimension
  return(expand.grid(dimCoords))
  
}
