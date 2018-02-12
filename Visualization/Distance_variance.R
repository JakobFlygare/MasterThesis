#Obtain data points between a certain interval of time
library(tidyverse)
library(lubridate)
datafile<- read.csv("queryResults-23-jan.csv", header = FALSE) 
colnames(datafile) <- c("ID","Sensor_Code","Time","Address","RSSI","OUI","TS_PARSED")

simon_data <- read.csv("simon29jan.csv",header=FALSE)
colnames(simon_data) <- c("ID","Sensor_Code","Time","Address","RSSI","OUI","TS_PARSED")
simon_data$TS_PARSED <- as.POSIXct(simon_data$TS_PARSED)+3600

test_prot <- read_csv("s300_29jan.csv")
test_prot$Starttime <- force_tz(test_prot$Starttime, "CET")
test_prot$Endtime <- force_tz(test_prot$Endtime, "CET")


#Specify the parameters of the data filtering
address <- "e581d79354d73e465709e1bd0282c702e7d45395"
starttime <- as.POSIXct("2018-01-29 09:22:03")
endtime <- as.POSIXct("2018-01-23 15:28:03")
distance <- 0 #only used for the data table

#Select data over time period for all affected sensors
simon_data29 <- 
  simon_data %>%
  filter(as.POSIXct(TS_PARSED) > starttime) %>%
  arrange(Time)

#Plot the data points over time
daytime <- as.POSIXct(simon_data29$TS_PARSED) #Why do we need to add 3600 here?
ggplot(simon_data29,aes(x= as.POSIXct(TS_PARSED)+3600, y = RSSI, colour = factor(Sensor_Code)))+geom_point() + 
  scale_x_datetime(date_label = "%H:%M")+labs(x= " ",colour='Sensor')

#Compute variance for a sensor at a given range
var_distance <-
  simon_data29 %>%
  filter(Address == address & as.POSIXct(TS_PARSED) > as.POSIXct(test_prot$Starttime[1]) & as.POSIXct(TS_PARSED) < as.POSIXct(test_prot$Endtime[length(test_prot$Endtime)]) & Sensor_Code == '300') %>%
  arrange(Time) %>%
  select(Sensor_Code,RSSI, Time, TS_PARSED)

#Add distance from time interval in test data
for (i in 1:length(test_prot$Starttime)){
  for (n in 1:length(var_distance$TS_PARSED)){
    if (as.POSIXct(var_distance$TS_PARSED[n])>as.POSIXct(test_prot$Starttime[i]) & as.POSIXct(var_distance$TS_PARSED[n])<as.POSIXct(test_prot$Endtime[i])){
      var_distance$Distance[n] = test_prot$Distance[i] 
    }
  }
}

ggplot(var_distance,aes(x= as.POSIXct(TS_PARSED)+3600, y = RSSI, colour = factor(Distance)))+geom_point() + 
  scale_x_datetime(date_label = "%H:%M")+labs(x= " ",colour='Distance m')

ggplot(var_distance,aes(x=Distance,y=RSSI))+geom_point()+geom_smooth(span = 0.3)

ggplot(aes(RSSI), data = var_distance) + geom_histogram(binwidth = 10)+
  xlab("RSSI")+ylab("Count")  

var(var_distance$RSSI)
sd(var_distance$RSSI)
