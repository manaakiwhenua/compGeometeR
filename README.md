# compGeometeR  R package 

### Implementation of Computational Geometry Algorithms for use in R

This is the initial version for the implementation of computation geometery algorithem to be use in R. It exposes some of the algorithms in the  Qhull library (http://www.qhull.org/) and implement additional algorithm using the output derived from some of the Qhull algorithms. 




## Local Development 

To start local development please branch out from the current stable master branch e.g :

+ git branch development
+ git checkout development


### Software needed to get started

1. Download perl(https://www.activestate.com/products/activeperl/downloads/)


2. Download make using the step below


+ Download make.exe from their official site ("http://gnuwin32.sourceforge.net/packages/make.htm")

+ In the Download session, click Complete package, except sources.

+ Follow the installation instructions.

+ Once finished, add the <installation directory>/bin/ to the PATH variable.



3. Download html tidy for generating a tidy help package (http://www.paehl.com/open_source/?HTML_Tidy_for_Windows).


4. R studio (use to open the .Rproj)


5. Eclipse (Needed if you need to update the C files)


After making changes,  build and install to your R library by running the following command in the package root directory:

+ make install (this should be run outside the project directory)
+  R CMD Rd2pdf --title='compGeometeR' -o /d/Projects/SDMRPackages/compGeometeR_doc.pdf package/man/*.Rd (to regenerate the pdf file)
devtools::install(args = c("--no-multiarch"))


## Installing Stable Development version from the repo

There are two ways to install the stable development version.

1. Using the zip file in the package folder 

download the version from the repo package folder (""release_package""), and run the following command

remove.packages("compGeometeR", lib="C:/Program Files/R/R-3.5.1/library")
detach("compGeometeR",unload=TRUE)
install.packages("D:/Projects/SDMRPackages/compGeometeR_1.0.0.zip", repos=NULL, type="binary")



2. Installing directly from the Master branch

You will need to install these 2 R package:
+ install.packages("devtools")
+ install.packages("getPass")

Please change to your bitbucket username

devtools::install_git("https://github.com/manaakiwhenua/compGeometeR", subdir ="package",credentials = git2r::cred_user_pass("omondiagbep@landcareresearch.co.nz", getPass::getPass()))
    
    
    

## Maintainer
Pascal Omondiagbe <omondiagbep@landcareresearch.co.nz>




