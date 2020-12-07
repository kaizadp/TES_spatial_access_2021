# TES SPATIAL ACCESS
# workflow and functions for fticr graphs 

# Plots for various pipeline targets

options(scipen = 999)
# 0a. set color palette ----------------------------------------------------
pal3 = c("#FFE733", "#96001B", "#2E5894") #soil_palette("redox2")

# 0b. fit models for scatterplots ------------------------------------------
fit_aov_moisture = function(depvar, Moisture){
  # boxplot p-values
  a1 <- aov(log(depvar) ~ Moisture)
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
fit_aov_wetting = function(depvar, Wetting){
  a3 = aov(log(depvar) ~ Wetting)
  broom::tidy(a3) %>% 
    filter(term != "Residuals") %>% 
    dplyr::select(term, `p.value`) %>% 
    filter(`p.value` <= 0.05)
}

#
# I. van krevelens -----------------------------------------------------------
do_vk_reps <- function(data_key, meta_hcoc) {
  gg_fticr_reps_1_5_intact <- 
    data_key %>%
    filter(Homogenization == "Intact" & Suction == 1.5) %>% 
    left_join(meta_hcoc, by = "formula") %>%
    gg_vankrev(aes(x = OC, y = HC, color = Amendments))+
    scale_color_manual(values = PNWColors::pnw_palette("Bay",3))+
    facet_grid(n~Moisture+Wetting)+
    labs(title = "1.5 kPa intact")+
    theme_kp()+
    NULL
  
  gg_fticr_reps_50_intact <- 
    data_key %>%
    filter(Homogenization == "Intact" & Suction == 50) %>% 
    left_join(meta_hcoc, by = "formula") %>%
    gg_vankrev(aes(x = OC, y = HC, color = Amendments))+
    scale_color_manual(values = PNWColors::pnw_palette("Bay",3))+
    facet_grid(n~Moisture+Wetting)+
    labs(title = "50 kPa intact")+
    theme_kp()+
    NULL
  
  gg_fticr_reps_1_5_homo <- 
    data_key %>%
    filter(Homogenization == "Homogenized" & Suction == 1.5) %>% 
    left_join(meta_hcoc, by = "formula") %>%
    gg_vankrev(aes(x = OC, y = HC, color = Amendments))+
    scale_color_manual(values = PNWColors::pnw_palette("Bay",3))+
    facet_grid(n~Moisture+Wetting)+
    labs(title = "1.5 kPa hommogenized")+
    theme_kp()+
    NULL
  
  gg_fticr_reps_50_homo <- 
    data_key %>%
    filter(Homogenization == "Homogenized" & Suction == 50) %>% 
    left_join(meta_hcoc, by = "formula") %>%
    gg_vankrev(aes(x = OC, y = HC, color = Amendments))+
    scale_color_manual(values = PNWColors::pnw_palette("Bay",3))+
    facet_grid(n~Moisture+Wetting)+
    labs(title = "50 kPa homogenized")+
    theme_kp()+
    NULL
  
  list(
       gg_fticr_reps_1_5_intact = gg_fticr_reps_1_5_intact, 
       gg_fticr_reps_50_intact = gg_fticr_reps_50_intact,
       gg_fticr_reps_1_5_homo = gg_fticr_reps_1_5_homo, 
       gg_fticr_reps_50_homo = gg_fticr_reps_50_homo)
}

do_vk_pores <- function(data_long_trt) {
 # (gg_fticr_pores_1_5kPa <-  
 #   data_long_trt %>%
 #   filter(Suction=="1.5") %>% 
 #   gg_vankrev(aes(x = OC, y = HC, color = Amendments))+
 #   stat_ellipse()+
 #   scale_color_manual(values = pal3)+
 #   # scale_alpha_manual(values = c(0.1, 0.3, 0.3))+
 #   facet_grid(Homogenization~Moisture+Wetting)+
 #   labs(title = "1.5 kPa")+
 #   NULL)
  
  
  gg_fticr_pores_1_5kPa <-  
    data_long_trt %>%
    filter(Suction=="1.5") %>% 
    gg_vankrev(aes(x = OC, y = HC, color = Amendments))+
    geom_point(size=0.7, alpha = 0.8)+
    #  scale_color_manual(values = (pnw_palette("Bay",3)))+
    scale_color_manual(values = pal3)+
    facet_grid(Homogenization~Moisture+Wetting)+
    labs(title = "1.5 kPa")+
    theme_kp()+
    NULL
  
  
  gg_fticr_pores_50kPa <-  
    data_long_trt %>%
    filter(Suction=="50") %>% 
    gg_vankrev(aes(x = OC, y = HC, color = Amendments))+
    stat_ellipse(show.legend = F)+
    scale_color_manual(values = pal3)+
    facet_grid(Homogenization~Moisture+Wetting)+
    labs(title = "50 kPa")+
    #theme(legend.position = "none")+
    theme_kp()+
    NULL 
  
  list(
    gg_fticr_pores_1_5kPa = gg_fticr_pores_1_5kPa,
    gg_fticr_pores_50kPa = gg_fticr_pores_50kPa)
}

do_vk_unique <- function(data_long_trt) {
  data_unique <-  
    data_long_trt %>% 
    group_by(formula, Suction, Homogenization, Moisture, Wetting) %>% 
    dplyr::mutate(n = n()) %>% 
    filter(n==1) %>% 
    filter(Amendments != "control")
  
  
  gg_control <- 
    data_long_trt %>% 
    filter(Amendments =="control") %>%
    ggplot(aes(x = OC, y = HC))+
    #geom_point(size=2, color = "grey50", alpha = 0.1)+
    geom_point(size=0.5, color = "#FFE733", alpha = 0.2)+
    labs(y = "H/C",
         x = "O/C") +
    xlim(0,1.25) +
    ylim(0,2.5) +
    geom_segment(x = 0.0, y = 1.5, xend = 1.2, yend = 1.5,color="black",linetype="longdash") +
    geom_segment(x = 0.0, y = 0.7, xend = 1.2, yend = 0.4,color="black",linetype="longdash") +
    geom_segment(x = 0.0, y = 1.06, xend = 1.2, yend = 0.51,color="black",linetype="longdash")
  
  gg_fticr_unique_int <-
    gg_control +
    geom_point(data = data_unique %>% filter(Homogenization=="Intact"), aes(color = Amendments),
               size = 0.5, alpha = 0.8)+
    scale_color_manual(values = c("#96001B", "#2E5894"))+
    facet_grid(Suction~Moisture+Wetting)+
    labs(title = "unique peaks -- intact cores",
         caption = "yellow = all peaks in control soils")+
    theme_kp()+
    guides(colour = guide_legend(override.aes = list(alpha=1, size=2)))+
    NULL
    
  gg_fticr_unique_homo <-
      gg_control +
      geom_point(data = data_unique %>% filter(Homogenization=="Homogenized"), aes(color = Amendments),
                 size = 0.7, alpha = 0.8)+
    scale_color_manual(values = c("#96001B", "#2E5894"))+
    facet_grid(Suction~Moisture+Wetting)+
      labs(title = "unique peaks -- homogenized cores",
           caption = "yellow = all peaks in control soils")+
      theme_kp()+
      guides(colour = guide_legend(override.aes = list(alpha=1, size=2)))+
      NULL
  
                  #  gg_fticr_unique_int  <- 
                  #    data_unique %>% 
                  #    #left_join(meta_hcoc, by = "formula") %>%
                  #    filter(Homogenization=="Intact") %>% 
                  #    gg_vankrev(aes(x = OC, y = HC, color = Amendments))+
                  #    #stat_ellipse()+
                  #    scale_color_manual(values = pal)+
                  #    facet_grid(Suction~Moisture+Wetting)+
                  #    labs(title = "intact cores")+
                  #    #theme(legend.position = "none")+
                  #    NULL
                  #  
                  #  gg_fticr_unique_homo <- 
                  #    data_unique %>% 
                  #    left_join(meta_hcoc, by = "formula") %>%
                  #    filter(Homogenization=="Homogenized") %>% 
                  #    gg_vankrev(aes(x = OC, y = HC, color = Amendments))+
                  #    #stat_ellipse()+
                  #    scale_color_manual(values = pal)+
                  #    facet_grid(Suction~Moisture+Wetting)+
                  #    labs(title = "homogenized cores")+
                  #    #theme(legend.position = "none")+
                  #    NULL
                    
  list(
    gg_fticr_unique_int = gg_fticr_unique_int,
    gg_fticr_unique_homo = gg_fticr_unique_homo)
}

do_vk_homo_new <- function(data_long_trt){
  data_homo_new = 
    data_long_trt %>% 
    group_by(formula, Suction, Moisture, Wetting, Amendments) %>% 
    dplyr::mutate(n = n()) %>% 
    ungroup()%>% 
    filter(n==1 & Homogenization=="Homogenized")
  
  data_homo_new %>% 
    gg_vankrev(aes(x = OC, y = HC, color = Amendments))+
    stat_ellipse(show.legend = F)+
    scale_color_manual(values = pal3)+
    labs(title = "peaks introduced after homogenization")+
    facet_grid(Suction ~ Moisture + Wetting)+
    theme_kp()+
    NULL
}

# ---- -------------------------------------------------------------------------
#  ## Ia. domains
          #  gg_fticr_domains <- 
          #    data_long_trt %>% 
          #    distinct(formula) %>% 
          #    left_join(dplyr::select(meta, formula, class, HC, OC), by = "formula") %>% 
          #    gg_vankrev(aes(x = OC, y = HC, color = class))+
          #    scale_color_manual(values = PNWColors::pnw_palette("Sailboat"))+
          #    theme_kp()+
          #    theme(legend.position = "right")+
          #    NULL
          
          # do_fticrs <- function(data_long_trt, data_key, meta_hcoc) {
                     # gg_fticr_baseline <-      
           #   data_long_trt %>%
           #   filter(Moisture=="fm" & Wetting == "groundw" & Amendments=="control" & 
           #            Homogenization=="Intact") %>% 
           #   left_join(meta_hcoc, by = "formula") %>%
           #   gg_vankrev(aes(x = OC, y = HC, color = as.character(Suction)))+
           #   stat_ellipse()+
           #   scale_color_manual(values = PNWColors::pnw_palette("Bay",3))+
           #   labs(title = "baseline (fm, groundw, non-amended)")+
           #   theme_kp()+
           #   NULL
  

# ---- -------------------------------------------------------------------------

# II. peak counts ---------------------------------------------------------
# all peaks (bar plot)
do_gg_peaks_bar <- function(peakcounts_trt) {
    peakcounts_trt %>% 
      ggplot(aes(x = Amendments, y = peaks, fill = class))+
      geom_bar(stat = "identity")+
      labs(x = "",
           y = "peaks")+
      facet_grid(Homogenization+Suction~Moisture+Wetting)+
      NULL
}

# total peak counts (scatter plot)
do_labels_totalcounts_intact = function(depvar, peakcounts_core){
  # 0. make file ----
  peakcounts_core_total_int = 
    peakcounts_core %>% 
    filter(class=="total" & Homogenization=="Intact")
  
  # 1. p-values for moisture ----
  moisture_label <- 
    peakcounts_core_total_int %>% 
    group_by(Suction) %>% 
    do(fit_aov_moisture(.[[depvar]], .$Moisture)) %>% 
    mutate(x = 1.5,
           y = 0,
           label = paste("p =", p_value),
           label = if_else(p_value == 0, "p < 0.0001", label))
  
  # 2. HSD for amendments ----
  hsd_y <- peakcounts_core_total_int %>% 
    group_by(Suction, Moisture, Amendments) %>% 
    dplyr::summarize(max = max(counts),
                     y = max(counts) + 200)
  
  amend_label <- peakcounts_core_total_int %>% 
    group_by(Suction, Moisture) %>% 
    do(fit_hsd_amend(.$counts, .$Amendments)) %>% 
    dplyr::mutate(skip = control==C & C==N) %>% 
    filter(!skip) %>% 
    dplyr::select(-skip) %>% 
    pivot_longer(-c(Suction, Moisture),
                 names_to = "Amendments",
                 values_to = "label") %>% 
    mutate(m = dplyr::recode(Moisture, "fm"="1" , "drought"="2"),
           am = dplyr::recode(Amendments, "control" = -0.2, "C" = 0, "N" = 0.2),
           x = as.numeric(m)+as.numeric(am)) %>% 
    left_join(hsd_y)
  
  # 3. wetting label ----
  wetting_label <- 
    peakcounts_core_total_int %>% 
    group_by(Suction, Moisture, Amendments) %>% 
    do(fit_aov_wetting(.$counts, .$Wetting))
  
  # 4. combined label ----
  
  amend_label %>% rbind(moisture_label)
}
do_gg_totalcounts <- function(peakcounts_core) {
  totalcounts_label <- do_labels_totalcounts_intact("counts", peakcounts_core)
  
  peakcounts_core %>% 
    filter(class=="total" & Homogenization=="Intact") %>% 
    ggplot(aes(x = Moisture, y = counts))+
    geom_boxplot(aes(group = Moisture), 
                 fill = "grey90", alpha = 0.3, color = "grey60", width = 0.6)+
    geom_point(aes(fill = Amendments, shape = Wetting, group = Amendments),
               size=4, stroke=1, position = position_dodge(width = 0.6))+
    geom_text(data = totalcounts_label, aes(x = x, y = y, label = label), size=5)+
    scale_fill_manual(values = pal3)+
    scale_shape_manual(values = c(21,23))+
    guides(fill=guide_legend(override.aes=list(shape=21)))+
    labs(title = "total peak counts",
         y = "count",
         caption = "wetting sig for: 1.5/fm/control,C; 50/fm/C,N; 50/dr/control,N")+
    facet_grid(Homogenization~Suction)+
    theme_kp()+
    NULL
}


# effect of homogenization
fit_aov_homo = function(depvar, Homogenization){
  # boxplot p-values
  a1 <- aov(log(depvar) ~ Homogenization)
  label_a1 <- broom::tidy(a1) %>% 
    filter(term != "Residuals") %>% 
    mutate(p_value = round(p.value, 4)) %>% 
    dplyr::select(term, p_value) 
}
plot_totalcounts_homo <- function(peakcounts_core) {
  
  do_labels_totalcounts_homo = function(depvar, peakcounts_core){
    peakcounts_core %>%
      group_by(Suction, Amendments) %>% 
      do(fit_aov_homo(.[[depvar]], .$Homogenization)) %>% 
      mutate(x = 1.5,
             y = -200,
             label = paste("p =", p_value),
             label = if_else(p_value == 0, "p < 0.0001", label))
  }
  
  totalcounts_label_homo <- do_labels_totalcounts_homo("counts", peakcounts_core)
  
  peakcounts_core %>% 
    filter(class=="total") %>% 
    ggplot(aes(x = Homogenization, y = counts))+
    geom_boxplot(aes(group = Homogenization), 
                 fill = "grey90", alpha = 0.3, color = "grey60", width = 0.6)+
    geom_point(aes(fill = Moisture, shape = Wetting, group = Moisture),
               size=4, stroke=1, position = position_dodge(width = 0.6))+
    geom_text(data = totalcounts_label_homo, aes(x = x, y = y, label = label), size=5)+
    scale_shape_manual(values = c(21,23))+
    scale_fill_manual(values = soilpalettes::soil_palette("crait",2))+
    
    guides(fill=guide_legend(override.aes=list(shape=21)))+
    labs(title = "total peak counts",
         y = "count")+
    facet_grid(Suction~Amendments)+
    theme_kp()+
    NULL
}

# simple:complex peaks (scatter plots)
do_aliph_plots <- function(aliphatic_aromatic_counts) {
  gg_aliph_aromatic <- 
    aliphatic_aromatic_counts %>% 
    filter(Homogenization=="Intact") %>% 
    ggplot(aes(x = Amendments, y = arom_aliph_ratio, color = Amendments))+
    geom_point()+
    labs(y = "complex:simple")+
    facet_grid(Homogenization+Suction ~ Moisture+Wetting)+
    NULL
  
  gg_aliph_aromatic_intact_suction <-  
    aliphatic_aromatic_counts %>% 
    filter(Homogenization=="Intact") %>% 
    ggplot(aes(x = Moisture, y = arom_aliph_ratio, fill = Amendments, shape = Wetting))+
    geom_boxplot(fill=NA, color = "grey", aes(group=Moisture))+
    geom_point(size=4, stroke=1, position = position_dodge(width = 0.4), aes(group = Amendments))+
    scale_fill_manual(values = rev(soilpalettes::soil_palette("rendoll", 5)))+
    scale_shape_manual(values = c(21,23))+
    guides(fill=guide_legend(override.aes=list(shape=21)))+
    facet_grid(Homogenization~Suction)+
    theme_kp()+
    NULL
  
  list(gg_aliph_aromatic = gg_aliph_aromatic,
       gg_aliph_aromatic_intact_suction = gg_aliph_aromatic_intact_suction)
}

# ---- -------------------------------------------------------------------------
# III. relative abundance ------------------------------------------------------
# relative abundance (bar plot) 
do_relabund_barplots <- function(relabund_trt, relabund_cores_complex) {
  gg_fticr_relabund_barplots <-     
    relabund_trt %>%  
    ggplot(aes(x = Amendments, y = rel_abund, fill = class))+
    geom_bar(stat = "identity")+
    #scale_fill_viridis_d(option = "inferno")+
    scale_fill_manual(values = PNWColors::pnw_palette("Sailboat"))+
    labs(x = "",
         y = "relative abundance (%)")+
    facet_grid(Homogenization+Suction~Moisture+Wetting)+
    NULL
  
  list(gg_fticr_relabund_barplots = gg_fticr_relabund_barplots)
}

# contribution of complex peaks (scatter plot)
do_labels_complex_intact = function(depvar, relabund_cores_complex){
  # 1. p-values for moisture ----
  moisture_label <- 
    relabund_cores_complex %>% 
    filter(Homogenization=="Intact") %>% 
    group_by(Suction) %>% 
    do(fit_aov_moisture(.[[depvar]], .$Moisture)) %>% 
    mutate(x = 1.5,
           y = 40,
           label = paste("p =", p_value),
           label = if_else(p_value == 0, "p < 0.0001", label))
  
  # 2. HSD for amendments ----
  hsd_y = 
    relabund_cores_complex %>% 
    filter(Homogenization=="Intact") %>% 
    group_by(Suction, Moisture, Amendments) %>% 
    dplyr::summarize(max = max(relabund),
                     y = max(relabund) + 10)
  
  amend_label = 
    relabund_cores_complex %>% 
    filter(Homogenization=="Intact") %>% 
    group_by(Suction, Moisture) %>% 
    do(fit_hsd_amend(.$relabund, .$Amendments)) %>% 
    mutate(skip = control==C & C==N) %>% 
    filter(!skip) %>% 
    dplyr::select(-skip) %>% 
    pivot_longer(-c(Suction, Moisture),
                 names_to = "Amendments",
                 values_to = "label") %>% 
    mutate(m = dplyr::recode(Moisture, "fm"="1" , "drought"="2"),
           am = dplyr::recode(Amendments, "control" = -0.2, "C" = 0, "N" = 0.2),
           x = as.numeric(m)+as.numeric(am)) %>% 
    left_join(hsd_y)
  
  # 3. wetting label ----
  wetting_label = 
    relabund_cores_complex %>% 
    filter(Homogenization=="Intact") %>% 
    group_by(Suction, Moisture, Amendments) %>% 
    do(fit_aov_wetting(.$relabund, .$Wetting))
  
  # 4. combined label ----
  
  amend_label %>% rbind(moisture_label)
}
do_gg_complex <- function(relabund_cores_complex) {
  label <- do_labels_complex_intact("relabund", relabund_cores_complex)
  
  relabund_cores_complex %>% 
    filter(Homogenization=="Intact") %>% 
    ggplot(aes(x = Moisture, y = relabund))+
    geom_boxplot(aes(group = Moisture), 
                 fill = "grey90", alpha = 0.3, color = "grey60", width = 0.6)+
    geom_point(aes(fill = Amendments, shape = Wetting, group = Amendments),
               size=4, stroke=1, position = position_dodge(width = 0.6))+
    geom_text(data = label, aes(x = x, y = y, label = label), size=5)+
    scale_fill_manual(values = pal3)+
    scale_shape_manual(values = c(21,23))+
    guides(fill=guide_legend(override.aes=list(shape=21)))+
    labs(title = "contribution of complex molecules",
         y = "% contribution",
         caption = "wetting sig for: 1.5/fm/C,N; 1.5/dr/N; 50/fm/C; 50/dr/control")+
    facet_grid(Homogenization~Suction)+
    theme_kp()+
    NULL
}

# complex peaks, effect of homogenization
plot_complex_homo <- function(relabund_cores_complex) {
  
  do_labels_totalcounts_homo = function(depvar, relabund_cores_complex){
    relabund_cores_complex %>%
      group_by(Suction, Amendments) %>% 
      do(fit_aov_homo(.[[depvar]], .$Homogenization)) %>% 
      mutate(x = 1.5,
             y = 40,
             label = paste("p =", round(p_value,4)),
             label = if_else(p_value == 0, "p < 0.0001", label))
  }
  
  totalcounts_label_homo <- do_labels_totalcounts_homo("relabund", relabund_cores_complex)
  
  relabund_cores_complex %>% 
    ggplot(aes(x = Homogenization, y = relabund))+
    geom_boxplot(aes(group = Homogenization), 
                 fill = "grey90", alpha = 0.3, color = "grey60", width = 0.6)+
    geom_point(aes(fill = Moisture, shape = Wetting, group = Moisture),
               size=4, stroke=1, position = position_dodge(width = 0.6))+
    geom_text(data = totalcounts_label_homo, aes(x = x, y = y, label = label), size=5)+
    scale_shape_manual(values = c(21,23))+
    scale_fill_manual(values = soilpalettes::soil_palette("crait",2))+
    
    guides(fill=guide_legend(override.aes=list(shape=21)))+
    labs(title = "contribution of complex molecules",
         y = "% contribution")+
    facet_grid(Suction~Amendments)+
    theme_kp()+
    NULL
}

#
# IV. PCA ---------------------------------------------------------------------


do_gg_pca_intact_plots <- function(pca_int, relabund_pca_grp_intact) {
  gg_pca_intact_suction <- 
    ggbiplot(pca_int, obs.scale = 1, var.scale = 1, 
             groups = as.character(relabund_pca_grp_intact$Suction), ellipse = TRUE, circle = FALSE,
             var.axes = TRUE) +
    geom_point(size=5,stroke=1, 
               aes(color = groups, 
                   shape = interaction(as.factor(relabund_pca_grp_intact$Moisture),
                                       as.factor(relabund_pca_grp_intact$Wetting))))+
    scale_shape_manual(values = c(1, 2, 19, 17))+
    scale_color_manual(values = pal)+
    labs(shape="",
         title = "INTACT",
         subtitle = "grouped by suction")+
    NULL
  
  gg_pca_intact_amend  <-  
    ggbiplot(pca_int, obs.scale = 1, var.scale = 1, 
             groups = relabund_pca_grp_intact$Amendments, ellipse = TRUE, circle = FALSE,
             var.axes = TRUE)+
    geom_point(size=5,stroke=1, 
               aes(color = groups, 
                   shape = interaction(as.factor(relabund_pca_grp_intact$Moisture),
                                       as.factor(relabund_pca_grp_intact$Wetting))))+
    scale_shape_manual(values = c(1, 2, 19, 17))+
    scale_color_manual(values = pal)+
    labs(shape="",
         title = "INTACT",
         subtitle = "grouped by amendment")+
    NULL
  
  list(#gg_pca_intact_suction = gg_pca_intact_suction,
       #gg_pca_intact_amend = gg_pca_intact_amend,
       gg_fticr_pca_intact = gg_pca_intact_suction + gg_pca_intact_amend
  )
}

do_gg_pca_home_plots <- function(pca_homo, relabund_pca_grp_Homogenized) {
  gg_pca_homo_amend <- 
    ggbiplot(pca_homo, obs.scale = 1, var.scale = 1, 
             groups = relabund_pca_grp_Homogenized$Amendments, 
             ellipse = TRUE, circle = FALSE,
             var.axes = TRUE)+
    geom_point(size=5,stroke=1, 
               aes(color = groups, 
                   shape = interaction(as.factor(relabund_pca_grp_Homogenized$Moisture),
                                       as.factor(relabund_pca_grp_Homogenized$Wetting))))+
    scale_shape_manual(values = c(1, 2, 19, 17))+
    scale_color_manual(values = pal)+
    labs(shape="",
         title = "Homogenized",
         subtitle = "grouped by amendment")+
    NULL
  
  gg_pca_homo_suction <- 
    ggbiplot(pca_homo, obs.scale = 1, var.scale = 1, 
             groups = as.character(relabund_pca_grp_Homogenized$Suction), 
             ellipse = TRUE, circle = FALSE,
             var.axes = TRUE)+
    geom_point(size=5,stroke=1, 
               aes(color = groups, 
                   shape = interaction(as.factor(relabund_pca_grp_Homogenized$Moisture),
                                       as.factor(relabund_pca_grp_Homogenized$Wetting))))+
    scale_shape_manual(values = c(1, 2, 19, 17))+
    scale_color_manual(values = pal)+
    labs(shape="",
         title = "Homogenized",
         subtitle = "grouped by suction")+
    NULL
  
  list(#gg_pca_homo_amend = gg_pca_homo_amend,
       #gg_pca_homo_suction = gg_pca_homo_suction,
       gg_fticr_pca_homo = gg_pca_homo_suction + gg_pca_homo_amend)
}

do_gg_element_plots <- function(fticr_elements) {
  
  gg_elements_n <-  
    fticr_elements %>% 
    ggplot(aes(x = N, color = Amendments, fill = Amendments))+
    geom_histogram(position = position_dodge(width = 0.3), alpha = 0.5)+
    #geom_density(alpha = 0.2)+
    facet_grid(Suction + Wetting ~ Moisture)+
    ylim(0,1000)
  
  gg_elements_o <-  
    fticr_elements %>% 
    ggplot(aes(x = O, color = Amendments, fill = Amendments))+
    geom_histogram(position = position_dodge(width = 0.3), alpha = 0.5)+
    #geom_density(alpha = 0.2)+
    facet_grid(Suction + Wetting ~ Moisture)+
    ylim(0,1000)
  
  list(gg_elements_n = gg_elements_n,
       gg_elements_o = gg_elements_o)
}



# IVb. PCA -- unique peaks -----------------------------------------------------
# data_unique

compute_pca = function(dat){
  data_unique_all <-  
    data_long_trt %>% 
    group_by(formula, Suction, Homogenization, Moisture, Wetting) %>% 
    dplyr::mutate(n = n()) %>% 
    filter(n==1) %>% 
    filter(Homogenization=="Intact")
  
  
data_unique_counts = 
  data_unique_all %>% 
  left_join(meta_classes, by = "formula") %>% 
  group_by(Suction, Moisture, Wetting, Amendments, Homogenization, class) %>% 
  dplyr::summarise(counts = sum(presence))
  
  unique_wide_intact = 
    data_unique_counts %>% 
    spread(class, counts) %>% 
    replace(is.na(.), 0)
  
  unique_wide_pca = 
    unique_wide_intact %>% 
    ungroup ()
  
## 1.5 kPa  ----
  unique_wide_pca_1 = 
    unique_wide_pca %>% 
    filter(Suction==1.5)
  
  unique_pca_num_1  = 
    unique_wide_pca_1 %>% 
    dplyr::select(., -(1:5))
  
  unique_pca_grp_1  = 
    unique_wide_pca_1 %>% 
    dplyr::select(., (1:5)) %>% 
    dplyr::mutate(row = row_number())
  
  unique_pca_1 = prcomp(unique_pca_num_1, scale. = T)
  
  ggbiplot(unique_pca_1, obs.scale = 1, var.scale = 1, 
           groups = as.character(unique_pca_grp_1$Amendments), ellipse = TRUE, circle = FALSE,
           var.axes = TRUE) +
    geom_point(size=5,stroke=1, 
               aes(color = groups, 
                   shape = interaction(as.factor(unique_pca_grp_1$Moisture),
                                       as.factor(unique_pca_grp_1$Wetting))))+
    scale_shape_manual(values = c(1, 2, 19, 17))+
    scale_color_manual(values = pal3)+
    labs(shape="",
         title = "INTACT unique",
         subtitle = "1.5 kPa")+
    NULL
  
## 50 kPa  ----
  unique_wide_pca_5 = 
    unique_wide_pca %>% 
    filter(Suction==50)
  
  unique_pca_num_5  = 
    unique_wide_pca_5 %>% 
    dplyr::select(., -(1:5))
  
  unique_pca_grp_5  = 
    unique_wide_pca_5 %>% 
    dplyr::select(., (1:5)) %>% 
    dplyr::mutate(row = row_number())
  
  unique_pca_5 = prcomp(unique_pca_num_5, scale. = T)
  
  ggbiplot(unique_pca_5, obs.scale = 1, var.scale = 1, 
           groups = as.character(unique_pca_grp_5$Amendments), ellipse = TRUE, circle = FALSE,
           var.axes = TRUE) +
    geom_point(size=5,stroke=1, 
               aes(color = groups, 
                   shape = interaction(as.factor(unique_pca_grp_5$Moisture),
                                       as.factor(unique_pca_grp_5$Wetting))))+
    scale_shape_manual(values = c(1, 2, 19, 17))+
    scale_color_manual(values = pal3)+
    labs(shape="",
         title = "INTACT unique",
         subtitle = "50 kPa")+
    NULL 
 
## bar ----
 data_unique_counts %>% 
    ggplot(aes(x = Amendments, y = counts, fill = class))+
    geom_bar(stat = "identity")+
    facet_grid(Suction ~ Moisture + Wetting)+
    labs(title = "Unique Peaks, Intact Cores")
  
}


### IIIb1. intact cores -----------------------------------------------------
do_pca_intact = function(relabund_cores){
  ## PCA functions ----
  do_pca_functions = function(dat){
    num = 
      dat %>% 
      dplyr::select(.,-(1:6))
    
    grp = 
      dat %>% 
      dplyr::select(.,(1:6)) %>% 
      dplyr::mutate(row = row_number())
    
    pca_int = prcomp(num, scale. = T)
    
    list(num = num,
         grp = grp,
         pca_int = pca_int)
  }
  
  ## PCA files ----
  relabund_pca = 
    relabund_cores %>% 
    filter(!Suction==15) %>% 
    dplyr::select(Core, SampleAssignment, class, relabund, 
                  Moisture, Wetting, Suction, Homogenization, Amendments) %>% 
    spread(class, relabund) %>% 
    replace(is.na(.), 0) %>% 
    select(-1) %>% 
    filter(Homogenization=="Intact")
  
  relabund_pca_1 = relabund_pca %>% filter(Suction==1.5)
  relabund_pca_5 = relabund_pca %>% filter(Suction==50)
  
  
  pca = do_pca_functions(relabund_pca)
  pca_1 = do_pca_functions(relabund_pca_1)
  pca_5 = do_pca_functions(relabund_pca_5)
  
  ## PCA plots ----
  ### suction separation ----
  (gg_pca_suction = 
     ggbiplot(pca$pca_int, obs.scale = 1, var.scale = 1, 
              groups = as.character(pca$grp$Suction), ellipse = TRUE, circle = FALSE,
              var.axes = TRUE) +
     geom_point(size=3,stroke=1, aes(fill = groups, shape = groups))+
     scale_shape_manual(values = c(21,25), name = "")+
     scale_color_manual(values = pal, name = "")+
     scale_fill_manual(values = pal, name = "")+
     xlim(-4,4)+
     ylim(-3.5,3.5)+
     labs(shape="")+
     theme_kp()+
     NULL
  )
  
  ### amendments separation ----
  (gg_pca_amend_1 = 
     ggbiplot(pca_1$pca_int, obs.scale = 1, var.scale = 1, 
              groups = as.character(pca_1$grp$Amendments), ellipse = TRUE, circle = FALSE,
              var.axes = TRUE) +
     geom_point(size=3,stroke=1, 
                aes(fill = groups, shape = groups))+
     scale_color_manual(values = pal, name  ="")+
     scale_shape_manual(values = c(21, 22, 23), name = "")+
     scale_fill_manual(values = pal, name = "")+
     xlim(-3.5,3.5)+
     ylim(-3,3)+
     labs(shape="",
          title = "1.5 kPa")+
     theme_kp()+
     NULL
  )
  
  (gg_pca_amend_5 = 
      ggbiplot(pca_5$pca_int, obs.scale = 1, var.scale = 1, 
               groups = as.character(pca_5$grp$Amendments), ellipse = TRUE, circle = FALSE,
               var.axes = TRUE) +
      geom_point(size=3,stroke=1, 
                 aes(fill = groups, shape = groups))+
      scale_color_manual(values = pal, name  ="")+
      scale_shape_manual(values = c(21, 22, 23), name = "")+
      scale_fill_manual(values = pal, name = "")+
      xlim(-3.5, 3.5)+
      ylim(-3,3)+
      labs(shape="",
           title = "50 kPa")+
      theme_kp()+
      NULL
  )
  
  (gg_pca_amend = gg_pca_amend_1 + gg_pca_amend_5 +
    plot_layout(guides = "collect") &
    theme(legend.position = "bottom"))
  
  
  ### moisture separation ----
  
  (gg_pca_moist1 = 
     ggbiplot(pca_1$pca_int, obs.scale = 1, var.scale = 1, 
              groups = as.character(pca_1$grp$Moisture), ellipse = TRUE, circle = FALSE,
              var.axes = TRUE) +
     geom_point(size=3,stroke=1, aes(color = groups, fill = groups, shape = pca_1$grp$Wetting))+
     geom_point(size=3,stroke=1, color = "black", aes(fill = groups, shape = pca_1$grp$Wetting), show.legend = F)+
     scale_fill_manual(values = pal)+
     scale_shape_manual(values = c(21, 24))+
     scale_color_manual(values = pal)+
     xlim(-3.5,3.5)+
     ylim(-3,3)+
     labs(shape="",
          title = "1.5 kPa")+
     theme_kp()+
     NULL
  )
  
  (gg_pca_moist5 = 
      ggbiplot(pca_5$pca_int, obs.scale = 1, var.scale = 1, 
               groups = as.character(pca_5$grp$Moisture), ellipse = TRUE, circle = FALSE,
               var.axes = TRUE) +
      scale_color_manual(values = pal)+
      geom_point(size=1)+
      geom_point(size=3,stroke=1, aes(color = groups, fill = groups, shape = pca_5$grp$Wetting))+
      geom_point(size=3,stroke=1, color = "black", aes(fill = groups, shape = pca_5$grp$Wetting), show.legend = F)+
      scale_shape_manual(values = c(21, 24))+
      scale_fill_manual(values = pal)+
      xlim(-3.5, 3.5)+
      ylim(-3,3)+
      labs(shape="",
           title = "50 kPa")+
      theme_kp()+
      NULL
  )
  
  
  (gg_pca_moist = gg_pca_moist1 + gg_pca_moist5 +
      plot_layout(guides = "collect") &
      theme(legend.position = "bottom"))
  
  ### homogenized ----
  relabund_pca_homo = 
    relabund_cores %>% 
    filter(!Suction==15) %>% 
    dplyr::select(Core, SampleAssignment, class, relabund, 
                  Moisture, Wetting, Suction, Homogenization, Amendments) %>% 
    spread(class, relabund) %>% 
    replace(is.na(.), 0) %>% 
    select(-1) %>% 
    filter(Homogenization=="Homogenized" & Amendments == "control" & Moisture == "fm")
  
  pca_homo = 
    do_pca_functions(relabund_pca_homo)
  
  (gg_pca_suction_homo = 
      ggbiplot(pca_homo$pca_int, obs.scale = 1, var.scale = 1, 
               groups = as.character(pca_homo$grp$Suction), ellipse = TRUE, circle = FALSE,
               var.axes = TRUE) +
      geom_point(size=3,stroke=1, aes(fill = groups, shape = pca_homo$grp$Wetting))+
      scale_shape_manual(values = c(21,25), name = "")+
      scale_color_manual(values = pal, name = "")+
      scale_fill_manual(values = pal, name = "")+
      xlim(-4,4)+
      ylim(-3.5,3.5)+
      labs(shape="",
           title = "Homogenized")+
      theme_kp()+
      NULL
  )
}


gg_pca_intact_plots = do_gg_pca_intact_plots(pca_int, relabund_pca_grp_intact)


relabund_pca_control1 = relabund_pca %>% filter(Suction==1.5 & Amendments == "control" & Homogenization == "Intact")
relabund_pca_control5 = relabund_pca %>% filter(Suction==50 & Amendments == "control" & Homogenization == "Intact")
pca_control1 = do_pca_functions(relabund_pca_control1)
pca_control5 = do_pca_functions(relabund_pca_control5)
    ggbiplot(pca_control1$pca_int, obs.scale = 1, var.scale = 1, 
             groups = as.character(pca_control1$grp$Moisture), ellipse = TRUE, circle = FALSE,
             var.axes = TRUE) +
    geom_point(size=3,stroke=1, aes(color = groups, fill = groups, shape = pca_control1$grp$Wetting))+
    geom_point(size=3,stroke=1, color = "black", aes(fill = groups, shape = pca_control1$grp$Wetting), show.legend = F)+
    scale_fill_manual(values = pal)+
    scale_shape_manual(values = c(21, 24))+
    scale_color_manual(values = pal)+
    xlim(-3.5,3.5)+
    ylim(-3,3)+
    labs(shape="",
         title = "1.5 kPa")+
    theme_kp()+
    NULL


    ggbiplot(pca_control5$pca_int, obs.scale = 1, var.scale = 1, 
             groups = as.character(pca_control5$grp$Moisture), ellipse = TRUE, circle = FALSE,
             var.axes = TRUE) +
    scale_color_manual(values = pal)+
    geom_point(size=1)+
    geom_point(size=3,stroke=1, aes(color = groups, fill = groups, shape = pca_control5$grp$Wetting))+
    geom_point(size=3,stroke=1, color = "black", aes(fill = groups, shape = pca_control5$grp$Wetting), show.legend = F)+
    scale_shape_manual(values = c(21, 24))+
    scale_fill_manual(values = pal)+
    xlim(-3.5, 3.5)+
    ylim(-3,3)+
    labs(shape="",
         title = "50 kPa")+
    theme_kp()+
    NULL



pca = do_pca_functions(relabund_pca)
