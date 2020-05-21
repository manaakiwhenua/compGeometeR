/* This file is included via Makevars in all C files */
#include <R.h>
#include <Rdefines.h>
#include <Rinternals.h>

FILE * tmpstdout;
#undef stdout
#define stdout tmpstdout

/* For stderr, qhull already defines a dummy stderr qh_FILEstderr in
   libqhull_r.h */
#undef stderr
#define stderr qh_FILEstderr

/* PI has been defined by the R header files, but the Qhull package
   defines it again, so undefine it here. */
#undef PI

#include "qhull_ra.h"



void print_summary(qhT *qh);
void freeQhull(qhT *qh);
void qhullFinalizer(SEXP ptr);
boolT hasPrintOption(qhT *qh, qh_PRINT format);
