library(here)
source("code/0-packages.R")
library(drake)
library(rmarkdown)
library(vegan)
library(visNetwork)
library(car)
library(lme4)
library(patchwork)

# Pipeline functions
source("code/pipeline_plotting.R")
source("code/pipeline_tables.R")

# Setup (from here from plan)
theme_set(theme_bw())
pal <- pnw_palette("Bay", 3)


# ----- Functions extracted from the drake plan
# BBL: I would suggest moving them to another file, e.g. "fit_functions.R"

fit_hsd_totalpeaks <- function(dat) {
  a <-aov(log(counts) ~ Amendments, data = dat)
  h <-agricolae::HSD.test(a,"Amendments")
  #create a tibble with one column for each treatment
  #the hsd results are row1 = drought, row2 = saturation, row3 = time zero saturation, row4 = field moist. hsd letters are in column 2
  tibble(`control` = h$groups["control",2], 
         `C` = h$groups["C",2],
         `N` = h$groups["N",2])
}

fit_hsd_complex <- function(dat) {
  a <-aov(log(relabund) ~ Amendments, data = dat)
  h <-agricolae::HSD.test(a,"Amendments")
  #create a tibble with one column for each treatment
  #the hsd results are row1 = drought, row2 = saturation, row3 = time zero saturation, row4 = field moist. hsd letters are in column 2
  tibble(`control` = h$groups["control",2], 
         `C` = h$groups["C",2],
         `N` = h$groups["N",2])
}


# BBL: Why are you getting cache this way? Should not be necessary
fticr_cache <- drake_cache(path = "reports/cache/fticr")

fticr_plan <- 
  drake_plan(
    # 0a. setup -------------------------------------------------------------------
    
    # 0b. load files --------------------------------------------------------------
    fticr_key = read_fticr_key("data/processed/fticr_key.csv"),
    data_key = read_data_key("data/processed/fticr_long_key.csv.gz"),
    data_long_trt = read_data_long_trt("data/processed/fticr_long_trt.csv.gz"),
    meta = read.csv(file_in("data/processed/fticr_meta.csv")),
    
    meta_hcoc = select(meta, formula, HC, OC),    
    meta_classes = select(meta, formula, class),
    
    # 0c. reps ----------------------------------------------------------------
    reps = compute_reps(data_key),
    
    # ----- ---------------------------------------------------------------------
    # I. van krevelens -----------------------------------------------------------
    ## Ia. domains --------------------------------------------------------------
    van_krevelen_plots = do_van_krevelens(data_long_trt, data_key),
    
    ## IIb. fticr baseline -----------------------------------------------------
    fticr_plots = do_fticrs(data_long_trt, data_key, meta_hcoc),
    
    # ----- ---------------------------------------------------------------------
    # II. peaks ---------------------------------------------------------------------
    peaks_distinct_core = data_key %>% group_by(Core, SampleAssignment) %>% distinct(formula),
    
    peakcounts_core = compute_peakcounts_core(peaks_distinct_core, meta_classes),
    peakcounts_trt = compute_peakcounts_trt(peakcounts_core, fticr_key),

    ## IIa. bar plots ------------------------------------------------------------------
    gg_peaks_bar = do_gg_peaks_bar(peakcounts_trt),
    
    ## IIb. peak count tables --------------------------------------------------
    peakcount_tables = do_peakcount_table(peakcounts_core, fticr_key),
    
    aliph_plots = do_alpha_plots(aliphatic_aromatic_counts),
    
    ## IId.  total peak count -- scatter ----------------------------------------------------------
    
    fticr_hsd_totalpeaks = compute_fticr_hsd_totalpeaks(peakcounts_core),
    
    totalcounts_label = tribble(
      ~x, ~y, ~Suction, ~Homogenization, ~label,
      1.87, 2000, 1.5, "Intact", "b",
      2, 3000, 1.5, "Intact", "a",
      2.13, 2000, 1.5, "Intact", "ab"
    ),  
    
    gg_totalcounts = do_gg_totalcounts(peakcounts_core),
    
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
    relabund_trt = read_relabund_trt("data/processed/fticr_relabund_trt.csv"),
    relabund_cores = read_relabund_cores("data/processed/fticr_relabund_cores.csv"), 
    
    # IIb. bar plots ----------------------------------------------------------

    
    # IIc. complex peaks ----------------------------------------------------------
    ## fit hsd
    relabund_cores_complex = compute_relabund_cores_complex(relabund_cores),
    fticr_hsd_complex = compute_fticr_hsd_complex(relabund_cores_complex),
      
    complex_label = tribble(
      ~x, ~y, ~Suction, ~Homogenization, ~label,
      0.87, 90, 50, "Intact", "a",
      1, 85, 50, "Intact", "b",
      1.13, 85, 50, "Intact", "ab",
      
      1.87, 92, 50, "Intact", "a",
      2, 85, 50, "Intact", "b",
      2.13, 85, 50, "Intact", "b"
    ),
    
    relabund_plots = do_relabund_plots(relabund_trt, relabund_cores_complex),
  
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
      replace(is.na(.), 0),
    
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
    
    gg_element_plots <- do_gg_element_plots(fticr_elements),
    
    # ----- ---------------------------------------------------------------------
    # report ------------------------------------------------------------------
    report1 = rmarkdown::render(
      knitr_in("reports/fticr_drake_md_report.Rmd"),
      #  output_file = file_out("drake_md_report.md"))
      #      output_format = rmarkdown::html_document(toc = TRUE))
      output_format = rmarkdown::github_document()),
    
    report2 = rmarkdown::render(
      knitr_in("reports/results.Rmd"),
      output_format = rmarkdown::github_document())
    
    # ----- ---------------------------------------------------------------------
  )

# make plan ---------------------------------------------------------------
make(fticr_plan, cache = fticr_cache, lock_cache = F)


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
