#install.packages("leaflet")
# to install the development version from Github, run
# devtools::install_github("rstudio/leaflet")
#GUIDE: https://rstudio.github.io/leaflet/
library(leaflet)
library(htmltools)
library(htmlwidgets)
library(dplyr)

data_180117_180208 <- read.csv("Sensor_Data/s200_300_180117_180208.csv",header=FALSE)
colnames(data_180117_180208) <- c("ID","Sensor_Code","Time","Address","RSSI","OUI","TS_PARSED")

coord_200 = c(59.291773,18.081157)
max_coord_200 = c(59.291773,18.081157)
min_coord_200 = c(59.292020, 18.081811)

coord_300 = c(59.288639,18.085545)
min_coord_300 = c(59.288167, 18.085277)
max_coord_300 = c(59.288731, 18.085352)

#Filter addresses which is not identified 
coord_data_180117_180208 <- data_180117_180208 %>%
  filter(as.character(OUI) != as.character(Address)) %>%
  mutate(long = ifelse(Sensor_Code == '300',coord_300[1],coord_200[1]), lat = ifelse(Sensor_Code == '300',coord_300[2],coord_200[2]))


heatPlugin <- htmlDependency("Leaflet.heat", "99.99.99",
                             src = c(href = "http://leaflet.github.io/Leaflet.heat/dist/"),
                             script = "leaflet-heat.js"
)

registerPlugin <- function(map, plugin) {
  map$dependencies <- c(map$dependencies, list(plugin))
  map
}

lat <- c(59.288373,59.293882)
lon <- c(18.084965,18.079787)

data_coord <- filter_data

leaflet() %>% addTiles() %>%
  fitBounds(min(18.079787), min(59.288373), max(18.084965),     max(59.293882)) %>%
  registerPlugin(heatPlugin) %>%
  onRender("function(el, x, data) {
           data = HTMLWidgets.dataframeToD3(data);
           data = data.map(function(val) { return [val.lat, val.long, val.mag*100]; });
           L.heatLayer(data, {radius: 25}).addTo(this);
           }", data = quakes %>% select(lat, long, mag))