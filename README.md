# {[BuildIndex](https://martinepunhcr.github.io/MVI_Guatemala/)}


## Problem Statement


To be able to reach, properly assess and understand local dynamics, vulnerabilities and capacities of the displaced and host populations alike, humanitarian organisations are increasingly using sub-national [Area Based Approach](https://www.humanitarianlibrary.org/collection/implementing-area-based-approaches). Area based approaches define "*an area, rather than a sector or target group, as a primary entry point*". Such approach is particularly appropriate when residents in an affected area face complex, inter-related and multisectoral needs, resulting in risk of forced displacement. Severity index informs therefore comparison of needs across geographic areas, which can help to prioritise interventions. The challenge is to summarize and condense the information of a plurality of underlying indicators into a single measure, in a way that accurately reflects the underlying concept.

However the calculation of Humanitarian Severity Index comes with challenges: 

> "we end up relying on a lot of expert judgment, which in effect means that we’re faking it--we have a process and looks like it’s very rigorous, and in the end is just being done by people’s...assumptions."

Conceptual and statistical flaws during the creation of Humanitarian Severity Index can greatly limit its usefulness. __While there are no magic formula to establish a single right way to calculate the index, there are definitely risks to make mistakes when selecting, treating and aggregating data__. The main challenge is therefore to allow for a process that will be based on the expert judgement but framed within a set of aggregation options where people assumptions will be balanced by quantitative data properly selected and treated in a fully auditable way. 


## Solution: a guided workflow


An organized workflow to build __severity index__, aka a composite indicator in line with the commonly used tri-dimensional conceptual framework: 

  1. Vulnerability / Living Standards 
  
  2. Exposure / Coping Mechanisms 
  
  3. Intensity / Physical and Mental Well being 
  
The output includes different scenarios to be presented through a _reality-check_ workshop to a local panel of field experts so that they can select the most appropriate one in relation with the context. 

The approach generates Transparency, Robustness & Accuracy as it follows the standards [10 steps approach](https://knowledge4policy.ec.europa.eu/sites/default/files/10-step-pocket-guide-to-composite-indicators-and-scoreboards.pdf) in a reproducible approach, using [coinR package](https://bluefoxr.github.io/COINr/). It also ensures Credibility & Engagement through the effective participation of field experts.

> Aid organisations and donors commit to...  'Dedicate resources and involve independent specialists within the clusters to strengthen [..] analysis in a fully transparent, collaborative process, which includes a brief summary of the methodological and analytical limitations of the assessment."
> --   Grand Bargain Commitment #5: [Improve joint and impartial needs assessments](https://interagencystandingcommittee.org/improve-joint-and-impartial-needs-assessments)

## How to?
UNHCR Guatemala is building a composite indicator to assess the Severity of the 340 municipalities in the country. The main purpose of the index is to better prioritize the municipalities in which UNHCR should do Community-based Protection interventions. To reproduce the current, results:

### 1. Source sub-national scale data

Create a github repository and start a wiki within your repository to document your data investigaion. 

There is an available https://github.com/martinepunhcr/MVI_Guatemala/wiki to review the metadata of all indicators used in the Index

### 2. Install  
```{r}
install.packages("pak")
pak::pkg_install("martinepunhcr/MVI_Guatemala")  
```  

### 3. Create Project in Rstudio

Create a new project in Rstudio from the git of your github repository. 
Then create a folder and put the required data file

 * __datafolder__: by default `"data-raw"` This is the default folder where to put you data in  
 
 * __data__:  Name of the data excel (.xlsx) file  with the indicator main excel file - following precisely a standard template - see example [here](https://github.com/martinepunhcr/MVI_Guatemala/raw/main/data-raw/data_module-input.xlsx): one worksheet for the indicator and one worksheet for the documentation of aggregation  
 
 * __shp__: name of the shapefile to create the map. The shapefile must include a default field named `"ADM2_PCODE"`, that will be used as the main key to join with  `"admin2Pcode"` within the indicator main excel file

### 4. Technical Documentation Report
Whenever an index is being build, a key element of quality is related to documentation. The packge include a template to generate it.

Create a new file > new R markdown > from template > index_report from {BuildIndex}

In this file, adjust the parameters from the template to get your index based on your own data:

See work-in-progress [tecnical report here](articles/skeleton.html)

__[to do]__ ShinyApp to deploy on  [rstudio.unhcr.org](https:://rstudio.unhcr.org) to further guide the data preparation and build the Technical Documentation Report without Rstudio

### 4. Field Expert Validation 

See an initial template for  [Field Expert Presentation here](articles/skeleton2.html)

### 5. Data Export

See a sample of [Excel Data Export](https://github.com/martinepunhcr/MVI_Guatemala/raw/main/inst/index_export_geo.xlsx)

### 6. Interactive Exploration for Dissemination

__[to do]__ function to build deployable ShinyApp visualisation on [rstudio.unhcr.org](https:://rstudio.unhcr.org)


## Acknowledgement

This project is led by [UNNHCR Guatemala](https://www.unhcr.org/guatemala.html), supported technically by [William Becker](https://www.willbecker.me/) and funded through [UNHCR innovation fund](https://www.unhcr.org/innovation/innovation-fund/). It also benefited from the review of the [Regional Bureau for the Americas based in Panama](https://www.unhcr.org/americas.html)
