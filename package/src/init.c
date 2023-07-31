#include <R.h>
#include <Rinternals.h>
#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

/* FIXME:
   Check these declarations against the C/Fortran source code.
*/

/* .Call calls */
extern SEXP C_delaunayn(SEXP, SEXP, SEXP);
extern SEXP C_convex(SEXP, SEXP, SEXP);
extern SEXP C_voronoiR(SEXP, SEXP, SEXP);
extern SEXP C_inconvexhull(SEXP, SEXP);
extern SEXP C_findSimplex(SEXP, SEXP);
extern SEXP C_compGeomete(SEXP,SEXP,SEXP);


static const R_CallMethodDef CallEntries[] =
{
	 {"C_inconvexhull", (DL_FUNC) &C_inconvexhull, 2},
   {"C_delaunayn", (DL_FUNC) &C_delaunayn, 3},
   {"C_convex", (DL_FUNC) &C_convex, 3},
	 {"C_voronoiR", (DL_FUNC) &C_voronoiR, 3},
	 {"C_compGeomete", (DL_FUNC) &C_compGeomete, 3},
	 {"C_findSimplex", (DL_FUNC) &C_findSimplex, 2},

    {NULL, NULL, 0}
};

void R_init_compGeometeR(DllInfo *dll)
{
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
