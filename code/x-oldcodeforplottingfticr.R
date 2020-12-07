# IGNORE alternate homogenization plots ------------------------------------------

##    
##    
##    relabund_cores_complex %>% 
##      ggplot(aes(x = Moisture, y = relabund, fill = Homogenization))+
##    #  geom_boxplot(# aes(group = Moisture), 
##    #               # fill = "grey90", 
##    #               alpha = 0.3, color = "grey60", width = 0.6)+
##      geom_point(aes(shape = Wetting, group = Wetting),
##                 size=4, stroke=1, position = position_dodge(width = 0.6))+
##      #geom_text(data = totalcounts_label_homo, aes(x = x, y = y, label = label), size=5)+
##      scale_shape_manual(values = c(21,23))+
##      scale_fill_manual(values = soilpalettes::soil_palette("crait",2))+
##      
##      guides(fill=guide_legend(override.aes=list(shape=21)))+
##      labs(title = "contribution of complex molecules",
##           y = "% contribution")+
##      facet_grid(Suction~Amendments)+
##      theme_kp()+
##      NULL
##    
##    
##    peakcounts_core %>% 
##      filter(class=="total") %>% 
##      ggplot(aes(x = Moisture, y = counts, fill = Homogenization))+
##    #  geom_boxplot(aes(group = Homogenization), 
##    #               fill = "grey90", alpha = 0.3, color = "grey60", width = 0.6)+
##      geom_point(aes(shape = Wetting, group = Wetting),
##                 size=4, stroke=1, position = position_dodge(width = 0.6))+
##      #geom_text(data = totalcounts_label_homo, aes(x = x, y = y, label = label), size=5)+
##      scale_shape_manual(values = c(21,23))+
##      scale_fill_manual(values = soilpalettes::soil_palette("crait",2))+
##      
##      guides(fill=guide_legend(override.aes=list(shape=21)))+
##      labs(title = "total peak counts",
##           y = "count")+
##      facet_grid(Suction~Amendments)+
##      theme_kp()+
##      NULL
##    
##    
##    
##    
##    ## HOMOGENIZATION NEW PEAKS PCA
##    
##    data_homo_new2 = 
##      data_homo_new %>% 
##      left_join(meta_classes, by = "formula") %>% 
##      group_by(Suction, Moisture, Wetting, Amendments, class) %>% 
##      dplyr::summarise(abund = n()) %>%
##      group_by(Suction, Moisture, Wetting, Amendments) %>% 
##      dplyr::mutate(total = sum(abund)) %>%
##      ungroup() %>% 
##      mutate(relabund = (abund/total)*100) %>% 
##      dplyr::select(-abund, -total) %>% 
##      spread(class, relabund) %>% 
##      replace(is.na(.),0)  
##    
##    data_homo_pca_num = 
##      data_homo_new2 %>% 
##      dplyr::select(-c(1:4))
##    
##    data_homo_pca_grp = 
##      data_homo_new2 %>% 
##      dplyr::select(c(1:4)) %>% 
##      dplyr::mutate(row = row_number())
##    
##    homo_pca = prcomp(data_homo_pca_num, scale. = T)
##    summary(homo_pca)
##    
##    
##    ggbiplot(homo_pca, obs.scale = 1, var.scale = 1, 
##             groups = interaction(
##               as.factor(data_homo_pca_grp$Amendments)), ellipse = TRUE, circle = FALSE,
##             var.axes = TRUE) +
##      geom_point(size=5,stroke=1, 
##                 aes(color = groups, 
##                     shape = interaction(as.factor(data_homo_pca_grp$Moisture),
##                                         as.factor(data_homo_pca_grp$Wetting))))+
##      scale_shape_manual(values = c(1, 2, 19, 17))+
##      #scale_color_manual(values = pal3)+
##      labs(shape="",
##           title = "INTACT unique",
##           subtitle = "50 kPa")+
##      NULL 
##    
##    


# IGNORE -------------------------------------------------------------------------


## 
## 
## 
## 
## gg_nosc = 
##   data_key %>% 
##   left_join(meta_nosc, by = "formula") %>% 
##   ggplot(aes(x = Amendments, y = NOSC, fill = Amendments))+
##   geom_violin()+
##   geom_boxplot(width=0.2, coef=0, outlier.shape = NA, fill = "white")+
##   #   geom_dotplot(binaxis = "y", size=1)+
##   scale_fill_manual(values = pal3)+
##   labs(x = "",
##        y = "NOSC")+
##   theme(legend.position = "none")+
##   facet_grid(Homogenization+Suction~Moisture+Wetting)+
##   NULL
## 
## 
## 
## 
## fticr_elements %>% 
##   ggplot(aes(x = O, color = Moisture, fill = Moisture))+
##   geom_histogram(position = position_dodge(width = 0.3), 
##                  alpha = 0.5)+
##   #geom_density(alpha = 0.2)+
##   facet_grid(Suction + Wetting ~ Amendments)+
##   ylim(0,1000)
## 
## 
## data_c = 
##   data_long_trt %>% 
##   filter(Amendments != "N" & Homogenization == "Intact")
## 
## data_c_lossgain =
##   data_c %>% 
##   group_by(Suction, Moisture, Wetting, formula) %>% 
##   dplyr::mutate(n = n()) %>% 
##   ungroup() %>% 
##   mutate(loss_gain = case_when(n == 1 & Amendments == "control" ~ "lost",
##                                n == 1 & Amendments == "C" ~ "gained"))
## 
## data_c_lossgain %>% 
##   filter(!is.na(loss_gain)) %>% 
##   gg_vankrev(aes(x = OC, y = HC, color = loss_gain))+
##   stat_ellipse(show.legend = F)+
##   facet_grid(Suction ~ Moisture+Wetting)+
##   labs(title = "loss/gain for C amendments")
## 
## 
## 
## data_n = 
##   data_long_trt %>% 
##   filter(Amendments != "C" & Homogenization == "Intact")
## 
## data_n_lossgain =
##   data_n %>% 
##   group_by(Suction, Moisture, Wetting, formula) %>% 
##   dplyr::mutate(n = n()) %>% 
##   ungroup() %>% 
##   mutate(loss_gain = case_when(n == 1 & Amendments == "control" ~ "lost",
##                                n == 1 & Amendments == "N" ~ "gained"))
## 
## data_n_lossgain %>% 
##   filter(!is.na(loss_gain)) %>% 
##   gg_vankrev(aes(x = OC, y = HC, color = loss_gain))+
##   stat_ellipse(show.legend = F)+
##   facet_grid(Suction ~ Moisture+Wetting)+
##   labs(title = "loss/gain for N amendments")
## 
#

# IGNORE -- NEW PLOTS ---------------------------------------------------------------

##    
##    
##    
##    
##    ## PCA for new drought ----
##    
##    
##    newdrought_wide = 
##      newpeaks_drought %>% 
##      left_join(meta_classes, by = "formula") %>% 
##      dplyr::select(formula, class, Suction, Moisture, Wetting, Amendments, Homogenization, presence) %>% 
##      group_by(class, Suction, Moisture, Wetting, Amendments, Homogenization) %>% 
##      dplyr::summarize(abund = sum(presence)) %>% 
##      group_by(Suction, Moisture, Wetting, Amendments, Homogenization) %>% 
##      dplyr::mutate(total = sum(abund)) %>% 
##      ungroup() %>% 
##      mutate(relabund = (abund/total)*100) %>% 
##      dplyr::select(-abund, -total) %>% 
##      spread(class, relabund)
##    
##    library(cluster)  
##    
##    x = daisy(agriculture, metric = "euclidean")  
##    as.matrix(x)  
##    summary(x)
##    print(x)
##    
##    dist = vegdist((relabund_wide %>% select(aliphatic:condensed_arom)), method = "euclidean")
##    
##    newdrought_wide2 = 
##      newdrought_wide %>% 
##      mutate(SuctionWetting = paste0(Suction, "-", Wetting)) %>% 
##      column_to_rownames("SuctionWetting") %>% 
##      dplyr::select(aliphatic:`unsaturated/lignin`)
##    
##    
##    
##    
##    
##    relabund_wide = 
##      relabund_cores %>% 
##      filter(!Suction==15) %>% 
##      dplyr::select(Core, SampleAssignment, class, relabund, 
##                    Moisture, Wetting, Suction, Homogenization, Amendments) %>% 
##      spread(class, relabund) %>% 
##      replace(is.na(.), 0)
##    
##    permanova_fticr_all = 
##      adonis(relabund_wide %>% select(aliphatic:condensed_arom) ~ (Amendments+Moisture+Wetting+Suction+Homogenization)^2, 
##             data = relabund_wide)
##    
##    broom::tidy(permanova_fticr_all$aov.tab)
##    
##    permanova_fticr_all = 
##      adonis(dist ~ (Amendments+Moisture+Wetting+Suction+Homogenization)^2, 
##             data = relabund_wide)
##    broom::tidy(permanova_fticr_all$aov.tab)
##    
##    
##    fticr_wide = 
##      data_key %>% 
##      filter(Homogenization=="Intact" & Moisture == "drought" & Amendments != "N" & Suction == 50) %>% 
##      dplyr::select(formula, Core, Homogenization, Suction, presence) %>% 
##      arrange(Core, Homogenization, Suction, formula) %>% 
##      spread(formula, presence) %>% 
##      replace(is.na(.),0) %>% 
##      dplyr::select(-c(Core, Homogenization, Suction))
##    
##    data_key2 =
##      data_key %>% 
##      distinct(Core, Homogenization, Suction, Moisture, Wetting, Amendments) %>% 
##      filter(Homogenization=="Intact" & Moisture == "drought" & Amendments != "N" & Suction == 50) %>% 
##      arrange(Core, Homogenization, Suction) %>% 
##      dplyr::select(Wetting, Amendments)
##    
##    permanova_fticr_all = 
##      adonis(fticr_wide ~ (Wetting+Amendments)^2, 
##             data = data_key2)  
##    broom::tidy(permanova_fticr_all$aov.tab)


# IGNORE -------------------------------------------------------------------------

# relabund bar graphs
##    
##    
##    
##    
##    relabund_newdrought = 
##      newpeaks_drought %>% 
##      left_join(meta_classes, by = "formula") %>% 
##      group_by(Suction, class, Wetting) %>% 
##      dplyr::summarise(abund = sum(presence)) %>% 
##      group_by(Suction, Wetting) %>% 
##      dplyr::mutate(total = sum(abund),
##                    relabund = round((abund/total)*100,2))
##    
##    
##    relabund_newdrought %>% 
##      ggplot(aes(x = Wetting, y = relabund, fill = class))+
##      geom_bar(stat = "identity")+
##      scale_fill_manual(values = PNWColors::pnw_palette("Sailboat"))+
##      facet_grid(Suction~.)+
##      theme_kp()+
##      theme(legend.position = "right")+
##      labs(title = "new peaks drought",
##           x = "")+
##      scale_x_discrete(labels = c("precip" = "PR", "groundw" = "GW"))
##    
##    
##    relabund_newhomo = 
##      newpeaks_homo %>% 
##      left_join(meta_classes, by = "formula") %>% 
##      group_by(Suction, class, Wetting) %>% 
##      dplyr::summarise(abund = sum(presence)) %>% 
##      group_by(Suction, Wetting) %>% 
##      dplyr::mutate(total = sum(abund),
##                    relabund = round((abund/total)*100,2))
##    
##    
##    relabund_newhomo %>% 
##      ggplot(aes(x = Wetting, y = relabund, fill = class))+
##      geom_bar(stat = "identity")+
##      scale_fill_manual(values = PNWColors::pnw_palette("Sailboat"))+
##      facet_grid(Suction~.)+
##      theme_kp()+
##      theme(legend.position = "right")+
##      labs(title = "new peaks homogen",
##           x = "")+
##      scale_x_discrete(labels = c("precip" = "PR", "groundw" = "GW"))
##    
##    
##    relabund_c = 
##      newpeaks_c %>% 
##      left_join(meta_classes, by = "formula") %>% 
##      group_by(Suction, class, Wetting) %>% 
##      dplyr::summarise(abund = sum(presence)) %>% 
##      group_by(Suction, Wetting) %>% 
##      dplyr::mutate(total = sum(abund),
##                    relabund = round((abund/total)*100,2))
##    
##    
##    relabund_c %>% 
##      ggplot(aes(x = Wetting, y = relabund, fill = class))+
##      geom_bar(stat = "identity")+
##      scale_fill_manual(values = PNWColors::pnw_palette("Sailboat"))+
##      facet_grid(Suction~.)+
##      theme_kp()+
##      theme(legend.position = "right")+
##      labs(title = "new peaks +C",
##           x = "")+
##      scale_x_discrete(labels = c("precip" = "PR", "groundw" = "GW"))
##    
##    
##    relabund_n = 
##      newpeaks_n %>% 
##      left_join(meta_classes, by = "formula") %>% 
##      group_by(Suction, class, Wetting) %>% 
##      dplyr::summarise(abund = sum(presence)) %>% 
##      group_by(Suction, Wetting) %>% 
##      dplyr::mutate(total = sum(abund),
##                    relabund = round((abund/total)*100,2))
##    
##    
##    relabund_n %>% 
##      ggplot(aes(x = Wetting, y = relabund, fill = class))+
##      geom_bar(stat = "identity")+
##      scale_fill_manual(values = PNWColors::pnw_palette("Sailboat"))+
##      facet_grid(Suction~.)+
##      theme_kp()+
##      theme(legend.position = "right")+
##      labs(title = "new peaks +N",
##           x = "")+
##      scale_x_discrete(labels = c("precip" = "PR", "groundw" = "GW"))
##    
##    
##    
##    # pca ---------------------------------------------------------------------
##    
##    data_pca = 
##      data_key %>% 
##      filter((Homogenization == "Intact" & Moisture == "fm")|
##               (Homogenization == "Intact" & Moisture == "drought" & Amendments == "control")|
##               (Homogenization == "Homogenized" & Moisture == "fm" & Amendments == "control")) %>% 
##      dplyr::select(Core, Homogenization, Suction, Moisture, Wetting, Amendments, formula, presence) %>% 
##      group_by(formula) %>% 
##      dplyr::mutate(n = n()) %>% 
##      filter(n != 75) %>% 
##      spread(formula, presence) %>% 
##      replace(is.na(.), 0)
##    
##    
##    data_pca = 
##      relabund_cores %>% 
##      filter((Homogenization == "Intact" & Moisture == "fm")|
##               (Homogenization == "Intact" & Moisture == "drought" & Amendments == "control")|
##               (Homogenization == "Homogenized" & Moisture == "fm" & Amendments == "control")) %>% 
##      dplyr::select(Core, Homogenization, Suction, Moisture, Wetting, Amendments, class, relabund) %>% 
##      filter(Suction == 1.5) %>% 
##      spread(class, relabund) %>% 
##      replace(is.na(.), 0)
##    
##    
##    data_pca_num = 
##      data_pca %>% 
##      dplyr::select(-c(Core:Amendments))
##    data_pca_grp = 
##      data_pca %>% 
##      dplyr::select(c(Core:Amendments))
##    
##    
##    pca_int = prcomp(data_pca_num, scale. = T)
##    
##    ggbiplot(pca_int, obs.scale = 1, var.scale = 1, 
##                              groups = interaction(data_pca_grp$Amendments,
##                                                   data_pca_grp$Homogenization,
##                                                   data_pca_grp$Moisture), ellipse = TRUE, circle = FALSE,
##                              var.axes = TRUE) +
##      geom_point(size=3,stroke=1, 
##                 aes(color = groups))+
##      labs(title = "effect of suction")
##    
##    
##    ######
##    
##    data_pca = 
##      relabund_cores %>% 
##      filter((Homogenization == "Intact" & Moisture == "fm")) %>% 
##      dplyr::select(Core, Homogenization, Suction, Moisture, Wetting, Amendments, class, relabund) %>% 
##      filter(Suction == 1.5) %>% 
##      spread(class, relabund) %>% 
##      replace(is.na(.), 0)
##    
##    
##    data_pca_num = 
##      data_pca %>% 
##      dplyr::select(-c(Core:Amendments))
##    data_pca_grp = 
##      data_pca %>% 
##      dplyr::select(c(Core:Amendments))
##    
##    
##    pca_int = prcomp(data_pca_num, scale. = T)
##    
##    ggbiplot(pca_int, obs.scale = 1, var.scale = 1, 
##             groups = interaction(data_pca_grp$Amendments,
##                                  data_pca_grp$Wetting), ellipse = TRUE, circle = FALSE,
##             var.axes = TRUE) +
##      geom_point(size=3,stroke=1, 
##                 aes(color = data_pca_grp$Amendments,
##                     shape = data_pca_grp$Wetting))+
##      labs(title = "effect of suction")
##    
##    
##    ######
##    
##    data_pca = 
##      relabund_cores %>% 
##      filter((Amendments == "control" & Moisture == "fm")) %>% 
##      dplyr::select(Core, Homogenization, Suction, Moisture, Wetting, Amendments, class, relabund) %>% 
##      filter(Suction == 50) %>% 
##      spread(class, relabund) %>% 
##      replace(is.na(.), 0)
##    
##    
##    data_pca_num = 
##      data_pca %>% 
##      dplyr::select(-c(Core:Amendments))
##    data_pca_grp = 
##      data_pca %>% 
##      dplyr::select(c(Core:Amendments))
##    
##    
##    pca_int = prcomp(data_pca_num, scale. = T)
##    
##    ggbiplot(pca_int, obs.scale = 1, var.scale = 1, 
##             groups = interaction(data_pca_grp$Homogenization), ellipse = TRUE, circle = FALSE,
##             var.axes = TRUE) +
##      geom_point(size=3,stroke=1, 
##                 aes(color = data_pca_grp$Homogenization,
##                     shape = data_pca_grp$Wetting))+
##      labs(title = "effect of suction")
##    
##    ######
##    data_long_trt %>% 
##      filter(Homogenization == "Intact" & Moisture == "drought") %>% 
##      gg_vankrev(aes(x = OC, y = HC, color = Wetting))+
##      stat_ellipse(show.legend = F)+
##      facet_grid(Suction ~ Amendments)+
##      theme_kp()
##    
##    
##    newpeaks_drought_c = 
##      data_long_trt %>% 
##      filter(Homogenization == "Intact" & Moisture == "drought" & Amendments != "N") %>% 
##      group_by(Suction, Wetting, formula) %>% 
##      dplyr::mutate(n = n()) %>% 
##      filter(n == 1) %>% 
##      ungroup() %>% 
##      mutate(lossgain = dplyr::recode(Amendments, "control" = "loss", "C" = "gain"))
##      
##    newpeaks_drought_c %>% 
##      filter(lossgain == "gain") %>% 
##      gg_vankrev(aes(x = OC, y = HC, color = Wetting))+
##      stat_ellipse(show.legend = F, level = 0.90)+
##      facet_grid(. ~Suction)+
##      theme_kp()+
##      NULL
##    



# extra plots ----
##  newpeaks_drought = 
##    data_long_trt %>% 
##    filter(Homogenization == "Intact" & Amendments == "control") %>%
##    group_by(formula, Suction, Wetting) %>% 
##    dplyr::mutate(n = n()) %>% 
##    filter(n == 1 & Moisture == "drought")
##    
##  newpeaks_drought %>% 
##    gg_vankrev(aes(x = OC, y = HC, color = Wetting))+
##    stat_ellipse(show.legend = F, level = 0.90)+
##    facet_grid(.~Suction)+
##    labs(title = "new peaks after drought",
##         subtitle = "intact, control cores")+
##    scale_color_manual(values = c("#0f85a0", "#ed8b00"))+
##    theme_kp()+
##    theme(legend.position = c(0.15, 0.9))+
##    guides(color = guide_legend(nrow = 1, override.aes = list(alpha=1, size=2)))+
##    NULL
##  
##  lostgainedpeaks_homo = 
##    data_long_trt %>% 
##    filter(Amendments == "control" & Moisture == "fm") %>% 
##    group_by(formula, Suction, Wetting, Homogenization) %>% 
##    dplyr::mutate(n = n()) %>% 
##    filter(n == 1) %>% 
##    ungroup() %>% 
##    mutate(loss_gain = dplyr::recode(Homogenization, "Intact" = "lost", "Homogenized" = "gained"))
## 
##  lostgainedpeaks_homo %>% 
##    gg_vankrev(aes(x = OC, y = HC, color = loss_gain))+
##    stat_ellipse(show.legend = F)+
##    facet_grid(Suction~Wetting)+
##    labs(title = "new peaks after drought",
##         subtitle = "intact, control cores")+
##    scale_color_manual(values = (PNWColors::pnw_palette("Bay",2)))+
##    #theme(legend.position = "none")+
##    theme_kp()+
##    NULL 
##  
##  
##  newpeaks_c = 
##    data_long_trt %>% 
##    filter(Homogenization == "Intact" & Amendments %in% c("control", "C") & Moisture == "fm") %>% 
##    group_by(formula, Suction, Wetting) %>% 
##    dplyr::mutate(n = n()) %>% 
##    filter(n == 1 & Amendments == "C") 
## 
##  newpeaks_c %>% 
##    gg_vankrev(aes(x = OC, y = HC, color = Wetting))+
##    stat_ellipse(show.legend = F, level = 0.90)+
##    scale_color_manual(values = (PNWColors::pnw_palette("Bay",2)))+
##    facet_grid(Homogenization+Suction~Moisture)+
##    labs(title = "new peaks after +C",
##         subtitle = "FM, intact cores")+
##    #theme(legend.position = "none")+
##    theme_kp()+
##    NULL  
##  
##  newpeaks_n = 
##    data_long_trt %>% 
##    filter(Homogenization == "Intact" & Amendments %in% c("control", "N") & Moisture == "fm") %>% 
##    group_by(formula, Suction, Wetting) %>% 
##    dplyr::mutate(n = n()) %>% 
##    filter(n == 1 & Amendments == "N") 
##  
##  newpeaks_n %>% 
##    gg_vankrev(aes(x = OC, y = HC, color = Wetting))+
##    stat_ellipse(show.legend = F)+
##    scale_color_manual(values = (PNWColors::pnw_palette("Bay",2)))+
##    facet_grid(Homogenization+Suction~Moisture)+
##    labs(title = "new peaks after +N",
##         subtitle = "FM, intact cores")+
##    #theme(legend.position = "none")+
##    theme_kp()+
##    NULL  
##  
##  lostgainedpeaks_droughtc = 
##    data_long_trt %>% 
##    filter(Homogenization == "Intact" & Amendments %in% c("control", "C") & Moisture == "drought") %>% 
##    group_by(formula, Suction, Wetting) %>% 
##    dplyr::mutate(n = n()) %>% 
##    filter(n == 1) %>% 
##    ungroup() %>% 
##    mutate(loss_gain = dplyr::recode(Amendments, "control" = "lost", "C" = "gained"))
##  
##  lostgainedpeaks_droughtc %>% 
##    gg_vankrev(aes(x = OC, y = HC, color = loss_gain))+
##    stat_ellipse(show.legend = F, level = 0.90)+
##    facet_grid(Wetting ~ Suction)+
##    labs(title = "peaks lost/gained after +C",
##         subtitle = "intact, drought cores")+
##    scale_color_manual(values = c("grey70", "#0F4C81"))+
##    theme_kp()+
##    theme(legend.position = c(0.9, 0.9))+
##    NULL



## generalized PCA plots ---------------------------------------------------
##    
##    plot_pca_general_int = function(relabund_cores){
##      pca_file_int = 
##        relabund_cores %>% 
##        filter(!Suction==15 & Homogenization == "Intact") %>% 
##        dplyr::select(Core, SampleAssignment, class, relabund, 
##                      Moisture, Wetting, Suction, Homogenization, Amendments) %>% 
##        spread(class, relabund) %>% 
##        replace(is.na(.), 0) %>% 
##        select(-1, -2)
##      
##      pca_num = 
##        pca_file_int %>% 
##        dplyr::select(aliphatic, aromatic, condensed_arom, `unsaturated/lignin`)
##      
##      pca_grp = 
##        pca_file_int %>% 
##        dplyr::select(-c(aliphatic, aromatic, condensed_arom, `unsaturated/lignin`)) %>% 
##        dplyr::mutate(row = row_number())
##      
##      pca_int = prcomp(pca_num, scale. = T)
##      
##      gg_pca_suction = ggbiplot(pca_int, obs.scale = 1, var.scale = 1, 
##               groups = as.character(pca_grp$Suction), ellipse = TRUE, circle = FALSE,
##               var.axes = TRUE) +
##        geom_point(size=3,stroke=1, 
##                   aes(color = groups))+
##        labs(title = "effect of suction")
##      
##      ggbiplot(pca_int, obs.scale = 1, var.scale = 1, 
##               groups = as.character(pca_grp$Wetting), ellipse = TRUE, circle = FALSE,
##               var.axes = TRUE) +
##        geom_point(size=3,stroke=1, 
##                   aes(color = groups)) 
##      
##      ggbiplot(pca_int, obs.scale = 1, var.scale = 1, 
##               groups = as.character(pca_grp$Amendments), ellipse = TRUE, circle = FALSE,
##               var.axes = TRUE) +
##        geom_point(size=3,stroke=1, 
##                   aes(color = groups)) 
##    
##      ggbiplot(pca_int, obs.scale = 1, var.scale = 1, 
##               groups = as.character(pca_grp$Moisture), ellipse = TRUE, circle = FALSE,
##               var.axes = TRUE) +
##        geom_point(size=3,stroke=1, fill = "white", 
##                   aes(color = groups, shape = as.character(pca_grp$Suction)))+
##        scale_shape_manual(values = c(8, 16))+
##        labs(title = "effect of moisture",
##             shape = "Suction")
##      
##      ## 1.5 kPa
##      pca_num_1 = 
##        pca_file_int %>% 
##        filter(Suction==1.5) %>% 
##        dplyr::select(aliphatic, aromatic, condensed_arom, `unsaturated/lignin`)
##      
##      pca_grp_1 = 
##        pca_file_int %>% 
##        filter(Suction==1.5) %>% 
##        dplyr::select(-c(aliphatic, aromatic, condensed_arom, `unsaturated/lignin`)) %>% 
##        dplyr::mutate(row = row_number())
##      
##      pca_int_1 = prcomp(pca_num_1, scale. = T)
##      
##      gg_pca_1 = ggbiplot(pca_int_1, obs.scale = 1, var.scale = 1, 
##               groups = as.character(pca_grp_1$Moisture), ellipse = TRUE, circle = FALSE,
##               var.axes = TRUE) +
##        geom_point(size=3,stroke=1, 
##                   aes(color = groups, shape = pca_grp_1$Wetting))+
##        labs(title = "effect of Moisture, 1.5 kPa",
##             shape = "Wetting")
##      
##      
##      ggbiplot(pca_int_1, obs.scale = 1, var.scale = 1, 
##               groups = as.character(pca_grp_1$Amendments), ellipse = TRUE, circle = FALSE,
##               var.axes = TRUE) +
##        geom_point(size=3,stroke=1, 
##                   aes(color = groups, shape = pca_grp_1$Moisture)) 
##      
##      
##      ## 50 kPa
##      pca_num_5 = 
##        pca_file_int %>% 
##        filter(Suction==50) %>% 
##        dplyr::select(aliphatic, aromatic, condensed_arom, `unsaturated/lignin`)
##      
##      pca_grp_5 = 
##        pca_file_int %>% 
##        filter(Suction==50) %>% 
##        dplyr::select(-c(aliphatic, aromatic, condensed_arom, `unsaturated/lignin`)) %>% 
##        dplyr::mutate(row = row_number())
##      
##      pca_int_5 = prcomp(pca_num_5, scale. = T)
##      
##      gg_pca_5 = ggbiplot(pca_int_5, obs.scale = 1, var.scale = 1, 
##               groups = as.character(pca_grp_5$Moisture), ellipse = TRUE, circle = FALSE,
##               var.axes = TRUE) +
##        geom_point(size=3,stroke=1, 
##                   aes(color = groups, shape = pca_grp_5$Wetting)) +
##        labs(title = "effect of Moisture, 50 kPa",
##             shape = "Wetting")+
##        xlim(-3,3)
##      
##      
##      ggbiplot(pca_int_5, obs.scale = 1, var.scale = 1, 
##               groups = as.character(pca_grp_5$Amendments), ellipse = TRUE, circle = FALSE,
##               var.axes = TRUE) +
##        geom_point(size=3,stroke=1, 
##                   aes(color = groups, shape = pca_grp_5$Wetting)) 
##      
##      
##      library(patchwork)
##      gg_pca_1+gg_pca_5+
##        plot_layout(guides = "collect")
##    }
##    
##    
##    
##    
##    
# IVb. PCA -- unique peaks -----------------------------------------------------

##    compute_pca = function(dat){
##     data_unique_all <-  
##       data_long_trt %>% 
##       group_by(formula, Suction, Homogenization, Moisture, Wetting) %>% 
##       dplyr::mutate(n = n()) %>% 
##       filter(n==1) %>% 
##       filter(Homogenization=="Intact")
##     
##   
##     # raw counts ----  
##     data_unique_counts = 
##       data_unique_all %>% 
##       left_join(meta_classes, by = "formula") %>% 
##       group_by(Suction, Moisture, Wetting, Amendments, Homogenization, class) %>% 
##       dplyr::summarise(counts = sum(presence))
##     
##     unique_wide_intact = 
##       data_unique_counts %>% 
##       spread(class, counts) %>% 
##       replace(is.na(.), 0)
##     
##     unique_wide_pca = 
##       unique_wide_intact %>% 
##       ungroup ()
##     
##     ## 1.5 kPa  ---
##     unique_wide_pca_1 = 
##       unique_wide_pca %>% 
##       filter(Suction==1.5)
##     
##     unique_pca_num_1  = 
##       unique_wide_pca_1 %>% 
##       dplyr::select(., -(1:5))
##     
##     unique_pca_grp_1  = 
##       unique_wide_pca_1 %>% 
##       dplyr::select(., (1:5)) %>% 
##       dplyr::mutate(row = row_number())
##     
##     unique_pca_1 = prcomp(unique_pca_num_1, scale. = T)
##     
##     ggbiplot(unique_pca_1, obs.scale = 1, var.scale = 1, 
##              groups = as.character(unique_pca_grp_1$Amendments), ellipse = TRUE, circle = FALSE,
##              var.axes = TRUE) +
##       geom_point(size=5,stroke=1, 
##                  aes(color = groups, 
##                      shape = interaction(as.factor(unique_pca_grp_1$Moisture),
##                                          as.factor(unique_pca_grp_1$Wetting))))+
##       scale_shape_manual(values = c(1, 2, 19, 17))+
##       scale_color_manual(values = pal3)+
##       labs(shape="",
##            title = "INTACT unique",
##            subtitle = "1.5 kPa")+
##       NULL
##     
##     ## 50 kPa  ---
##     unique_wide_pca_5 = 
##       unique_wide_pca %>% 
##       filter(Suction==50)
##     
##     unique_pca_num_5  = 
##       unique_wide_pca_5 %>% 
##       dplyr::select(., -(1:5))
##     
##     unique_pca_grp_5  = 
##       unique_wide_pca_5 %>% 
##       dplyr::select(., (1:5)) %>% 
##       dplyr::mutate(row = row_number())
##     
##     unique_pca_5 = prcomp(unique_pca_num_5, scale. = T)
##     
##     ggbiplot(unique_pca_5, obs.scale = 1, var.scale = 1, 
##              groups = as.character(unique_pca_grp_5$Amendments), ellipse = TRUE, circle = FALSE,
##              var.axes = TRUE) +
##       geom_point(size=5,stroke=1, 
##                  aes(color = groups, 
##                      shape = interaction(as.factor(unique_pca_grp_5$Moisture),
##                                          as.factor(unique_pca_grp_5$Wetting))))+
##       scale_shape_manual(values = c(1, 2, 19, 17))+
##       scale_color_manual(values = pal3)+
##       labs(shape="",
##            title = "INTACT unique",
##            subtitle = "50 kPa")+
##       NULL 
##    
##     
##     # unique relabund ----  
##     data_unique_counts = 
##       data_unique_all %>% 
##       left_join(meta_classes, by = "formula") %>% 
##       group_by(Suction, Moisture, Wetting, Amendments, Homogenization, class) %>% 
##       dplyr::summarise(counts = sum(presence)) %>% 
##       group_by(Suction, Moisture, Wetting, Amendments, Homogenization) %>%
##       dplyr::mutate(total = sum(counts),
##                     unique_rel = round((counts/total)*100,2))
##     
##     unique_wide_pca = 
##       data_unique_counts %>% 
##       dplyr::select(Suction, Moisture, Wetting, Amendments, Homogenization, class, unique_rel) %>% 
##       spread(class, unique_rel) %>% 
##       replace(is.na(.), 0) %>% 
##       ungroup ()
##     
##     ## 1.5 kPa  ---
##     unique_wide_pca_1 = 
##       unique_wide_pca %>% 
##       filter(Suction==1.5)
##     
##     unique_pca_num_1  = 
##       unique_wide_pca_1 %>% 
##       dplyr::select(., -(1:5))
##     
##     unique_pca_grp_1  = 
##       unique_wide_pca_1 %>% 
##       dplyr::select(., (1:5)) %>% 
##       dplyr::mutate(row = row_number())
##     
##     unique_pca_1 = prcomp(unique_pca_num_1, scale. = T)
##     
##     ggbiplot(unique_pca_1, obs.scale = 1, var.scale = 1, 
##              groups = as.character(unique_pca_grp_1$Amendments), ellipse = TRUE, circle = FALSE,
##              var.axes = TRUE) +
##       geom_point(size=5,stroke=1, 
##                  aes(color = groups, 
##                      shape = interaction(as.factor(unique_pca_grp_1$Moisture),
##                                          as.factor(unique_pca_grp_1$Wetting))))+
##       scale_shape_manual(values = c(1, 2, 19, 17))+
##       scale_color_manual(values = pal3)+
##       labs(shape="",
##            title = "INTACT unique",
##            subtitle = "1.5 kPa")+
##       NULL
##     
##     ## 50 kPa  ---
##     unique_wide_pca_5 = 
##       unique_wide_pca %>% 
##       filter(Suction==50)
##     
##     unique_pca_num_5  = 
##       unique_wide_pca_5 %>% 
##       dplyr::select(., -(1:5))
##     
##     unique_pca_grp_5  = 
##       unique_wide_pca_5 %>% 
##       dplyr::select(., (1:5)) %>% 
##       dplyr::mutate(row = row_number())
##     
##     unique_pca_5 = prcomp(unique_pca_num_5, scale. = T)
##     
##     ggbiplot(unique_pca_5, obs.scale = 1, var.scale = 1, 
##              groups = as.character(unique_pca_grp_5$Amendments), ellipse = TRUE, circle = FALSE,
##              var.axes = TRUE) +
##       geom_point(size=5,stroke=1, 
##                  aes(color = groups, 
##                      shape = interaction(as.factor(unique_pca_grp_5$Moisture),
##                                          as.factor(unique_pca_grp_5$Wetting))))+
##       scale_shape_manual(values = c(1, 2, 19, 17))+
##       scale_color_manual(values = pal3)+
##       labs(shape="",
##            title = "INTACT unique",
##            subtitle = "50 kPa")+
##       NULL 
##     
##     
##     
##     
##   ## bar ----
##    data_unique_counts %>% 
##       ggplot(aes(x = Amendments, y = counts, fill = class))+
##       geom_bar(stat = "identity")+
##       facet_grid(Suction ~ Moisture + Wetting)+
##       labs(title = "Unique Peaks, Intact Cores")
##     
##   }
##   
##   










##   
##   relabund_wide = 
##     relabund_cores %>% 
##     filter(!Suction==15) %>% 
##     dplyr::select(Core, SampleAssignment, class, relabund, 
##                   Moisture, Wetting, Suction, Homogenization, Amendments) %>% 
##     spread(class, relabund) %>% 
##     replace(is.na(.), 0),
##   
##   relabund_pca=
##     relabund_wide %>% 
##     select(-1),

##  # IIIb1. intact cores -----------------------------------------------------
##   relabund_pca_num_intact = 
##     relabund_pca %>% 
##     filter(Homogenization=="Intact") %>% 
##     dplyr::select(.,-(1:6)),
##   
##   relabund_pca_grp_intact = 
##     relabund_pca %>% 
##     filter(Homogenization=="Intact") %>% 
##     dplyr::select(.,(1:6)) %>% 
##     dplyr::mutate(row = row_number()),
##   
##   pca_int = prcomp(relabund_pca_num_intact, scale. = T),
##   #summary(pca)
##   
##   gg_pca_intact_plots = do_gg_pca_intact_plots(pca_int, relabund_pca_grp_intact),    ##  




