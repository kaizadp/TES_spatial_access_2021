## SPATIAL ACCESS
## KAIZAD F. PATEL
## 2-JULY-2020



# packages ----------------------------------------------------------------

library(tidyverse)


# ggplot customizations ------------------------------------------------------------------

# custom ggplot theme
theme_kp <- function() {  # this for all the elements common across plots
  theme_bw() %+replace%
    theme(legend.position = "top",
          legend.key=element_blank(),
          legend.title = element_blank(),
          legend.text = element_text(size = 12),
          legend.key.size = unit(1.5, 'lines'),
          legend.background = element_rect(colour = NA),
          panel.border = element_rect(color="black",size=1.5, fill = NA),
          
          plot.title = element_text(hjust = 0.05, size = 14),
          axis.text = element_text(size = 14, color = "black"),
          axis.title = element_text(size = 14, face = "bold", color = "black"),
          
          # formatting for facets
          panel.background = element_blank(),
          strip.background = element_rect(colour="white", fill="white"), #facet formatting
          panel.spacing.x = unit(1.5, "lines"), #facet spacing for x axis
          panel.spacing.y = unit(1.5, "lines"), #facet spacing for x axis
          strip.text.x = element_text(size=12, face="bold"), #facet labels
          strip.text.y = element_text(size=12, face="bold", angle = 270) #facet labels
    )
}


# custom ggplot function for Van Krevelen plots
gg_vankrev <- function(data,mapping){
  ggplot(data,mapping) +
    # plot points
    geom_point(size=2, alpha = 0.2) + # set size and transparency
    # axis labels
    ylab("H/C") +
    xlab("O/C") +
    # axis limits
    xlim(0,1.25) +
    ylim(0,2.5) +
    # add boundary lines for Van Krevelen regions
    geom_segment(x = 0.0, y = 1.5, xend = 1.2, yend = 1.5,color="black",linetype="longdash") +
    #geom_segment(x = 0.0, y = 2, xend = 1.2, yend = 2,color="black",linetype="longdash") +
    #geom_segment(x = 0.0, y = 1, xend = 1.2, yend = 0.75,color="black",linetype="longdash") +
    geom_segment(x = 0.0, y = 0.8, xend = 1.2, yend = 0.8,color="black",linetype="longdash")+
    guides(colour = guide_legend(override.aes = list(alpha=1)))
  
}

