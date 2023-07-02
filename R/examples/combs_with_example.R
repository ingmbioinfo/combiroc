\dontrun{
demo_data # combiroc built-in demo data (proteomics data from Zingaretti et al. 2012 - PMC3518104)

combs <- combi(data= demo_data, signalthr=450, combithr=1, case_class='A')  # compute combinations

# To show all the combinations with given markers.

combs_with(markers = c('Marker1', 'Marker2') , markers_table = combs)
}