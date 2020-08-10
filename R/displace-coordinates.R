#' @title Displace coordinates
#' 
#' @description  This function displaces each point coordinate within an 
#'   \href{https://en.wikipedia.org/wiki/Ball_(mathematics)}{eqn{n}-ball} of 
#'   specified radius.
#' 
#' @param points a \eqn{n}-by-\eqn{d} dataframe or matrix. The rows
#'   represent \eqn{n} points and the \eqn{d} columns the coordinates in 
#'   \eqn{d}-dimensional space.
#' @param radii a vector of real numbers that defines the radius of the 
#'   {eqn{n}-ball} within which each point will be displaced.
#' 
#' @return Returns a \eqn{n}-by-\eqn{d} dataframe of coordinates that have been 
#'   displaced based on the specified radii.
#' 
#' @examples 
#' # Define points
#' x <- c(30, 70, 20, 50, 40, 70)
#' y <- c(35, 80, 70, 50, 60, 20)
#' p <- data.frame(x, y)
#' # Define uncertainty radii
#' r <- c(2, 7, 5, 12, 0, 15)
#' # Plot points with uncertainty radii
#' plot(p, pch=16, asp=1)
#' symbols(x=p[,1], y=p[,2], circles = p[,3], fg="blue", inches = FALSE, add = TRUE)
#' # Generate and plot some other possible locations
#' for (i in seq(10)) {
#'   u_boot = displace_coordinates(points = p, radii = r)
#'   points(u_boot, pch=16, col="red", cex=0.5)
#' }
#' 
#' @export
displace_coordinates <- function(points=NULL, radii) {

  n <- nrow(points)
  d <- ncol(points)
  
  if (d == 2) { # Efficient sampling
    r <- runif(n, min = 0, max = radii)
    angle <- runif(n, min = 0, max = 2 * pi)
    points[, 1] <- points[, 1] + r * cos(angle)
    points[, 2] <- points[, 2] + r * sin(angle)
  } else { # Naive sampling with rejection
    i = 1
    while (i <= n) {
      random_offsets <- runif(d, min = -radii[i], max = radii[i])
      random_radii <- sqrt(sum(random_offsets ^ 2))
      if (random_radii <= radii[i]) {
        points[i,] = points[i,] + random_offsets
        i = i + 1
      }
    }
  }
  
  return(points)
  
}
