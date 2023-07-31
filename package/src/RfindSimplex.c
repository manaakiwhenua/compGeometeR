
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
#include "RcompGeomete.h"
#include "qhull_ra.h"
#include <unistd.h>
#include <stdio.h>
#include <string.h>

/* test if a given point is contain in the convex hull , currently not used*/

SEXP C_findSimplex(const SEXP convexhull, const SEXP testPoints)
{
	  // Retrieve qh object
	  SEXP ptr, tag;
	  qhT *qh;
	  PROTECT(tag = allocVector(STRSXP, 1));
	  facetT *facet;
	  SET_STRING_ELT(tag, 0, mkChar("convexhull"));

	  PROTECT(ptr = getAttrib(convexhull, tag));

	  qh = R_ExternalPtrAddr(ptr);

	  UNPROTECT(2);

	  SEXP insideQhull;
	  insideQhull = R_NilValue;
	  vertexT *vertex, **vertexp; /* set by FORALLfacets */
	  unsigned int dim, n;
	  dim = ncols(testPoints);
	  n   = nrows(testPoints);

	  /* use qh_findbestfacet to check if a point set is inside hull */
	  PROTECT(insideQhull = allocVector(INTSXP, n));

	  boolT isoutside;
	  realT bestdist,dist;

	  int i, j;
	  for(i=0; i < n; i++)
	  {
			double *point;
			point = (double *) R_alloc(dim, sizeof(double));
			for(j=0; j < dim; j++)
			{
			   point[i+n*j] = REAL(testPoints)[i+n*j];
			}
			 facet->coplanarset;
			 facet = qh_findbestfacet(qh, point, qh_ALL, &bestdist, &isoutside);
			 qh_distplane(qh,point, facet, &dist);

			 printf("double is %5.2f \n", dist);
			 printf("min_vertex %5.2f \n", qh->min_vertex);
			 printf("DISTround %5.2f \n", qh->DISTround);
			 //Simplices in the triangulation == facets on the convex hull.
			// if(!isoutside ==TRUE) //point is inside convex hull, so now check which simplex this point lies inside
			// {
			 FOREACHvertex_ (facet->vertices)
			 {

				 if (dist < qh->min_vertex - 2 * qh->DISTround)
				 {
						 /* point is clearly inside of facet, get the facet id */
					 INTEGER(insideQhull)[i] = qh_pointid(qh, vertex->point);
				 }
				 else{
					 INTEGER(insideQhull)[i] = 0;
				 }
			 }
			// }
	//			 int triR=nrows(triPoint);
	//			 int  triCol =ncols(triPoint);
	//			 //loop over the trigulation point to determin if the points lies inside or not
	//			 for(i=0; i < triR; i++)
	//				for(j=0; j < triCol; j++)
	//				{
	//					//calulate the area of this triangle
	//
	//					value =REAL(triPoint)[i+triR*j];
	//					REAL(point0)[i+triR*j] = REAL(p)[value];
	//				}

			// }else
	//		 {
	//			 INTEGER(insideQhull)[i] = -1; //point is outside convexhull, assign -1
	//		 }


	 }

	  UNPROTECT(1);

	  return insideQhull;
}
