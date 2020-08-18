library(here)
source(("code/0-packages.R"))
library(drake)
library(rmarkdown)
library(vegan)
library(visNetwork)
library(car)
library(lme4)

fticr_cache <- drake_cache(path = "reports/cache/fticr")

fticr_plan = 
  drake_plan(
    # 0a. setup -------------------------------------------------------------------
    theme_set(theme_bw()),
    pal = pnw_palette("Bay", 3),
    
    # 0b. load files --------------------------------------------------------------
    fticr_key = read.csv(file_in("data/processed/fticr_key.csv")) %>% 
      distinct(SampleAssignment, Moisture, Wetting, Amendments, Suction, Homogenization),
    
    data_key = 
      read.csv(file_in("data/processed/fticr_long_key.csv.gz")) %>%
      mutate(Homogenization = factor(Homogenization, levels = c("Intact", "Homogenized")),
             Amendments = factor(Amendments, levels = c("control", "C", "N")),
             Moisture = factor(Moisture, levels = c("fm", "drought")),
             Wetting = factor(Wetting, levels = c("precip", "groundw"))),
    
    data_long_trt = 
      read.csv(file_in("data/processed/fticr_long_trt.csv.gz")) %>% 
      mutate(Homogenization = factor(Homogenization, levels = c("Intact", "Homogenized")),
             Amendments = factor(Amendments, levels = c("control", "C", "N")),
             Moisture = factor(Moisture, levels = c("fm", "drought")),
             Wetting = factor(Wetting, levels = c("precip", "groundw"))),
    
    meta = 
      read.csv(file_in("data/processed/fticr_meta.csv")),
    
    meta_hcoc = 
      meta %>% 
      select(formula, HC, OC),    
    
    meta_classes = 
      meta %>% 
      select(formula, class),
    
    
    # 0c. reps ----------------------------------------------------------------
    reps = 
      data_key %>% 
      filter(!Suction==15) %>% 
      ungroup() %>% 
      distinct(Core, SampleAssignment) %>% 
      group_by(SampleAssignment) %>% 
      dplyr::summarise(reps = n()),
    
    # ----- ---------------------------------------------------------------------
    # I. van krevelens -----------------------------------------------------------
    ## Ia. domains --------------------------------------------------------------
    gg_fticr_domains = 
      data_long_trt %>% 
      distinct(formula) %>% 
      left_join(dplyr::select(meta, formula, class, HC, OC), by = "formula") %>% 
      gg_vankrev(aes(x = OC, y = HC, color = class))+
      scale_color_manual(values = PNWColors::pnw_palette("Sailboat"))+
      theme_kp()+
      theme(legend.position = "right")+
      NULL,
    
    ## Ib. replication -------------------------------------------------------
    gg_fticr_reps_1_5_intact = 
      data_key %>%
      filter(Homogenization == "Intact" & Suction == 1.5) %>% 
      left_join(meta_hcoc, by = "formula") %>%
      gg_vankrev(aes(x = OC, y = HC, color = Amendments))+
      scale_color_manual(values = PNWColors::pnw_palette("Bay",3))+
      facet_grid(n~Moisture+Wetting)+
      labs(title = "1.5 kPa intact")+
      theme_kp()+
      NULL,
    
    gg_fticr_reps_50_intact = 
      data_key %>%
      filter(Homogenization == "Intact" & Suction == 50) %>% 
      left_join(meta_hcoc, by = "formula") %>%
      gg_vankrev(aes(x = OC, y = HC, color = Amendments))+
      scale_color_manual(values = PNWColors::pnw_palette("Bay",3))+
      facet_grid(n~Moisture+Wetting)+
      labs(title = "50 kPa intact")+
      theme_kp()+
      NULL,
    
    gg_fticr_reps_1_5_homo = 
      data_key %>%
      filter(Homogenization == "Homogenized" & Suction == 1.5) %>% 
      left_join(meta_hcoc, by = "formula") %>%
      gg_vankrev(aes(x = OC, y = HC, color = Amendments))+
      scale_color_manual(values = PNWColors::pnw_palette("Bay",3))+
      facet_grid(n~Moisture+Wetting)+
      labs(title = "1.5 kPa hommogenized")+
      theme_kp()+
      NULL,
    
    gg_fticr_reps_50_homo = 
      data_key %>%
      filter(Homogenization == "Homogenized" & Suction == 50) %>% 
      left_join(meta_hcoc, by = "formula") %>%
      gg_vankrev(aes(x = OC, y = HC, color = Amendments))+
      scale_color_manual(values = PNWColors::pnw_palette("Bay",3))+
      facet_grid(n~Moisture+Wetting)+
      labs(title = "50 kPa homogenized")+
      theme_kp()+
      NULL,
    
    
    
    ## IIb. fticr baseline -----------------------------------------------------
    gg_fticr_baseline =     
      data_long_trt %>%
      filter(Moisture=="fm" & Wetting == "groundw" & Amendments=="control" & 
               Homogenization=="Intact") %>% 
      left_join(meta_hcoc, by = "formula") %>%
      gg_vankrev(aes(x = OC, y = HC, color = as.character(Suction)))+
      stat_ellipse()+
      scale_color_manual(values = PNWColors::pnw_palette("Bay",3))+
      labs(title = "baseline (fm, groundw, non-amended)")+
      theme_kp()+
      NULL,
    
    
    ## IIc. vk pores ----------------------------------------------------------------
    
    gg_fticr_pores_1_5kPa = 
      data_key %>%
      left_join(meta_hcoc, by = "formula") %>%
      filter(Suction=="1.5") %>% 
      gg_vankrev(aes(x = OC, y = HC, color = Amendments))+
      stat_ellipse()+
      scale_color_manual(values = pal)+
      facet_grid(Homogenization~Moisture+Wetting)+
      labs(title = "1.5 kPa")+
      #theme(legend.position = "none")+
      NULL,
    
    gg_fticr_pores_50kPa = 
      data_key %>%
      left_join(meta_hcoc, by = "formula") %>%
      filter(Suction=="50") %>% 
      gg_vankrev(aes(x = OC, y = HC, color = Amendments))+
      stat_ellipse()+
      scale_color_manual(values = pal)+
      facet_grid(Homogenization~Moisture+Wetting)+
      labs(title = "50 kPa")+
      #theme(legend.position = "none")+
      NULL,    
    
    
    ## IId. vk unique ---------------------------------------------------------------
    data_unique = 
      data_key %>% 
      group_by(formula, Suction, Homogenization, Moisture, Wetting, Amendments) %>% 
      dplyr::summarise(n = n()) %>% 
      group_by(formula, Suction, Homogenization, Moisture, Wetting) %>% 
      dplyr::mutate(n = n()) %>% 
      filter(n==1),
    
    gg_fticr_unique_int =
      data_unique %>% 
      left_join(meta_hcoc, by = "formula") %>%
      filter(Homogenization=="Intact") %>% 
      gg_vankrev(aes(x = OC, y = HC, color = Amendments))+
      #stat_ellipse()+
      scale_color_manual(values = pal)+
      facet_grid(Suction~Moisture+Wetting)+
      labs(title = "intact cores")+
      #theme(legend.position = "none")+
      NULL,
    
    gg_fticr_unique_homo =
      data_unique %>% 
      left_join(meta_hcoc, by = "formula") %>%
      filter(Homogenization=="Homogenized") %>% 
      gg_vankrev(aes(x = OC, y = HC, color = Amendments))+
      #stat_ellipse()+
      scale_color_manual(values = pal)+
      facet_grid(Suction~Moisture+Wetting)+
      labs(title = "homogenized cores")+
      #theme(legend.position = "none")+
      NULL,
    
    # ----- ---------------------------------------------------------------------
    # II. peaks ---------------------------------------------------------------------
    peaks_distinct_core = 
      data_key %>% 
      group_by(Core, SampleAssignment) %>% 
      distinct(formula),
    
    peakcounts_core = 
      peaks_distinct_core %>% 
      left_join(meta_classes, by = "formula") %>% 
      group_by(Core, SampleAssignment, class) %>% 
      summarize(n = n()) %>% 
      ungroup() %>% 
      group_by(Core, SampleAssignment) %>% 
      dplyr::mutate(total = sum(n)) %>% 
      spread(class, n) %>% 
      pivot_longer(-c(Core, SampleAssignment),
                   names_to = "class",
                   values_to = "counts") %>% 
      ungroup() %>% 
      left_join(fticr_key, by = "SampleAssignment") %>% 
      mutate(Amendments = factor(Amendments, 
                                 levels = c("control", "C", "N")),
             Homogenization = factor(Homogenization, 
                                     levels = c("Intact", "Homogenized")),
             Moisture = factor(Moisture, 
                               levels = c("fm", "drought")),
             Wetting = factor(Wetting, 
                              levels = c("precip", "groundw"))),
    
    peakcounts_trt = 
      peakcounts_core %>% 
      group_by(SampleAssignment, class) %>% 
      filter(!class=="total") %>% 
      summarize(peaks = as.integer(mean(counts))) %>% 
      ungroup() %>% 
      left_join(fticr_key, by = "SampleAssignment") %>% 
      mutate(Amendments = factor(Amendments, 
                                 levels = c("control", "C", "N")),
             Homogenization = factor(Homogenization, levels = c("Intact", "Homogenized"))),
    
    ## IIa. bar plots ------------------------------------------------------------------
    gg_peaks_bar = peakcounts_trt %>% 
      ggplot(aes(x = Amendments, y = peaks, fill = class))+
      geom_bar(stat = "identity")+
      #scale_fill_viridis_d(option = "inferno")+
      scale_fill_manual(values = PNWColors::pnw_palette("Sailboat"))+
      labs(x = "",
           y = "peaks")+
      facet_grid(Homogenization+Suction~Moisture+Wetting)+
      NULL,
    
    ## IIb. peak count tables --------------------------------------------------
    peakcounts_table_total =
      peakcounts_core %>% 
      filter(class=="total") %>% 
      group_by(SampleAssignment, class) %>% 
      dplyr::summarize(peaks_mean = as.integer(mean(counts)),
                       peaks_se = as.integer(sd(counts)/sqrt(n())),
                       peaks = paste(peaks_mean, "\u00b1", peaks_se)) %>% 
      #spread(name, peaks) %>% 
      ungroup %>% 
      left_join(fticr_key, by = "SampleAssignment") %>% 
      mutate(Amendments = factor(Amendments, 
                                 levels = c("control", "C", "N")),
             Homogenization = factor(Homogenization, levels = c("Intact", "Homogenized")),
             # now create a new combined column for suction-amendments
             var = paste0(Suction,"-",Amendments),
             var = factor(var, levels = c("1.5-control", "1.5-C", "1.5-N",
                                          "50-control", "50-C", "50-N"))
      ) %>% 
      dplyr::select(Homogenization, Moisture, Wetting, var, peaks) %>% 
      spread(var, peaks), 
    
    peakcounts_table_aromatic =
      peakcounts_core %>% 
      filter(class %in% c("unsaturated/lignin", "aromatic", "condensed_arom")) %>%
      group_by(Core, SampleAssignment) %>% 
      summarise(peaks=sum(counts))  %>% 
      group_by(SampleAssignment) %>% 
      dplyr::summarize(peaks_mean = as.integer(mean(peaks)),
                       peaks_se = as.integer(sd(peaks)/sqrt(n())),
                       peaks = paste(peaks_mean, "\u00b1", peaks_se)) %>% 
      left_join(fticr_key, by = "SampleAssignment") %>% 
      ungroup %>% 
      mutate(Amendments = factor(Amendments, 
                                 levels = c("control", "C", "N")),
             Homogenization = factor(Homogenization, levels = c("Intact", "Homogenized")),
             # now create a new combined column for suction-amendments
             var = paste0(Suction,"-",Amendments),
             var = factor(var, levels = c("1.5-control", "1.5-C", "1.5-N",
                                          "50-control", "50-C", "50-N"))
      ) %>% 
      dplyr::select(Homogenization, Moisture, Wetting, var, peaks) %>% 
      spread(var, peaks), 
    
    ## IIc. aliphatic:complex --------------------------------------------------
    aliphatic_aromatic_counts = 
      peakcounts_core %>% 
      ungroup %>% 
      filter(!class=="total") %>% 
      mutate(new_class = if_else(grepl("aliphatic",class), "aliphatic", "complex")) %>% 
      group_by(Core, Homogenization, Moisture, Wetting, Amendments, Suction, new_class) %>% 
      dplyr::summarise(counts = sum(counts)) %>%
      ungroup() %>% 
      spread(new_class, counts) %>% 
      mutate(arom_aliph_ratio = complex/aliphatic),
    
    gg_aliph_aromatic = 
      aliphatic_aromatic_counts %>% 
      filter(Homogenization=="Intact") %>% 
      ggplot(aes(x = Amendments, y = arom_aliph_ratio, color = Amendments))+
      geom_point()+
      labs(y = "complex:simple")+
      facet_grid(Homogenization+Suction ~ Moisture+Wetting)+
      NULL,
    
    gg_aliph_aromatic_intact_suction = 
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
      NULL,
    
    
    ## IId.  total peak count -- scatter ----------------------------------------------------------
    
    fit_hsd_totalpeaks <- function(dat) {
      a <-aov(log(counts) ~ Amendments, data = dat)
      h <-agricolae::HSD.test(a,"Amendments")
      #create a tibble with one column for each treatment
      #the hsd results are row1 = drought, row2 = saturation, row3 = time zero saturation, row4 = field moist. hsd letters are in column 2
      tibble(`control` = h$groups["control",2], 
             `C` = h$groups["C",2],
             `N` = h$groups["N",2])
    },
    
    fticr_hsd_totalpeaks = 
      peakcounts_core %>% 
      filter(class=="total") %>% 
      mutate(Suction = as.character(Suction)) %>% 
      group_by(Suction, Homogenization, Moisture) %>% 
      do(fit_hsd_totalpeaks(.)),
    
    totalcounts_label = tribble(
        ~x, ~y, ~Suction, ~Homogenization, ~label,
        1.87, 2000, 1.5, "Intact", "b",
        2, 3000, 1.5, "Intact", "a",
        2.13, 2000, 1.5, "Intact", "ab"
        ),  
    
  
    gg_totalcounts = 
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
      NULL,
    
    
    
    ## IId.  peaks -- stats ----------------------------------------------------------
    ### -- arom-aliph-ratio
  #  aov_arom_aliph_ratio_all = 
  #    Anova(lmer(log(arom_aliph_ratio) ~ (Homogenization+Suction+Moisture+Wetting+Amendments) +
  #                 (1|Core), 
  #               data = aliphatic_aromatic_counts),
  #          type = "III"),
    
    aov_arom_aliph_ratio_intact = 
      Anova(lm(arom_aliph_ratio ~ (Suction+Moisture+Wetting+Amendments)^2, 
               data = aliphatic_aromatic_counts %>% 
                 filter(Homogenization=="Intact")),
            type = "III"),
    
    ### -- total-peaks
    peakcounts_total_core = 
      peakcounts_core %>% 
      filter(class=="total"),
    
 #   aov_total_peaks_all = 
 #     Anova(lmer(log(counts) ~ (Homogenization+Suction+Moisture+Wetting+Amendments) +
 #                  (1|Core), 
 #                data = peakcounts_total_core),
 #           type = "III"),
    
    aov_total_peaks_intact = 
      Anova(lm(log(counts) ~ (Suction+Moisture+Wetting+Amendments)^2, 
               data = peakcounts_total_core %>% 
                 filter(Homogenization=="Intact")),
            type = "III"),
    
    # ----- ---------------------------------------------------------------------
    # II. relative abundances -------------------------------------------------
    # IIa. load files ---------------------------------------------------------
    relabund_trt = 
      read.csv(file_in("data/processed/fticr_relabund_trt.csv")) %>% 
      filter(!Suction=="15") %>% 
      dplyr::mutate(
        class = factor(class, levels = 
                         c("aliphatic", "unsaturated/lignin",
                           "aromatic","condensed_arom")),
        Amendments = factor(Amendments, levels = c("control", "C", "N")),
        Homogenization = factor(Homogenization, levels = c("Intact", "Homogenized")),
        Moisture = factor(Moisture, levels = c("fm", "drought"))),
    
    relabund_cores = 
      read.csv(file_in("data/processed/fticr_relabund_cores.csv")) %>% 
      filter(!Suction=="15") %>% 
      dplyr::mutate(
        class = factor(class, levels = 
                         c("aliphatic","unsaturated/lignin","aromatic","condensed_arom")),
        Amendments = factor(Amendments, levels = c("control", "C", "N")),
        Homogenization = factor(Homogenization, levels = c("Intact", "Homogenized")),
        Moisture = factor(Moisture, levels = c("fm", "drought"))), 
    
    # IIb. bar plots ----------------------------------------------------------
    gg_fticr_relabund_barplots =     
      relabund_trt %>%  
      ggplot(aes(x = Amendments, y = rel_abund, fill = class))+
      geom_bar(stat = "identity")+
      #scale_fill_viridis_d(option = "inferno")+
      scale_fill_manual(values = PNWColors::pnw_palette("Sailboat"))+
      labs(x = "",
           y = "relative abundance (%)")+
      facet_grid(Homogenization+Suction~Moisture+Wetting)+
      NULL,
    
    # IIc. complex peaks ----------------------------------------------------------
    ## fit hsd
    relabund_cores_complex = 
      relabund_cores %>% 
      filter(!class=="aliphatic") %>% 
      group_by(Core, Suction, Homogenization, Moisture, Wetting, Amendments) %>% 
      dplyr::summarise(relabund = sum(relabund)) %>% 
      ungroup(),
    
    
    fit_hsd_complex <- function(dat) {
      a <-aov(log(relabund) ~ Amendments, data = dat)
      h <-agricolae::HSD.test(a,"Amendments")
      #create a tibble with one column for each treatment
      #the hsd results are row1 = drought, row2 = saturation, row3 = time zero saturation, row4 = field moist. hsd letters are in column 2
      tibble(`control` = h$groups["control",2], 
             `C` = h$groups["C",2],
             `N` = h$groups["N",2])
    },
    
    fticr_hsd_complex = 
      relabund_cores_complex %>% 
      mutate(Suction = as.character(Suction)) %>% 
      group_by(Suction, Homogenization, Moisture) %>% 
      do(fit_hsd_complex(.)),
    
    
    complex_label = tribble(
      ~x, ~y, ~Suction, ~Homogenization, ~label,
      0.87, 90, 50, "Intact", "a",
      1, 85, 50, "Intact", "b",
      1.13, 85, 50, "Intact", "ab",
      
      1.87, 92, 50, "Intact", "a",
      2, 85, 50, "Intact", "b",
      2.13, 85, 50, "Intact", "b"
    ),
    
    gg_complex_relabund = 
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
      NULL,
  
    # ----- ---------------------------------------------------------------------
    # III. statistics ----------------------------------------------------------
    ## IIIa. PERMANOVA ---------------------------------------------------------
    # make wide
    relabund_wide = 
      relabund_cores %>% 
      filter(!Suction==15) %>% 
      dplyr::select(Core, SampleAssignment, class, relabund, 
                    Moisture, Wetting, Suction, Homogenization, Amendments) %>% 
      spread(class, relabund) %>% 
      replace(is.na(.),0),
    
    ### IIIa1. overall permanova (homogenization) --------------------------------------
    permanova_fticr_all = 
      adonis(relabund_wide %>% select(aliphatic:condensed_arom) ~ (Amendments+Moisture+Wetting+Suction+Homogenization)^3, 
             data = relabund_wide),
    
    ### IIIa2. permanova for treatments --------------------------------------
    intact_1_5 = relabund_wide %>% filter(Homogenization=="Intact" & Suction==1.5),
    intact_50 = relabund_wide %>% filter(Homogenization=="Intact" & Suction==50),
    homo_1_5 = relabund_wide %>% filter(Homogenization=="Homogenized" & Suction==1.5),
    homo_50 = relabund_wide %>% filter(Homogenization=="Homogenized" & Suction==50),
    
    permanova_fticr_1_5_intact = 
      adonis(intact_1_5 %>% 
               select(aliphatic:condensed_arom) ~  Amendments*Moisture*Wetting, 
             data = intact_1_5),
    
    permanova_fticr_50_intact = 
      adonis(intact_50 %>% 
               select(aliphatic:condensed_arom) ~  Amendments*Moisture*Wetting, 
             data = intact_50),
    
    permanova_fticr_1_5_homo = 
      adonis(homo_1_5 %>%  
               select(aliphatic:condensed_arom) ~  Amendments*Moisture*Wetting, 
             data = homo_1_5),
    
    permanova_fticr_50_homo = 
      adonis(homo_50 %>% 
               select(aliphatic:condensed_arom) ~  Amendments*Moisture*Wetting, 
             data = homo_50),
    
    ## IIIb. PCA ---------------------------------------------------------------
    # make pca file
    relabund_pca=
      relabund_wide %>% 
      select(-1),
    
    ### IIIb1. intact cores -----------------------------------------------------
    relabund_pca_num_intact = 
      relabund_pca %>% 
      filter(Homogenization=="Intact") %>% 
      dplyr::select(.,-(1:6)),
    
    relabund_pca_grp_intact = 
      relabund_pca %>% 
      filter(Homogenization=="Intact") %>% 
      dplyr::select(.,(1:6)) %>% 
      dplyr::mutate(row = row_number()),
    
    pca_int = prcomp(relabund_pca_num_intact, scale. = T),
    #summary(pca)
    
    gg_pca_intact_suction = 
      ggbiplot(pca_int, obs.scale = 1, var.scale = 1, 
               groups = as.character(relabund_pca_grp_intact$Suction), ellipse = TRUE, circle = F,
               var.axes = TRUE)+
      geom_point(size=5,stroke=1, 
                 aes(color = groups, 
                     shape = interaction(as.factor(relabund_pca_grp_intact$Moisture),
                                         as.factor(relabund_pca_grp_intact$Wetting))))+
      scale_shape_manual(values = c(1, 2, 19, 17))+
      scale_color_manual(values = pal)+
      labs(shape="",
           title = "INTACT",
           subtitle = "grouped by suction")+
      NULL,
    
    gg_pca_intact_amend = 
      ggbiplot(pca_int, obs.scale = 1, var.scale = 1, 
               groups = relabund_pca_grp_intact$Amendments, ellipse = TRUE, circle = F,
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
      NULL,
    
    library(patchwork),
    gg_fticr_pca_intact = gg_pca_intact_suction+gg_pca_intact_amend,
    
    ### IIIb2. homogenized cores ------------------------------------------------
    relabund_pca_num_Homogenized = 
      relabund_pca %>% 
      filter(Homogenization=="Homogenized") %>% 
      dplyr::select(.,-(1:6)),
    
    relabund_pca_grp_Homogenized = 
      relabund_pca %>% 
      filter(Homogenization=="Homogenized") %>% 
      dplyr::select(.,(1:6)) %>% 
      dplyr::mutate(row = row_number()),
    
    pca_homo = prcomp(relabund_pca_num_Homogenized, scale. = T),
    #summary(pca)
    
    gg_pca_homo_amend =
      ggbiplot(pca_homo, obs.scale = 1, var.scale = 1, 
               groups = relabund_pca_grp_Homogenized$Amendments, 
               ellipse = TRUE, circle = F,
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
      NULL,
    
    gg_pca_homo_suction =
      ggbiplot(pca_homo, obs.scale = 1, var.scale = 1, 
               groups = as.character(relabund_pca_grp_Homogenized$Suction), 
               ellipse = TRUE, circle = F,
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
      NULL,
    
    gg_fticr_pca_homo = gg_pca_homo_suction+gg_pca_homo_amend,
    
    
    ### IIIb3. individual treatments ---------------------------------------------------
    #### (1) 50 & intact ----
    relabund_pca_num_50_intact = 
      relabund_pca %>% 
      filter(Suction==50 & Homogenization=="Intact") %>% 
      dplyr::select(.,-(1:6)),
    
    relabund_pca_grp_50_intact = 
      relabund_pca %>% 
      filter(Suction==50 & Homogenization=="Intact") %>% 
      dplyr::select(.,(1:6)) %>% 
      dplyr::mutate(row = row_number()),
    
    pca_1 = prcomp(relabund_pca_num_50_intact, scale. = T),
    #summary(pca)
    
    gg_pca_50_intact =
      ggbiplot(pca_1, obs.scale = 1, var.scale = 1, 
               groups = relabund_pca_grp_50_intact$Amendments, ellipse = TRUE, circle = F,
               var.axes = TRUE)+
      geom_point(size=5,stroke=1, 
                 aes(color = groups, 
                     shape = interaction(as.factor(relabund_pca_grp_50_intact$Moisture),
                                         as.factor(relabund_pca_grp_50_intact$Wetting))))+
      scale_shape_manual(values = c(1, 2, 19, 17))+
      scale_color_manual(values = pal)+
      labs(shape="",
           title = "50 kPa INTACT")+
      NULL,
    
    
    #### (3) 1.5 & intact ----
    relabund_pca_num_1_intact = 
      relabund_pca %>% 
      filter(Suction==1.5 & Homogenization=="Intact") %>% 
      dplyr::select(.,-(1:6)),
    
    relabund_pca_grp_1_intact = 
      relabund_pca %>% 
      filter(Suction==1.5 & Homogenization=="Intact") %>% 
      dplyr::select(.,(1:6)) %>% 
      dplyr::mutate(row = row_number()),
    
    pca_3 = prcomp(relabund_pca_num_1_intact, scale. = T),
    #summary(pca)
    
    gg_pca_1_intact=
      ggbiplot(pca_3, obs.scale = 1, var.scale = 1, 
               groups = relabund_pca_grp_1_intact$Amendments, ellipse = TRUE, circle = F,
               var.axes = TRUE)+
      geom_point(size=5,stroke=1, 
                 aes(color = groups, 
                     shape = interaction(as.factor(relabund_pca_grp_1_intact$Moisture),
                                         as.factor(relabund_pca_grp_1_intact$Wetting))))+
      scale_shape_manual(values = c(1, 2, 19, 17))+
      scale_color_manual(values = pal)+
      labs(shape="",
           title = "1.5 kPa INTACT")+
      NULL,
    
    #### (4) 50 & Homogenized ----
    relabund_pca_num_50_Homogenized = 
      relabund_pca %>% 
      filter(Suction==50 & Homogenization=="Homogenized") %>% 
      dplyr::select(.,-(1:6)),
    
    relabund_pca_grp_50_Homogenized = 
      relabund_pca %>% 
      filter(Suction==50 & Homogenization=="Homogenized") %>% 
      dplyr::select(.,(1:6)) %>% 
      dplyr::mutate(row = row_number()),
    
    pca_4 = prcomp(relabund_pca_num_50_Homogenized, scale. = T),
    #summary(pca)
    
    gg_pca_50_homo =
      ggbiplot(pca_4, obs.scale = 1, var.scale = 1, 
               groups = relabund_pca_grp_50_Homogenized$Amendments, ellipse = TRUE, circle = F,
               var.axes = TRUE)+
      geom_point(size=5,stroke=1, 
                 aes(color = groups, 
                     shape = interaction(as.factor(relabund_pca_grp_50_Homogenized$Moisture),
                                         as.factor(relabund_pca_grp_50_Homogenized$Wetting))))+
      scale_shape_manual(values = c(1, 2, 19, 17))+
      scale_color_manual(values = pal)+
      labs(shape="",
           title = "50 kPa Homogenized")+
      NULL,
    
    #### (6) 1.5 & homogenized ----
    relabund_pca_num_1_Homogenized = 
      relabund_pca %>% 
      filter(Suction==1.5 & Homogenization=="Homogenized") %>% 
      dplyr::select(.,-(1:6)),
    
    relabund_pca_grp_1_Homogenized = 
      relabund_pca %>% 
      filter(Suction==1.5 & Homogenization=="Homogenized") %>% 
      dplyr::select(.,(1:6)) %>% 
      dplyr::mutate(row = row_number()),
    
    pca_6 = prcomp(relabund_pca_num_1_Homogenized, scale. = T),
    #summary(pca)
    
    gg_pca_1_homo =
      ggbiplot(pca_6, obs.scale = 1, var.scale = 1, 
               groups = relabund_pca_grp_1_Homogenized$Amendments, ellipse = TRUE, circle = F,
               var.axes = TRUE)+
      geom_point(size=5,stroke=1, 
                 aes(color = groups, 
                     shape = interaction(as.factor(relabund_pca_grp_1_Homogenized$Moisture),
                                         as.factor(relabund_pca_grp_1_Homogenized$Wetting))))+
      scale_shape_manual(values = c(1, 2, 19, 17))+
      scale_color_manual(values = pal)+
      labs(shape="",
           title = "1.5 kPa Homogenized")+
      NULL,
    
    #### combined ----
    library(patchwork),
    gg_fticr_pca_intact_combined = gg_pca_1_intact + gg_pca_50_intact,
    gg_fticr_pca_homo_combined = gg_pca_1_homo + gg_pca_50_homo,
    
    
    
    # ----- ---------------------------------------------------------------------
    # IV. others ------------------------------------------------------------------
    ## IVa. NOSC ---------------------------------------------------------------
    meta_nosc = 
      meta %>% 
      select(formula, NOSC),
    
    gg_nosc = 
      data_key %>% 
      left_join(meta_nosc, by = "formula") %>% 
      ggplot(aes(x = Amendments, y = NOSC, fill = Amendments))+
      geom_violin()+
      geom_boxplot(width=0.2, coef=0, outlier.shape = NA, fill = "white")+
      #   geom_dotplot(binaxis = "y", size=1)+
      scale_fill_manual(values = pal)+
      labs(x = "",
           y = "NOSC")+
      theme(legend.position = "none")+
      facet_grid(Homogenization+Suction~Moisture+Wetting)+
      NULL,
    
    ## IVb. elements -----------------------------------------------------------
    meta_on = 
      meta %>% select(formula, O, N),
    
    fticr_elements = 
      data_key %>% 
      filter(!Suction==15) %>% 
      filter(Homogenization=="Intact") %>% 
      left_join(meta_on, by = "formula"),
    
    gg_elements_n = 
      fticr_elements %>% 
      ggplot(aes(x = N, color = Amendments, fill = Amendments))+
      geom_histogram(position = position_dodge(width = 0.3), alpha = 0.5)+
      #geom_density(alpha = 0.2)+
      facet_grid(Suction + Wetting ~ Moisture)+
      ylim(0,1000),
    
    gg_elements_o = 
      fticr_elements %>% 
      ggplot(aes(x = O, color = Amendments, fill = Amendments))+
      geom_histogram(position = position_dodge(width = 0.3), alpha = 0.5)+
      #geom_density(alpha = 0.2)+
      facet_grid(Suction + Wetting ~ Moisture)+
      ylim(0,1000),
    
    # ----- ---------------------------------------------------------------------
    # report ------------------------------------------------------------------
    report1 = rmarkdown::render(
      knitr_in("code/drake_md_report.Rmd"),
      #  output_file = file_out("drake_md_report.md"))
      #      output_format = rmarkdown::html_document(toc = TRUE))
      output_format = rmarkdown::github_document()),
    
    report2 = rmarkdown::render(
      knitr_in("reports/results.Rmd"),
      output_format = rmarkdown::github_document())
    
    # ----- ---------------------------------------------------------------------
  )

# make plan ---------------------------------------------------------------
make(fticr_plan, cache = fticr_cache)


loadd(aliphatic_aromatic_counts)











aliphatic_aromatic_counts %>% 
  ggplot(aes(x = Homogenization, y = arom_aliph_ratio))+
  geom_boxplot()+
  geom_jitter()+
  NULL

aliphatic_aromatic_counts %>% 
  ggplot(aes(x = Moisture, y = arom_aliph_ratio))+
  geom_boxplot()+
  geom_jitter()+
  NULL

aliphatic_aromatic_counts %>% 
  ggplot(aes(x = Amendments, y = arom_aliph_ratio))+
  geom_boxplot()+
  geom_jitter()+
  NULL


# total peaks
loadd(peakcounts_core)



peakcounts_total_core %>% 
  ggplot(aes(x = as.character(Suction), y = counts))+
  geom_boxplot()+
  geom_jitter()+
  NULL
