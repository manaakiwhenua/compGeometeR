#' @title Grid Coordinates
#' 
#' @description This function creates a \code{n}-dimensional grid of coordinates 
#' systematically spaced throughout the specified spatial extent.
#'
#' @param mins Vector of length \code{n} listing the point space minimum for each
#' dimension.
#' @param maxs Vector of length \code{n} listing the point space maximum for each
#' dimension.
#' @param spacing The spacings between points in all dimensions.
#'
#' @return A matrix with \code{n} columns - and potentially lots of rows!
#'
#' @examples
#' # Point space grid coordinates usage
#' xy = grid_coordinates(mins=c(0,0), maxs=c(10,15), spacing=1)
#' 
#' @export
grid_coordinates <- function(mins, maxs, spacing) {
  
  # Check input data
  if (length(mins) != length(maxs)) {
    stop("Length of mins and maxs differ")
  }
  if (FALSE %in% (mins < maxs)) {
    stop("Maximums not greater than minimums in all dimensions")
  }
  if (spacing <= 0) {
    stop("Spacing must be greater than zero")
  }
  
  # Create list of coordinate locations for each dimension
  dimCoords = list()
  for (n in seq(1, length(mins))) {
    dimCoords[[n]] <- seq(mins[n], maxs[n], spacing)
  }
  # Create all combinations of coordinates across all dimension
  return(expand.grid(dimCoords))
  
}
