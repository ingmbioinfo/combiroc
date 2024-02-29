demo_data # combiroc built-in demo data (proteomics data from Zingaretti et al. 2012 - PMC3518104)


# To compute the marker combinations and count their corresponding positive samples for each class.

 combs <- combi(data= demo_data, signalthr=450, combithr=1, case_class='A')
 # count as positive the samples with value >= 450 for at least 1 marker in the combination

