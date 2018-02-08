# loading the required packages
install.packages("ggmap")
library(ggplot2)
library(ggmap)

# creating a sample data.frame with your lat/lon points
lat <- c(59.288373,59.293882)
lon <- c(18.084965,18.079787)
df <- as.data.frame(cbind(lon,lat))

# getting the map
mapgilbert <- get_map(location = c(lon = mean(df$lon), lat = mean(df$lat)), zoom = 16,
                      maptype = "satellite", scale = 2)

# plotting the map with some points on it
ggmap(mapgilbert) +
  geom_point(data = df, aes(x = lon, y = lat, fill = "red", alpha = 0.8), size = 3, shape = 21) +
  guides(fill=FALSE, alpha=FALSE, size=FALSE)

