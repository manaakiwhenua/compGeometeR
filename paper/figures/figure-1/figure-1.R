#-------------------------------------------------------------------------------

# R version 3.5.3 (2019-03-11) -- "Great Truth"
# Platform: x86_64-w64-mingw32/x64 (64-bit)

library(compGeometeR) # version 1.0

#-------------------------------------------------------------------------------

set.seed(2) # to reproduce figure exactly
x = rgamma(n = 20, shape = 3, scale = 2)
y = rnorm(n = 20, mean = 10, sd = 2)
p = cbind(x, y)

#-------------------------------------------------------------------------------

png("figure-1.png", width = 10, height = 10, res=300, units = "cm", pointsize = 10)
par(mfrow=c(2,2), oma=c(0,0,0,0), mar=c(0.5,0.5,1.5,0.5))

# Convex hull
plot(x, y, yaxt="n", xaxt="n", xlab="", ylab = "", pch=16, cex=0.75)
ch = convex_hull(p)
polygon(ch$hull_vertices, col="orange", border="firebrick")
points(p, pch=16, cex=0.75)
mtext("(a)", side = 3, line=0.25)

# Convex layers
plot(x, y, yaxt="n", xaxt="n", xlab="", ylab = "", pch=16, cex=0.75)
for (i in seq(4)) {
  cl = convex_layer(p, layer = i)
  polygon(cl$hull_vertices, col="orange", border="firebrick")
}
points(p, pch=16, cex=0.75)
mtext("(b)", side = 3, line=0.25)

# Delaunay triangulation
plot(x, y, yaxt="n", xaxt="n", xlab="", ylab = "", pch=16, cex=0.75)
dt = delaunay(p)
for (s in seq(nrow(dt$simplices))) {
  polygon(dt$input_points[dt$simplices[s,],], col="orange", border="firebrick")
}
points(p, pch=16, cex=0.75)
mtext("(c)", side = 3, line=0.25)

# Alpha complex
plot(x, y, yaxt="n", xaxt="n", xlab="", ylab = "", pch=16, cex=0.75)
ac = alpha_complex(p, alpha = 2)
for (s in seq(nrow(ac$simplices))) {
  polygon(ac$input_points[ac$simplices[s,],], col="orange", border="firebrick")
}
points(p, pch=16, cex=0.75)
mtext("(d)", side = 3, line=0.25)

dev.off()

# ------------------------------------------------------------------------------