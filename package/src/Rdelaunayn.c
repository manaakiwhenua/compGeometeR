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



SEXP C_delaunayn(const SEXP p, const SEXP options, SEXP tmpdir)
{
   SEXP retlist, retnames,nor,point0,originalPoint;       /* Return list and names */
   int retlen= 4;      


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



  sprintf(flags,"qhull d Qbb T0 Fn %s", CHAR(STRING_ELT(options,0)));


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

  if (!exitcode)
  {                    /* 0 if no error from qhull */
      /* Triangulate non-simplicial facets - this commented out code
         does not appear to be needed, but retaining in case useful --
      /* qh_triangulate (); */

      facetT *facet;                  /* set by FORALLfacets */
      vertexT *vertex, **vertexp;
      facetT *neighbor, **neighborp;
      ridgeT *ridge, **ridgep;

      qh_option(qh,"delaunay  Qbbound-last", NULL, NULL);
  	qh->DELAUNAY= True;     /* 'v'   */

  	qh->SCALElast= True;    /* 'Qbb' */
  	qh->KEEPcoplanar= True;

  	if (dim >= 5)
  	{
  		qh_option(qh,"_merge-exact", NULL, NULL);
  		qh->MERGEexact= True; /* 'Qx' always */
  	 }

      /* Count the number of facets so we know how much space to
         allocate in R */
      int nf=0;                 /* Number of facets */
      FORALLfacets {
        if (!facet->upperdelaunay) {
          nf++;
        }
        nk=nf;
        /* Double check. Non-simplicial facets will cause segfault
           below */
        if (! facet->simplicial) {
          Rprintf("Qhull returned non-simplicial facets -- try delaunayn with different options");
          exitcode = 1;
          break;
        }
      }

      /* Allocate the space in R */
      PROTECT(tri = allocMatrix(INTSXP, nf, dim+1));
      PROTECT(neighbours = allocVector(VECSXP, nf));
      PROTECT(areas = allocVector(REALSXP, nf));
      PROTECT(point0= allocMatrix(REALSXP, nf, dim+1));

      /* Iterate through facets to extract information */
      int i=0;
      FORALLfacets
  	  {
        if (!facet->upperdelaunay)
        {
          if (i >= nf) {
            error("Trying to access non-existent facet %i", i);
          }

          /* Triangulation */
           boolT inorder=True;

  		 qh_RIDGE innerouter= qh_RIDGEall;
  		 printvridgeT printvridge= NULL;
  		 qh_eachvoronoi_all(qh, errfile, printvridge, qh->UPPERdelaunay, innerouter, inorder);

  		 int j=0;

  		if(qh->hull_dim ==3 && facet->toporient == qh_ORIENTclock)
  		{
  			  FOREACHvertex_ (facet->vertices)
  			 {
  				  if ((i + nf*j) >= nf*(dim+1))
  					error("Trying to write to non-existent area of memory i=%i, j=%i, nf=%i, dim=%i", i, j, nf, dim);


  				 INTEGER(tri)[i + nf*j] = qh_pointid(qh, vertex->point);
  				  j++;
  			  }
  		}
  		else if (facet->simplicial || qh->hull_dim ==1)
  		{
  			if ((facet->toporient == qh_ORIENTclock) || (qh->hull_dim > 2 && !facet->simplicial))
  			{
  				FOREACHvertex_(facet->vertices){
  				   INTEGER(tri)[i + nf*j] = qh_pointid(qh, vertex->point);
  				   j++;
  				}
  			 }
  			else
  			{
  				FOREACHvertexreverse12_(facet->vertices){
  					INTEGER(tri)[i + nf*j] = qh_pointid(qh, vertex->point);

  					j++;
  				}
  			}
  		}
  		else
  		{
  			 if (facet->visible && qh->NEWfacets)
  			 {
  				 error("cant process");
  				 break;
  			 }

  			  FOREACHridge_(facet->ridges)
  			  {

  				if ((ridge->top == facet) ^ qh_ORIENTclock)
  				{
  				  FOREACHvertex_(ridge->vertices){
  					  INTEGER(tri)[i + nf*j] = qh_pointid(qh, vertex->point);
  					  j++;
  				  }
  				}
  				else
  				{
  				  FOREACHvertexreverse12_(ridge->vertices){
  					 INTEGER(tri)[i + nf*j] = qh_pointid(qh, vertex->point);
  					 j++;
  				  }
  				}

  		   }
  		}

          /* Neighbours */
          PROTECT(neighbour = allocVector(INTSXP, qh_setsize(qh, facet->neighbors)));
          j=0;
          FOREACHneighbor_(facet) {
            INTEGER(neighbour)[j] = neighbor->visitid ? neighbor->visitid: 0 - neighbor->id;
            j++;
          }
          SET_VECTOR_ELT(neighbours, i, neighbour);
          UNPROTECT(1);

          /* Area. Code modified from qh_getarea() in libquhull/geom2.c */
          if ((facet->normal) && !(facet->upperdelaunay && qh->ATinfinity)) {
            if (!facet->isarea) {
              facet->f.area= qh_facetarea(qh, facet);
              facet->isarea= True;
            }
            REAL(areas)[i] = facet->f.area;
          }
          i++;
        }
      }
       unsigned int firstTemp=0,secondTemp=0;
       simpliexDim = ncols(tri);
       simplexRow   = nrows(tri);
       //swap the first and second value in the triangulation
       for(int i =0; i<simplexRow ; i++)
       {
  		  firstTemp =INTEGER(tri)[i];
  		  secondTemp=INTEGER(tri)[i+simplexRow];
  		  INTEGER(tri)[i] =secondTemp;
  		  INTEGER(tri)[i+simplexRow] = firstTemp;
       }

       //get the trigulation simplex point
	 int k=0,value=0;
	 int triR=nrows(tri);
	 int  triCol =ncols(tri);
	 for(i=0; i < triR; i++)
		for(j=0; j < triCol; j++)
		{
			value =INTEGER(tri)[i+triR*j];
			REAL(point0)[i+triR*j] = REAL(p)[value];
		}




    }
    else //error here
    { /* exitcode != 1 */
  		/* There has been an error; Qhull will print the error
  		   message */
  		PROTECT(tri = allocMatrix(INTSXP, 0, dim+1));
  		PROTECT(neighbours = allocVector(VECSXP, 0));
  		PROTECT(areas = allocVector(REALSXP, 0));


  		/* If the error been because the points are colinear, coplanar
  		   &c., then avoid mentioning an error by setting exitcode=2*/
  		/* Rprintf("dim %d; n %d\n", dim, n); */
  		if ((dim + 1) == n)
  		{
  		  exitcode = 2;
  		}
    }



    PROTECT(retlist = allocVector(VECSXP, retlen));
    PROTECT(retnames = allocVector(VECSXP, retlen));
    SET_VECTOR_ELT(retlist, 0, tri);
    SET_VECTOR_ELT(retnames, 0, mkChar("tri"));
    SET_VECTOR_ELT(retlist, 1, neighbours);
    SET_VECTOR_ELT(retnames, 1, mkChar("neighbours"));
    SET_VECTOR_ELT(retlist, 2, areas);
    SET_VECTOR_ELT(retnames, 2, mkChar("areas"));
    SET_VECTOR_ELT(retlist, 3, point0);
    SET_VECTOR_ELT(retnames, 3, mkChar("simplex_points"));
    setAttrib(retlist, R_NamesSymbol, retnames);
    UNPROTECT(6);

    /* Register qhullFinalizer() for garbage collection and attach a
       pointer to the hull as an attribute for future use. */

    PROTECT(tag = allocVector(STRSXP, 1));

    SET_STRING_ELT(tag, 0, mkChar("delaunay_tri")); //we are returning only delaunay trigulation

    PROTECT(ptr = R_MakeExternalPtr(qh, tag, R_NilValue));
    if (exitcode)
    {
      //qhullFinalizer(ptr);
    } else
    {
      //R_RegisterCFinalizerEx(ptr, qhullFinalizer, TRUE);
      setAttrib(retlist, tag, ptr);
    }
    UNPROTECT(2);

    if (exitcode & (exitcode != 2))
    {
  	  if(exitcode ==1)
  	  {
  		  error("Qhull returned non-simplicial facets -- try delaunayn with different options. exitcode", exitcode);
  	  }
  	  else
  	  {
  		  error("Received error code %d from qhull.", exitcode);
  	  }

    }


	return retlist;
}


