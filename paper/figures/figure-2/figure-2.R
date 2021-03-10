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

png("figure-2.png", width = 15, height = 5, res=300, units = "cm", pointsize = 10)
par(mfrow=c(1,3), oma=c(0,0,0,0), mar=c(0.5,0.5,1.5,0.5))
cols = c("white", "slateblue", "firebrick", "lightseagreen", "purple", "darkorchid", "dodgerblue",
         "goldenrod", "grey", "deeppink", "turquoise", "yellowgreen", "yellow", "limegreen",
         "red2", "navajowhite2", "orange", "darkgrey")

# Digital convex hull
d_ch = digital_convex_hull(p, mins=c(0,5), maxs=c(15,15), spacings = c(0.05,0.05))
image(x=d_ch[[3]][[1]], y=d_ch[[3]][[2]], z=d_ch[[1]], 
      yaxt="n", xaxt="n", xlab="", ylab = "", col=c("white", "orange"))
points(p, pch=16, cex=0.75)
mtext("(a)", side = 3, line=0.25)

# Digital alpha complex
d_ac = digital_alpha_complex(p, alpha = 2, mins=c(0,5), maxs=c(15,15), spacings = c(0.05,0.05))
image(x=d_ac[[3]][[1]], y=d_ac[[3]][[2]], z=d_ac[[1]]+1, 
      yaxt="n", xaxt="n", xlab="", ylab = "", col=cols)
points(p, pch=16, cex=0.75)
mtext("(b)", side = 3, line=0.25)

# Digital alpha shape
d_as = digital_alpha_shape(p, alpha = 2, mins=c(0,5), maxs=c(15,15), spacings = c(0.05,0.05))
image(x=d_as[[3]][[1]], y=d_as[[3]][[2]], z=d_as[[1]], 
      yaxt="n", xaxt="n", xlab="", ylab = "", col=c("white", "orange"))
points(p, pch=16, cex=0.75)
mtext("(c)", side = 3, line=0.25)


dev.off()

# ------------------------------------------------------------------------------