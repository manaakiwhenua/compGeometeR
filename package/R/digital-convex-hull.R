#' @title Digital convex hull
#' 
#' @description  This function calculates the digital 
#' \href{https://en.wikipedia.org/wiki/Convex_hull}{convex hull} around a set of
#' \eqn{n} points in \eqn{d}-dimensional space based upon a grid of 
#' \eqn{d}-dimensional coordinates.
#'
#' @param points a \eqn{n}-by-\eqn{d} dataframe or matrix. The rows
#'   represent \eqn{n} points and the \eqn{d} columns the coordinates in 
#'   \eqn{d}-dimensional space.
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
#'   \item A \eqn{d}-dimensional array containing 1 if a grid coordinate lies 
#'   within the hull and 0 if it lies outside the hull (if any of the test point 
#'   coordinates contain NA then the output is 0).
#'   \item A list of length \code{d} that contains the grid coordinates along 
#'   each dimension.
#' }
#'
#' @examples
#' # Define points
#' x <- c(30, 70, 20, 50, 40, 70)
#' y <- c(35, 80, 70, 50, 60, 20)
#' p <- data.frame(x, y)
#' # Create digital convex hull
#' d_ch <- digital_convex_hull(points = p, mins=c(15,15), maxs=c(85,85), spacings=c(0.5,0.5))
#' # Unpack the digital convex hull components
#' d_ch_array <- d_ch[[1]]
#' x_coords <- d_ch[[2]][[1]]
#' y_coords <- d_ch[[2]][[2]]
#' # Plot the digital convex hull
#' image(x=x_coords, y=y_coords, z=d_ch_array, xlab="x", ylab="y")
#' points(p, pch = as.character(seq(nrow(p))))
#' 
#' @export
digital_convex_hull <- function(points=NULL, mins, maxs, spacings) {

  # Create the discrete convex hull
  ch <- convex_hull(points=p)
  # Generate a grid of coordinates
  grid <- grid_coordinates(mins, maxs, spacings)
  # Check which grid coordinates are in the convex hull
  m <- in_convex_hull(ch, grid[[1]])
  # Get the grid length of each dimension
  dim_n <- c()
  for (dim in grid[[2]]) {
    dim_n <- c(dim_n, length(dim))
  }
  # Create an array of the results
  ch_array <- array(m, dim=dim_n)
  
  return(list(ch_array, grid[[2]]))
  
}
