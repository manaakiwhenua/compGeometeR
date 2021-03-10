#' @title Grid Coordinates
#' 
#' @description This function creates a \code{d}-dimensional grid of coordinates 
#' systematically spaced throughout the specified spatial extent.
#'
#' @param mins Vector of length \code{d} listing the grid coordinate minimum for 
#' each dimension.
#' @param maxs Vector of length \code{d} listing the grid coordinate maximum for 
#' each dimension.
#' @param spacings Vector of length \code{d} listing the grid coordinate spacing 
#' for each dimension.
#'
#' @return A list of two objects:
#' 
#' \itemize{
#'   \item A dataframe with \code{d} columns and a row for each grid coordinate 
#'   - so potentially lots of rows!
#'   \item A list of length \code{d} that contains the grid coordinates along 
#'   each dimension.
#' }
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
