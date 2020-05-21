#' @title Find simplex
#' 
#' @description Returns the simplicies of a Delaunay triangulation or alpha 
#' complex that contain the given set of test points.
#' 
#' @param simplicies A Delaunay trigulation list object created by 
#' \code{\link{delaunay}} or a alpha complex list object created by 
#' \code{\link{alpha_complex}} that contain simplicies.
#' @param test_points a \eqn{n}-by-\eqn{d} dataframe or matrix. The rows
#'   represent \eqn{n} points and the \eqn{d} columns the coordinates in 
#'   \eqn{d}-dimensional space. 
#' 
#' @return A \eqn{n} length vector containing the index of the simplex the test 
#' point is within, or a value of NA if a test point is not within any of the 
#' simplicies.
#' 
#' @examples 
#' # Define points and create a Delaunay triangulation
#' x <- c(30, 70, 20, 50, 40, 70)
#' y <- c(35, 80, 70, 50, 60, 20)
#' p <- data.frame(x, y)
#' a_complex <- alpha_complex(points = p, alpha = 20)
#' # Check which simplex the test points belong to
#' p_test <- data.frame(c(20, 50, 60, 40), c(20, 60, 60, 50))
#' p_test_simplex <- find_simplex(simplicies = a_complex, test_points = p_test)
#' plot(p, pch = as.character(seq(nrow(p))), xlim=c(0,90))
#' for (s in seq(nrow(a_complex$simplices))) {
#'   polygon(a_complex$input_points[a_complex$simplices[s,],], border="red")
#'   text(x=colMeans(a_complex$input_points[a_complex$simplices[s,],])[1],
#'        y=colMeans(a_complex$input_points[a_complex$simplices[s,],])[2],
#'        labels=s, col="red")
#' }
#' points(p_test[,1], p_test[,2], pch=c("1", "2", "3", "4"), col="blue")
#' legend("topright", legend = c("input points", "simplicies", "test points"), 
#'        text.col=c("black", "red", "blue"), title = "Indicies for:", bty="n")
#' print(p_test_simplex)
#'
#' @export
find_simplex <- function(simplicies, test_points) {
  
  # Coerce the input to be matrix
  if(is.null(test_points)){
    stop(paste("points must be an n-by-d dataframe or matrix", "\n"))
  }
  if(!is.data.frame(test_points) & !is.matrix(test_points)){
    stop(paste("points must be a dataframe or matrix", "\n"))
  }
  if (is.data.frame(test_points)) {
    test_points <- as.matrix(test_points)
  }

  # Identify the simplicies that test point belongs 
  # First check if the point lies in the convex hull
  hull <- convex_hull(points = simplicies$input_points)
  inHull <- in_convex_hull(hull, test_points)
  
  # Create an empty object to hold which simplex the test points are in
  test_points_simplex <- NULL
  
  # For each test point that is within the convex hull
  for (p in c(1:nrow(test_points))) {
    if (inHull[p] == TRUE) {
      
      # Loop over the simplicies
      for(s in c(1:nrow(simplicies$simplices))) {
        
        # Get the coordinates of the points that make the simplex
        simplex_indicies <- simplicies$simplices[s, ]
        simplex_coordinates <- simplicies$input_points[simplex_indicies, ]

        # Get the barycentric coordinate of the test point for the simplex
        tp = rbind(c(test_points[p,]))
        test_barycentric <- barycentric_coordinate(simplex_coordinates, tp)
        
        # The point is inside the triangle all of the barycentric coordinates 
        # are positive
        check_sign <- sign(test_barycentric[1, ])
        if (length(which(check_sign == -1)) == 0) {
          test_points_simplex[p] <- s
          break    # the test point is inside this simplex so stop searching
        } else {
          test_points_simplex[p] = NA # test point is not in a simplex
        }
      }
      
    } else {
      test_points_simplex[p] = NA # test point is not in a simplex
    }
  }
  return (test_points_simplex)
  #return(.Call("C_findSimplex", hull$convexhull, test_points, PACKAGE="alphashape"))
}

# Internal function used by \code{\link{find_simplex}} to calculate the 
# barycentric coordinate of a point in relation to a simplex
barycentric_coordinate <- function(X, P) {
  M <- nrow(P)
  N <- ncol(P)
  if (ncol(X) != N) {
    stop("Simplex X must have same number of columns as point matrix P")
  }
  if (nrow(X) != (N+1)) {
    stop("Simplex X must have N columns and N+1 rows")
  }
  X1 <- X[1:N,] - (matrix(1,N,1) %*% X[N+1,,drop=FALSE])
  if (rcond(X1) < .Machine$double.eps) {
    warning("Degenerate simplex")
    return(NULL)
  }
  Beta <- (P - matrix(X[N+1,], M, N, byrow=TRUE)) %*% solve(X1)
  Beta <- cbind(Beta, 1 - apply(Beta, 1, sum))
  return(Beta)
}
