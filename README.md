[![manaakiwhenua-standards](https://github.com/manaakiwhenua/compGeometeR/workflows/manaakiwhenua-standards/badge.svg)](https://github.com/manaakiwhenua/manaakiwhenua-standards)

# compGeometeR<a name="Top"/>

`compGeometeR` aims to implement commonly used computational geometry algorithms in `R`.  We believed that by implementing these algorithms within a single unified framework an `R` user could easily apply these algorithms in solving spatial problems in a variety of different domains, and we are building a [`compGeometeR` cookbook](https://github.com/manaakiwhenua/compGeometeR/wiki) that illustrates various use cases and provides advice for plotting and efficient computation.

You can read more about the design of `compGeometeR`, what algorithms are available, and some simple examples of use in the [`compGeometeR` preprint](https://osf.io/b4zvr/) software paper.

`compGeometeR` is distributed under the GNU General Public License (GPLv3).

[Dependencies](#Dependencies)

[Installation Options](#InstallOptions)

[Citation](#Citation)

[Community Guidelines](#CommunityGuide)

## Dependencies<a name="Dependencies"/>

`compGeometeR` has no package dependencies and was developed using `R` version 3.5.1.

It is built upon and depends on the [Qhull library](http://www.qhull.org/), however, and includes some `C` sources from that project.

[Back to Top](#Top)

## Installation Options<a name="InstallOptions"/>

`compGeometeR` is currently verified to build, install and run on Windows. Depending on what you intend to use the package for, you may need different levels of control over how - and how often - you build, rebuild and install the package.

`compGeometeR` is not available on CRAN. You'll need to choose one of the options below in order to use it.

[Installing the package tarball from inside `RStudio` or `R`](#FromTarball)

[Installing the package from the GitHub repository inside `RStudio` or `R`](#FromGitHub)

[Checking and building the package locally in `RStudio` or `R`](#LocalBuild)

[Reinstalling a local build from `RStudio` or `R` after making changes](#ReinstallLocal)

### Installing the package tarball from inside `RStudio` or `R`<a name="FromTarball"/>

Choose this option if you want to simply use the `R` functions from the package, or if any code that you add to it is also in `R` and you have an up-to-date tarball to install from.

 * Clone the repository from https://github.com/manaakiwhenua/compGeometeR if you haven't done that already
 
 * Open the `compGeometeR` project folder
 
 * Check that it contains a file called `compGeometeR_<version>.tar.gz`, where `<version>` is the current release number
 
 * Open `compGeometeR.Rproj` in `RStudio`, or start `R` in that folder
 
 * Verify your working directory on the `R` console using `getwd()`
 
   * Set your working directory to `compGeometeR` using `setwd("<path to parent folder>/compGeometeR")` if you're in the wrong place
   
 * Build and install the source package:
   ```r
   install.packages("compGeometeR_<version>.tar.gz", repos = NULL, type = "source")
   ``` 
   where `<version>` is again the current release number
 
You should be able to verify that the installation succeeded by loading the package using `library(compGeometeR)`.

[Installation Options](#InstallOptions)

[Back to Top](#Top)

### Installing the package from the GitHub repository inside `RStudio`  or `R`<a name="FromGitHub"/>

Choose this option if you want to use the most recent, in-development version of the package, or if you want to build and install a version that comes from a git branch other than the main one.

 * Open `RStudio` or start `R`
 
 * Install `devtools` if you haven't done that already:
 
   * Inside `RStudio`:
     Tools -> Install Packages... -> select `devtools` package
     
   * From the `R` console:
     ```r
     install.packages("devtools")
     ```
 
 * Load `devtools` if it's not in the workspace from a previous session:
   
   * Inside `RStudio`:
     Packages tab -> find `devtools` in the list of packages -> tick box next to package name
     
   * From the `R` console:
     ```r
     library(devtools)
     ```
 
 * To install the master branch from GitHub:
   ```r
   devtools::install_github("https://github.com/manaakiwhenua/compGeometeR", subdir = "package")
   ```

 * To install a different branch of `compGeometeR` from GitHub:
   ```r
   devtools::install_github("https://github.com/manaakiwhenua/compGeometeR", subdir = "package", ref = "<your branch name>")
   ```
   where `<your branch name>` is the git branch that you want to check out from the repository.

As with installing from the tarball, you'll be able to verify that the installation succeeded by calling `library(compGeometeR)` to load it.

[Installation Options](#InstallOptions)

[Back to Top](#Top)

### Checking and building the package locally in `RStudio` or `R`<a name="LocalBuild"/>

Choose this option if you think you'll be making changes to any part of the `C` code. You'll end up with a new source package tarball that replaces the one you got from the git repository.

 * Clone the repository from https://github.com/manaakiwhenua/compGeometeR if you haven't done that already
 
 * Switch to the branch you want to be on if it's not `master`
 
 * Open `compGeometeR.Rproj` in `RStudio`, or start `R` in folder `compGeometeR`
 
 * Install `devtools` if you haven't done that already:
 
   * Inside `RStudio`:
     Tools -> Install Packages... -> select `devtools` package
     
   * From the `R` console:
     ```r
     install.packages("devtools")
     ```
 
 * Load `devtools` if it's not in the workspace from a previous session:
   
   * Inside `RStudio`:
     Packages tab -> find `devtools` in the list of packages -> tick box next to package name
     
   * From the `R` console:
     ```r
     library(devtools)
     ```
 
 * Verify your working directory on the `R` console using `getwd()`

 * Set the working directory to the `package` folder using `setwd("./package")`
 
 * Check if the package is in a state where it can be build and installed:
   ```r
   devtools::check()
   ```
   This will:
   
   * Let you know any errors, warnings and notes that you might want to fix before proceeding
   
   * Rebuild the package documentation
   
   * Compile and link the `C` code in folder `src` for testing purposes
  
   * Run the tests
   
 * Build the package once you're happy with it:
   ```r
   devtools::build()
   ```
   This will:
   
   * Produce a tarball in folder `compGeometeR` that replaces the old one if you've made no changes to the version number
   
   * Produce a new tarball alongside the old one in folder `compGeometeR` if you've changed the version number in the `DESCRIPTION` file

You'll be able load the newly built binary package using `library(compGeometeR)` if the build succeeded.

[Installation Options](#InstallOptions)

[Back to Top](#Top)

### Reinstalling a local build from `RStudio` or `R` after making changes<a name="ReinstallLocal"/>

You'll be able to install a newly built local package in the exact same way as installing the tarball that came with the repo. The only thing you may have to change is the path to your .tar.gz file if it's different from the default.

 * Calling `devtools::install()` on the console from inside the `package` folder will work as well.

You may find that you get permission errors on Windows when reinstalling the package on top of an existing version after making changes to the code. Trying the following might help:

 * Unload the package if it's loaded 
 
   * Untick the `compGeometeR` entry in the Packages tab if using `RStudio`
   
   * Detach it from the console if using plain `R`
     ```r
     detach("package:compGeometeR", unload=TRUE)
     ```
     
     * You may have to do that in `RStudio` as well if you try to reinstall and get an error stating that the package is in use
     
 * Remove the package from your system:
 
   * Click the Remove icon for the `compGeometeR` entry in the Packages tab if using `RStudio`
   
   * Remove it from the console if using plain `R`:
   ```r
   remove.packages("compGeometeR")
   ```
   
 * If that doesn't help for some reason:
 
   * Open the installation folder for `R` packages in Explorer (or in a file manager of your choice if not using Windows)
   
     * The error message will tell you what it is (typically something like `C:\Users\<your_user_name>\AppData\Local\R\win-library\<r_version>\`)
     
     * You can also find out by calling `.libPaths()` on the `R` console (the first entry on the list is the default location)
     
   * Check if the package folder is still there - it'll have the same name as the package
   
   * If the package folder's still hanging around:
     * Close `RStudio` and save the workspace
     
     * Delete the `compGeometeR` folder manually
     
     * Reopen `RStudio`
     
 * Rerun `install.packages("<path to tarball>/compGeometeR_<version>.tar.gz", repos=NULL, type="source")` or `devtools::install()` to reinstall the package after a successful `devtools::build()` 

As always, loading the package with `library(compGeometeR)` afterwards will tell you if your installation succeeded.

[Installation Options](#InstallOptions)

[Back to Top](#Top)

## Citation<a name="Citation"/>

If you make use of `compGeometeR`, we would really appreciate it if you could cite the [`compGeometeR` preprint](https://osf.io/b4zvr/) software paper:

Etherington TR, Omondiagbe OP (2021) compGeometeR: an R package for computational geometry. OSF Preprints, doi:[10.31219/osf.io/b4zvr](https://doi.org/10.31219/osf.io/b4zvr).

However, as `compGeometeR` is built upon and is dependant on the [Qhull library](http://www.qhull.org/) that has also been published:

Barber CB, Dobkin DP, Huhdanpaa H (1996) The Quickhull algorithm for convex hulls. ACM Transactions on Mathematical Software 22: 469-483, doi:[10.1145/235815.235821](https://dl.acm.org/doi/10.1145/235815.235821).

we think it is only fair that this work is cited too, so we would suggest including a statement such as the following in any published work:

"[we did some computational geometry analysis ...] using the R package `compGeometeR` (Barber *et al*. 1996, Etherington and Omondiagbe 2021)"

[Back to Top](#Top)

## Community Guidelines<a name="CommunityGuide"/>

To report bugs or request extra functionality please use log an [issue](https://github.com/manaakiwhenua/compGeometeR/issues) to get in touch.

We would also welcome contributions to `compGeometeR` from people who would like to join the development team.  We would ask that you first open an [issue](https://github.com/manaakiwhenua/compGeometeR/issues) to suggest an enhancement to be sure it is within scope of the project before forking the repository and issuing a pull request.

Our intention is that as people help to refine, fix, or add functionality to `compGeometeR` we will include these people as co-authors on the project, and will release a new version of the software paper preprint that includes these people as co-authors so that they too can get credit for their efforts.

[Back to Top](#Top)

## Maintainer
Pascal Omondiagbe <omondiagbep@landcareresearch.co.nz>