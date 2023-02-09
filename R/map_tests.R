# map tests

library(leaflet)
library(rgdal)
# shape files in working directory for now
guat <- readOGR("shp/gtm_admbnda_adm2_ocha_conred_20190207.shp")

# "guat" is a "SpatialPolygonsDataFrame" object which behaves like a data frame in many ways
# but has lots of other stuff attached

# We add the data to plot directly to this data frame
guat$Values <- runif(nrow(guat))

# to make the choropleth map we have to make a colour scale
bins <- c(0, 0.1, 0.4, 0.7, 0.9, 1)
# colorBin is a leaflet function
pal <- colorBin("YlOrRd", domain = guat$Values, bins = bins)

# labels
labels <- sprintf(
  "<strong>%s</strong><br/>%g",
  guat$ADM2_ES, round(guat$Values, 1)
) |>
  lapply(htmltools::HTML)

# now we can make the map

mp <- leaflet(guat) |>
  addTiles() |>
  addPolygons(
    fillColor = ~pal(Values),
    weight = 2,
    opacity = 1,
    color = "white",
    dashArray = "3",
    fillOpacity = 0.7,
    highlightOptions = highlightOptions(
      weight = 5,
      color = "#666",
      dashArray = "",
      fillOpacity = 0.7,
      bringToFront = TRUE),
    label = labels,
    labelOptions = labelOptions(
      style = list("font-weight" = "normal", padding = "3px 8px"),
      textsize = "15px",
      direction = "auto")) |>
  addLegend(pal = pal, values = ~Values, opacity = 0.7, title = NULL,
            position = "bottomright")

mp
