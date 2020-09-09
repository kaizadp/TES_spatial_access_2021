# Plots for various pipeline targets
# pal2 = c("grey20", "#00496f", "#edd746")
# pal3 = rev(soilpalettes::soil_palette("rendoll",5))
# pal3 = rev(soilpalettes::soil_palette("redox2",3))
pal3 = c("#FFE733", "#96001B", "#2E5894") #soil_palette("redox2")



# I. van krevelens -----------------------------------------------------------
## reps --------------------------------------------------------------------


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


## vk pores ----------------------------------------------------------------

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


## vk unique ----------------------------------------------------------------

do_vk_unique <- function(data_long_trt) {
  ## IId. vk unique ---------------------------------------------------------------
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
    scale_color_manual(values = c("#2E5894", "#96001B"))+
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
    scale_color_manual(values = c("#2E5894", "#96001B"))+
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

## all peaks -------------------------------------------------------------

do_gg_peaks_bar <- function(peakcounts_trt) {
    peakcounts_trt %>% 
      ggplot(aes(x = Amendments, y = peaks, fill = class))+
      geom_bar(stat = "identity")+
      labs(x = "",
           y = "peaks")+
      facet_grid(Homogenization+Suction~Moisture+Wetting)+
      NULL
}

do_gg_totalcounts <- function(peakcounts_core) {
  totalcounts_label = tribble(
    ~x, ~y, ~Suction, ~Homogenization, ~label,
    1.87, 2000, 1.5, "Intact", "b",
    2, 3000, 1.5, "Intact", "a",
    2.13, 2000, 1.5, "Intact", "ab"
  )
  
  peakcounts_core %>% 
    filter(class=="total") %>% 
    filter(Homogenization=="Intact") %>% 
    ggplot()+
    geom_point(aes(x = Moisture, y = counts, 
                   fill = Amendments, shape = Wetting, group = Amendments),
               size=4, stroke=1, position = position_dodge(width = 0.4))+
    geom_text(data = totalcounts_label, aes(x = x, y = y, label = label), size=4)+
    scale_fill_manual(values = rev(soilpalettes::soil_palette("rendoll",5)))+
    scale_shape_manual(values = c(21,23))+
    guides(fill=guide_legend(override.aes=list(shape=21)))+
    labs(title = "total peak counts",
         y = "count")+
    facet_grid(Homogenization~Suction)+
    theme_kp()+
    NULL
}


## simple:complex ----------------------------------------------------------

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

do_relabund_scatterplots <- function(relabund_trt, relabund_cores_complex) {
  
  complex_label = tribble(
    ~x, ~y, ~Suction, ~Homogenization, ~label,
    0.87, 90, 50, "Intact", "a",
    1, 85, 50, "Intact", "b",
    1.13, 85, 50, "Intact", "ab",
    
    1.87, 92, 50, "Intact", "a",
    2, 85, 50, "Intact", "b",
    2.13, 85, 50, "Intact", "b"
  )
  
  gg_complex_relabund_intact <- 
    relabund_cores_complex %>% 
    filter(Homogenization=="Intact") %>% 
    ggplot() +
    geom_point(aes(x = Moisture, y = relabund, fill = Amendments, shape = Wetting, group = Amendments),
               size = 4, stroke = 1,
               position = position_dodge(width = 0.4)) + 
    geom_text(data = complex_label, aes(x = x, y = y, label = label))+
    
    scale_fill_manual(values = rev(soilpalettes::soil_palette("rendoll",5)))+
    scale_shape_manual(values = c(21,23))+
    guides(fill=guide_legend(override.aes=list(shape=21)))+
    labs(title = "% contribution of complex peaks",
         y = "% contribution")+
    facet_grid(Homogenization~ Suction)+
    theme_kp()+
    NULL
  
  list(gg_complex_relabund = gg_complex_relabund_intact)
}


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

