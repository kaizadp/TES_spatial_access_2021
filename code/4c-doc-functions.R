library(patchwork)




# I. READING -----------------------------------------------------------

read_file <- function(fn) {
  read.csv(file_in(fn)) %>% 
    dplyr::mutate(
      Homogenization = factor(Homogenization, levels = c("Intact", "Homogenized")),
      Amendments = factor(Amendments, levels = c("control", "C", "N")),
      Moisture = factor(Moisture, levels = c("fm", "drought")),
      Wetting = factor(Wetting, levels = c("precip", "groundw")))
  
}

#
# II. PLOTTING ------------------------------------------------------------
pal3 = c("#FFE733", "#96001B", "#2E5894") #soil_palette("redox2")

# II. plots -------------------------------------------------------------------

plot_doc_suctions = function(doc){
  
  gg_doc_boxplot_suctions = 
    doc %>% 
    filter(Homogenization=="Intact") %>% 
    ggplot(aes(x = Moisture, y = DOC_ng_g))+
    geom_boxplot(aes(group = Moisture), 
                 fill = "grey90", alpha = 0.3, color = "grey60", width = 0.4)+
    geom_point(aes(fill = Amendments, shape = Wetting, group=Amendments),
               size=3, stroke=1, position = position_dodge(width = 0.4))+
    scale_shape_manual(values = c(21,23))+
    scale_fill_manual(values = pal3)+
    facet_grid(Homogenization ~ Suction, scales = "free_y")+
    #labs(title = "combined Wetting direction")+
    theme_kp()+
    guides(fill=guide_legend(override.aes=list(shape=21)))+
    theme(axis.title.x = element_blank())+
    NULL
  
  gg_doc_boxplot_suctions_zoomed = 
    gg_doc_boxplot_suctions+
    ylim(0,10)+
    labs(subtitle = "1-10 ng/g zoomed")+
    #labs(title = "combined Wetting direction")+
    theme_kp()+
    guides(fill=guide_legend(override.aes=list(shape=21)))+
    theme(axis.title = element_blank(),
          strip.text.x = element_blank(),
          panel.border = element_rect(color="grey50",size=1, fill = NA))+
    NULL
  
  
  gg_doc_boxplot_suctions_combined = gg_doc_boxplot_suctions/gg_doc_boxplot_suctions_zoomed +
    plot_layout(guides = "collect",
                heights = c(2,1)) & 
    theme(legend.position = "top")
  
  list(gg_doc_boxplot_suctions_combined = gg_doc_boxplot_suctions_combined)
}

plot_doc_fullcore = function(doc){
  
  doc_fullcore = 
    doc %>% 
    group_by(CORE, Homogenization, Moisture, Wetting, Amendments) %>% 
    dplyr::summarise(DOC_ng_g = sum(DOC_ng_g))
    
  (gg_doc_boxdotplot_fullcore = 
    doc_fullcore %>% 
    filter(Homogenization=="Intact") %>% 
    ggplot(aes(x = Wetting, y = DOC_ng_g))+
    geom_boxplot(aes(group = Wetting), 
                 fill = "grey90", alpha = 0.3, color = "grey60", width = 0.4)+
    geom_point(aes(fill = Amendments, shape = Wetting, group=Amendments),
               size=3, stroke=1, position = position_dodge(width = 0.4))+
    scale_shape_manual(values = c(21,23))+
    scale_fill_manual(values = pal3)+
    facet_grid(Homogenization ~ Moisture, scales = "free_y")+
      labs(title = "full core")+
      theme_kp()+
    guides(fill=guide_legend(override.aes=list(shape=21)))+
    theme(axis.title.x = element_blank())+
    NULL)
  
  # effect of homogenization
  (gg_doc_boxdotplot_fullcore_homo = 
    doc_fullcore %>% 
    ggplot(aes(x = Homogenization, y = DOC_ng_g))+
    geom_boxplot(aes(group = Homogenization), 
                 fill = "grey90", alpha = 0.3, color = "grey60", width = 0.4)+
    geom_point(aes(fill = Moisture, shape = Wetting, group=Moisture),
               size=3, stroke=1, position = position_dodge(width = 0.4))+
    scale_shape_manual(values = c(21,23))+
      scale_fill_manual(values = soilpalettes::soil_palette("crait",2))+
      facet_grid(. ~ Amendments, scales = "free_y")+
    labs(title = "effect of homogenization -- full core")+
    theme_kp()+
    guides(fill=guide_legend(override.aes=list(shape=21)))+
    theme(axis.title.x = element_blank())+
    NULL)

  
list(gg_doc_boxdotplot_fullcore = gg_doc_boxdotplot_fullcore,
     gg_doc_boxdotplot_fullcore_homo = gg_doc_boxdotplot_fullcore_homo)  
  
}

## other doc plots
plot_doc_others = function(doc){
gg_doc_allpanels = 
  doc %>% 
  ggplot(aes(x = Amendments, y = DOC_ng_g, color = Amendments))+
  geom_point()+
  scale_y_continuous(trans = "log10", labels = scales::comma)+
  facet_grid(Homogenization+Suction~Moisture+Wetting, scales = "free_y")+
  theme(legend.position = "none")

gg_doc_boxdotplot = 
  doc %>% 
  #filter(Homogenization=="Intact") %>% 
  ggplot(aes(x = Amendments, y = DOC_ng_g, color = Moisture, shape = Wetting))+
  geom_boxplot(aes(group = Amendments), color = "grey")+
  geom_point(size=3, position = position_dodge(width = 0.7))+
  scale_y_continuous(trans = "log10", labels = scales::comma)+
  facet_grid(Homogenization~Suction)+
  #  theme(legend.position = "none")+
  NULL

gg_doc_boxdotplot2 = 
  doc %>% 
  #filter(Homogenization=="Intact") %>% 
  ggplot(aes(x = Wetting, y = DOC_ng_g, color = Amendments, shape = Amendments))+
  geom_boxplot(aes(group = Wetting), fill = "grey90", alpha = 0.9, color = "grey60", width = 0.4)+
  geom_point(size=3, position = position_dodge(width = 0.7))+
  scale_y_continuous(trans = "log10", labels = scales::comma)+
  facet_grid(Homogenization ~ Moisture+Suction)+
  theme_kp()+
  #  theme(legend.position = "none")+
  NULL

gg_doc_boxdotplot3 = 
  doc %>% 
  #filter(Homogenization=="Intact") %>% 
  ggplot(aes(x = Moisture, y = DOC_ng_g, color = Amendments, shape = Amendments))+
  geom_boxplot(aes(group = Moisture), fill = "grey90", alpha = 0.9, color = "grey60", width = 0.4)+
  geom_point(size=3, position = position_dodge(width = 0.5))+
  scale_color_manual(values = soilpalettes::soil_palette("redox2",3))+
  scale_y_continuous(trans = "log10", labels = scales::comma)+
  facet_grid(Homogenization ~ Suction)+
  labs(title = "combined Wetting direction")+
  theme_kp()+
  #  theme(legend.position = "none")+
  NULL

}


