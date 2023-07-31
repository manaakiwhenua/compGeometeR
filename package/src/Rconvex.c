/* Copyright
** This program is free software; you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation; either version 2 of the License, or
** (at your option) any later version.
**
** This program is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with this program; if not, write to the Free Software
** Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
*/



// Enable C++11 via this plugin
//[[Rcpp::plugins(cpp11)]]

#include "RcompGeomete.h"
#include <unistd.h>              /* For unlink() */



SEXP C_convex(const SEXP p, const SEXP options, SEXP tmpdir)
{
   SEXP retlist, retnames,nor,point0,originalPoint;       /* Return list and names */
   int retlen;
   
   retlen = 1;              
   SEXP ptr, tag;
   SEXP tri;                     /* The triangulation */
   SEXP neighbour, neighbours;   /* List of neighbours */
   SEXP areas;                    /* Facet areas */
   int i, j,nk;
   unsigned dim, n, simpliexDim, simplexRow;
   int exitcode = 1;
   boolT ismalloc;
   char flags[250];             /* option flags for qhull, see qh_opt.htm */
   double *pt_array;
    /* Initialise return values */
	tri = neighbours = retlist = areas = R_NilValue;


    FILE *errfile = NULL;

	if(!isString(options) || length(options) != 1){
		error("Second argument must be a single string.");
	}
	if(!isMatrix(p) || !isReal(p)){
		error("First argument should be a real matrix.");
	}
  
  /* Read options into command */
  i = LENGTH(STRING_ELT(options,0));
  if (i > 200) 
    error("Option string too long");




  sprintf(flags,"qhull %s", CHAR(STRING_ELT(options,0)));
  


  /* Check input*/
	dim = ncols(p);
	n   = nrows(p);
	if(dim <= 0 || n <= 0){
		error("Invalid input matrix.");
	}
  if (n <= dim) {
    error("Number of points is not greater than the number of dimensions.");
  }

  i = 0, j = 0;
  pt_array = (double *) R_alloc(n*dim, sizeof(double)); 
  for(i=0; i < n; i++)
    for(j=0; j < dim; j++)
      pt_array[dim*i+j] = REAL(p)[i+n*j];
  ismalloc = False;   /* True if qhull should free points in qh_freeqhull() or reallocation */


  const char *name;

  name = R_tmpnam("Rf", CHAR(STRING_ELT(tmpdir, 0)));
  qhT *qh= (qhT*)malloc(sizeof(qhT));
  qh_zero(qh, errfile);
  exitcode = qh_new_qhull(qh, dim, n, pt_array, ismalloc, flags, tmpstdout, errfile);
  fclose(tmpstdout);
  unlink(name);
  free((char *) name); 

  int *idx;
  SEXP retval;
  retval =R_NilValue;
  nor = R_NilValue;
  unsigned int nVertexMax = dim;
  
  if (!exitcode)
  {
    /* 0 if no error from qhull */
    
    facetT *facet;              /* set by FORALLfacets */
    vertexT *vertex, **vertexp; /* set by FORALLfacets */
    unsigned int n = qh->num_facets;
    
    retval = PROTECT(allocMatrix(INTSXP, n, nVertexMax));
    idx = (int *) R_alloc(n*nVertexMax,sizeof(int));
    
    
    qh_vertexneighbors(qh);
    
    i=0; /* Facet counter */
    FORALLfacets {
      j=0;
      /* qh_printfacet(stdout,facet); */
      FOREACHvertex_ (facet->vertices) {
        /* qh_printvertex(stdout,vertex); */
        if (j >= dim)
        {
          printf("warning:extra vertex %d of facet %d = %d", j++,i,qh_pointid(qh, vertex->point));
        }
        else
          idx[i+n*j++] = qh_pointid(qh, vertex->point);
      }
      if (j < dim) printf("warning: facet %d only has %d vertices",i,j);
      
      while (j < nVertexMax){
        idx[i+n*j++] = 0; /* Fill with zeros for the moment */
      }
      i++; /* Increment facet counter */
        
    }
    
    j=0;
    for(i=0;i<nrows(retval);i++)
      for(j=0;j<ncols(retval);j++)
        if (idx[i+n*j] > 0){
          INTEGER(retval)[i+nrows(retval)*j] = idx[i+n*j];
        }else{
          INTEGER(retval)[i+nrows(retval)*j] = NA_INTEGER;
        }
        
        
  }
  else //error here
  { /* exitcode != 1 */
        /* There has been an error; Qhull will print the error
    message */
        PROTECT(allocMatrix(INTSXP, n, nVertexMax));
    PROTECT(retlist = allocVector(VECSXP, 0));
    
    /* If the error been because the points are colinear, coplanar
    &c., then avoid mentioning an error by setting exitcode=2*/
    /* Rprintf("dim %d; n %d\n", dim, n); */
    if ((dim + 1) == n)
    {
      exitcode = 2;
    }
    UNPROTECT(2);
  }
  
  
  /* Register qhullFinalizer() for garbage collection and attach a
   pointer to the hull as an attribute for future use. */
  
  PROTECT(retlist = allocVector(VECSXP, retlen));
  
  PROTECT(retnames = allocVector(VECSXP, retlen));
  
  
  SET_VECTOR_ELT(retlist, 0, retval);
  SET_VECTOR_ELT(retnames, 0, mkChar("convex_hull"));
  
  setAttrib(retlist, R_NamesSymbol, retnames);
  
  
  
  tag = PROTECT(allocVector(STRSXP, 1));
  SET_STRING_ELT(tag, 0, mkChar("convex_hull"));
  ptr = PROTECT(R_MakeExternalPtr(qh, tag, R_NilValue));
  
  
  if (exitcode)
  {
    //qhullFinalizer(ptr);
  }
  else
  {
    setAttrib(retval, tag, ptr);
  }
  UNPROTECT(5);
  
  if (exitcode) {
    error("Received error code %d from qhull.", exitcode);
  }

	return retlist;
}


