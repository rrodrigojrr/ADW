#' @title Angular Distance Weighting interpolation
#' @name ADW
#'
#' @description Apply the Angular Distance Weighting interpolation
#' method on the irregular points of meteorological observations to a regular grid.
#'
#' @param xy A matrix (N,2) with longitude and latitude of points of data observed 
#' @param z A vector (N) with the values observeds in the points
#' @param xrange A vector with extremes longitudes of grid eg: c(-45,-35)
#' @param yrange A vector with extremes latitudes of grid. eg: c(-1,-5)
#' @param res The resolution of grid in degree
#' @param n.station Number of stations used per point for interpolation. The default is 8.
#' @param m The param m of distance weight. The default is 4.
#' @param CDD Correlation distance decay param (Km).The default is 100 km.
#'
#'
#' @return Interpoled regular grid in Netcdf, data.frame or raster by ADW method.
#'
#' @author Rodrigo Lins R Júnior
#'
#' 
#'
#' @export
ADW = function(xy,z,xrange,yrange,res=0.5,n.station=8,m=4,CDD=50){
  
  
  #########################################################################################
  x.range <- seq(xrange[1],xrange[2],by=res) 
  y.range <- seq(yrange[1],yrange[2],by=res)
  
  coord=xy
  
  n.station=n.station
  m=m
  CDD=CDD
  
  ###################################################################################
  
  angle <- function(from,to){
    dot.prods <- from$x*to$x + from$y*to$y
    norms.x <- distance(from = `[<-`(from,,,0), to = from)
    norms.y <- distance(from = `[<-`(to,,,0), to = to)
    thetas <- acos((dot.prods / (norms.x * norms.y)))
    return(as.numeric(thetas))
  }
  
  distance <- function(from, to){
    D <- sqrt((abs(from[,1]-to[,1])^2) + (abs(from[,2]-to[,2])^2))
    return(D)
  }
  
  ##################################################################
  
  
  INTERPOLED=data.frame()
  
  i=1
  j=1
  while (i<=length(x.range)) {
    
    while (j<=length(y.range)) {
      
      x1=x.range[i]          #Coordenada X do poonto a estimar
      y1=y.range[j]          #Coordenada y do ponto a estimar
      
      x2=coord[,1]           #Coordenadas x dos pontos observados e usados para estimar
      y2=coord[,2]           #Coordenadas y dos pontos observados e usados para estimar
      
      point=data.frame(x1,y1) # Data.frame com as coordenadas do ponto a estimar
      colnames(point)=c("x","y") 
      
      est_coordenadas=data.frame(x2,y2) #Data.frame com as coordenadas dos pontos observados
      colnames(est_coordenadas)=c("x","y")
      
      Di=distance(from = point,to=est_coordenadas) #Dist?ncia euclidianda entre os pontos
      
      
      
      aux=data.frame(coord,Di,z)
      colnames(aux)=c("Lat","Lon","Di","DATA")
      
      cron=aux[order(aux$Di),]
      
      cron=cron[1:n.station,]
      
      DW=(exp((-cron[,3])/CDD))**m   # Peso pela dist?ncia euclidiana
      
      aux=cron[,1:2]
      colnames(aux)=c("x","y")
      
      
      angl=angle(aux,point)
      
      cron=cbind(angl,cron)
      cron=cbind(DW,cron)
      
      AW=data.frame()
      n3=nrow(cron)
      
      k=1
      while (k<=n3) {
        
        aux1=cron[k,]
        aux2=cron[-k,]
        
        ax=aux1[,1]*(1+((sum(aux1[,1]*(cos(aux2[k,2]-aux1[,2]))))/sum(aux2[,1]))) # Peso angular entre as esta??es
        
        AW=rbind(ax,AW)
        k=k+1
      }
      colnames(AW)=c("AW")
      AW[is.na(AW$AW),]=0
      
      AW=rev(AW$AW)    
      
      cron=cbind(AW,cron)
      
      W=cron$DW*(1+cron$AW)
      
      PE=sum(W*cron$DATA)/sum(W)
      
      aux=data.frame(x1,y1,PE)
      INTERPOLED=rbind(aux,INTERPOLED)
      j=j+1
    }
    j=1
    i=i+1
  }
  
  
  colnames(INTERPOLED)=c("long","lat","var")
  
  
  return(INTERPOLED)
  
}

