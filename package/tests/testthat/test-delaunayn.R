context("compGeometeR")

test_that("delaunayn should return an error when the the input has NAs", {

  ps <- as.matrix(rbind(data.frame(a=0, b=0, d=0),
                        merge(merge(data.frame(a=c(-1, 1)),
                                    data.frame(b=c(-1, 1))),
                              data.frame(d=c(-1, 1)))))
 
  
  ps <- rbind(ps, NA)
  expect_error(delaunay(point=ps))
  
})


test_that("A square is triangulated", {
  ## This doesn't work if the Qz option isn't supplied
  square <- rbind(c(0, 0), c(0, 1), c(1, 0), c(1, 1))

  triangulation <- delaunay(square)

  expect_equal(triangulation$input_points, square)
  expect_equal(triangulation$simplices, rbind(c(4, 2, 1), c(3, 4, 1)))
  expect_equal(triangulation$simplex_neighs[[1]], 2)
  expect_equal(triangulation$simplex_neighs[[2]], 1)

  expect_error(delaunay(square, ""))
})
