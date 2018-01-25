library(readr)
library(tidyverse)
raspdata<- read_csv("csv_dump.txt",col_names = c("Time","Address","RSSI","SS_ID") )

pingrasp <- raspdata %>%
  filter(is.na(SS_ID)) %>%
  group_by(Address) %>%
  arrange(Time) %>%
  mutate(TimeLag = Time - lag(Time,default = NA)) %>%
  filter(TimeLag >1 & TimeLag <1000)

ggplot(pingrasp,aes(TimeLag)) + geom_histogram(binwidth=10) +xlab("Time between pings(sec)") +
  ylab("Count") +ggtitle("Histogram over time between pings from same device")

mean(pingrasp$TimeLag)
median(pingrasp$TimeLag)
summary(pingrasp$TimeLag)

#Calculating how often a device is pinged in a 5-minute window
intrvl <- 300 #interval set to 5 minutes
nrpings <- pingrasp %>%
  group_by(Address) %>%
  mutate(interval = floor((Time-min(Time))/intrvl) +1) %>%
  group_by(interval, add = TRUE) %>%
  summarize(startDate = min(Time),
            endDate = (startDate + intrvl -1),
            frequency = n()) %>%
  select(-interval)

ggplot(nrpings,aes(frequency)) + geom_bar() +xlab("Nr of pings within 5 minutes") +
  ylab("Count") +ggtitle("Histogram for amount of pings for a device during a time period")

# fkldasflks jflkjsd lkjlksdjflasjd 
