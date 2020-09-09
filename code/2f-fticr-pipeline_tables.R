# Tables for various pipeline targets

do_peakcount_tables <- function(peakcounts_core, fticr_key) {
  # 1. total counts ----
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
    spread(var, peaks)
  
  # 2. complex peak counts ----
  peakcounts_table_aromatic <- 
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
    spread(var, peaks)
  
  # 3. simple:complex peak counts ----
  aliphatic_aromatic_counts <-  
    peakcounts_core %>% 
    ungroup %>% 
    filter(!class=="total") %>% 
    mutate(new_class = if_else(grepl("aliphatic",class), "aliphatic", "complex")) %>% 
    group_by(Core, Homogenization, Moisture, Wetting, Amendments, Suction, new_class) %>% 
    dplyr::summarise(counts = sum(counts)) %>%
    ungroup() %>% 
    spread(new_class, counts) %>% 
    mutate(arom_aliph_ratio = complex/aliphatic)
  
  # 4. list ----
  list(peakcounts_table_total = peakcounts_table_total,
       peakcounts_table_aromatic = peakcounts_table_aromatic,
       aliphatic_aromatic_counts = aliphatic_aromatic_counts)
}
