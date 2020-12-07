library(here)
source("code/0-packages.R")
library(drake)
library(rmarkdown)
library(vegan)
library(visNetwork)
library(car)
library(lme4)
library(patchwork)
library(dplyr)

# Pipeline functions
source("code/2f-fticr-pipeline_plotting_new.R")
source("code/2f-fticr-pipeline_tables.R")
source("code/2f-fticr-pipeline_compute.R")
source("code/2f-fticr-pipeline_reading.R")

# Setup (from here from plan)
pal <- PNWColors::pnw_palette("Bay", 3)
pal3 = c("#FFE733", "#96001B", "#2E5894") #soil_palette("redox2")

# BBL: Why are you getting cache this way? Should not be necessary
#fticr_cache <- drake_cache(path = "reports/cache/fticr")

fticr_plan <- 
  drake_plan(
    # 0a. setup -------------------------------------------------------------------
    
    # 0b. load files --------------------------------------------------------------
    meta = read.csv(file_in("data/processed/fticr_meta.csv")) %>% dplyr::select(-Mass) %>% distinct(),
    meta_hcoc = select(meta, formula, HC, OC),    
    meta_classes = select(meta, formula, class),
    
    fticr_key = read_fticr_key("data/processed/fticr_key.csv"),
    data_key = read_fticr_file("data/processed/fticr_long_key.csv.gz"),
    data_long_trt = read_fticr_file("data/processed/fticr_long_trt.csv.gz") %>% left_join(meta_hcoc, by = "formula"),
    
    # 0c. reps ----------------------------------------------------------------
    reps = compute_reps(data_key),
    
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
    
    ## Ib. fticr baseline -----------------------------------------------------
    gg_fticr_baseline =      
      data_long_trt %>%
      filter(Moisture=="fm" & Wetting == "groundw" & Amendments=="control" & 
               Homogenization=="Intact") %>% 
      gg_vankrev(aes(x = OC, y = HC, color = as.character(Suction)))+
      stat_ellipse()+
      scale_color_manual(values = pal3)+
      labs(title = "baseline (fm, groundw, non-amended)")+
      theme_kp()+
      NULL,
    
    
    ## Ic. vk -- replication ---------------------------------------------------------
    vk_reps = do_vk_reps(data_key, meta_hcoc),
    
    ## Id. vk -- pores ------------------------------------------------------------
    vk_pores = do_vk_pores(data_long_trt),
    vk_pores_amend = do_vk_pores_amend(data_long_trt),
    
    ## Ie. vk -- unique ---------------------------------------------------------------
    vk_unique = do_vk_unique(data_long_trt),
    
    ## If. vk -- peaks introduced after homogenization -------------------------------------------------------------------------
    vk_homo_new = do_vk_homo_new(data_long_trt),
    
    ## Ig. van krevelen baseline comparisons -------------------------------------------------------------------------
    vk_comparisons = do_vk_comparisons(data_long_trt, relabund_control, meta_classes),
    
    # ----- ---------------------------------------------------------------------
    # II. peaks ---------------------------------------------------------------------
    ## IIa. files --------------------------------------------------------------
    peaks_distinct_core = data_key %>% group_by(Core, SampleAssignment) %>% distinct(formula),


    
    peakcounts_core = compute_peakcounts_core(peaks_distinct_core, meta_classes, fticr_key),
    peakcounts_trt = compute_peakcounts_trt(peakcounts_core, fticr_key),

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
    
    
    ## IIb. tables -- peak counts --------------------------------------------------
    peakcount_tables = do_peakcount_tables(peakcounts_core, fticr_key),

    ## IIc. plots -- all peaks (bar) ------------------------------------------------------------------
    gg_peaks_bar = 
      do_gg_peaks_bar(peakcounts_trt)+
      scale_fill_manual(values = PNWColors::pnw_palette("Sailboat"))+
      NULL,
    
    ## IId. plots -- total peaks (scatter) ----------------------------------------------------------
    gg_totalcounts = do_gg_totalcounts(peakcounts_core),
    gg_totalcounts_homo = plot_totalcounts_homo(peakcounts_core),
    
    ## IIe. plots -- simple:complex (scatter) --------------------------------------------------
    aliph_plots = do_aliph_plots(aliphatic_aromatic_counts),
    
    ## IIf. stats -- peak counts ----------------------------------------------------------
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
    lme_peaks_overall = compute_lme_peaks_overall(peakcounts_core),
    aov_peaks_intact = compute_aov_peaks_intact(peakcounts_core),
    

    # ----- ---------------------------------------------------------------------
    # II. relative abundances -------------------------------------------------
    ## IIa. files ---------------------------------------------------------
    relabund_trt = read_fticr_file("data/processed/fticr_relabund_trt.csv"),
    relabund_cores = read_fticr_file("data/processed/fticr_relabund_cores.csv"), 
    
    ## IIb. plots -- all classes (bar) ----------------------------------------------------------
    relabund_barplots = do_relabund_barplots(relabund_trt, relabund_cores_complex),
    
    ## IIc. plots -- complex peaks (scatter) ----------------------------------------------------------
    relabund_cores_complex = compute_relabund_cores_complex(relabund_cores),
    #fticr_hsd_complex = compute_fticr_hsd_complex(relabund_cores_complex),
    
    gg_relabund_complex = do_gg_complex(relabund_cores_complex),
    gg_relabund_complex_homo = plot_complex_homo(relabund_cores_complex),
    
    
    ## IId. stats -------------------------------------------------------------------------
    # this overall lme doesn't work in drake. run separately for results
    #lme_complex_overall = compute_lme_complex_overall(relabund_cores_complex),
    aov_complex_intact = compute_aov_complex_intact(relabund_cores_complex),
    
    # ----- ---------------------------------------------------------------------
    # III. statistics ----------------------------------------------------------
    ## IIIa. PERMANOVA ---------------------------------------------------------
    # overall permanova
    relabund_permanova_overall = compute_permanova_overall(relabund_cores),
    
    # intact cores by suction
    relabund_permanova_int = 
      relabund_cores %>% 
      filter(Homogenization=="Intact") %>% 
      do(compute_permanova_intact_overall(.)),
    
    relabund_permanova_int_1 = 
      relabund_cores %>% 
      filter(Suction==1.5 & Homogenization=="Intact") %>% 
      do(compute_permanova_intact(.)),
    
    relabund_permanova_int_50 = 
      relabund_cores %>% 
      filter(Suction==50 & Homogenization=="Intact") %>% 
      do(compute_permanova_intact(.)),
    
    ## IIIb. PCA ---------------------------------------------------------------
    # pca for ms ----
    gg_pca = do_pca_intact(relabund_cores),
    
    
    
    # make pca file
    relabund_wide = 
      relabund_cores %>% 
      filter(!Suction==15) %>% 
      dplyr::select(Core, SampleAssignment, class, relabund, 
                    Moisture, Wetting, Suction, Homogenization, Amendments) %>% 
      spread(class, relabund) %>% 
      replace(is.na(.), 0),
    
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
    
    gg_pca_intact_plots = do_gg_pca_intact_plots(pca_int, relabund_pca_grp_intact),
    
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
    
    pca_homo = prcomp(relabund_pca_num_Homogenized, scale. = TRUE),
    #summary(pca)
    
    gg_pca_homo_plots = do_gg_pca_home_plots(pca_homo, relabund_pca_grp_Homogenized),
  
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
      scale_color_manual(values = pal3)+
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
      scale_color_manual(values = pal3)+
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
      scale_color_manual(values = pal3)+
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
      scale_color_manual(values = pal3)+
      labs(shape="",
           title = "1.5 kPa Homogenized")+
      NULL,
    
    #### combined ----
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
      scale_fill_manual(values = pal3)+
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
    
    gg_element_plots = do_gg_element_plots(fticr_elements),
    
    # ----- ---------------------------------------------------------------------
    # report ------------------------------------------------------------------
    report1 = rmarkdown::render(
      knitr_in("reports/fticr_drake_md_report.Rmd"),
      #  output_file = file_out("drake_md_report.md"))
      #      output_format = rmarkdown::html_document(toc = TRUE))
      output_format = rmarkdown::github_document()),
    
              #   report2 = rmarkdown::render(
              #     knitr_in("reports/results.Rmd"),
              #     output_format = rmarkdown::github_document())
    
    # ----- ---------------------------------------------------------------------
  )

# make plan ---------------------------------------------------------------
make(fticr_plan)





    # loadd(aliphatic_aromatic_counts)
    # 
    # aliphatic_aromatic_counts %>% 
    #   ggplot(aes(x = Homogenization, y = arom_aliph_ratio))+
    #   geom_boxplot()+
    #   geom_jitter()+
    #   NULL
    # 
    # aliphatic_aromatic_counts %>% 
    #   ggplot(aes(x = Moisture, y = arom_aliph_ratio))+
    #   geom_boxplot()+
    #   geom_jitter()+
    #   NULL
    # 
    # aliphatic_aromatic_counts %>% 
    #   ggplot(aes(x = Amendments, y = arom_aliph_ratio))+
    #   geom_boxplot()+
    #   geom_jitter()+
    #   NULL
    # 
    # 
    # # total peaks
    # loadd(peakcounts_core)
    # 
    # peakcounts_total_core %>% 
    #   ggplot(aes(x = as.character(Suction), y = counts))+
    #   geom_boxplot()+
    #   geom_jitter()+
    #   NULL
