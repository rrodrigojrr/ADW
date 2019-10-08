# A toolbox for spatial interpolation by irregular meteorogical data observations
By: Rodrigo Lins R Jr, Fabrício D S Silva at Federal University of Alagoas 


Apply two interpolation methods on the irregular points of meteorological observations for get a regular grid in Netcdf, raster or data.frame.

**Inverse distance weighting (IDW)** is a type of deterministic method for multivariate interpolation with a known scattered set of points. The assigned values to unknown points are calculated with a weighted that variate in function of distance. The method did propose by Sherpard's (1968).

**The Angular Distance Weighting (ADW)** is a modifield version of Sherpard's algorithm (Hofstra & New, 2009). The weights are estimed in function of the distance and angle between the sample stations. 


### References:

HOFSTRA, Nynke; NEW, Mark. Spatial variability in correlation decay distance and influence on angular‐distance weighting interpolation of daily precipitation over Europe. International Journal of Climatology: A Journal of the Royal Meteorological Society, v. 29, n. 12, p. 1872-1880, 2009.

XAVIER, Alexandre C.; KING, Carey W.; SCANLON, Bridget R. Daily gridded meteorological variables in Brazil (1980–2013). International Journal of Climatology, v. 36, n. 6, p. 2644-2659, 2016.

SHEPARD, Donald. A two-dimensional interpolation function for irregularly-spaced data. In: Proceedings of the 1968 23rd ACM national conference. ACM, 1968. p. 517-524.
