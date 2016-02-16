# vanc_events.R
# 
# make list of patients who received vancomycin
# 

source("library.R")

# read in clinical event data
ce.data <- list.files(vanc.dir, pattern = "^Vancomycin Clinical Event", full.names = TRUE) %>%
    lapply(read.csv, colClasses = "character") %>%
    bind_rows %>%
    transmute(pie.id = PowerInsight.Encounter.Id,
              date = mdy(Discharge.Date)) %>%
    distinct(pie.id, date)

# optional, filter data based on date
ce.data <- filter(ce.data, date >= mdy("4/1/2015"))

# get list of encounters
edw.pie <- split(ce.data$pie.id, ceiling(seq_along(ce.data$pie.id) / 750)) %>%
    lapply(str_c, collapse = ";")

print(edw.pie)
