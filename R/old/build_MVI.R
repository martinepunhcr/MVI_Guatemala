# Build MVI (script only)

# packages
library(COINr)
library(readxl)

# this function builds the MVI coin up to "new_coin()".
build_MVI_coin <- function(){

  # Import data

  idata <- read_excel(here::here("inst/data_input","data_input_formatted.xlsx"), sheet = "iData")
  imeta <- read_excel(here::here("inst/data_input","data_input_formatted.xlsx"), sheet = "iMeta")

  # Tidy up inputs (see func below to see what this does if you want to know)
  l <- tidy_inputs(idata, imeta)

  # build coin
  MVI <-new_coin(iData = l$idata, iMeta = l$imeta,
           level_names = c("Indicator", "Category", "Dimension", "Index"))

  # treat outliers
  MVI <- qTreat(MVI, dset = "Raw",
                winmax = 5,
                skew_thresh = 2,
                kurt_thresh = 3.5,
                f2 = "log_CT_plus")

  # normalise to [0, 100]
  MVI <- Normalise(MVI, dset = "Treated")

  # aggregate
  MVI <- Aggregate(MVI, dset = "Normalised")

  # generate results tables (attached to coin, so will appear when exported to Excel)
  MVI <- get_results(MVI, dset = "Aggregated", tab_type = "Full",
                               also_get = "uName", nround = 1, out2 = "coin")
  MVI <- get_results(MVI, dset = "Aggregated", tab_type = "Full", use = "ranks",
                     also_get = "uName", nround = 1, out2 = "coin")

}


# this function adjusts the imeta and idata input so that they are ready
# for COINr.
tidy_inputs <- function(idata, imeta){

  # rename code col
  names(idata)[names(idata) =="admin2Pcode"] <- "uCode"

  # remove indicators with no data
  i_nodata <- names(idata)[colSums(!is.na(idata)) == 0]
  idata <- idata[!(names(idata) %in% i_nodata)]
  imeta <- imeta[!(imeta$iCode %in% i_nodata), ]

  # remove any groups with no children
  no_children <- imeta$iCode[imeta$Type == "Aggregate" & !(imeta$iCode %in% imeta$Parent)]
  imeta <- imeta[!(imeta$iCode %in% no_children), ]

  list(imeta = imeta, idata = idata)

}


