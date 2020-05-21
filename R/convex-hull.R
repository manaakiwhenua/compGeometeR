#' @title Convex hull
#' 
#' @description  This function calculates the 
#' \href{https://en.wikipedia.org/wiki/Convex_hull}{convex hull} around a set of
#' \eqn{n} points in \eqn{d}-dimensional space using the
#' \href{http://www.qhull.org}{Qhull} library.
#'
#' @param points a \eqn{n}-by-\eqn{d} dataframe or matrix. The rows
#'   represent \eqn{n} points and the \eqn{d} columns the coordinates in 
#'   \eqn{d}-dimensional space.
#'   
#' @return Returns a list consisting of:
#' 
#' \itemize{
#'   \item \code{input_points}: the input points used to create the convex hull.
#'   \item \code{hull_simplices}: a \eqn{s}-by-\eqn{d} matrix of point indices 
#'   that define the \eqn{s} \href{https://en.wikipedia.org/wiki/Simplex}{simplices} 
#'   that make up the convex hull.
#'   \item \code{hull_indicies}: a vector of the point indicies that form the 
#'   convex hull.
#'   \item \code{hull_verticies}: a matrix of point coordinates that form the 
#'   convex hull.
#' }
#' 
#' @seealso \code{\link{convex_layer}}
#' 
#' @references Barber CB, Dobkin DP, Huhdanpaa H (1996) The Quickhull algorithm 
#' for convex hulls. ACM Transactions on Mathematical Software, 22(4):469-83 
#' \url{https://doi.org/10.1145/235815.235821}.
#' 
#' @examples
#' # Define points
#' x <- c(30, 70, 20, 50, 40, 70)
#' y <- c(35, 80, 70, 50, 60, 20)
#' p <- data.frame(x, y)
#' # Create convex hull and plot
#' ch <- convex_hull(points=p)
#' plot(p, pch = as.character(seq(nrow(p))))
#' for (s in seq(nrow(ch$hull_simplices))) {
#'   lines(ch$input_points[ch$hull_simplices[s, ], ], col = "red")
#' }
#' 
#' @export
  convex_hull <- function(points=NULL) {
    
  	# Check directory writable
  	tmpdir <- tempdir()
  	# R should guarantee the tmpdir is writable, but check in any case
  	if (file.access(tmpdir, 2) == -1) {
  		stop(paste("Unable to write to R temporary directory", tmpdir, "\n"))
  	}
  	
    # Coerce the input to be matrix
    if(is.null(points)){
      stop(paste("points must be an n-by-d dataframe or matrix", "\n"))
    }
    if(!is.data.frame(points) & !is.matrix(points)){
      stop(paste("points must be a dataframe or matrix", "\n"))
    }
    if (is.data.frame(points)) {
      points <- as.matrix(points)
    }
    # Make sure we have real-valued input
    storage.mode(points) <- "double"
    # We need to check for NAs in the input, as these will crash the C code.
    if (any(is.na(points))) {
      stop("points should not contain any NAs")
    }
  	
  	# Specify the Qhull options: http://www.qhull.org/html/qh-optq.htm
  	options <- "Qt"
	
    # Call C function to create the convex hull
  	ch <- .Call("C_convex", points, options, tmpdir, PACKAGE="alphashape")
  	# Re-index from C numbering to R numbering
  	ch$convex_hull[is.na(ch$convex_hull)] <- 0
  	simplices <- as.data.frame(ch$convex_hull + 1)
  	
  	# Create list to return the desired convex hull information
  	convex <- list()
  	convex$input_points <- points
  	convex$hull_simplices <- as.matrix(simplices)
  	convex$hull_indices <- unique(c(as.integer(ch$convex_hull + 1)))
  	convex$hull_verticies <- points[convex$hull_indices,]
  
  	return(convex)
  }
 
