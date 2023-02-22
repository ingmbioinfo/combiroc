demo_data # combiroc built-in demo data (proteomics data from Zingaretti et al. 2012 - PMC3518104)

combs <- combi(data= demo_data, signalthr=450, combithr=1, case_class='A')  # compute combinations

#  To show the composition of combinations of interest.

show_markers(markers_table = combs, selected_combinations = c(1,11))
