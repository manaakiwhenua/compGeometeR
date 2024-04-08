[![manaakiwhenua-standards](https://github.com/manaakiwhenua/compGeometeR/workflows/manaakiwhenua-standards/badge.svg)](https://github.com/manaakiwhenua/manaakiwhenua-standards)

# compGeometeR

`compGeometeR` aims to implement commonly used computational geometry algorithms in `R`.  We believed that by implementing these algorithms within a single unified framework an `R` user could easily apply these algorithms in solving spatial problems in a variety of different domains, and we are building a [`compGeometeR` cookbook](https://github.com/manaakiwhenua/compGeometeR/wiki) that illustrates various use cases and provides advice for plotting and efficient computation.

You can read more about the design of `compGeometeR`, what algorithms are available, and some simple examples of use in the [`compGeometeR` preprint](https://osf.io/b4zvr/) software paper.

## Installation

You can install `compGeometeR` from GitHub using the `devtools` package.

Install `devtools` from CRAN:

```r
install.packages("devtools")
```
Install the master branch of `compGeometeR` from GitHub:

```r
devtools::install_github("https://github.com/manaakiwhenua/compGeometeR", subdir = "package")
```

Install a different branch of `compGeometeR` from GitHub:

```r
devtools::install_github("https://github.com/manaakiwhenua/compGeometeR", subdir = "package", ref = "<your_branch_name>")
```

Please note that `devtools` may require you to install `RTools`, and to install `compGeometeR` from GitHub may require you to install `Git`.

## Dependencies

`compGeometeR` has no package dependencies and was developed using `R` version 3.5.1.

## Citation

If you make use of `compGeometeR`, we would really appreciate it if you could cite the [`compGeometeR` preprint](https://osf.io/b4zvr/) software paper:

Etherington TR, Omondiagbe OP (2021) compGeometeR: an R package for computational geometry. OSF Preprints, doi:[10.31219/osf.io/b4zvr](https://doi.org/10.31219/osf.io/b4zvr).

However, as `compGeometeR` is built upon and is dependant on the [Qhull library](http://www.qhull.org/) that has also been published:

Barber CB, Dobkin DP, Huhdanpaa H (1996) The Quickhull algorithm for convex hulls. ACM Transactions on Mathematical Software 22: 469-483, doi:[10.1145/235815.235821](https://dl.acm.org/doi/10.1145/235815.235821).

we think it is only fair that this work is cited too, so we would suggest including a statement such as the following in any published work:

"[we did some computational geometry analysis ...] using the R package `compGeometeR` (Barber *et al*. 1996, Etherington and Omondiagbe 2021)"

## Community Guidelines

To report bugs or request extra functionality please use log an [issue](https://github.com/manaakiwhenua/compGeometeR/issues) to get in touch.

We would also welcome contributions to `compGeometeR` from people who would like to join the development team.  We would ask that you first open an [issue](https://github.com/manaakiwhenua/compGeometeR/issues) to suggest an enhancement to be sure it is within scope of the project before forking the repository and issuing a pull request.

Our intention is that as people help to refine, fix, or add functionality to `compGeometeR` we will include these people as co-authors on the project, and will release a new version of the software paper preprint that includes these people as co-authors so that they too can get credit for their efforts.

## Local Development

This software was developed using `R` and `C` Language. If you fork this project and want to extend the current functionality, you can do that by extending the `R` code the `C` code or both.

To learn about `R` development, please see [Chapter 2: The whole game](http://r-pkgs.org/whole-game.html) in the [R Packages](https://r-pkgs.org/) development book.  It gives a comprehensive explanation for `R` package development and uses the `devtools` package. Also, [Chapter 4: Package structure and state](http://r-pkgs.org/package-structure-state.html) gives a great explanation of how to structure your `R` package.

To get started with local development on Windows you will need the following software:

### Software

1. Download [perl](https://www.activestate.com/products/activeperl/downloads/)

2. Download make using the step below

  * Download make.exe from their [official site]("http://gnuwin32.sourceforge.net/packages/make.htm")
  
  * In the download session, click complete package, except sources.
  
  * Follow the installation instructions.
  
  * Once finished, add the <installation directory>/bin/ to the PATH variable.

3. Download [html tidy](http://www.paehl.com/open_source/?HTML_Tidy_for_Windows). for generating a tidy help package

4. Download R studio and use it to open the .Rproj

5. Use Eclipse, VS Code or any other C editor to update the C files as needed.

### Building and installing

There are two ways to build and install the package. This is done by using the make file or by using the `devtools` package in `R`. 
The `make` file is the easier way to rebuild and install the package, this is because it creates the documentation, builds, and installs the package using one command. To do this, please run the following command in the package root directory: 

 * `make install` (this should be run outside the project directory)

To build and install using the `R` and `devtools`, you have to make sure you that `make` is installed on your system.  Once you have follow the instruction given above to install `make`, then run the following:

 * `getwd()` to check that you're in subfolder "package" and not in folder "compGeometeR" (the parent)
 * `setwd("./package")` if you happen to be in the parent folder
 * `roxygen2::roxygenise()` to regenrate the documentation
 * `devtools::build()` to build
 * `devtools::install()` or `devtools::install(args = c("--no-multiarch"))` to install depending on your architecture

 You should then be able to load the package using:
 
 * `library(compGeometeR)`

### Reinstalling after making changes

You may find that you get permission errors on Windows when reinstalling the package on top of an existing version after making changes to the code. Trying the following might help:

 * Unload the package if it's loaded (untick the `compGeometeR` entry in the Packages tab if using RStudio)
 * Remove the package (click the Remove icon for the `compGeometeR` entry in the Packages tab if using RStudio)
 * Open the installation folder for R packages in Explorer (or in a file manager of your choice if not using Windows)
   * The error message will tell you what it is (typically something like `C:\Users\<your_user_name>\AppData\Local\R\win-library\<r_version>\`)
 * Check if the package folder is still there - you're done if it isn't, skip the next point
 * If the package folder's still hanging around:
   * Close RStudio and save the workspace
   * Delete the `compGeometeR` folder manually
   * Reopen RStudio
 * Rerun `devtools::install()`

### Generating Package PDF

To re-generate the package pdf, please run the following
 * `R CMD Rd2pdf --title='compGeometeR' -o /path-to-your-project-folder/man/*.Rd`

## Maintainer
Pascal Omondiagbe <omondiagbep@landcareresearch.co.nz>
