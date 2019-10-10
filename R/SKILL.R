#' @title A meansure skill of interpolation by cross-validation
#' @name SKILL
#'
#' @description Will test the skill of interpolation methods at a given data set by cross-validation methodoloy.
#'
#' @param data A data.frame of size N x M with observations in meteorogical stantions, where N is the time and M the
#'  points by stations. 
#' @param coord data.frame of size N x 2 with longitude and Latitude of stations points. The order
#' @param method Choose the interpolation method that will be validated. The default is classical IDW.
#' @param n.station Number of stations used per point for interpolation. The default is 8.
#' @param p Power parameter. The default is 1.
#' @param m The param m of distance weight. The default is 4.
#' @param CDD Correlation distance decay param (Km).The default is 800 km.
#' @param r radius (in degree) for interpolation. The default ins 100
#'
#'
#' @return A data.frame with longitude, latitude and statistics by cross-validation.
#'
#' @author Rodrigo Lins R Junior
#' @importFrom stats cor
#' 
#' @export
skill=function(data,coord,method="RDW",n.station=8,p=1,m=4,CDD=800,r=100){
  
  distance <- function(from, to){
    D <- sqrt((abs(from[,1]-to[,1])^2) + (abs(from[,2]-to[,2])^2))
    return(D)
  }
  
  angle <- function(from,to){
    dot.prods <- from$x*to$x + from$y*to$y
    norms.x <- distance(from = `[<-`(from,,,0), to = from)
    norms.y <- distance(from = `[<-`(to,,,0), to = to)
    thetas <- acos((dot.prods / (norms.x * norms.y)))
    return(as.numeric(thetas))
  }

  statistics=data.frame()
  
  if (method=="ADW"){
    
    n1=ncol(data)
    n2=nrow(data)
    i=1
    j=1
    while (i<n1) {
      
      data.int=data[,i]
      data.est=data[,-i]
      
      coord.int=coord[i,1:2]
      coord.est=coord[-i,1:2]
      
      INTER.aux=data.frame()
      
      while (j<=n2) {
        
        
        V1=data.int[j]
        V2=data.est[j,]
        
        
        point=data.frame(coord.int[2],coord.int[1]) # Data.frame com as coordenadas do ponto a estimar
        colnames(point)=c("x","y") 
        
        est_coordenadas=data.frame(coord.est[,2],coord.est[,1]) #Data.frame com as coordenadas dos pontos observados
        colnames(est_coordenadas)=c("x","y")
        
        Di=distance(from = point,to=est_coordenadas) #Dist?ncia euclidianda entre os pontos
        
        aux=data.frame(coord.est,Di,V2)
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
        
        aux=data.frame(coord.int[2],coord.int[1],PE)
        INTER.aux=rbind(aux,INTER.aux)
        j=j+1
        
      }
      colnames(INTER.aux)=c("Lon","Lat","v1")
      
      cor.aux=cor(data.int,rev(INTER.aux$v1))
      vies=mean((data.int-rev(INTER.aux$v1)))
      eb=mean(abs(data.int-rev(INTER.aux$v1)))
      aux=data.frame(INTER.aux$Lon[1],INTER.aux$Lat[2],cor.aux,vies,eb)
      statistics=rbind(aux,statistics)
      j=1
      i=i+1
      print(i/n1)
    }
    
  } 
  
  
  if (method=="IDW") {
    
    n1=ncol(data)
    n2=nrow(data)
    i=1
    j=1
    while (i<=n1) {
      
      data.int=data[,i]
      data.est=data[,-i]
      
      coord.int=coord[i,1:2]
      coord.est=coord[-i,1:2]
      
      INTER.aux=data.frame()
      
      while (j<=n2) {
        
        V1=data.int[j]
        V2=data.est[j,]
        
        point=data.frame(coord.int[2],coord.int[1]) # Data.frame com as coordenadas do ponto a estimar
        colnames(point)=c("x","y") 
        
        est_coordenadas=data.frame(coord.est[,2],coord.est[,1]) #Data.frame com as coordenadas dos pontos observados
        colnames(est_coordenadas)=c("x","y")
        
        Di=distance(from = point,to=est_coordenadas) #Dist?ncia euclidianda entre os pontos
        
        aux=data.frame(coord.est,Di,V2)
        colnames(aux)=c("Lat","Lon","Di","DATA")
        
        cron=aux[order(aux$Di),]
        
        cron=cron[1:n.station,]
        
        DW=(exp((-cron[,3])/CDD))**m   # Peso pela dist?ncia euclidiana
        
        W=(1/(cron$Di**p))
        
        W[is.na(W)]=0
        
        PE=sum(W*cron$DATA)/sum(W)
        
        aux=data.frame(coord.int[2],coord.int[1],PE)
        INTER.aux=rbind(aux,INTER.aux)
        j=j+1
        
      }
      colnames(INTER.aux)=c("Lon","Lat","v1")
      
      cor.aux=cor(data.int,rev(INTER.aux$v1))
      vies=mean((data.int-rev(INTER.aux$v1)))
      eb=mean(abs(data.int-rev(INTER.aux$v1)))
      aux=data.frame(INTER.aux$Lon[1],INTER.aux$Lat[2],cor.aux,vies,eb)
      statistics=rbind(aux,statistics)
      j=1
      i=i+1
      print(i/n1)
    } 
  }
  
  
  if (method=="RDW") {
    
    ESTATISTICA=data.frame()
    n1=ncol(data)
    n2=nrow(data)
    i=1
    j=1
    while (i<=n1) {
      
      data.int=data[,i]
      data.est=data[,-i]
      
      coord.int=coord[i,1:2]
      coord.est=coord[-i,1:2]
      
      INTER.aux=data.frame()
      
      while (j<=n2) {
        
        
        V1=data.int[j]
        V2=data.est[j,]
        
        point=data.frame(coord.int[2],coord.int[1]) # Data.frame com as coordenadas do ponto a estimar
        colnames(point)=c("x","y") 
        
        est_coordenadas=data.frame(coord.est[,2],coord.est[,1]) #Data.frame com as coordenadas dos pontos observados
        colnames(est_coordenadas)=c("x","y")
        
        Di=distance(from = point,to=est_coordenadas) #Dist?ncia euclidianda entre os pontos
        
        aux=data.frame(coord.est,Di,V2)
        colnames(aux)=c("Lat","Lon","Di","DATA")
        
        cron=aux[order(aux$Di),]
        
        cron=cron[1:n.station,]
        
        W=((r-cron$Di)/r*cron$Di)**p
        
        W[is.na(W)]=0
        
        PE=sum(W*cron$DATA)/sum(W)
        
        aux=data.frame(coord.int[2],coord.int[1],PE)
        INTER.aux=rbind(aux,INTER.aux)
        j=j+1
        
      }
      colnames(INTER.aux)=c("Lon","Lat","v1")
      
      cor.aux=cor(data.int,rev(INTER.aux$v1))
      vies=mean((data.int-rev(INTER.aux$v1)))
      eb=mean(abs(data.int-rev(INTER.aux$v1)))
      aux=data.frame(INTER.aux$Lon[1],INTER.aux$Lat[2],cor.aux,vies,eb)
      statistics=rbind(aux,statistics)
      j=1
      i=i+1
      print(i/n1)
    } 
    
    
  }
  
  colnames(statistics)=c("Longitude","Latitude","Correlation","Vies","RelativeError")
  
  return(statistics)
  
}