# vanc_orders.R
# 
# use daily vancomycin orders to graph volumes
# 

source("library.R")

med.orders <- "^Vancomycin Orders"
service.orders <- "^Vancomycin Dosing"

start.date = mdy("7/1/2012")
stop.date = mdy("12/31/2015")
excl.units = "^HC|Her|(HH PACU)|(HH PAHH)|(HH PARH)|(HH PROC)|(HH VUHH)|(HH WC5)|(HH WC6N)|(HH WCAN)|(HH WCOR)|(HVI OR)|(HH A2HV)|(HH AMSA)|(HH APAC)|(HH 7J)|(HH CCU)|(HH CVICU)|(HH MICU)|(HH STIC)|(HH TSIC)"

# read in daily orders
vanc.data <- get_data(vanc.dir, med.orders, start.date, stop.date, excl.units)
vancds.data <- get_data(vanc.dir, service.orders, start.date, stop.date, excl.units)

# get monthly totals
vanc.monthly <- calc_monthly(vanc.data, vancds.data)

slide.title <- "Vancomycin Dosing Service"
plot.title <- "Utilization of Vancomycin Pharmacy Dosing Service\nin Non-ICU Units from July 2012 to December 2015"

# create PowerPoint file
mydoc <- pptx(template = "Templates/template.pptx")

# generate graph
mydoc <- make_pptx(mydoc, vanc.monthly, slide.title, plot.title)

# repeat for focused time frame
start.date = mdy("7/1/2015")
plot.title <- "Utilization of Vancomycin Pharmacy Dosing Service\nin Non-ICU Units from July 2015 to December 2015"

# read in daily orders
vanc.data <- get_data(vanc.dir, med.orders, start.date, stop.date, excl.units)
vancds.data <- get_data(vanc.dir, service.orders, start.date, stop.date, excl.units)

# get monthly totals
vanc.monthly <- calc_monthly(vanc.data, vancds.data)

# generate graph
mydoc <- make_pptx(mydoc, vanc.monthly, slide.title, plot.title)

# write the PowerPoint slides to file
writeDoc(mydoc, file = "vancomycin.pptx")
