#Fältstudie 2018-01-23 första sensor försöket nummer 26.


#Läsa in filen
sensor26jan23 <- read.csv("queryResults-23-jan.csv", header = FALSE) 
colnames(sensor26jan23) <- c("ID","Sensor Code","Time","Address","RSSI","OUI","TS_PARSED")
testdata <- subset(sensor26jan23,Time >=1516698600 & Time <=1516705200)
idphase <- subset(sensor26jan23,Time >= 1516703500 & Time <=1516703680)
uniqueOUI <- count(idphase,"OUI")
Simon <- "e581d79354d73e465709e1bd0282c702e7d45395"
simondata <- subset(sensor26jan23,Address == Simon)
jakobdata <- subset(sensor26jan23,Address == "5073d1ff497821b2469d8e7c5c48a4467b013f15")
JakobOUI <- "3451C9"

uniquemac <- count(idphase,"Address")
uniquewhole <- count(sensor26jan23, "Address") 
adresswholeset <- subset(sensor26jan23, Address == "5b38af7487d70082d994732d96922ecada233c60" )
adress23jan <- subset(testdata, Address == "eb087a24b4d40bdf00c5f6d14924ac44adb369ad" )
