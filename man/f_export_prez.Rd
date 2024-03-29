% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/f_export_prez.R
\name{f_export_prez}
\alias{f_export_prez}
\title{Generate an html prez}
\usage{
f_export_prez(datafolder, data, shp, folder = "Report")
}
\arguments{
\item{datafolder}{"data-raw" ## This is the default folder where to put you data in}

\item{data}{"data_module-input.xlsx" ## Name of the data file}

\item{shp}{name of the shapefile to create the map
for instance "gtm_admbnda_adm2_ocha_conred_20190207.shp"}

\item{folder}{folder within your project where to put the generated prez. 
Folder will be created if it does not exist}
}
\value{
nothing the file for the prez is generated
}
\description{
This functions provides a quick access to a basic prez to generate severity index 
according multiple scenario
}
\examples{

# f_export_prez( 
    ## This is the default folder where to put you data in
    #      datafolder = "data-raw",
    ## Name of the data file
    #      data = "data_module-input.xlsx",
    ## name of the shapefile to create the map
    #      shp = "gtm_admbnda_adm2_ocha_conred_20190207.shp", 
    #      folder = "Report")
}
