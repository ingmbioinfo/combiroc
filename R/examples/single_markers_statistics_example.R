demo_data # combiroc built-in demo data (proteomics data from Zingaretti et al. 2012 - PMC3518104)

data_long <- combiroc_long(demo_data) # reshape data in long format

sms <- single_markers_statistics(data_long)

sms$Statistics # to visualize the statistics of each single marker
sms$Plots[[1]] # to visualize the scatterplot of the first marker
