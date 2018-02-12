#Chord diagram for flow of people between sensors 
install.packages("devtools")
library(chorddiag)
devtools::install_github("mattflor/chorddiag")

#Read in file
s200_300 <- read.csv("s200_300_180117_180208.csv",header=FALSE)
colnames(s200_300) <- c("ID","Sensor_Code","Time","Address","RSSI","OUI","TS_PARSED")

#Filter addresses which is not identified 
filter_data <- s200_300 %>%
  filter(as.character(OUI) != as.character(Address)) 

#Count number of transitions between the sensors in the data set
cross_person <- filter_data%>%
  group_by(Address)%>%
  arrange(Time)%>%
  mutate(prev_sensor = lag(Sensor_Code))%>%
  group_by(Sensor_Code)%>%
  na.omit() %>%
  count(prev_sensor) #creates a data frame with number of transitions
  
#Convert the data frame to a matrix for the chord diagram plot
chordMat = matrix(as.numeric(unlist(cross_person[3])),nrow=2) #will need to be changed when we increase number of sensors
dimnames(chordMat) = list(c('200','300'),c('200','300'))

groupColors <- c("#000000", "#FFDD89", "#957244", "#F26223")
chorddiag(chordMat, groupColors = groupColors, groupnamePadding = 20)
