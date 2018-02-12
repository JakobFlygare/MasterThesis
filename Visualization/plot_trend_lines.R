#Plot trend for number of unique individuals over time
library(tidyverse)
library(lubridate)
library(scales)
library(zoo)

s200_300 <- read.csv("Sensor_Data/s200_300_180117_180208.csv",header=FALSE)
colnames(s200_300) <- c("ID","Sensor_Code","Time","Address","RSSI","OUI","TS_PARSED")

#Filter addresses which is not identified 
filter_data <- s200_300 %>%
  filter(as.character(OUI) != as.character(Address)) 

#Add column with day and hour
filter_data$day_hr_min <- substr(filter_data$TS_PARSED, 1, 15)
filter_data$day_hr <- substr(filter_data$TS_PARSED, 1, 13)
filter_data$day <- substr(filter_data$TS_PARSED, 1, 10)

#Count number of unique devices within each day and hour for the sensors
uniq_per_day_hour <- filter_data %>% 
  select(day_hr,Address,Sensor_Code) %>% 
  group_by(day_hr,Sensor_Code) %>% 
  summarise(num = n(),u_num=n_distinct(Address))

#Add a column displaying only the hour of the day
uniq_per_day_hour$h <- substr(uniq_per_day_hour$day_hr,11,13)

#Create standard deviation, mean and confidence 95% for each hour of the day
mean_sd_num_hr<- uniq_per_day_hour%>%
  group_by(h,Sensor_Code)%>%
  summarise(sd = sd(u_num),mean_num = mean(u_num),n=n())%>%
  mutate(ci = sd/sqrt(n)*qt(0.975,df=n-1))

#Plot the mean and 95% confidence interval for average number of unique devices every hour of the day
ggplot(mean_sd_num_hr, aes(x=h, y=mean_num, colour=factor(Sensor_Code),group=Sensor_Code)) + 
  geom_errorbar(aes(ymin=mean_num-ci, ymax=mean_num+ci), width=0.5) +
  geom_smooth()+
  geom_line() +
  geom_point() +
  xlab("Hour of the Day") +
  ylab("Average Number of Unique Devices")+
  scale_colour_discrete(name  ="Sensor Code")

mean_two_h = rollmean(uniq_per_day_hour$u_num,k=2)

ggplot(subset(uniq_per_day_hour,Sensor_Code %in% c("300")),aes(mean_two_h))+
  #geom_histogram(stat="identity") +
  #geom_smooth(se=FALSE)+
  geom_line()+
  scale_colour_discrete(name  ="Sensor Code")+
  xlab("Day and Hour")+
  ylab("Number of Unique Devices")


#Create number of unique and all pinged devices for each day
uniq_per_day <- filter_data %>% 
  select(day,Address,Sensor_Code) %>% 
  group_by(day,Sensor_Code) %>% 
  summarise(num = n(),u_num=n_distinct(Address))

#Plot number of unique devices for each day
ggplot(uniq_per_day, aes(x=as.Date(day),y=u_num,group = Sensor_Code,colour = factor(Sensor_Code)))+
  geom_point()+
  geom_line()+
  scale_x_date(labels = date_format("%d/%m"))+
  theme(axis.text.x = element_text(angle=90))+
  xlab("Day")+
  ylab("Number of Unique Devices")+
  scale_colour_discrete(name  ="Sensor_Code")

#Distribution for each day in the data, binwidth 600 = 10 min
ggplot(filter_data,aes(as_datetime(Time))) +
  geom_freqpoly(binwidth = 600)

#Some kind of distribution over the day for all days in the data
filter_data %>%
  mutate(TS_time = update(as.POSIXct(TS_PARSED), yday = 1)) %>%
  distinct(Address,.keep_all = TRUE)%>%
  ggplot(aes(TS_time)) +
  geom_freqpoly(binwidth = 300)
