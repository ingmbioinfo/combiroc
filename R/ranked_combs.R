#' @title Rank combinations.
#' @description A function to rank combinations by a Youden index and select them if they have a min SE and/or SP.
#' @details This function is meant to help the user in finding the best combinations (in the first rows) and allows also (not mandatory) the SE/SP-dependent filtering of combinations.
#' @param combo_table a data.frame with SE, SP and number of composing markers for each combination (returned by se_sp()).
#' @param min_SE a numeric that specifies the min value of SE that a combination must have to be filtered-in.
#' @param min_SP a numeric that specifies the min value of SP that a combination must have to be filtered-in.
#' @example R/examples/ranked_combs_example.R
#' @return a named list containing:
#' - $table, a data.frame with ranked combination, reporting: SE, SP, number of markers composing the combination and the score.
#' - $bubble_chart, a dot plot showing the selected 'gold' combinations
#' @export

ranked_combs <- function(combo_table, min_SE=0, min_SP=0) {

  SE<- as.numeric(combo_table$SE)
  SP<- as.numeric(combo_table$SP)
  markers <- as.numeric(combo_table$n_markers)

  combo_table$Youden<-SE + SP
  combo_table$Youden<-(combo_table$Youden/100)-1
  combo_table<-combo_table[order(-combo_table$Youden), ]

  combo_table$Combo <- (combo_table$SP>=min_SP & combo_table$SE>=min_SE)
  Combo <- combo_table$Combo

  combo_table$Combo[which(combo_table$Combo=='TRUE')] <- 'gold'
  combo_table$Combo[which(combo_table$Combo=='FALSE')] <- 'below_thr'

  rkc <- combo_table[which(combo_table$Combo=='gold'), ]
  rkc$Combo <- NULL

  bubble<-
    ggplot(combo_table, aes(x = SP, y = SE, size = markers, color = Combo)) +
    geom_point(alpha=0.3) +
    scale_size(range = c(5, 15), name="# of markers") +
    scale_x_continuous(limits = c(0,100)) +
    scale_y_continuous(limits = c(0,100)) +
    labs(x ="specificity", y = "sensitivity") +
    guides(color = guide_legend(order=2),
           size = guide_legend(order=1)) +
    geom_vline(xintercept = min_SP, linetype="dotted", color = "grey", size=1) +
    geom_hline(yintercept = min_SE, linetype="dotted", color = "grey", size=1) +
    scale_color_manual(values=c("blue", "gold")) +
    theme_light()

  res <- list(rkc, bubble)
  names(res)<- c('table', 'bubble_chart')
  return(res)
  }

