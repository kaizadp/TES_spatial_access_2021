# Computations for various pipeline targets


compute_reps <- function(data_key) {
  data_key %>% 
    filter(Suction != 15) %>% 
    ungroup() %>% 
    distinct(Core, SampleAssignment) %>% 
    group_by(SampleAssignment) %>% 
    dplyr::summarise(reps = n())
}

compute_peakcounts_core <- function(peaks_distinct_core, meta_classes, fticr_key) {
  peaks_distinct_core %>% 
    left_join(meta_classes, by = "formula") %>% 
    group_by(Core, SampleAssignment, class) %>% 
    dplyr::summarize(n = n()) %>% 
    ungroup() %>% 
    group_by(Core, SampleAssignment) %>% 
    dplyr::mutate(total = sum(n)) %>% 
    ungroup() %>% 
    spread(class, n) %>% 
    pivot_longer(-c(Core, SampleAssignment),
                 names_to = "class",
                 values_to = "counts") %>% 
    left_join(fticr_key, by = "SampleAssignment") %>% 
    mutate(Amendments = factor(Amendments, 
                               levels = c("control", "C", "N")),
           Homogenization = factor(Homogenization, 
                                   levels = c("Intact", "Homogenized")),
           Moisture = factor(Moisture, 
                             levels = c("fm", "drought")),
           Wetting = factor(Wetting, 
                            levels = c("precip", "groundw")))
}

compute_peakcounts_trt <- function(peakcounts_core, fticr_key) {
  peakcounts_core %>% 
    filter(class != "total") %>% 
    group_by(SampleAssignment, class) %>% 
    dplyr::summarize(peaks = as.integer(mean(counts))) %>% 
    ungroup() %>% 
    left_join(fticr_key, by = "SampleAssignment") %>% 
    mutate(Amendments = factor(Amendments, 
                               levels = c("control", "C", "N")),
           Homogenization = factor(Homogenization, levels = c("Intact", "Homogenized")))  
}

compute_relabund_cores_complex <- function(relabund_cores) {
  relabund_cores %>% 
    filter(!class=="aliphatic") %>% 
    group_by(Core, Suction, Homogenization, Moisture, Wetting, Amendments) %>% 
    dplyr::summarise(relabund = sum(relabund)) %>% 
    ungroup()
}


# stats -------------------------------------------------------------------

compute_permanova_overall = function(relabund_cores){
  relabund_wide = 
    relabund_cores %>% 
    filter(!Suction==15) %>% 
    dplyr::select(Core, SampleAssignment, class, relabund, 
                  Moisture, Wetting, Suction, Homogenization, Amendments) %>% 
    spread(class, relabund) %>% 
    replace(is.na(.), 0)
  
  permanova_fticr_all = 
    adonis(relabund_wide %>% select(aliphatic:condensed_arom) ~ (Amendments+Moisture+Wetting+Suction+Homogenization)^2, 
           data = relabund_wide)
  
  broom::tidy(permanova_fticr_all$aov.tab)
}
compute_permanova_intact = function(dat){
  relabund_wide = 
    dat %>% 
    filter(!Suction==15) %>% 
    dplyr::select(Core, SampleAssignment, class, relabund, 
                  Moisture, Wetting, Amendments) %>% 
    spread(class, relabund) %>% 
    replace(is.na(.), 0)
  
  permanova_fticr_int = 
    adonis(relabund_wide %>% select(aliphatic:condensed_arom) ~ (Amendments+Moisture+Wetting)^2, 
           data = relabund_wide)
  
  broom::tidy(permanova_fticr_int$aov.tab)
}

# total peaks
compute_lme_peaks_overall = function(peakcounts_core){
  peakcounts_total = 
    peakcounts_core %>% 
    filter(class=="total")

  l = lme4::lmer(log(counts) ~ (Homogenization+Moisture+Wetting+Amendments)^2 + (1|Core), 
                 data = peakcounts_total)
  car::Anova(l, type = "III")
}
compute_aov_peaks_intact = function(peakcounts_core){
  peakcounts_total = 
    peakcounts_core %>% 
    filter(class=="total")
  
  l = lm(log(counts) ~ (Moisture + Amendments + Wetting + Suction)^2,
         data = peakcounts_total %>% filter(Homogenization=="Intact"))
  
  car::Anova(l, type="III")
}

# loadd(peakcounts_core)
# 
# compute_lme_peaks_overall(peakcounts_core)
# compute_aov_peaks_intact(peakcounts_core)
# 
# peakcounts_core %>% 
#   filter(class=="total" & Homogenization=="Intact") %>% 
#   ggplot(aes(x = Amendments, y = counts, color = Moisture, shape = Wetting))+
#   geom_point()+
#   facet_grid(Homogenization~Suction)
