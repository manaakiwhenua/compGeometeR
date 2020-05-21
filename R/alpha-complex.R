#' @title Alpha complex
#' 
#' @description  This function calculates the 
#' \href{https://en.wikipedia.org/wiki/Alpha_shape#Alpha_complex}{alpha complex} 
#' of a set of \eqn{n} points in \eqn{d}-dimensional space using the
#' \href{http://www.qhull.org}{Qhull} library.
#' 
#' @param points a \eqn{n}-by-\eqn{d} dataframe or matrix. The rows
#'   represent \eqn{n} points and the \eqn{d} columns the coordinates in 
#'   \eqn{d}-dimensional space.
#' @param alpha a real number between zero and infinity that defines the maximum 
#'   circumradii for a simplex to be included in the alpha complex.  If 
#'   unspecified \code{alpha} defaults to infinity and the alpha complex is 
#'   equivalent to a Delaunay triangulation.
#' 
#' @return Returns a list consisting of:
#' 
#' \itemize{
#'   \item \code{input_points}: the input points used to create the Voronoi 
#'   diagram.
#'   \item \code{simplices}: a \eqn{s}-by-\eqn{d+1} matrix of point indices 
#'   that define the \eqn{s} \href{https://en.wikipedia.org/wiki/Simplex}{simplices} 
#'   that make up the alpha complex.
#'   \item \code{circumcentres}: a \eqn{s}-by-\eqn{d} matrix of coordinates 
#'   that define the centre of the 
#'   \href{https://en.wikipedia.org/wiki/Circumscribed_circle}{circumcircle} 
#'   associated with each simplex.
#'   \item \code{circumradii}: the radius of each circumcircle.
#' }
#' 
#' @references Barber CB, Dobkin DP, Huhdanpaa H (1996) The Quickhull algorithm 
#' for convex hulls. ACM Transactions on Mathematical Software, 22(4):469-83 
#' \url{https://doi.org/10.1145/235815.235821}.
#' 
#' Edelsbrunner H, Mücke EP (1994) Three-dimensional alpha shapes. ACM 
#' Transactions on Graphics, 13(1):43-72 
#' \url{https://dl.acm.org/doi/abs/10.1145/174462.156635}.
#' 
#' @examples 
#' # Define points
#' x <- c(30, 70, 20, 50, 40, 70)
#' y <- c(35, 80, 70, 50, 60, 20)
#' p <- data.frame(x, y)
#' # Create alpha complex and plot
#' a_complex <- alpha_complex(points = p, alpha = 20)
#' plot(p, pch = as.character(seq(nrow(p))), xlim=c(0,80), ylim=c(10,90), asp=1)
#' for (s in seq(nrow(a_complex$simplices))) {
#'   polygon(a_complex$input_points[a_complex$simplices[s,],], border="red")
#' }
#' text(a_complex$circumcentres, labels=seq(nrow(a_complex$simplices)), col="blue")
#' symbols(a_complex$circumcentres, circles = a_complex$circumradii, 
#'         inches = FALSE, add = TRUE, fg="blue", lty="dotted")
#' 
#' @export
alpha_complex <- function(points=NULL, alpha=Inf) {
	
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
    if (ncol(points) < 4) {
      options <- "Qt Qc Qz"
    } else {
      options <- "Qt Qc Qx"
    }
    options <- paste(options, collapse=" ")  

	  # Call C function to create the Voronoi diagram
  	vd <- .Call("C_voronoiR", points, options, tmpdir, PACKAGE="alphashape")
    # Re-index from C numbering to R numbering
    vd$tri[is.na(vd$tri)] <- 0
    tri <- vd$tri + 1
    
    # Create list to return the desired alpha complex information
    alpha_complex <- list()
    alpha_complex$input_points <- points
    in_alpha_complex <- vd$circumRadii <= alpha
    alpha_complex$simplices <- tri[in_alpha_complex, ]
    
    if (nrow(alpha_complex$simplices) < 1) {
	    alpha_complex$circumcentres <- NULL
	    alpha_complex$circumradii <- NULL
	    } else {
	    alpha_complex$circumcentres <- vd$voronoi_vertices[in_alpha_complex,]
	    alpha_complex$circumradii <- vd$circumRadii[in_alpha_complex]
	  }

  	return(alpha_complex)
  }
