# MODULE 1: DATA INPUT


# Required packages -------------------------------------------------------

suppressMessages({
  library(readxl)
  library(COINr)
  library(plotly)
})


# Functions ---------------------------------------------------------------


# Reads an Excel file found at `file_path` which is expected to be in a specific
# format. See "./data_input/data_module-input.xlsx" for example.
# Outputs a constructed coin.
#
# Example: MVI <- f_data_input("./data_input/data_module-input.xlsx")
#
f_data_input <- function(file_path){

  # Settings ----

  # anchor points in spreadsheet
  idata_topleft <- c(5, 1)
  imeta_topleft <- c(1, 3)
  imeta_botleft <- c(5, 3)

  # col names to look for
  ucode_name <- "admin2Pcode"
  uname_name <- "Name"


  # Read in data ----

  iData <- read_excel(
    path = file_path, sheet = "Data",
    range = cell_limits(ul = idata_topleft, lr = c(NA, NA))
    )
  iMeta <- read_excel(
    path = file_path, sheet = "Data",
    range = cell_limits(ul = imeta_topleft,
                        lr = c(imeta_botleft[1], NA)),
    col_names = FALSE
  ) |> suppressMessages()

  # Tidy iData ----

  names(iData)[names(iData) == ucode_name] <- "uCode"
  names(iData)[names(iData) == uname_name] <- "uName"


  # Tidy and merge metadata ----

  # tidy existing
  iMeta <- as.data.frame(t(iMeta))
  names(iMeta) <- c("Weight", "Direction", "Parent", "iName", "iCode")
  iMeta$Weight <- as.numeric(iMeta$Weight)
  iMeta$Direction <- as.numeric(iMeta$Direction)
  row.names(iMeta) <- NULL

  # add cols (ready for merge)
  iMeta$Level <- 1
  iMeta$Type <- "Indicator"

  # merge with aggregate levels
  iMeta_aggs <- readRDS("./data_input/iMeta_aggs.RDS")
  iMeta <- rbind(iMeta, iMeta_aggs)


  # Further tidying ----

  # remove indicators with no data

  i_nodata <- names(iData)[colSums(!is.na(iData)) == 0]
  iData <- iData[!(names(iData) %in% i_nodata)]
  iMeta <- iMeta[!(iMeta$iCode %in% i_nodata), ]

  if(length(i_nodata) > 0){
    message("Removed indicators with no data points: ",
            paste0(i_nodata, collapse = ", "))
  }

  # remove any second-level groups with no children

  no_children_1 <- iMeta$iCode[iMeta$Level == 2 & !(iMeta$iCode %in% iMeta$Parent)]
  iMeta <- iMeta[!(iMeta$iCode %in% no_children_1), ]

  if(length(no_children_1) > 0){
    message("Removed categories containing no indicators: ",
            paste0(no_children_1, collapse = ", "))
  }

  # remove any third-level groups with no children

  no_children_2 <- iMeta$iCode[iMeta$Level == 3 & !(iMeta$iCode %in% iMeta$Parent)]
  iMeta <- iMeta[!(iMeta$iCode %in% no_children_1), ]

  if(length(no_children_2) > 0){
    message("Removed dimensions containing no categories: ", no_children_2,
            paste0(no_children_2, collapse = ", "))
  }


  # Build coin and output ----

  new_coin(iData, iMeta, quietly = TRUE,
           level_names = c("Indicator", "Category", "Dimension", "Index"))

}

f_print_coin <- function(coin){

  cat("----------\n")
  cat("Your data:\n")
  cat("----------\n")
  # Input
  # Units
  firstunits <- paste0(utils::head(coin$Data$Raw$uCode, 3), collapse = ", ")
  if(length(coin$Data$Raw$uCode)>3){
    firstunits <- paste0(firstunits, ", ...")
  }

  # Indicators
  iCodes <- coin$Meta$Ind$iCode[coin$Meta$Ind$Type == "Indicator"]
  firstinds <- paste0(utils::head(iCodes, 3), collapse = ", ")
  if(length(iCodes)>3){
    firstinds <- paste0(firstinds, ", ...")
  }

  cat("Input:\n")
  cat("  Units: ", nrow(coin$Data$Raw), " (", firstunits, ")\n", sep = "")
  cat(paste0("  Indicators: ", length(iCodes), " (", firstinds, ")\n\n"))

  # Structure
  fwk <- coin$Meta$Lineage

  cat("Structure:\n")

  for(ii in 1:ncol(fwk)){

    codes <- unique(fwk[[ii]])
    nuniq <- length(codes)
    first3 <- utils::head(codes, 3)
    if(length(codes)>3){
      first3 <- paste0(first3, collapse = ", ")
      first3 <- paste0(first3, ", ...")
    } else {
      first3 <- paste0(first3, collapse = ", ")
    }

    # colnames are level names
    levnames <- colnames(fwk)
    # check if auto-generated, if so we don't additionally print.
    if(levnames[1] == "Level_1"){
      levnames <- NULL
    }

    if(ii==1){
      cat(paste0("  Level ", ii, " ", levnames[ii], ": ", nuniq, " indicators (", first3,") \n"))
    } else {
      cat(paste0("  Level ", ii, " ", levnames[ii], ": ", nuniq, " groups (", first3,") \n"))
    }

  }
  cat("\n")

}


#' Interactive sunburst plot of index structure
#'
#' Plots the structure of the index using a sunburst plot using **plotly**.
#'
#' @param COIN COIN object, or list with first entry is the indicator metadata, second entry is the aggregation metadata
#' @param seg_cols A character vector of colour codes, one for each segment in the plot. The length of this
#' vector must be equal to the number of segments, i.e. the sum of the number of indicators and aggregates
#' in each level.
f_plot_framework <- function(coin, seg_cols = NULL){

  # get iMeta
  iMeta <- coin$Meta$Ind

  # check if EffWeight present, if not, get
  if(is.null(iMeta$EffWeight)){
    coin <- get_eff_weights(coin, out2 = "coin")
    # get iMeta
    iMeta <- coin$Meta$Ind[!is.na(coin$Meta$Ind$Parent), ]
  }

  iMeta$EffWeight <- round(iMeta$EffWeight, 2)

  if(is.null(seg_cols)){
    fig <- plotly::plot_ly(
      labels = iMeta$iCode,
      parents = iMeta$Parent,
      values = iMeta$EffWeight,
      type = 'sunburst',
      branchvalues = 'total'
    )
  } else {
    stopifnot(is.vector(seg_cols),
              is.character(seg_cols))
    if(length(seg_cols) != length(outW$LabelsParents$Labels)){
      stop("seg_cols is the wrong length: it needs to be a character vector of colour codes that is
           the same length as the sum of all elements of the structure, in this case length should be ",
                  length(outW$LabelsParents$Labels))
    }
    fig <- plotly::plot_ly(
      labels = iMeta$iCode,
      parents = iMeta$Parent,
      values = iMeta$EffWeight,
      type = 'sunburst',
      branchvalues = 'total',
      marker = list(colors = seg_cols)
    )
  }

  fig

}
