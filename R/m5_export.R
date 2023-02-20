# MODULE 5: Export

# Required packages -------------------------------------------------------

library(openxlsx)

# Functions ---------------------------------------------------------------

# Simplified export to Excel with some formatting
# Note if we change the index structure this may need adjusting.
f_export_to_excel <- function(coin, fname = "index_export.xlsx"){

  l <- list()

  # Results
  l$Scores <- coin$Results$FullScore
  l$Ranks <- coin$Results$FullRank

  # Structure
  l$Structure <- coin$Meta$Lineage

  # Analysis
  l$Analysis <- coin$Analysis$Raw$FlaggedStats

  # Weights
  l$Weights <- f_get_last_weights(coin)

  # Data sets
  l <- c(l, coin$Data)

  # colours
  tab_colours <- list(
    Results = "green",
    Structure = "orange",
    Analysis = "blue",
    Weights = "yellow",
    Other = "grey"
  )

  # Write
  wb <- openxlsx::createWorkbook()

  options("openxlsx.borderStyle" = "thin")
  options("openxlsx.borderColour" = "white")

  lapply(names(l), function(s){

    if(s %in% c("Scores", "Ranks")){

      addWorksheet(wb, s, tabColour = tab_colours[["Results"]])
      writeData(wb, sheet = s, x = l[[s]])
      writeDataTable(wb, s, x = l[[s]],
                     tableStyle = "TableStyleMedium6",
                     bandedRows = FALSE)

      r_format <- 2: (nrow(l[[s]]) + 1)

      if(s == "Scores"){

        # index score
        conditionalFormatting(
          wb, s, cols = 4, rows = r_format,
          type = "databar")

        # Mov_Hum
        # cols = c(5, 16)
        conditionalFormatting(
          wb, s, cols = 5, rows = r_format,
          style = brewer.pal(n = 3, name = "YlOrRd"),
          type = "colourScale")

        # Amenazas
        # c(6, 9, 10)
        conditionalFormatting(
          wb, s, cols = 6, rows = r_format,
          style = brewer.pal(n = 3, name = "RdPu"),
          type = "colourScale")

        # Sit_SocEc
        # c(7, 17:20)
        conditionalFormatting(
          wb, s, cols = 7, rows = r_format,
          style = brewer.pal(n = 3, name = "PuBuGn"),
          type = "colourScale")

        # Sit_SocEc
        # cols = c(8, 11:15)
        conditionalFormatting(
          wb, s, cols = 8, rows = r_format,
          style = brewer.pal(n = 3, name = "YlGnBu"),
          type = "colourScale")

      }

    } else if (s %in% c("Structure", "Analysis", "Weights")) {

      addWorksheet(wb, s, tabColour = tab_colours[[s]])
      writeData(wb, sheet = s, x = l[[s]])

    } else {

      addWorksheet(wb, s, tabColour = tab_colours[["Other"]])
      writeData(wb, sheet = s, x = l[[s]])
    }

  })

  # write to excel
  saveWorkbook(wb, fname, overwrite = TRUE)

}
