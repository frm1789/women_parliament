library(readr)
library(dplyr)
library(viridis)
library(viridisLite)
library(leaflet)
library(geojsonio)
library(countrycode)
library(pretty)

# get data for map
json_api <- "https://raw.githubusercontent.com/PublicaMundi/MappingAPI/master/data/geojson/countries.geojson"
mundo <- geojson_read(json_api, what = "sp")

# get info about percentage of women in parliament
url_wom <- 'https://raw.githubusercontent.com/frm1789/women_parliament/master/data_women_parliament_2017.csv'
df_wom <- read_csv(url(url_wom))



##Complete mundo@data w/info about women in parliament
mundo@data <- left_join(mundo@data, df_wom, by = c("id"="country_code"))
mundo@data$name <- as.character(mundo@data$name)

##Adding colors
bins <- c(0, 10, 20, 40, 60, 80, 100)
pal <- colorBin("Purples", domain = mundo@data$percentage, bins = bins)

casecountpopup <- paste0("<strong>", mundo@data$name, "</strong>", "<br>", "Percentage of women: ", mundo@data$percentage)


m <- leaflet(data = mundo) %>%
  addPolygons(fillColor = ~pal(percentage), 
              fillOpacity = 0.9, 
              color = "white", 
              weight = 1,
              popup = casecountpopup) %>%
  addLegend(position = "bottomleft",pal = pal, values = ~percentage, title = "<strong>Women in Parliament</strong><br>2017") %>%
  setView(lat = 18.8634698, lng = -13.301653, zoom = 2)
m %>% addProviderTiles(providers$CartoDB.Positron)

