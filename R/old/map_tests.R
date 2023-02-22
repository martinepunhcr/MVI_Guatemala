# map tests

library(leaflet)
library(rgdal)
# shape files in working directory for now
guat <- readOGR(here::here("inst/shp","gtm_admbnda_adm2_ocha_conred_20190207.shp"))

# "guat" is a "SpatialPolygonsDataFrame" object which behaves like a data frame in many ways
# but has lots of other stuff attached

plot_choropleth <- function(MVI, dset, iCode){

  # get data first
  df_plot <- get_data(MVI, dset = dset, iCodes = iCode)

  # merge into shape df
  guat$Indicator <- df_plot[[iCode]][match(guat$ADM2_PCODE, df_plot$uCode)]

  # colorBin is a leaflet function
  pal <- colorBin("YlOrRd", domain = guat$Indicator, bins = 7)

  # labels
  labels <- sprintf(
    "<strong>%s</strong><br/>%g",
    guat$ADM2_ES, round(guat$Indicator, 1)
  ) |>
    lapply(htmltools::HTML)


  # now we can make the map

  mp <- leaflet(guat) |>
    addTiles() |>
    addPolygons(
      fillColor = ~pal(Indicator),
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
    addLegend(pal = pal, values = ~Indicator, opacity = 0.7, title = NULL,
              position = "bottomright")

  mp

}

