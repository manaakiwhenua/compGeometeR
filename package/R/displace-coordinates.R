#' @title Displace coordinates
#' 
#' @description  This function displaces each point coordinate within an 
#'   \href{https://en.wikipedia.org/wiki/Ball_(mathematics)}{\eqn{n}-ball} of 
#'   specified radius.
#' 
#' @param points a \eqn{n}-by-\eqn{d} dataframe or matrix. The rows
#'   represent \eqn{n} points and the \eqn{d} columns the coordinates in 
#'   \eqn{d}-dimensional space.
#' @param displace Vector of length \code{n} that defines the radius of the 
#'   {\eqn{n}-ball} within which each point will be displaced.
#' 
#' @return Returns a \eqn{n}-by-\eqn{d} dataframe of coordinates that have been 
#'   displaced.
#' 
#' @examples 
#' # Define points
#' x <- c(30, 70, 20, 50, 40, 80)
#' y <- c(35, 80, 70, 50, 60, 20)
#' p <- data.frame(x, y)
#' # Define displacement radii
#' r <- c(25, 15, 10, 22, 5, 17)
#' # Plot points with displacement radii
#' cols <- c("red", "blue", "orange", "skyblue", "green3", "hotpink")
#' plot(p, pch=16, col=cols, asp=1, xlim=c(0,100), ylim=c(0,100))
#' symbols(x=p[,1], y=p[,2], circles = r, fg=cols, inches = FALSE, add = TRUE)
#' # Generate and plot some other possible locations
#' for (i in seq(100)) {
#'  u_boot <- displace_coordinates(points = p, displace = r)
#'  points(u_boot, pch=4, col=cols, cex=0.5)
#' }
#' 
#' @importFrom stats complete.cases runif
#' @export
displace_coordinates <- function(points=NULL, displace) {

  n <- nrow(points)
  d <- ncol(points)
  
  if (d == 2) { # Efficient sampling
    r <- runif(n, min = 0, max = displace)
    angle <- runif(n, min = 0, max = 2 * pi)
    points[, 1] <- points[, 1] + r * cos(angle)
    points[, 2] <- points[, 2] + r * sin(angle)
  } else { # Naive sampling with rejection
    i = 1
    while (i <= n) {
      random_offsets <- runif(d, min = -displace[i], max = displace[i])
      random_radii <- sqrt(sum(random_offsets ^ 2))
      if (random_radii <= displace[i]) {
        points[i,] = points[i,] + random_offsets
        i = i + 1
      }
    }
  }
  
  return(points)
  
}
