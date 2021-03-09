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
#' @return A list of two objects.  The first object is a dataframe with \code{n} 
#' columns and a row for each coordinate - so potentially lots of rows!  The 
#' second object is another list of length \code{n} that contains the 
#' coordinates along each dimension.
#'
#' @examples
#' # Point space grid coordinates usage
#' grid = grid_coordinates(mins=c(0,0), maxs=c(10,15), spacings=c(1,1))
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
  dims = length(mins)
  dimension_coords <- list()
  for (n in seq(dims)) {
    dimension_coords[[n]] <- seq(mins[n], maxs[n], spacings[n])
  }
  # Create all combinations of coordinates across all dimension
  grid_coords <- expand.grid(dimension_coords, KEEP.OUT.ATTRS = FALSE)
  colnames(grid_coords) <- seq(dims)
  
  return(list(grid_coords, dimension_coords))
  
}
