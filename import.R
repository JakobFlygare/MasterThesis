library(readr)

## script finally works - uploaded 16 jan 10:18 - everything that had arrived prior
## to the stop on the NI side

## note dashDB seems to care only about the order of columns and it's really picky

events <- read_csv('events.csv', col_names=c('sensor_code', 'time', 'address', 'rssi', 'OUI'))

tot <- nrow(events)
events <- unique(events)
tot.unique <- nrow(events)


## no duplicate rows.
names(events) <- c('SENSOR_CODE', 'TIME', 'ADDRESS', 'RSSI', 'OUI')

events$SOURCE = 'NI'

events$TS_PARSED <- as.POSIXct(events$TIME, origin="1970-01-01")

nrow(events)
unique(events)
ids <- data.frame(ID=1:tot.unique)

events <- cbind(ids, events)
events$TS_ARRIVED = events$TS_PARSED

write.csv(events, file='events-out.csv', row.names=F)



events_n <- read_csv('queryResults-23-jan.csv', col_names=c('ID', 'sensor_code', 'time', 'address', 'rssi', 'OUI', 'ts_parsed'))
