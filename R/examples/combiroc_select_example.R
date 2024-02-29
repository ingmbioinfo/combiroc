
demo_data # combiroc built-in demo data (proteomics data from Zingaretti et al. 2012 - PMC3518104)

# To select the best 3 single markers for class A with 1 CPU.

best_markers <- combiroc_select(data = demo_data, case_class = "A",n_cpus = 1 , n = 3)
