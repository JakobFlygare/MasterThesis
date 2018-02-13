#install.packages("leaflet")
# to install the development version from Github, run
# devtools::install_github("rstudio/leaflet")
#GUIDE: https://rstudio.github.io/leaflet/

library(leaflet)

m <- leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addMarkers(lng=174.768, lat=-36.852, popup="The birthplace of R")
m  # Print the map
