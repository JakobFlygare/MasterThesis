library(dplyr)
library(ggplot2)
library(zoo)
library(tidyr)


events$day = as.Date(events$TS_PARSED)
events$day_hr <- substr(events$TS_PARSED, 1, 13)

per_day <- events %>% 
  group_by(day, SENSOR_CODE) %>% 
  summarise(num = n()) %>% 
  spread(SENSOR_CODE, num, fill=NA)

z <- zoo(per_day[,2:4], order.by = per_day$day)

plot(z, type="b")

per_hour <- events %>% 
  filter(SENSOR_CODE == '300') %>% 
  group_by(day_hr) %>% 
  summarise(num = n())

vis_per_day <- events %>% 
  filter(SENSOR_CODE == '300') %>% 
  select(day, ADDRESS) %>% 
  unique() %>% 
  group_by(day) %>% 
  summarise(num = n())

pings_per_vis_22_dec <- events %>% 
  filter(SENSOR_CODE == '300') %>% 
  filter(day == '2017-12-22') %>% 
  select(ADDRESS) %>% 
  group_by(ADDRESS) %>% 
  summarise(num = n())


ggplot(aes(x=day_hr, y=num), data=per_hour) +
  geom_bar(stat = "identity")

ggplot(aes(x=day, y=num), data=vis_per_day) +
  geom_bar(stat = "identity")

hist(per_hour$num, breaks=30)


events_n$day = as.Date(events_n$ts_parsed)
events_n$day_hr <- substr(events_n$ts_parsed, 1, 13)

per_hour_n <- events_n %>% 
  filter(sensor_code == '300') %>% 
  group_by(day_hr) %>% 
  summarise(num = n())

hist(per_hour_n$num, breaks=30)

ggplot(aes(x=day_hr, y=num), data=per_hour_n) +
  geom_bar(stat = "identity")
