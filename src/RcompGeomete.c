/* Copyright (C) 2018

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
#include <R.h>
#include <Rdefines.h>
#include <Rinternals.h>
#include "qhull_ra.h"



void freeQhull(qhT *qh) {
  int curlong, totlong;
  qh_freeqhull(qh, !qh_ALL);                /* free long memory */
  qh_memfreeshort (qh, &curlong, &totlong);	/* free short memory and memory allocator */
  if (curlong || totlong) {
    warning("convhulln: did not free %d bytes of long memory (%d pieces)",
	    totlong, curlong);
  }
  qh_free(qh);
}

/* Finalizer which R will call when garbage collecting. This is
   registered at the end of convhulln() */
void qhullFinalizer(SEXP ptr)
{
  if(!R_ExternalPtrAddr(ptr)) return;
  qhT *qh;
  qh = R_ExternalPtrAddr(ptr);
  freeQhull(qh);
  R_ClearExternalPtr(ptr); /* not really needed */
}

boolT hasPrintOption(qhT *qh, qh_PRINT format) {
  for (int i=0; i < qh_PRINTEND; i++) {
    if (qh->PRINTout[i] == format) {
      return(True);
    }
  }
  return(False);
}

/*-------------------------------------------------
-print_summary(qh)
*/
void print_summary(qhT *qh)
{
	  printf("\n%d vertices and %d facets with normals:\n",
					 qh->num_vertices, qh->num_facets);

}

/* DETERMINE THE CIRCUMCENTRES OF ALL THE TRIANGLES IN THE DELAUNAY TRIANGULATIONf
 */
double * calculateradill(double *point0,double *voronoiVertices)
{
	int j,k=0;
	unsigned row = nrows(point0);
	unsigned colD= ncols(point0);
	double *circumRadii= (double *) R_alloc(row, sizeof(double));

	for(j=0; j < row; j++)
	{
		 double pointSumDiff =0.0;
		 //get the point value using the trigulation index
		 pointSumDiff += (double)pow((REAL(voronoiVertices)[j] - REAL(point0)[j]),2);

		 for(int i=1; i<colD;i++)
		 {
			 pointSumDiff += (double)pow((REAL(voronoiVertices)[j + row*i] - REAL(point0)[j + row*i]),2);

		 }
		 circumRadii[k] = sqrt(pointSumDiff);

		 k++;
	 }

	 return circumRadii;
}

/* find if a given point in the grid is an alpha-complex simplex */
SEXP C_compGeomete(const SEXP gridSpaceSimplex,const SEXP circumRadii, const SEXP alpha)
{

	  double *gridPoint,*circumRadiiPoint;
	  int *alphaComplexSimplices;
	  int i, j,n,dim;
	  dim = ncols(gridSpaceSimplex);
	  n   = nrows(gridSpaceSimplex);
	  gridPoint = (double *) R_alloc(dim, sizeof(double));
	  SEXP gridOutput;
	  circumRadiiPoint = (double *) R_alloc(1, sizeof(double));
	  PROTECT(gridOutput = allocVector(INTSXP, n));
      double alphaValue =asReal(alpha);


	  //get the gridSpaceSimplex
	  for(i=0; i < nrows(circumRadii); i++) {

		  circumRadiiPoint[i] = REAL(circumRadii)[i];

	  }

	  alphaComplexSimplices=(int *) R_alloc(1, sizeof(int));

	  // Identify those simplices that will form the alpha-shape
	  for(i=0;i<nrows(circumRadii); i++)
	  {

		  if( alphaValue > circumRadiiPoint[i])
		  {
			  alphaComplexSimplices[i] =i;

		  }



	  }
	  const int alphaComplexSimplicesSize = sizeof(alphaComplexSimplices) / sizeof(alphaComplexSimplices[0]);
	  //get the gridSpaceSimplex and check if each point is an alpha-complex simplex, if it is return the trigulation index number , hence return 0
	  for(i=0; i < n; i++)
	  {

			for(j=0; j < dim; j++)
			{

				gridPoint[j] = INTEGER(gridSpaceSimplex)[i+n*j];

				const int pointCheckSize = sizeof(gridPoint[j] ) / sizeof(gridPoint[j]);

				boolT isFound = FALSE;

				  if (pointCheckSize > alphaComplexSimplicesSize)
				  {

						INTEGER(gridOutput)[j] =0.0;
						break;
				  }
				  else
				  {

					    int t = 0;
						for (int i = 0; (i < alphaComplexSimplicesSize)  ; i++)
						{
							  if (alphaComplexSimplices[i] == gridPoint[j])
							  {
								t++;
							  }
							  else
							  {
								t = 0;
								if (i > alphaComplexSimplicesSize - pointCheckSize)
								{
								  break;
								}
							  }
					    }
						isFound = (t == pointCheckSize) ? TRUE : FALSE;
				  }
				  if(isFound)
				  {

					  INTEGER(gridOutput)[j] = INTEGER(gridSpaceSimplex)[i+n*j];
				  }
				  else
				  {

					  INTEGER(gridOutput)[j] =0.0;
				  }

			   }
	  }

	    UNPROTECT(1);
		return gridOutput;

}

