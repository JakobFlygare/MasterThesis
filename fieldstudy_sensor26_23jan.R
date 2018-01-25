#Fältstudie 2018-01-23 första sensor försöket nummer 26.
install.packages("tidyverse")
install.packages("plyr")
install.packages("ggplot2")
install.packages("lubridate")
library(tidyverse)

#Läsa in filen
sensor26jan23 <- read.csv("queryResults-23-jan.csv", header = FALSE) 
colnames(sensor26jan23) <- c("ID","Sensor Code","Time","Address","RSSI","OUI","TS_PARSED")
testdata <- subset(sensor26jan23,Time >=1516698600 & Time <=1516705200)
idphase <- subset(sensor26jan23,Time >= 1516703500 & Time <=1516703680)
uniqueOUI <- count(idphase,"OUI")
uniqueAddress <- count(sensor26jan23,"Address")


Simon <- "e581d79354d73e465709e1bd0282c702e7d45395"
simondata <- subset(sensor26jan23,Address == Simon)
JakobMacBook <- "5073d1ff497821b2469d8e7c5c48a4467b013f15"
jakobdata <- subset(sensor26jan23,Address == JakobMacBook)

ggplot(simondata,aes(x=TS_PARSED, y=RSSI, size=RSSI))+geom_point()

#Identify our devices and common devices in the data sets
idphase_address <- count(idphase,"Address")
whole_address <- count(sensor26jan23, "Address") 

#Look up specific addresses
addresswholeset <- subset(sensor26jan23, Address ==  address)
address23jan <- subset(testdata, Address == "eb087a24b4d40bdf00c5f6d14924ac44adb369ad" )

#Söka pingfrekvens för andra enheter
address <- "c7824f65bad4a1d550df91951c1e27ec91a238e7"
mostCommonDevice <- subset(sensor26jan23, Address == "c7824f65bad4a1d550df91951c1e27ec91a238e7")

ggplot(sensor26jan23,aes(Time))+geom_histogram(binwidth = 200)
ggplot(sensor26jan23,aes(RSSI))+geom_histogram()

#Adding hours as a column
sensor26jan23hours<- cbind(sensor26jan23,hour(as.POSIXct(sensor26jan23[,7])))

