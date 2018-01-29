#Obtain data points between a certain interval of time
library(tidyverse)
library(lubridate)
datafile<- read.csv("queryResults-23-jan.csv", header = FALSE) 
colnames(datafile) <- c("ID","Sensor_Code","Time","Address","RSSI","OUI","TS_PARSED")
datafile$TS_PARSED <- as.POSIXct(datafile$TS_PARSED) + 3600

#Specify the parameters of the data filtering
address <- "e581d79354d73e465709e1bd0282c702e7d45395"
starttime <- as.POSIXct("2018-01-23 09:22:03")
endtime <- as.POSIXct("2018-01-23 15:28:03")
distance <- 0 #only used for the data table

#Select data over time period for all affected sensors
time_window <- 
  datafile %>%
  filter(Address == address & as.POSIXct(TS_PARSED) > starttime & as.POSIXct(TS_PARSED) < endtime) %>%
  arrange(Time) %>%
  select(Sensor_Code,RSSI, Time, TS_PARSED)

#Testar lägga til en rad med ny sensor kod för att testa skriptet nedan
time_window <-
time_window %>% 
  add_row(Sensor_Code = 400 , RSSI = -75, Time = 1516703762, TS_PARSED = '2018-01-23 10:36:02')

#Plot the data points over time
daytime <- as.POSIXct(time_window$TS_PARSED) + 3600
ggplot(time_window,aes(x= daytime + 3600, y = RSSI, colour = factor(Sensor_Code)))+geom_point() + 
  scale_x_datetime(date_label = "%H:%M")+labs(x= " ",colour='Sensor')

#Compute variance for a sensor at a given range
int1=ymd_hms("2018-01-23 14:02:24")
int2=ymd_hms("2018-01-23 15:02:24")
inttest=ymd_hms("2018-01-23 14:22:24")

var_distance <-
  datafile %>%
  filter(Address == address) %>%
  arrange(Time) %>%
  select(Sensor_Code,RSSI, Time, TS_PARSED) %>%
  group_by(as.POSIXct(TS_PARSED)  %within% interval(ymd_hms(variance_test$Starttime),ymd_hms(variance_test$Endtime))) %>%
  add_tally()
  
ggplot(aes(RSSI), data = var_distance) + geom_histogram(binwidth = 10)+
  xlab("RSSI")+ylab("Count")  

var(var_distance$RSSI)
sd(var_distance$RSSI)
