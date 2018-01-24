#Plot for ping frequency for meeting 
library(tidyverse)

onlyIdent <- 
  sensor26jan23 %>%
  filter(as.character(OUI) != as.character(Address)) %>%
  group_by(Address) %>%
  mutate(timeDiff = (Time-lag(Time))) %>%
  filter(timeDiff > 0 & timeDiff <=300)
  
ggplot(aes(timeDiff), data = onlyIdent) + geom_histogram()+
  xlab("Time Difference Between Ping")+ylab("Count")

#Create new column with day, hour and minute
sensor26jan23$day_hr_min <- substr(sensor26jan23$TS_PARSED, 1, 15)

