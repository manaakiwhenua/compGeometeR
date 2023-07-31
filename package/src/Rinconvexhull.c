
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

/* test if a given point is contain in the convex hull */

SEXP C_inconvexhull(const SEXP convexhull, const SEXP testPoints)
{
	  // Retrieve qh object
	  SEXP ptr, tag;
	  qhT *qh;
	  PROTECT(tag = allocVector(STRSXP, 1));

	  SET_STRING_ELT(tag, 0, mkChar("convex_hull"));

	  PROTECT(ptr = getAttrib(convexhull, tag));

	  qh = R_ExternalPtrAddr(ptr);

	  UNPROTECT(2);


	  SEXP insideQhull;
	  insideQhull = R_NilValue;

	  unsigned int dim, n;
	  dim = ncols(testPoints);
	  n   = nrows(testPoints);

	  /* use qh_findbestfacet to check if a point set is hull */
	  PROTECT(insideQhull = allocVector(LGLSXP, n));

	  double *point;

	  point = (double *) R_alloc(dim, sizeof(double));
	  boolT isoutside;
	  realT bestdist;

	  int i, j;
	  for(i=0; i < n; i++) {
		for(j=0; j < dim; j++)
		  point[j] = REAL(testPoints)[i+n*j];

		qh_findbestfacet(qh, point, !qh_ALL, &bestdist, &isoutside);

		LOGICAL(insideQhull)[i] = !isoutside;

	  }
	  UNPROTECT(1);

	  return insideQhull;
}

