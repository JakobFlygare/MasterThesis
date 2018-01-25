#Investigate the RSSI 

#Most frequent RSSI signals 
ggplot(sensor26jan23, aes(RSSI))+geom_bar()+xlab("RSSI signal")

