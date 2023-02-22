demo_data # combiroc built-in demo data (proteomics data from Zingaretti et al. 2012 - PMC3518104)
demo_unclassified_data # combiroc built-in unclassified demo data

combs <- combi(data= demo_data, signalthr=450, combithr=1, case_class='A')  # compute combinations

reports <- roc_reports(data= demo_data, markers_table= combs,
                       selected_combinations= c(1,11,15),
                       single_markers=c('Marker1', 'Marker2'), case_class='A') # train logistic
                                                                               # regression models


# To fit the models an retrieve the combi scores (predicted probabilities).

score_data <- combi_score(unclassified_data= demo_unclassified_data, Models= reports$Models,
                             Metrics= reports$Metrics)

# To classify new samples with logistic regression models.

classified_data <- combi_score(unclassified_data= demo_unclassified_data,
                               Models= reports$Models,Metrics= reports$Metrics,
                               Positive_class=1, Negative_class=0, classify=TRUE)

classified_data  # show samples classified using Logistic regression models
