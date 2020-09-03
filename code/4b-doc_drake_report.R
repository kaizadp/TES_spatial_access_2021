

source("code/0-packages.R")
library(drake)

doc_plan = drake_plan(
  # I. load files --------------------------------------------------------------
  theme_set(theme_bw()),
  doc = read.csv(file_in("data/processed/doc.csv"))  %>% 
    filter(!Suction==15) %>% 
    mutate(Amendments = factor(Amendments, levels = c("control", "C", "N")),
           Homogenization = factor(Homogenization, levels = c("Intact", "Homogenized")),
           Moisture = factor(Moisture, levels = c("fm", "drought")),
           Wetting = factor(Wetting, levels = c("precip", "groundw"))),
  
  doc_all = read.csv(file_in("data/processed/doc.csv"))  %>% 
    mutate(Amendments = factor(Amendments, levels = c("control", "C", "N")),
           Homogenization = factor(Homogenization, levels = c("Intact", "Homogenized")),
           Moisture = factor(Moisture, levels = c("fm", "drought")),
           Wetting = factor(Wetting, levels = c("precip", "groundw"))),
  
  
  
  # II. plots -------------------------------------------------------------------
  ## 1.5 and 50 kPa -------------------------------------------------------------------------
  
  gg_doc_allpanels = 
    doc %>% 
    ggplot(aes(x = Amendments, y = DOC_ng_g, color = Amendments))+
    geom_point()+
    scale_y_continuous(trans = "log10", labels = scales::comma)+
    facet_grid(Homogenization+Suction~Moisture+Wetting, scales = "free_y")+
    theme(legend.position = "none"),
  
  
  
  gg_doc_boxdotplot = 
    doc %>% 
    #filter(Homogenization=="Intact") %>% 
    ggplot(aes(x = Amendments, y = DOC_ng_g, color = Moisture, shape = Wetting))+
    geom_boxplot(aes(group = Amendments), color = "grey")+
    geom_point(size=3, position = position_dodge(width = 0.7))+
    scale_y_continuous(trans = "log10", labels = scales::comma)+
    facet_grid(Homogenization~Suction)+
    #  theme(legend.position = "none")+
    NULL,
  
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
    NULL,
  
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
    NULL,
  
  gg_doc_boxdotplot4 = 
    doc %>% 
    filter(Homogenization=="Intact") %>% 
    ggplot(aes(x = Moisture, y = DOC_ng_g))+
    geom_boxplot(aes(group = Moisture), 
                 fill = "grey90", alpha = 0.3, color = "grey60", width = 0.4)+
    geom_point(aes(fill = Amendments, shape = Wetting, group=Amendments),
               size=3, stroke=1, position = position_dodge(width = 0.4))+
    scale_shape_manual(values = c(21,23))+
    scale_fill_manual(values = rev(soilpalettes::soil_palette("rendoll",5)))+
    facet_grid(Homogenization ~ Suction, scales = "free_y")+
    #labs(title = "combined Wetting direction")+
    theme_kp()+
    guides(fill=guide_legend(override.aes=list(shape=21)))+
    theme(axis.title.x = element_blank())+
    NULL,
  
  gg_doc_boxdotplot4_low = 
    doc %>% 
    filter(Homogenization=="Intact") %>% 
    ggplot(aes(x = Moisture, y = DOC_ng_g))+
    geom_point(aes(fill = Amendments, shape = Wetting, group=Amendments),
               size=3, stroke=1, position = position_dodge(width = 0.4))+
    scale_shape_manual(values = c(21,23))+
    scale_fill_manual(values = rev(soilpalettes::soil_palette("rendoll",5)))+
    ylim(0,10)+
    facet_grid(Homogenization ~ Suction, scales = "free_y")+
    labs(subtitle = "1-10 ng/g zoomed")+
    #labs(title = "combined Wetting direction")+
    theme_kp()+
    guides(fill=guide_legend(override.aes=list(shape=21)))+
    theme(axis.title = element_blank(),
          strip.text.x = element_blank(),
          panel.border = element_rect(color="grey50",size=1, fill = NA))+
    NULL,
  
  library(patchwork),
  gg_doc_boxdotplot4_combined = gg_doc_boxdotplot4/gg_doc_boxdotplot4_low +
    plot_layout(guides = "collect",
                heights = c(2,1)) & 
    theme(legend.position = "top"),
  
  
  ### homogenization ----
  gg_doc_boxdot_homo = 
    doc %>% 
    ggplot(aes(x = Homogenization, y = DOC_ng_g))+
    geom_boxplot(aes(group = Homogenization), 
                 fill = "grey90", alpha = 0.3, color = "grey60", width = 0.4)+
    geom_point(aes(fill = Amendments, shape = Wetting, group=Amendments),
               size=3, stroke=1, position = position_dodge(width = 0.4))+
    scale_shape_manual(values = c(21,23))+
    scale_fill_manual(values = rev(soilpalettes::soil_palette("rendoll",5)))+
    facet_grid(. ~ Suction, scales = "free_y")+
    #labs(title = "combined Wetting direction")+
    theme_kp()+
    guides(fill=guide_legend(override.aes=list(shape=21)))+
    theme(axis.title.x = element_blank())+
    NULL,
  
  
  ## all 3 suctions -----------------------------------------------------------------------
  gg_doc_3suctions_scatter = 
    doc_all %>% 
    ggplot()+
    geom_point(aes(x = Moisture, y = DOC_ng_g, 
                   fill = Amendments, shape = Wetting, group = Amendments),
               position = position_dodge(width = 0.4))+
    scale_fill_manual(values = rev(soilpalettes::soil_palette("rendoll",5)))+
    scale_shape_manual(values = c(21,23))+
    guides(fill=guide_legend(override.aes=list(shape=21)))+
    facet_grid(Homogenization ~ Suction)+
    NULL,
  
  gg_doc_fullcore_scatter = 
    doc_all %>% 
    filter(Homogenization=="Intact") %>% 
    group_by(CORE, Homogenization, Moisture, Wetting, Amendments) %>% 
    dplyr::summarise(DOC_ng_g = sum(DOC_ng_g)) %>% 
    ggplot()+
    geom_point(aes(x = Wetting, y = DOC_ng_g, 
                   fill = Amendments, shape = Wetting, group = Amendments),
               size=3, stroke=1,
               position = position_dodge(width = 0.4))+
    scale_fill_manual(values = rev(soilpalettes::soil_palette("rendoll",5)))+
    scale_shape_manual(values = c(21,23))+
    guides(fill=guide_legend(override.aes=list(shape=21)))+
    facet_grid(Homogenization ~ Moisture)+
    labs(title = "DOC full core")+
    theme_kp()+
    NULL,
  
  gg_doc_fullcore_scatter_low = 
    gg_doc_fullcore_scatter +
    ylim(0,15)+
    labs(title = "",
         subtitle = "0-15 ng/g zoomed",
         y = "",
         x = "")+
    NULL,
  
  library(patchwork),
  gg_doc_fullcore_combined = 
  gg_doc_fullcore_scatter / gg_doc_fullcore_scatter_low +
    plot_layout(guides = "collect",
                heights = c(2,1)) & 
    theme(legend.position = "top"),
  
  ## Homogenization
  
  gg_doc_fullcore_combined_homo = 
    doc_all %>% 
    group_by(CORE, Homogenization, Moisture, Wetting, Amendments) %>% 
    dplyr::summarise(DOC_ng_g = sum(DOC_ng_g)) %>% 
    ggplot()+
    geom_point(aes(x = Homogenization, y = DOC_ng_g, 
                   fill = Moisture, shape = Wetting, group = Moisture),
               size=3, stroke=1,
               position = position_dodge(width = 0.4), alpha = 0.8)+
    #ylim(0,20)+
    scale_shape_manual(values = c(21,23))+
    scale_fill_manual(values = rev(soilpalettes::soil_palette("redox",2)))+
    guides(fill=guide_legend(override.aes=list(shape=21)))+
    labs(x = "")+
    facet_grid(.~Amendments)+
    theme_kp()+
    NULL,
  
  
  # III. stats -------------------------------------------------------------------
  ## overall ANOVA
  aov_doc_all = 
    Anova(lm((DOC_ng_g) ~ 
               (Homogenization + Suction + Moisture + Wetting + Amendments)^2,
             data = doc),
          type = "III"),
  
  ## intact and homogenized
  aov_doc_intact = 
    Anova(lm(DOC_ng_g ~ (Amendments+Suction+Moisture+Wetting)^2,
             data = doc %>% filter(Homogenization=="Intact")),
          type = "III"),
  
  aov_doc_homo = 
    Anova(lm(DOC_ng_g ~ (Amendments+Suction+Moisture+Wetting)^2,
             data = doc %>% filter(Homogenization=="Homogenized")),
          type = "III"),  
  
  # IV. report ------------------------------------------------------------------
  
  report1 = rmarkdown::render(
    knitr_in("reports/doc_drake_md_report.Rmd"),
    #  output_file = file_out("drake_md_report.md"))
    #      output_format = rmarkdown::html_document(toc = TRUE))
    output_format = rmarkdown::github_document()),
  
  #  report2 = rmarkdown::render(
  #    knitr_in("reports/results.Rmd"),
  #    output_format = rmarkdown::github_document())
  
  # ----- ---------------------------------------------------------------------
)


#drake::drake_cache("/Users/pate212/GitHub/tes_spatial_access/.drake")$unlock()
make(doc_plan)