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

# function to read in orders data
get_data <- function(data.dir, files, start.date = NA, stop.date = NA, excl.units = NA) {
    data <- list.files(data.dir, pattern = files, full.names = TRUE) %>%
        lapply(read.csv, colClasses = "character") %>%
        bind_rows %>%
        transmute(pie.id = PowerInsight.Encounter.Id,
                  order = factor(Order.Catalog.Mnemonic),
                  date = mdy(Order.Action.Date),
                  nurse.unit = factor(Person.Location..Nurse.Unit..Order.)) %>%
        distinct(pie.id, date)
    
    if (!is.na(start.date)) {
        data <- filter(data, date >= start.date)
    }
    
    if (!is.na(stop.date)) {
        data <- filter(data, date <= stop.date)
    }

    if (!is.na(excl.units)) {
        data <- filter(data, !str_detect(nurse.unit, excl.units))
    }
    
    return(data)
}

# calculate monthly totals
calc_monthly <- function(data, ds.data) {
    # count number of orders for each day
    daily <- data %>%
        group_by(date) %>%
        summarize(num.orders = n())
    
    ds.daily <- ds.data %>%
        group_by(date) %>%
        summarize(num.service = n())
    
    # combine daily orders and dosing service orders
    # calculate % of orders handled by dosing service
    orders <- full_join(daily, ds.daily, by = "date") %>%
        mutate(prcnt.service = num.service / num.orders)
    
    # get monthly totals
    monthly <- orders %>%
        mutate(month = update(date, mday = 1)) %>%
        group_by(month) %>%
        summarize(mean.orders = mean(num.orders, na.rm = TRUE),
                  mean.service = mean(num.service, na.rm = TRUE),
                  mean.prcnt.service = mean(prcnt.service, na.rm = TRUE) * 100)
    
    return(monthly)
}

# make PowerPoint slides
make_pptx <- function(mydoc, data, slide.title, plot.title) {
    # add new PowerPoint slide
    mydoc <- addSlide(mydoc, slide.layout = "Title and Content")
    mydoc <- addTitle(mydoc, slide.title)
    
    graph <- ggplot(data = data, aes(x = month, y = mean.prcnt.service)) +
        geom_point() + 
        geom_smooth(method = "lm", se = FALSE) +
        xlab("Month") +
        ylab("Orders Managed by Pharmacy (%)") +
        ggtitle(plot.title) +
        theme_bw()
    
    # save the graph to the PowerPoint slide
    mydoc <- addPlot(mydoc, fun=print, x=graph, vector.graphic=TRUE, fontname="Calibri")
    
    return(mydoc)
}

