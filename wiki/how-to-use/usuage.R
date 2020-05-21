# --------------------------------------------------------------

# R version 3.5.3 (2019-03-11) -- "Great Truth"
# Platform: x86_64-w64-mingw32/x64 (64-bit)

library(alphashape) # version 1.0


# --------------------------------------------------------------

# Create coordinates across niche space
x = c(30,70,20,50,40,70)
y = c(35,80,70,50,60,20)
p =data.frame(x,y)
                         

# get convex hull
convex =convex(point=p)
