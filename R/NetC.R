#' @title Convert data.frame for Netcdf
#' @name NetC
#'
#' @description Convert the data frame from IDW/EDW/ADW function for a netcdf file
#'
#' @param data The data frame output by IDW/EDW/ADW function 
#' @param varName Variable name in netcdf file 
#' @param fileName Netcdf file name archive (or path with name). Default is "data" and the archive will be save in
#' current directory
#' @param mask A logical param for choose make a geografical mask by a shapefile. If TRUE, is necessary put 
#' a path with shapefile andress in any directory. 
#' @param path The directory of shapefile for geografical mask in grid (Only mask=TRUE)
#'
#'
#' @return Generate a netcdf file in current directory or in path directory
#'
#' @author Rodrigo Lins R Júnior
#'
#' @importFrom ncdf4 nc_create
#' @export
#' 
NetC = function(data,varName="data",fileName="V1",mask=F,path=NULL){
  colnames(data)=c("Longitude","Latitude",varName)
  fileName=paste(fileName,".nc",sep = "")
  raster <- raster::rasterFromXYZ(data)
  if (mask==F){
    raster::writeRaster(raster, filename=fileName, format="CDF", overwrite=TRUE)  
  } else if (mask==T) {

    shp <- maptools::readShapePoly(path)
    mask.shp <- raster::crop(raster, shp)
    dataMask <- raster::mask(mask.shp, shp)
    
    raster::writeRaster(dataMask, filename=fileName, format="CDF", overwrite=TRUE)
  }
  
}








