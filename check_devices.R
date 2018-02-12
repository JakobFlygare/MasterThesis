#Check for unusual devices and filter them

#Read in data
s200_300 <- read.csv("Sensor_Data/s200_300_180210_180212.csv",header=FALSE)
s200_300_old <- read.csv("Sensor_Data/s200_300_180117_180208.csv",header=FALSE)
colnames(s200_300) <- c("ID","Sensor_Code","Time","Address","RSSI","OUI","TS_PARSED")
colnames(s200_300_old) <- c("ID","Sensor_Code","Time","Address","RSSI","OUI","TS_PARSED")

#Filter out sensor 100 and not identified addresses
s200_300 <- s200_300%>%
  filter(as.character(OUI)!=as.character(Address),Sensor_Code != 2980)

#Add column with day and hour and create variable over the amount of hour the data is gathered for
s200_300$day_hr <- substr(s200_300$TS_PARSED,1,13)
n_hours_data <-as.numeric(difftime(max(as.POSIXct(s200_300$TS_PARSED)),min(as.POSIXct(s200_300$TS_PARSED)),units = "hour"))

#Remove events which have been shorter time than 20000 sec around the sensor
s200_300_time_sensor <- s200_300%>%
  group_by(Address,OUI)%>%
  mutate(num = n())%>%
  arrange(Time)%>%
  mutate(timeDiff = (Time-lag(Time,default = NA)))%>%
  filter(timeDiff <=300) %>%
  summarize(time_at_sensor = sum(timeDiff))%>%
  arrange(time_at_sensor)%>%
  filter(time_at_sensor>=20000)

#Pick out the bad OUI
OUI_warning1 <- unique(s200_300_time_sensor$OUI)

#Remove events which have pinged less than 35% of the time 
s200_300_n_hour <- s200_300%>%
  group_by(Address,OUI)%>%
  mutate(n_hour_ping = n_distinct(day_hr)/n_hours_data)%>%
  filter(n_hour_ping>=0.35)

OUI_warning <- unique(s200_300_n_hour$OUI)

#Filter out bad OUI
s200_300_filter <- s200_300%>%
  filter(!OUI %in% OUI_warning)

