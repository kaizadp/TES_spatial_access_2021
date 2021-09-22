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
    ggplot(aes(x = Moisture, y = DOC_ug_gC))+
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
    dplyr::summarise(DOC_ug_gC = sum(DOC_ug_gC))
  
  (gg_doc_boxdotplot_fullcore = 
      doc_fullcore %>% 
      filter(Homogenization=="Intact") %>% 
      ggplot(aes(x = Wetting, y = DOC_ug_gC))+
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
  summary(aov(log(DOC_ug_gC) ~ Homogenization, data = doc_fullcore %>% 
                filter(Moisture == "fm" & Amendments == "control")))
  
  (gg_doc_boxdotplot_fullcore_homo = 
      doc_fullcore %>% 
      filter(Moisture == "fm" & Amendments == "control") %>% 
      mutate(Wetting = dplyr::recode(Wetting, "precip" = "PR", "groundw" = "GW"),
             Wetting = factor(Wetting, levels = c("PR", "GW")),
             Homogenization = dplyr::recode(Homogenization, "Intact" = "Intact (baseline)")) %>% 
      
      ggplot(aes(x = Homogenization, y = DOC_ug_gC))+
      geom_boxplot(fill = "grey80", alpha = 0.3, width = 0.4)+
      geom_point(size = 3.5, position = position_dodge(width = 0.5),
                 aes(fill = Wetting, shape = Wetting))+
      scale_shape_manual(values = c(21,24))+
      scale_fill_manual(values = c("#0f85a0", "#ed8b00"))+
      labs(x = "",
           y = expression(bold("WSOC, μg gC"^-1)))+
      annotate("text", label = "p = 0.0102", x = 1.5, y = 0, size = 4)+
      theme_kp()+
      theme(legend.position = c(0.2, 0.8))+
      NULL)

  list(gg_doc_boxdotplot_fullcore = gg_doc_boxdotplot_fullcore,
       gg_doc_boxdotplot_fullcore_homo = gg_doc_boxdotplot_fullcore_homo)  
  
}


do_scatterplot_stats = function(depvar, doc){
  fit_stats = function(depvar, Amendments){
    l = lm((depvar) ~ Amendments)
    a = car::Anova(l, type = "III")
    broom::tidy(a) %>% 
      filter(term == "Amendments") %>% 
      rename(p_value = `p.value`)
  }
  
  fit_stats_C = 
    doc %>% 
    filter(Amendments != "N") %>% 
    group_by(Moisture, Wetting) %>% 
    do(fit_stats(.[[depvar]], .$Amendments)) %>% 
    mutate(Amendments = "C")
  
  fit_stats_N = 
    doc %>% 
    filter(Amendments != "C") %>% 
    group_by(Moisture, Wetting) %>% 
    do(fit_stats(.[[depvar]], .$Amendments)) %>% 
    mutate(Amendments = "N")
  
  rbind(fit_stats_C, fit_stats_N) %>% 
    mutate(label = case_when(p_value <= 0.05 ~ "*",
                             p_value > 0.05 & p_value <= 0.10 ~ "\u02d9"),
           x_1 = case_when(Moisture=="fm"&Wetting=="precip" ~ 1,
                           Moisture=="fm"&Wetting=="groundw" ~ 2,
                           Moisture=="drought"&Wetting=="precip" ~ 3,
                           Moisture=="drought"&Wetting=="groundw" ~ 4),
           x_2 = case_when(Amendments=="control" ~ -0.2,
                           Amendments=="C" ~ 0,
                           Amendments=="N" ~ +0.2),
           x = x_1 + x_2)
}
do_doc_boxplot = function(doc){
  doc_label2 = 
    do_scatterplot_stats("DOC_ug_gC", doc %>% 
                           filter(Homogenization=="Intact"))
  
  
  doc %>% 
    filter(Homogenization=="Intact") %>% 
    ggplot(aes(x = interaction(Wetting, Moisture), y = DOC_ug_gC))+
    #  geom_boxplot(aes(fill = Amendments), 
    #               alpha = 0.3, color = "grey60", width = 0.6,
    #               show.legend = F)+
    geom_point(aes(fill = Amendments, shape = Wetting),
               size=4, stroke=1, position = position_dodge(width = 0.6))+
    #  geom_text(data = doc_label2, 
    #            aes(x = x, y = 1900, label = label), size=10)+
    
    scale_fill_manual(values = pal3)+
    scale_shape_manual(values = c(21,23))+
    guides(fill=guide_legend(override.aes=list(shape=21)))+
    labs(title = "WSOC full core",
         x = "")+
    annotate("rect", xmin = 0.8, xmax = 2.2, ymin = 1950, ymax = 2050, alpha = 0.2, fill = "yellow")+
    annotate("rect", xmin = 2.8, xmax = 4.2, ymin = 1950, ymax = 2050, alpha = 0.2, fill = "red")+
    annotate("text", label = "FM", x = 1.5, y = 2000)+
    annotate("text", label = "Drought", x = 3.5, y = 2000)+
    annotate("segment", x = 2.5, xend = 2.5, y = 50, yend = 2000, color = "grey70")+
    scale_x_discrete(breaks = c("precip.fm", "groundw.fm", "precip.drought", "groundw.drought"),
                     labels  =c("precip", "groundw", "precip", "groundw"))+
    facet_grid(Homogenization~.)+
    theme_kp()+
    theme(panel.grid.major.x = element_blank())+
    NULL
}


# III. STATS --------------------------------------------------------------

compute_lme_doc_overall = function(doc){
  doc_fullcore = 
    doc %>% 
    filter(CORE!=40) %>% 
    group_by(CORE, Homogenization, Moisture, Wetting, Amendments) %>% 
    dplyr::summarise(DOC_ug_gC = sum(DOC_ug_gC))
  
  l = lme4::lmer(log(DOC_ug_gC) ~ (Homogenization+Moisture+Wetting+Amendments)^2 + (1|CORE), 
                 data = doc_fullcore)
  car::Anova(l, type = "III")
}
compute_aov_flux_intact = function(doc){
  doc_fullcore = 
    doc %>% 
    filter(CORE!=40) %>% 
    group_by(CORE, Homogenization, Moisture, Wetting, Amendments) %>% 
    dplyr::summarise(DOC_ug_gC = sum(DOC_ug_gC))
  
  l = lm(log(DOC_ug_gC) ~ (Moisture + Amendments + Wetting)^2,
         data = doc_fullcore %>% filter(Homogenization=="Intact"))
  
  car::Anova(l, type="III")
}


# IV. TABLES --------------------------------------------------------------
make_doc_table = function(doc){
  doc_porewise_summarytable = 
    doc %>% 
    group_by(Homogenization, Moisture, Wetting, Amendments, Suction) %>% 
    dplyr::summarise(meanDOC_ug_gC = round(mean(DOC_ug_gC),2),
                     se = round(sd(DOC_ug_gC)/sqrt(n()),2)) %>% 
    ungroup() %>% 
    mutate(DOC_ug_gC = paste(meanDOC_ug_gC, "\u00b1", se)) %>% 
    dplyr::select(-c(meanDOC_ug_gC, se)) %>% 
    spread(Amendments, DOC_ug_gC) %>% knitr::kable()
  
  doc_fullcore = 
    doc %>% 
    group_by(CORE, Homogenization, Moisture, Wetting, Amendments) %>% 
    dplyr::summarise(DOC_ug_gC = sum(DOC_ug_gC)) %>% 
    filter(DOC_ug_gC != 0)
  
  doc_fullcore_summarytable = 
    doc_fullcore %>% 
    group_by(Homogenization, Moisture, Wetting, Amendments) %>% 
    dplyr::summarise(meanDOC_ug_gC = round(mean(DOC_ug_gC),2),
                     se = round(sd(DOC_ug_gC)/sqrt(n()),2)) %>% 
    ungroup() %>% 
    mutate(DOC_ug_gC = paste(meanDOC_ug_gC, "\u00b1", se)) %>% 
    dplyr::select(-c(meanDOC_ug_gC, se)) %>% 
    spread(Amendments, DOC_ug_gC) %>% knitr::kable()
  
  doc %>% 
    dplyr::select(-DOC_mg_L) %>% 
    mutate(Suction = as.character(Suction)) %>% 
    bind_rows(doc_fullcore %>% mutate(Suction = "full core")) %>% 
    mutate(DOC_mg_gC = round(DOC_ug_gC/1000,2)) %>% 
    group_by(Homogenization, Moisture, Wetting, Amendments, Suction) %>% 
    dplyr::summarise(meanDOC_ug_gC = round(mean(DOC_ug_gC),2),
                     se = round(sd(DOC_ug_gC)/sqrt(n()),2)) %>% 
    ungroup() %>% 
    mutate(DOC_ug_gC = paste(meanDOC_ug_gC, "\u00b1", se)) %>% 
    dplyr::select(-c(meanDOC_ug_gC, se)) %>% 
    spread(Amendments, DOC_ug_gC) %>% knitr::kable()
  
  }
compute_doc_tablestats = function(doc){
  doc_fullcore = 
    doc %>% 
    group_by(CORE, Homogenization, Moisture, Wetting, Amendments) %>% 
    dplyr::summarise(DOC_ug_gC = sum(DOC_ug_gC)) %>% 
    filter(DOC_ug_gC != 0)
  
  do_doc_stats_fullANOVA = function(dat){
    l = lm(log(DOC_ug_gC) ~ Moisture*Wetting, data = dat)
    a = car::Anova(l)
    broom::tidy((a)) %>% filter(term != "Residuals")
  }
  doc_stats_fullANOVA = doc_fullcore %>% 
    group_by(Homogenization, Amendments) %>% 
    do(do_doc_stats_fullANOVA(.))
  
  do_doc_stats_wetting = function(dat){
    l = lm(log(DOC_ug_gC) ~ Wetting, data = dat)
    a = car::Anova(l)
    broom::tidy((a)) %>% filter(term != "Residuals")
  }
  doc_stats_wetting = doc_fullcore %>% 
    group_by(Homogenization, Amendments, Moisture) %>% 
    do(do_doc_stats_wetting(.))

  do_doc_dunnett = function(dat){
    d <-DescTools::DunnettTest(log(DOC_ug_gC)~Amendments, control = "control", data = dat)
    tibble(C = d$control["C-control", 4],
           N = d$control["N-control", 4])
  }
  doc_dunnett = doc_fullcore %>% 
    group_by(Homogenization, Moisture, Wetting) %>% 
    do(do_doc_dunnett(.))
  
  list(doc_stats_fullANOVA = doc_stats_fullANOVA,
       doc_stats_wetting = doc_stats_wetting,
       doc_dunnett = doc_dunnett)
}