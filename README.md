# {BuildIndex}

An organized workflow to build __severity index__, aka a composite indicator in line with the commonly used tri-dimensional conceptual framework: 

  1. Vulnerability / Living Standards 
  
  2. Exposure / Coping Mechanisms 
  
  3. Intensity / Physical and Mental Well being 
  
  
The output includes different scenarios to be presented through a _reality-check_ workshop to a local panel of field experts so that they can select the most appropriate one in relation with the context. 


The approach generates Transparency, Robustness & Accuracy as it follows the standards [10 steps approach](https://knowledge4policy.ec.europa.eu/sites/default/files/10-step-pocket-guide-to-composite-indicators-and-scoreboards.pdf) in a reproducible approach, using [coinR package](https://bluefoxr.github.io/COINr/). It also ensures Credibility & Engagement through the effective participation of field experts.

## Install  

```{r}
install.packages("pak")
pak::pkg_install("martinepunhcr/MVI_Guatemala")  
```  

## Use

Create a new project in Rstudio

Create a new file > new R markdown > from template > index_report from {BuildIndex}

In this file, adjust the parameters from the template to get your index based on your own data:

 * __datafolder__: by default `"data-raw"` This is the default folder where to put you data in  
 
 * __data__:  Name of the data excel (.xlsx) file  with the indicator main excel file - following precisely a standard template - see example [here](https://github.com/martinepunhcr/MVI_Guatemala/raw/main/data-raw/data_module-input.xlsx): one worksheet for the indicator and one worksheet for the documentation of aggregation  
 
 * __shp__: name of the shapefile to create the map. The shapefile must include a default field named `"ADM2_PCODE"`, that will be used as the main key to join with  `"admin2Pcode"` within the indicator main excel file


## Next 

a shiny App will be created to ease the index building steps


## Example: Municipal Severity Index Guatemala

UNHCR Guatemala is building a composite indicator to assess the Severity of the 340 municipalities in the country. The main purpose of the index is to better prioritize the municipalities in which UNHCR should do Community-based Protection interventions.

See work-in-progress [here](skeleton.html)

There is an available https://github.com/martinepunhcr/MVI_Guatemala/wiki to review the metadata of all indicators used in the Index
