#Plot trend for number of unique individuals over time
library(tidyverse)

s200_300 <- read.csv("s200_300_180117_180208.csv",header=FALSE)
colnames(s200_300) <- c("ID","Sensor_Code","Time","Address","RSSI","OUI","TS_PARSED")

#Filter addresses which is not identified 
filter_data <- s200_300 %>%
  filter(as.character(OUI) != as.character(Address)) 

#Add column with day and hour
filter_data$day_hr <- substr(filter_data$TS_PARSED, 1, 13)

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
  geom_line() +
  geom_point() +
  xlab("Hour of the Day") +
  ylab("Average Number of Unique Devices")+
  scale_colour_discrete(name  ="Sensor Code")

#Bar plot for number of unique devices per day and hour for both sensors
ggplot(uniq_per_day_hour,aes(x=day_hr, y=num,colour = factor(Sensor_Code)))+
  geom_bar(stat="identity",fill="white") +
  scale_colour_discrete(name  ="Sensor Code")+
  xlab("Day and Hour")+
  ylab("Number of Unique Devices")

#Not finished plot. Want to show line for all devices and unique devices in same plot
ggplot(uniq_per_day_hour,aes(x=day_hr,group=Sensor_Code))+
  geom_line(aes(y=num,colour = "All Devices"))+
  geom_line(aes(y=u_num,colour = "Unique Devices"))
