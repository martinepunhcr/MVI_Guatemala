# map tests

library(leaflet)
library(rgdal)
# shape files in working directory for now
guat <- readOGR("shp/gtm_admbnda_adm2_ocha_conred_20190207.shp")

mp <- leaflet(guat) |>
  addTiles() |>
  addPolygons()

mp
