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

plot(y=finaltable$Global_active_power,
     x=finaltable$DateTime,type="l",
     ylab="Global Active Power (kilowatts)",xlab="")

dev.copy(png,file="plot2.png",width=480,height=480)
dev.off()
