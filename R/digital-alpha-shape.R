#' @title Digital alpha shape
#' 
#' @description  This function calculates the digital 
#' \href{https://en.wikipedia.org/wiki/Alpha_shape}{alpha shape}
#' of a set of \eqn{n} points in \eqn{d}-dimensional space based upon a grid of 
#' \eqn{d}-dimensional coordinates.
#'
#' @param points a \eqn{n}-by-\eqn{d} dataframe or matrix. The rows
#'   represent \eqn{n} points and the \eqn{d} columns the coordinates in 
#'   \eqn{d}-dimensional space.
#' @param alpha a real number between zero and infinity that defines the maximum 
#'   circumradii for a simplex to be included in the alpha shape  If 
#'   unspecified \code{alpha} defaults to infinity and the alpha shape is 
#'   equivalent to a Delaunay triangulation.
#' @param mins Vector of length \code{d} listing the grid coordinate minimum for 
#' each dimension.
#' @param maxs Vector of length \code{d} listing the grid coordinate maximum for 
#' each dimension.
#' @param spacings Vector of length \code{d} listing the grid coordinate spacing 
#' for each dimension.
#' 
#' @return A list of three objects:
#' 
#' \itemize{
#'   \item A \eqn{d}-dimensional array containing 1 if a grid coordinate lies 
#'   inside the alpha shape and 0 if it lies outside (if any of the test point 
#'   coordinates contain NA then the output is 0).
#'   \item A dataframe with \code{d} columns and a row for each grid coordinate 
#'   - so potentially lots of rows!
#'   \item A list of length \code{d} that contains the grid coordinates along 
#'   each dimension.
#' }
#'
#' @examples
#' # Define points
#' x <- c(30, 70, 20, 50, 40, 70)
#' y <- c(35, 80, 70, 50, 60, 20)
#' p <- data.frame(x, y)
#' # Create digital alpha complex and plot
#' d_as <- digital_alpha_shape(points = p, alpha = 20, mins=c(15,15), maxs=c(85,85), spacings=c(0.5,0.5))
#' image(x=d_as[[3]][[1]], y=d_as[[3]][[2]], z=d_as[[1]], xlab="x", ylab="y")
#' points(p, pch = as.character(seq(nrow(p))))
#' 
#' @export
digital_alpha_shape <- function(points=NULL, alpha=Inf, mins, maxs, spacings) {

  # Create the discrete alpha complex
  ac <- alpha_complex(points = p, alpha = alpha)
  # Generate a grid of coordinates
  grid <- grid_coordinates(mins, maxs, spacings)
  # Check if the grid coordinates are in a simplex
  m <- find_simplex(ac, grid[[1]])
  m[m >= 1] <- 1
  # Get the grid length of each dimension
  dim_n <- c()
  for (dim in grid[[2]]) {
    dim_n <- c(dim_n, length(dim))
  }
  # Create an array of the results
  as_array <- array(m, dim=dim_n)
  
  return(list(as_array, cbind(grid[[1]], m), grid[[2]]))
  
}

