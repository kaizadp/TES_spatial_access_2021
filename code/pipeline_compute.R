# Computations for various pipeline targets

compute_peakcounts_core <- function(peaks_distinct_core, meta_classes) {
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
    group_by(SampleAssignment, class) %>% 
    filter(class != "total") %>% 
    summarize(peaks = as.integer(mean(counts))) %>% 
    ungroup() %>% 
    left_join(fticr_key, by = "SampleAssignment") %>% 
    mutate(Amendments = factor(Amendments, 
                               levels = c("control", "C", "N")),
           Homogenization = factor(Homogenization, levels = c("Intact", "Homogenized")))  
}

compute_fticr_hsd_totalpeaks <- function(peakcounts_core) {
  peakcounts_core %>% 
    filter(class=="total") %>% 
    mutate(Suction = as.character(Suction)) %>% 
    group_by(Suction, Homogenization, Moisture) %>% 
    do(fit_hsd_totalpeaks(.))
}

compute_reps <- function(data_key) {
  data_key %>% 
    filter(Suction != 15) %>% 
    ungroup() %>% 
    distinct(Core, SampleAssignment) %>% 
    group_by(SampleAssignment) %>% 
    dplyr::summarise(reps = n())
}

compute_relabund_cores_complex <- function(relabund_cores) {
  relabund_cores %>% 
    filter(!class=="aliphatic") %>% 
    group_by(Core, Suction, Homogenization, Moisture, Wetting, Amendments) %>% 
    dplyr::summarise(relabund = sum(relabund)) %>% 
    ungroup()
}

compute_fticr_hsd_complex <- function(relabund_cores_complex) {
  relabund_cores_complex %>% 
    mutate(Suction = as.character(Suction)) %>% 
    group_by(Suction, Homogenization, Moisture) %>% 
    do(fit_hsd_complex(.))
}
