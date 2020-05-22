[![manaakiwhenua-standards](https://github.com/manaakiwhenua/compGeometeR/workflows/manaakiwhenua-standards/badge.svg)](https://github.com/manaakiwhenua/manaakiwhenua-standards)



# compGeometeR

CompGeometeR aims to expose the implementation of various computation geometry algorithms in R. We believed by exposing these algorithms, the R user could easily apply these algorithms in solving problems in different domains. For a start we have exposed some computation geometry implemented in the [Qhul library](http://www.qhull.org/) and implement additional algorithms using the output derived from the Qhull implemented algorithms. The following algorithm are available for use:

* Delunay: Computes the [Delaunay triangulation](https://en.wikipedia.org/wiki/Delaunay_triangulation) by computing a [convex hull](https://en.wikipedia.org/wiki/Convex_hull)

* Convex Hull : Implements the Quickhull algorithm for computing a [convex hull](https://en.wikipedia.org/wiki/Convex_hull). This is done using the [Qhull library](http://www.qhull.org/)

* In-Convex: Given a point with n-dimensional, the goal is to check which of the set of a test point are within the [convex hull](https://en.wikipedia.org/wiki/Convex_hull}{convex hull) 

* Alpha-Complex: Calculates the [alpha complex](href{https://en.wikipedia.org/wiki/Alpha_shape#Alpha_complex) of a set of point in n-dimensional using the [Qhull library](http://www.qhull.org/)

* Find simplex: Compute the simplices of a [Delaunay triangulation](https://en.wikipedia.org/wiki/Delaunay_triangulation) or [alpha complex](href{https://en.wikipedia.org/wiki/Alpha_shape#Alpha_complex) that contain the given set of test points.


* Voronoi: Computes the [voroni diagram](https://en.wikipedia.org/wiki/Voronoi_diagram) for a given set of point using [Qhull library](http://www.qhull.org/)




## Learning more

To learn more about computational geometry library/algorithms and R package development, visit the following:


*  To learn about R development, please see the chapter[Whole Game](http://r-pkgs.org/whole-game.html) in the R Packages development book. It gives a comprehensive explanation for R package development and uses the devtools package. Also, [chapeter 4](http://r-pkgs.org/package-structure-state.html) of that book gives a great explanation of how to structure your R package.

* [Qhull library](http://www.qhull.org/) for computational algorithm used


* Convex Hull: references Barber CB, Dobkin DP, Huhdanpaa H (1996) The Quickhull algorithm for convex hulls. ACM Transactions on Mathematical Software, 22(4):469-83  url:https://doi.org/10.1145/235815.235821.


* Alpha Shape: Edelsbrunner H, Mücke EP (1994) Three-dimensional alpha shapes. ACM Transactions on Graphics, 13(1):43-72             url:https://dl.acm.org/doi/abs/10.1145/174462.156635. 






## Citation



## Community Guidelines
For bugs or request to add extra functionality please use the [issue](https://github.com/manaakiwhenua/compGeometeR/issues) functionality to get in touch 


## Dependencies

`compGeometeR` dependants on `devtools` package and `R` version 3.5.1. was used for development

## Quick Examples in Ecology Domain



``` r
library(compGeometeR)


```

<img src="man/figures/README-1.png" width="100%" />




## Github Installation

```r
# Install devtools from CRAN
install.packages("devtools")
devtools::install_git("https://github.com/manaakiwhenua/compGeometeR")

``` 
    

## Local Development

This software was developed using `R` and `C` Language. If you fork this project and want to extend the current functionality, you can do that by extending the`R`code or `C` code or both. To get started you need the following software:

### Programming
1. Download [perl](https://www.activestate.com/products/activeperl/downloads/)


2. Download make using the step below


  * Download make.exe from their [official site]("http://gnuwin32.sourceforge.net/packages/make.htm")
  
  * In the download session, click complete package, except sources.
  
  * Follow the installation instructions.
  
  * Once finished, add the <installation directory>/bin/ to the PATH variable.



3. Download [html tidy](http://www.paehl.com/open_source/?HTML_Tidy_for_Windows). for generating a tidy help package


4. Download R studio and use it to open the .Rproj


5. Use Eclipse or any C editor to update the C files as needed.


### Building and Installing

There are two ways to build and install the package. This is done by using the make file or by using the `devtools` package in R. 
The `make` file is the easier way to rebuild and install the package, this is because it creates the documentation, builds, and installs the package using one command. To do this, please run the following command in the package root directory: 


1.  make install (this should be run outside the project directory)

To build and install using the R devtools, you have to make sure you `make` install on your system. Once you have follow the instruction given above to install `make`, then runn the following.

1.  roxygen2::roxygenise()  (to regenrate the documentation)
1.  devtools::build()  (to build)
2.  devtools::install or devtools::install(args = c("--no-multiarch"))  (to install depending on your architecture)

### Generating Package PDF

To re-generate the package pdf, please run the following
1. R CMD Rd2pdf --title='compGeometeR' -o /path-to-your-project-folder/man/*.Rd 





## Maintainer
Pascal Omondiagbe <omondiagbep@landcareresearch.co.nz>




