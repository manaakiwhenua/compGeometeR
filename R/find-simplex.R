#' @title Find simplex
#' 
#' @description Returns the simplices of a Delaunay triangulation or alpha 
#' complex that contain the given set of test points.
#' 
#' @param simplices A Delaunay trigulation list object created by 
#' \code{\link{delaunay}} or a alpha complex list object created by 
#' \code{\link{alpha_complex}} that contain simplices.
#' @param test_points a \eqn{n}-by-\eqn{d} dataframe or matrix. The rows
#'   represent \eqn{n} points and the \eqn{d} columns the coordinates in 
#'   \eqn{d}-dimensional space. 
#' 
#' @return A \eqn{n} length vector containing the index of the simplex the test 
#' point is within, or a value of 0 if a test point is not within any of the 
#' simplices.  If any of the test point coordinates contain NA then the output 
#' is also 0.
#' 
#' @examples 
#' # Define points and create an alpha complex
#' x <- c(30, 70, 20, 50, 40, 70)
#' y <- c(35, 80, 70, 50, 60, 20)
#' p <- data.frame(x, y)
#' a_complex <- alpha_complex(points = p, alpha = 20)
#' # Check which simplex the test points belong to
#' p_test <- data.frame(c(20, 50, 60, 40), c(20, 60, 60, 50))
#' p_test_simplex <- find_simplex(simplices = a_complex, test_points = p_test)
#' plot(p, pch = as.character(seq(nrow(p))), xlim=c(0,90))
#' for (s in seq(nrow(a_complex$simplices))) {
#'   polygon(a_complex$input_points[a_complex$simplices[s,],], border="red")
#'   text(x=colMeans(a_complex$input_points[a_complex$simplices[s,],])[1],
#'        y=colMeans(a_complex$input_points[a_complex$simplices[s,],])[2],
#'        labels=s, col="red")
#' }
#' points(p_test[,1], p_test[,2], pch=c("1", "2", "3", "4"), col="blue")
#' legend("topright", legend = c("input points", "simplices", "test points"), 
#'        text.col=c("black", "red", "blue"), title = "Indices for:", bty="n")
#' print(p_test_simplex)
#'
#' @export
find_simplex <- function(simplices, test_points) {
  
  # Coerce the input to be a data frame
  if(is.null(test_points)){
    stop(paste("test_points must be an n-by-d dataframe or matrix", "\n"))
  }
  if(!is.data.frame(test_points) & !is.matrix(test_points)){
    stop(paste("test_points must be a dataframe or matrix", "\n"))
  }
  if (is.matrix(test_points)) {
    test_points <- as.data.frame(test_points)
  }
  
  # Check dimensions of inputs match
  dim <- ncol(test_points)
  if(dim != ncol(simplices$input_points)){
    stop(paste("test_points must have the same dimensions as simplices", "\n"))
  }  
  
  # As a first screen reduce test points to those in the convex hull
  hull <- convex_hull(points = simplices$input_points)
  inHull <- in_convex_hull(hull, test_points)
  inHull_test_point_indices <- which(inHull == TRUE)
  inHull_test <- as.matrix(test_points[inHull_test_point_indices,])

  # Create an empty object to hold which simplex the test points are in
  test_points_simplex <- rep(0, nrow(test_points))
  # For each simplex
  for(simplex in c(1:nrow(simplices$simplices))) {
    
    # Get the coordinates of the points that make the simplex
    simplex_indices <- simplices$simplices[simplex, ]
    simplex_coordinates <- simplices$input_points[simplex_indices, ]
    
    # Calculate the minimum and maxium simplex coordinate in all dimensions
    mins = apply(simplex_coordinates, MARGIN=2, FUN=min)
    maxs = apply(simplex_coordinates, MARGIN=2, FUN=max)
    # As a second screen reduce test points to those within the extent of the simplex
    for (d in seq(dim)) {
      if (d == 1) {
        to_test = inHull_test[(inHull_test[,d] >= mins[d] & inHull_test[,d] <= maxs[d]), , drop = FALSE]
      } else {
        to_test = to_test[(to_test[,d] >= mins[d] & to_test[,d] <= maxs[d]), , drop = FALSE]
      }
    }
    
    n = nrow(to_test)
    if (n > 0) {
      # Calculate the barycentric coordinates of the test points for the simplex
      X1 <- simplex_coordinates[1:dim,] - (matrix(1,dim,1) %*% simplex_coordinates[dim+1,,drop=FALSE])
      barycentric_coords <- (to_test - matrix(simplex_coordinates[dim+1,], n, dim, byrow=TRUE)) %*% solve(X1)
      barycentric_coords <- cbind(barycentric_coords, 1 - apply(barycentric_coords, 1, sum))
      
      # Those test points for which are coords are positive are in the simplex
      barycentric_sign <- sign(barycentric_coords)
      barycentric_sign_sum <- rowSums(barycentric_sign)
      in_simplex = which(barycentric_sign_sum == d + 1)
      test_points_simplex[as.numeric(row.names(to_test[in_simplex, , drop=FALSE]))] = simplex
    }
  }
  
  return(test_points_simplex)
  
}
