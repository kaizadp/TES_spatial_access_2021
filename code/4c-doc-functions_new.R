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

# II. PLOTTING ------------------------------------------------------------
pal3 = c("#FFE733", "#96001B", "#2E5894") #soil_palette("redox2")

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

# intact cores (full core)
fit_aov_wetting = function(depvar, Wetting){
  # boxplot p-values
  a1 <- aov(log(depvar) ~ Wetting)
  label_a1 <- broom::tidy(a1) %>% 
    filter(term != "Residuals") %>% 
    mutate(p_value = round(p.value, 4)) %>% 
    dplyr::select(term, p_value) 
}
fit_hsd_amend <- function(depvar, Amendments) {
  a <-aov(log(depvar) ~ Amendments)
  h <-agricolae::HSD.test(a,"Amendments")
  #create a tibble with one column for each treatment
  #the hsd results are row1 = drought, row2 = saturation, row3 = time zero saturation, row4 = field moist. hsd letters are in column 2
  tibble(`control` = h$groups["control",2], 
         `C` = h$groups["C",2],
         `N` = h$groups["N",2])
}
plot_doc_fullcore_intact = function(doc){
  doc_fullcore = 
    doc %>% 
    group_by(CORE, Homogenization, Moisture, Wetting, Amendments) %>% 
    dplyr::summarise(DOC_ng_g = sum(DOC_ng_g))
  
  do_labels_doc_intact = function(depvar, doc_fullcore){
    # 1. p-values for moisture ----
    wetting_label <- 
      doc_fullcore %>%
      filter(CORE != 40) %>% 
      group_by(Moisture) %>% 
      do(fit_aov_wetting(.[[depvar]], .$Wetting)) %>% 
      mutate(x = 1.5,
             y = -500,
             label = paste("p =", p_value),
             label = if_else(p_value == 0, "p < 0.0001", label))
    
    # 2. HSD for amendments ----
    hsd_y <- 
      doc_fullcore %>% 
      filter(Homogenization=="Intact") %>% 
      group_by(Moisture, Wetting, Amendments) %>% 
      dplyr::summarize(
        y = max(DOC_ng_g, na.rm = T) + 500)
    
    amend_label <- 
      doc_fullcore %>% 
      filter(CORE != 40) %>% 
      group_by(Moisture, Wetting) %>% 
      do(fit_hsd_amend(.[[depvar]], .$Amendments)) %>% 
      pivot_longer(-c(Moisture, Wetting),
                   names_to = "Amendments",
                   values_to = "label") %>% 
      mutate(w = dplyr::recode(Wetting, "precip"="1" , "groundw"="2"),
             am = dplyr::recode(Amendments, "control" = -0.2, "C" = 0, "N" = 0.2),
             x = as.numeric(w)+as.numeric(am)) %>% 
      left_join(hsd_y)
    
    # 4. combined label ----
    amend_label %>% rbind(wetting_label)
  }
  
  doc_labels = do_labels_doc_intact("DOC_ng_g", doc_fullcore)
  doc_fullcore %>% 
    filter(Homogenization=="Intact") %>% 
    ggplot(aes(x = Wetting, y = DOC_ng_g))+
    geom_boxplot(aes(group = Wetting), 
                 fill = "grey90", alpha = 0.3, color = "grey60", width = 0.6)+
    geom_point(aes(fill = Amendments, shape = Wetting, group=Amendments),
               size=3, stroke=1, position = position_dodge(width = 0.6))+
    geom_text(data = doc_labels, aes(x = x, y = y, label = label), size=5)+
    scale_shape_manual(values = c(21,23))+
    scale_fill_manual(values = pal3)+
    facet_grid(Homogenization ~ Moisture, scales = "free_y")+
    labs(title = "full core")+
    theme_kp()+
    guides(fill=guide_legend(override.aes=list(shape=21)))+
    theme(axis.title.x = element_blank())+
    NULL
}

# intact cores (full core) -- version 2
fit_aov_moisture = function(depvar, Moisture){
  # boxplot p-values
  a1 <- aov(log(depvar) ~ Moisture)
  label_a1 <- broom::tidy(a1) %>% 
    filter(term != "Residuals") %>% 
    mutate(p_value = round(p.value, 4)) %>% 
    dplyr::select(term, p_value) 
}
fit_aov_wetting2 = function(depvar, Wetting){
  a3 = aov(log(depvar) ~ Wetting)
  broom::tidy(a3) %>% 
    filter(term != "Residuals") %>% 
    dplyr::select(term, `p.value`) %>% 
    filter(`p.value` <= 0.05)
}

plot_doc_fullcore_intact2 <- function(doc) {
  doc_fullcore = 
    doc %>% 
    filter(CORE != 40) %>% 
    group_by(CORE, Homogenization, Moisture, Wetting, Amendments) %>% 
    dplyr::summarise(DOC_ng_g = sum(DOC_ng_g)) %>% 
    ungroup()
  
  do_labels_doc_fullcore_intact2 = function(depvar, doc_fullcore){
    # 1. p-values for moisture ----
    moisture_label <- 
      doc_fullcore %>% 
      ungroup() %>%    
      group_by(Amendments) %>% 
      do(fit_aov_moisture(.[[depvar]], .$Moisture)) %>% 
      filter(p_value <= 0.05) %>% 
      mutate(x = 1.5,
             y = 6000,
             label = "\n*")
    
    # 2. HSD for amendments ----
    hsd_y <- doc_fullcore %>% 
      group_by(Amendments) %>% 
      dplyr::summarize(max = max(DOC_ng_g))
    
    amend_label <- doc_fullcore %>% 
      do(fit_hsd_amend(.$DOC_ng_g, .$Amendments)) %>% 
#      dplyr::mutate(skip = control==C & C==N) %>% 
#      filter(!skip) %>% 
#      dplyr::select(-skip) %>% 
      mutate(y = 10) %>% 
      pivot_longer(-y, names_to = "Amendments",
                   values_to = "label")
    
    
    # 3. wetting label ----
    wetting_label <- 
      doc_fullcore %>% 
      group_by(Amendments) %>% 
      do(fit_aov_wetting2(.$DOC_ng_g, .$Wetting)) %>% 
      #dplyr::select(-`p.value`) %>% 
      mutate(label = "\n\n†",
             y = 10)
    
    # 4. combined label ----
    
    amend_label %>% bind_rows(moisture_label) %>% bind_rows(wetting_label) %>% 
      left_join(hsd_y) %>% mutate(y = max+800)  
  }
  
  doc_label = 
    do_labels_doc_fullcore_intact2("DOC_ng_g", 
                                   doc_fullcore %>% filter(Homogenization=="Intact")) %>% 
    mutate(y = if_else(Amendments == "C", 8200, 13),
           Amendments = factor(Amendments, levels = c("control", "C", "N")))
    
  
  doc_fullcore %>% 
    filter(Homogenization=="Intact") %>% 
    ggplot(aes(x = Amendments, y = DOC_ng_g))+
    geom_boxplot(aes(group = Amendments), 
                 fill = "grey90", alpha = 0.3, color = "grey60", width = 0.6)+
    geom_point(aes(fill = Moisture, shape = Wetting, group = Wetting),
               size=4, stroke=1, position = position_dodge(width = 0.6))+
    geom_text(data = doc_label, aes(x = Amendments, y = y, label = label), size=5)+
    scale_fill_manual(values = pal3)+
    scale_shape_manual(values = c(21,23))+
    guides(fill=guide_legend(override.aes=list(shape=21)))+
    labs(title = "WSOC -- full core")+
    #facet_grid(Homogenization~.)+
    theme_kp()+
    NULL+
    facet_wrap(~Amendments, scales = "free")+expand_limits(y=0)+
    theme(strip.text.x = element_blank())
}

# effect of homogenization (full core)
fit_aov_homo = function(depvar, Homogenization){
  # boxplot p-values
  a1 <- aov(log(depvar) ~ Homogenization)
  label_a1 <- broom::tidy(a1) %>% 
    filter(term != "Residuals") %>% 
    mutate(p_value = round(p.value, 4)) %>% 
    dplyr::select(term, p_value) 
}
plot_doc_fullcore_homo = function(doc){
  doc_fullcore = 
    doc %>% 
    group_by(CORE, Homogenization, Moisture, Wetting, Amendments) %>% 
    dplyr::summarise(DOC_ng_g = sum(DOC_ng_g))
  
  do_labels_doc_homo = function(depvar, doc_fullcore){
    # 1. p-values for moisture ----
    doc_fullcore %>%
      filter(CORE != 40) %>% 
      group_by(Amendments) %>% 
      do(fit_aov_wetting(.[[depvar]], .$Homogenization)) %>% 
      mutate(x = 1.5,
             y = -500,
             label = paste("p =", p_value),
             label = if_else(p_value == 0, "p < 0.0001", label))
  }
  
  doc_labels_homo = do_labels_doc_homo("DOC_ng_g", doc_fullcore)
  
  doc_fullcore %>% 
    ggplot(aes(x = Homogenization, y = DOC_ng_g))+
    geom_boxplot(aes(group = Homogenization), 
                 fill = "grey90", alpha = 0.3, color = "grey60", width = 0.6)+
    geom_point(aes(fill = Moisture, shape = Wetting, group=Moisture),
               size=3, stroke=1, position = position_dodge(width = 0.6))+
    geom_text(data = doc_labels_homo, aes(x = x, y = y, label = label), size=5)+
    scale_shape_manual(values = c(21,23))+
    scale_fill_manual(values = soilpalettes::soil_palette("crait",2))+
    facet_grid(. ~ Amendments, scales = "free_y")+
    labs(title = "full core")+
    theme_kp()+
    guides(fill=guide_legend(override.aes=list(shape=21)))+
    theme(axis.title.x = element_blank())+
    NULL
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


# III. STATS --------------------------------------------------------------

compute_lme_doc_overall = function(doc){
  doc_fullcore = 
    doc %>% 
    filter(CORE!=40) %>% 
    group_by(CORE, Homogenization, Moisture, Wetting, Amendments) %>% 
    dplyr::summarise(DOC_ng_g = sum(DOC_ng_g))
  
  l = lme4::lmer(log(DOC_ng_g) ~ (Homogenization+Moisture+Wetting+Amendments)^2 + (1|CORE), 
                 data = doc_fullcore)
  car::Anova(l, type = "III")
}
compute_aov_flux_intact = function(doc){
  doc_fullcore = 
    doc %>% 
    filter(CORE!=40) %>% 
    group_by(CORE, Homogenization, Moisture, Wetting, Amendments) %>% 
    dplyr::summarise(DOC_ng_g = sum(DOC_ng_g))
  
  l = lm(log(DOC_ng_g) ~ (Moisture + Amendments + Wetting)^2,
         data = doc_fullcore %>% filter(Homogenization=="Intact"))
  
  car::Anova(l, type="III")
}

