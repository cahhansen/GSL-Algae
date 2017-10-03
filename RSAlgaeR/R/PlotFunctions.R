#' plotrecord.errors
#'
#' Plots estimated record with error bars
#'
#' @param data Dataframe with estimated values (value), dates (ImageDate), lake (Lake), lower and upper bounds (lower and upper)
#' @param value string, name of column with water quality values
#' @param date string, name of column with imagery dates
#' @param location string, name of column with location identifiers
#' @param ylab string, label for y axis
#' @import ggplot2
#' @import lubridate
#' @export

plotrecord.errors <- function(data, value, date, location, ylab=expression(paste("Chl-a (",mu,"g/L)"))){
  data$date <- as.Date(data[,date])
  data$value <- data[,value]
  data$location <- data[,location]
  ggplot(data)+geom_point(aes(x=date,y=value,col=as.factor(location)))+
    geom_errorbar(aes(x=ImageDate,ymin=lower,ymax=upper), width=0.2)+
    theme_bw()+scale_color_discrete(name="Location")+
    ggtitle("Modeled Record with Confidence Intervals")+
    xlab("Date")+
    theme(legend.position="bottom")+
    scale_x_date(limits = c(as.Date(paste0(min(year(data$ImageDate)),"-1-1")), as.Date(paste0(max(year(data$ImageDate)),"-12-31"))))
}

#' plotrecord.cal
#'
#' Plots estimated record with calibrated data
#'
#' @param data Dataframe with estimated values (value), dates (ImageDate), lake (Lake), lower and upper bounds (lower and upper)
#' @param caldata Dataframe with data used in Calibration (value, ImageDate, and Lake column)
#' @param value string, name of column with water quality values
#' @param date string, name of column with imagery dates
#' @param location string, name of column with location identifiers
#' @param ylab string, label for y axis
#' @import ggplot2
#' @import lubridate
#' @export

plotrecord.cal <- function(data,caldata,value,date,location,ylab=expression(paste("Chl-a (",mu,"g/L)"))){
  data$date <- as.Date(data[,date])
  data$value <- data[,value]
  data$location <- data[,location]
  caldata$date <- as.Date(caldata[,date])
  ggplot()+geom_point(data=data,aes(x=date,y=value,col=as.factor(location)))+
    geom_point(data=caldata,aes(x=date,y=value))+
    theme_bw()+scale_color_discrete(name="Location")+
    ggtitle("Modeled Values")+
    xlab("Date")+
    theme(legend.position="bottom")+
    scale_x_date(limits = c(as.Date(paste0(min(year(data$ImageDate)),"-1-1")), as.Date(paste0(max(year(data$ImageDate)),"-12-31"))))
}



#' plotrecord
#'
#' Plots estimated and observed data
#'
#' @param data Dataframe with estimated values (value), dates (ImageDate), lake (Lake), lower and upper bounds (lower and upper)
#' @param obsdata Dataframe with Observed Data (Value, ImageDate)
#' @param lake string, Name of Lake
#' @param labels optional for plotting
#' @param ylab string, label for y axis
#' @import ggplot2
#' @import lubridate
#' @export

plotrecord <- function(data,obsdata,lake,labels=TRUE,ylab=expression(paste("Chl-a (",mu,"g/L)"))){
  obsdata$Date <- as.Date(obsdata$Date)
  obsdata <- subset(obsdata, Value >= 0)
  data$Dataset <- as.character(data$Dataset)
  combinedf <- data.frame(Date=c(data$ImageDate,obsdata$Date),
                          Value=c(data$value,obsdata$Value),
                          Dataset=c(data$Dataset,rep("Observed",nrow(obsdata))))
  p <- ggplot(data=combinedf,aes(x=Date,y=Value))+
    geom_point(aes(fill=as.factor(Dataset)),pch=21,colour="black")+
    theme_bw()+
    scale_x_date(limits = c(as.Date(paste0(min(year(data$ImageDate)),"-1-1")), as.Date(paste0(max(year(data$ImageDate)),"-12-31"))))

  if(labels==FALSE){
    p <- p+
      xlab("")+
      ylab("")+
      scale_fill_manual(values=c('white','red'),
                        name="Dataset",
                        breaks=c("Estimated","Observed"),
                        labels=c("Estimated","Observed"))

    return(p)

  }else{
    p <- p+
      ggtitle(paste("Historical Record",":",lake))+
      xlab("Date")+
      theme(legend.position="bottom")+
      scale_fill_manual(values=c('white','red'),
                        name="Dataset",
                        breaks=c("Estimated","Observed"),
                        labels=c("Estimated","Observed"))
    print(p)
  }

}
