compGeometeR_VERSION=1.0
PACKAGE=compGeometeR_$(compGeometeR_VERSION).tar.gz
QHULL_DIR=qhull-2015 #directory where you have the quall library

roxygen:
	rm -f man/*
	echo "if (!library(roxygen2, logical.return=TRUE)) {install.packages(\"roxygen2\", repos=\"http://star-www.st-andrews.ac.uk/cran/\"); library(roxygen2) } ; roxygenize(\"package\")" |	R --no-restore --slave

package: roxygen
	R CMD build compGeometeR

install: package
	R CMD INSTALL --latex $(compGeometeR) 

doc: roxygen
	rm -f compGeometeR_doc.pdf
	R CMD Rd2pdf --pdf --output=compGeometeR_doc.pdf package

deps:
	echo "if (!library(devtools, logical.return=TRUE)) { install.packages(\"devtools\"); library(devtools) } ; devtools::install_deps(\"package/compGeometeR\", dependencies=c(\"Depends\", \"Suggests\"))"  |	R --no-restore --slave

check: package deps
	R CMD check --as-cran $(PACKAGE)
	@ if [ $$(/bin/ls -1 doc/*htm 2>/dev/null | wc -l) -gt 0 ] ; then echo "ERROR: .htm files inst/doc. See Makefile for suggestion of how to fix" ; fi	
	@ if [ $$(/bin/ls -1 doc/html/*htm 2>/dev/null | wc -l) -gt 0 ]; then echo "ERROR: .htm files in inst/doc. See Makefile for suggestion of how to fix" ; fi 

quickcheck: package deps
		R CMD check $(PACKAGE)
revision:
	@echo $(compGeometeR_VERSION)
	@echo $(compGeometeR_VERSION)


## qhull doc files need to have html suffixes and to have html 
htmldoc:
	echo html doc
	cp $(qhull-2015)/index.htm inst/doc/
	for f in  $(qhull-2015)/html/*.htm ; do cp $$f inst/doc/html/`basename $${f} .htm`.html ; done	
	cp $(qhull-2015)/html/*.gif package/inst/doc/html/
	perl -p -i -e 's/\.htm([#\"])/.html\1/g;' package/inst/doc/index.html	package/inst/doc/html/*.html
	perl -p -i -e 's|<head>|<head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>|g;' inst/doc/index.html	nst/doc/html/*.html
	tidy -config tidy-config -f tidy-error.log -m inst/doc/index.html	inst/doc/html/*.html

## for f in  *.htm ; do svn move $f ${f}l ; done
## 
## cd html
## for f in  *.htm ; do svn move $f ${f}l ; done
## perl -p -i -e 's/\.htm([#\"])/.html\1/g; ' *.html

## Generate test results like this:
## R --vanilla < pkg/tests/delaunayn.R > pkg/tests/delaunayn.Rout.save

qh_version:
	@echo "R version"
	@grep 'char qh_version2' src/global_r.c
	@echo "qhull version"
	@grep 'char qh_version2' ../qhull/src/libqhull_r/global_r.c 

qh_diff:
	diff -u -r -x '*.htm' -x '*.pro' -x '*.def' src/ ../qhull/src/libqhull_r

qh_diff_q:
	diff -u -r -x '*.htm' -x '*.pro' -x '*.def' -q src/ ../qhull/src/libqhull_r

