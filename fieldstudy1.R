#Fältstudie 2018-01-23 första sensor försöket nummer 26.


#Läsa in filen
sensor26jan23 <- read.csv("queryResults-23-jan.csv", header = FALSE) 
colnames(sensor26jan23) <- c("ID","Sensor Code","Time","Address","RSSI","OUI","TS_PARSED")
testdata <- subset(sensor26jan23,Time >=1516698600 & Time <=1516705200)
uniquemac <- count(testdata,"Address")
uniquewhole <- count(sensor26jan23, "Address") 
adresswholeset <- subset(sensor26jan23, Address == "e169e5fe25b6097c669ab186d30a4dd02d452ad4" )
adress23jan <- subset(testdata, Address == "e169e5fe25b6097c669ab186d30a4dd02d452ad4" )
