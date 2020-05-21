#' @title Convex layer
#' 
#' @description  This function calculates a 
#' \href{https://en.wikipedia.org/wiki/Convex_layers}{convex layer} of specified 
#' depth from a set of \eqn{n} points in \eqn{d}-dimensional space using the
#' \href{http://www.qhull.org}{Qhull} library.
#'
#' @param points a \eqn{n}-by-\eqn{d} dataframe or matrix. The rows
#'   represent \eqn{n} points and the \eqn{d} columns the coordinates in 
#'   \eqn{d}-dimensional space.
#' @param layer an integer that specifies the desired convex layer.  If left 
#'   unspecified convex layer 1 is returned that is equivalent to the convex 
#'   hull.
#'   
#' @return Returns a list consisting of:
#' 
#' \itemize{
#'   \item \code{input_points}: the input points used to create the convex layer.
#'   \item \code{hull_simplices}: a \eqn{s}-by-\eqn{d} matrix of point indices 
#'   that define the \eqn{s} \href{https://en.wikipedia.org/wiki/Simplex}{simplices} 
#'   that make up the convex layer.
#'   \item \code{hull_indicies}: a vector of the point indicies that form the 
#'   convex layer.
#'   \item \code{hull_verticies}: a matrix of point coordinates that form the 
#'   convex layer.
#' }
#'
#' @seealso \code{\link{convex_hull}}
#' 
#' @references Barber CB, Dobkin DP, Huhdanpaa H (1996) The Quickhull algorithm 
#' for convex hulls. ACM Transactions on Mathematical Software, 22(4):469-83 
#' \url{https://doi.org/10.1145/235815.235821}.
#' 
#' @examples
#' # Create some random example data
#' set.seed(1) # to reproduce figure exactly
#' x = 20 + rgamma(n = 100, shape = 3, scale = 2)
#' y = rnorm(n = 100, mean = 280, sd = 30)
#' p <- data.frame(x, y)
#' plot(p)
#' cols <- c("red", "blue", "orange", "lightseagreen", "purple")
#' for (i in seq(5)) {
#'   cl <- convex_layer(points = p, layer = i)
#'   for (s in seq(nrow(cl$hull_simplices))) {
#'     lines(cl$input_points[cl$hull_simplices[s, ], ], col = cols[i], lwd = 2)
#'   }
#' }
#' legend("topright", legend = seq(5), lwd = 2, col = cols, bty = "n",
#'        title = "Convex layers")
#' 
#' @export
  convex_layer <- function(points = NULL, layer = 1) {
    
    # Iteratively create convex hull and remove points to specified convex layer
  	for (i in seq(layer)) {
      if (i == 1) {
        ch <- convex_hull(points)
        if (i == layer) {
          return(ch)
      	} else {
      	  next_points <- points[-ch$hull_indices,]
      	}
      } else {
        ch <- convex_hull(next_points)
        if (i == layer) {
      	  return(ch)
      	} else {
      	  next_points <- next_points[-ch$hull_indices,]
      	}
      }
    }
  }
 
