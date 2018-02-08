#Plot trend for number of unique individuals over time
install.packages("Rmisc")
library(tidyverse)
library(Rmisc)

s200_300 <- read.csv("s200_300_180117_180208.csv",header=FALSE)
colnames(s200_300) <- c("ID","Sensor_Code","Time","Address","RSSI","OUI","TS_PARSED")

#Filter addresses which is not identified 
filter_data <- s200_300 %>%
  filter(as.character(OUI) != as.character(Address)) 

filter_data$day_hr <- substr(filter_data$TS_PARSED, 1, 13)
filter_data$hr <-substr(filter_data$TS_PARSED, 11, 13)

filter_data <- filter_data %>%
  group_by(day_hr)%>%
  summarize(uniq_hour=n())
