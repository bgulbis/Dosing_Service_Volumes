# library.R
# 
# packages needed for data tidying and analysis
# 

library(BGTools)
library(dplyr)
library(tidyr)
library(lubridate)
library(stringr)
library(ggplot2)
library(ReporteRs)

# set data directories
warf.dir <- "Warfarin Data"
vanc.dir <- "Vancomycin Data"

# compress data files
gzip_files(warf.dir)
gzip_files(vanc.dir)
