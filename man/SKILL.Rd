% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/SKILL.R
\name{SKILL}
\alias{SKILL}
\alias{skill}
\title{A meansure skill of interpolation by cross-validation}
\usage{
skill(data, coord, method = "RDW", n.station = 8, p = 1, m = 4,
  CDD = 800, r = 100)
}
\arguments{
\item{data}{A data.frame of size N x M with observations in meteorogical stantions, where N is the time and M the
points by stations.}

\item{coord}{data.frame of size N x 2 with longitude and Latitude of stations points. The order}

\item{method}{Choose the interpolation method that will be validated. The default is classical IDW.}

\item{n.station}{Number of stations used per point for interpolation. The default is 8.}

\item{p}{Power parameter. The default is 1.}

\item{m}{The param m of distance weight. The default is 4.}

\item{CDD}{Correlation distance decay param (Km).The default is 800 km.}

\item{r}{radius (in degree) for interpolation. The default ins 100}
}
\value{
A data.frame with longitude, latitude and statistics by cross-validation.
}
\description{
Will test the skill of interpolation methods at a given data set by cross-validation methodoloy.
}
\author{
Rodrigo Lins R Junior
}
