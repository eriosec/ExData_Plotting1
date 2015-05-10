library(lubridate)
library(data.table)
con<-file("household_power_consumption.txt","r")
hhheader<-read.table(con,sep=";",nrows=1,stringsAsFactors=FALSE)
close(con)
household<-read.table("household_power_consumption.txt",
                      sep=";", na.strings="?",
                      colClasses=c("character",
                                   "character","numeric","numeric",
                                   "numeric","numeric","numeric",
                                   "numeric","numeric"), nrows=2880,skip=66637)
names(household)<-hhheader
hh1<-household[,1:2]
hh2<-household[,3:9]
hh0<-(household[1:2])
hh0table<-(as.data.table(hh0))
hh0table[,DateTime:=paste(Date,Time)]
finaltable<-cbind(hh0table$DateTime, hh2)
colnames(finaltable)[1]<-c("DateTime")
finaltable[1]<-lapply(finaltable[1],as.character)
finaltable[1]<-lapply(finaltable[1],
                      function(x) strptime(x,"%d/%m/%Y %H:%M:%S"))
library(datasets)

plot(x=finaltable$DateTime,
     y=finaltable$Sub_metering_1,type="n",
     xlab="",ylab="Energy sub metering")
plot(x=finaltable$DateTime,
     y=finaltable$Sub_metering_1,type="l",
     xlab="",ylab="Energy sub metering")
lines(x=finaltable$DateTime,
      y=finaltable$Sub_metering_2,type="l",
      xlab="",ylab="Energy sub metering",col="red")
lines(x=finaltable$DateTime,
      y=finaltable$Sub_metering_3,type="l",
      xlab="",ylab="Energy sub metering",col="blue")
legend("topright",
       legend=c("Sub_metering_1",
                "Sub_metering_2",
                "Sub_metering_3"),
       lty=c(1,1,1),
       col=c("black","red","blue"),
       cex=0.70)
dev.copy(png,file="plot3.png",width=480,height=480)
dev.off()