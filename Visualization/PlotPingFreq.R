#Plot for ping frequency for meeting 
install.packages("data.table")
library(tidyverse)
require(data.table)

s200_300 <- read.csv("Sensor_Data/s200_300_20180210.csv",header=FALSE)
colnames(s200_300) <- c("ID","Sensor_Code","Time","Address","RSSI","OUI","TS_PARSED")


onlyIdent <- 
  s200_300 %>%
  filter(as.character(OUI) != as.character(Address)) %>%
  group_by(Address) %>%
  arrange(Time)%>%
  mutate(timeDiff = (Time-lag(Time,default = NA))) %>%
  filter(timeDiff <=300) 
   

onlyIdent$n <- onlyIdent$n+1   
  
ggplot(aes(timeDiff), data = onlyIdent) + geom_histogram(binwidth = 10)+
  xlab("Time Difference Between Ping")+ylab("Count")

summary(onlyIdent)

#Create new column with day, hour and minute
sensor26jan23$day_hr_min <- substr(sensor26jan23$TS_PARSED, 1, 15)

#Create Number of times pinged for each individual during a time interval
intrvl = 300
ping_freq <- onlyIdent %>%
  group_by(Address) %>%
  mutate(interval = floor((Time - min(Time))/intrvl)+1) %>%
  group_by(interval, add = TRUE) #%>%
  summarize(startDate = min(Time),
            endDate = (startDate + intrvl -1),
            frequency = n()) #%>%
  select(-interval)

ggplot(ping_freq, aes(frequency))+geom_bar()

mean(ping_freq$frequency)

