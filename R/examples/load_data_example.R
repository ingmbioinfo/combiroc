demo_data # combiroc built-in demo data (proteomics data from Zingaretti et al. 2012 - PMC3518104)

# save a data.frame as a csv to be load by combiroc package
file<- tempfile()
write.csv2(demo_data, file = file, row.names = FALSE)


#To load a csv file if correctly formatted

demo_data <- load_data(data = file, sep = ';', na.strings = "")


demo_unclassified_data # combiroc built-in unclassified demo data

# save a data.frame as a csv to be load by combiroc package
file<- tempfile()
write.csv2(demo_unclassified_data, file = file, row.names = FALSE)

# To load an unclassified dataset.

demo_unclassified_data <- load_data(data = file, sep = ';', na.strings = "", labelled_data = FALSE)

