# A toolbox for spatial interpolation by irregular meteorogical data observations
By: Rodrigo Lins Rocha Jr., Fabrício Daniel Santos Silva at Federal University of Alagoas 
*rodrigo.junior@icat.ufal.br*,*fabricio.santos@icat.ufal.br*
## Introduction
This package has a set of tools for spatial interpolation by Sherpard methods (classical and variations) and functions for validation of interpolation and export interpoled grid in netcdf output with or without spatial mask using shapefiles.

### Interpolation functions
**Inverse distance weighting (IDW)** is a type of deterministic method for multivariate interpolation with a known scattered set of points. The assigned values to unknown points are calculated with a weighted that variate in function of distance. The method did propose by Sherpard's (1968).

**Radial Distance Weighting (RDW)** is the first modifield version of Sherpard's algorithm where the estimative of weights consider the radius between the interpolation location x and the sample points xi.  

**Angular Distance Weighting (ADW)** is the second modifield version of Sherpard's algorithm (Hofstra & New, 2009). The weights are estimed in function of the distance and angle between the sample stations. 

### Get a netcdf output (without or with spatial mask)

#### References:

HOFSTRA, Nynke; NEW, Mark. Spatial variability in correlation decay distance and influence on angular‐distance weighting interpolation of daily precipitation over Europe. International Journal of Climatology: A Journal of the Royal Meteorological Society, v. 29, n. 12, p. 1872-1880, 2009.

XAVIER, Alexandre C.; KING, Carey W.; SCANLON, Bridget R. Daily gridded meteorological variables in Brazil (1980–2013). International Journal of Climatology, v. 36, n. 6, p. 2644-2659, 2016.

SHEPARD, Donald. A two-dimensional interpolation function for irregularly-spaced data. In: Proceedings of the 1968 23rd ACM national conference. ACM, 1968. p. 517-524.
