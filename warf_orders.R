# warf_orders.R
# 
# use daily warfarin orders to graph volumes
# 

source("library.R")

med.orders <- "^Warfarin Orders"
service.orders <- "^Dosing Service"

start.date = mdy("7/1/2012")
stop.date = mdy("12/31/2015")

# read in daily orders
warf.data <- get_data(warf.dir, med.orders, start.date, stop.date)
warfds.data <- get_data(warf.dir, service.orders, start.date, stop.date)

# get monthly totals
warf.monthly <- calc_monthly(warf.data, warfds.data)

slide.title <- "Warfarin Dosing Service"
plot.title <- "Utilization of Warfarin Pharmacy Dosing Service\n from July 2012 to December 2015"

# create PowerPoint file
mydoc <- pptx(template = "Templates/template.pptx")

# generate graph
mydoc <- make_pptx(mydoc, warf.monthly, slide.title, plot.title)

# repeat for focused time frame
start.date = mdy("7/1/2015")
plot.title <- "Utilization of Warfarin Pharmacy Dosing Service\n from July 2015 to December 2015"

# read in daily orders
warf.data <- get_data(warf.dir, med.orders, start.date, stop.date)
warfds.data <- get_data(warf.dir, service.orders, start.date, stop.date)

# get monthly totals
warf.monthly <- calc_monthly(warf.data, warfds.data)

# generate graph
mydoc <- make_pptx(mydoc, warf.monthly, slide.title, plot.title)

# write the PowerPoint slides to file
writeDoc(mydoc, file = "warfarin.pptx")
