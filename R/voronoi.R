#' @title Voronoi diagram
#' 
#' @description  This function calculates the 
#' \href{https://en.wikipedia.org/wiki/Voronoi_diagram}{Voronoi digram} of a set
#' of \eqn{n} points in \eqn{d}-dimensional space using the
#' \href{http://www.qhull.org}{Qhull} library.
#' 
#' @param points a \eqn{n}-by-\eqn{d} dataframe or matrix. The rows
#'   represent \eqn{n} points and the \eqn{d} columns the coordinates in 
#'   \eqn{d}-dimensional space.
#' @param delaunay a boolean indicating if the Delaunay triangulation, which is 
#'   the dual of the Voronoi diagram should also be returned, defaults to 
#'   \code{FALSE}.
#' 
#' @return Returns a list consisting of:
#' 
#' \itemize{
#'   \item \code{input_points}: the input points used to create the Voronoi 
#'   diagram.
#'   \item \code{voronoi_vertices}: a \eqn{i}-by-\eqn{d} matrix of point 
#'   coordinates that define the verticies that make each Voronoi region \eqn{v}.
#'   \item \code{voronoi_regions}: a list of length \eqn{p} that for each input 
#'   point contains indicies for the Voronoi vertices that define the Voronoi 
#'   region \eqn{v} for each input point - if the indicies include zeros then 
#'   the Voronoi region is infinite.
#' }
#' 
#' Additionally, if \code{delaunay = TRUE} the returned list also inclues:
#' 
#' \itemize{
#'   \item \code{simplices}: a \eqn{s}-by-\eqn{d+1} matrix of point indices 
#'   that define the \eqn{s} \href{https://en.wikipedia.org/wiki/Simplex}{simplices} 
#'   that make up the Delaunay triangulation.
#'   \item \code{circumradii}: for each simplex the radius of the associated 
#'   \href{https://en.wikipedia.org/wiki/Circumscribed_circle}{circumcircle} 
#'   (note: the \code{voronoi_vertices} are equivalent to the the centres of the 
#'   circumcircles).
#'   \item \code{simplex_neighs}: a list containing for each simplex the 
#'   neighbouring simplices.
#' }
#' 
#' @seealso \code{\link{delaunay}}
#' 
#' @references Barber CB, Dobkin DP, Huhdanpaa H (1996) The Quickhull algorithm 
#' for convex hulls. ACM Transactions on Mathematical Software, 22(4):469-83 
#' \url{https://doi.org/10.1145/235815.235821}.
#' 
#' @examples 
#' # Define points
#' x <- c(30, 70, 20, 50, 40, 70, 20, 55, 30)
#' y <- c(35, 80, 70, 50, 60, 20, 20, 55, 65)
#' p <- data.frame(x, y)
#' # Create Voronoi diagram and plot
#' vd <- voronoi(points = p)
#' cols = c("red", "blue", "green", "darkgrey", "purple", "lightseagreen",
#'          "brown", "darkgreen", "orange")
#' plot(vd$input_points, pch = as.character(seq(nrow(p))), col=cols,
#'      xlim=c(0,100), ylim=c(0,100))
#' text(vd$voronoi_vertices[,1], vd$voronoi_vertices[,2], 
#'      labels = as.character(seq(nrow(vd$voronoi_vertices))))
#' r = 0
#' for (vd_region in vd$voronoi_regions) {
#'   r = r + 1
#'   if (!0 %in% vd_region) {
#'     polygon(vd$voronoi_vertices[vd_region,], density=20, col = cols[r])
#'   }
#' }
#' 
#' @export
voronoi <- function(points=NULL, delaunay=FALSE) {
	
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
    # Extract voronoi regions relating to an input point and put in point order
    point_regions <- vd$point_regions
    voronoi_regions <- vd$voronoi_regions
    point_regions_data = point_regions[unlist(point_regions != -1)]
    voronoi_regions_data = voronoi_regions[unlist(point_regions != -1)]
    voronoi_regions_ordered = voronoi_regions_data[order(point_regions_data)]
    # Determine Vonoi neighbours via Delaunay triangulation
    tri_sorted <- t(apply(tri, 1, sort))
    all_edges <- rbind(tri_sorted[,1:2], tri_sorted[,2:3], tri_sorted[,c(1,3)])
    edges_ID <- paste(all_edges[,1], all_edges[,2], sep="_")
    voronoi_neighs <- all_edges[!duplicated(edges_ID),]      
    
    # Create list to return the desired Voronoi diagram information
    voronoi <- list()
    voronoi$input_points <- points
    voronoi$voronoi_vertices <- vd$voronoi_vertices
    voronoi$voronoi_regions <- voronoi_regions_ordered    

    # Return Delaunay triangulation information too if wanted
    if (delaunay == TRUE) {
	    voronoi$simplices <- tri
	    voronoi$circumradii <- vd$circumRadii
      for (s in seq(nrow(tri))) {
          voronoi$simplex_neighs[[s]] <- vd$neighbours[[s]][vd$neighbours[[s]] > 0]
      }
	  }
  	return(voronoi)
  }
