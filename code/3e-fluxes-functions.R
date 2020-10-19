
# I. READING -----------------------------------------------------------
read_file <- function(fn) {
  read.csv(file_in(fn)) %>% 
    dplyr::mutate(
      Homogenization = factor(Homogenization, levels = c("Intact", "Homogenized")),
      Amendments = factor(Amendments, levels = c("control", "C", "N")),
      Moisture = factor(Moisture, levels = c("fm", "drought")),
      Wetting = factor(Wetting, levels = c("precip", "groundw")))
}

#
# II. PLOTTING --------------------------------------------------------------
pal3 = c("#FFE733", "#96001B", "#2E5894") #soil_palette("redox2")


## IIa.  cum-flux ----------------------------------------------------------------

# old scatterplot
fit_hsd = function(dat) {
  a = aov(log(cum_CO2C_mg_gC) ~ Amendments, data = dat)
  h = agricolae::HSD.test(a,"Amendment")
  #create a tibble with one column for each treatment
  #the hsd results are row1 = drought, row2 = saturation, row3 = time zero saturation, row4 = field moist. hsd letters are in column 2
  tibble(`control` = h$groups["control",2], 
         `C` = h$groups["C",2],
         `N` = h$groups["N",2])
}  
do_cumflux_scatterplot = function(flux_summary){
  
  flux_hsd = 
    flux_summary %>% 
    group_by(Moisture, Wetting, Homogenization) %>% 
    do(fit_hsd(.)) %>% 
    # retain only those with differences
    mutate(newcol = paste0(control,C,N)) %>% 
    filter(!newcol=="aaa") %>% 
    select(-newcol) %>% 
    pivot_longer(-c(Moisture, Wetting, Homogenization),
                 names_to = "Amendments",
                 values_to = "label")
  
  ## make labels with hsd
  flux_cum_labels = 
    flux_summary %>% 
    na.omit() %>% 
    group_by(Moisture, Wetting, Homogenization, Amendments) %>% 
    summarize(y_lab = max(cum_CO2C_mg_gC)) %>% 
    left_join(flux_hsd) %>% 
    na.omit()
  
  ## plot
  gg_flux_cum = 
    flux_summary %>% 
    ggplot(aes(x = Amendments, y = cum_CO2C_mg_gC))+
    geom_point(size=2)+ 
    geom_text(data = flux_cum_labels, aes(x = Amendments, y = y_lab+70, label = label))+
    #scale_color_manual(values = soilpalettes::soil_palette("redox2",3))+
    labs(title = "cumulative CO2-C evolved")+
    facet_grid(Homogenization~Moisture+Wetting)+
    theme_kp()+
    theme(panel.grid = element_blank())
  
  list(gg_flux_cum)
}

# scatter + boxplot (intact cores)
fit_aov_wetting = function(depvar, Wetting){
  # boxplot p-values
  a1 <- aov(log(depvar) ~ Wetting)
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

do_labels_cumflux_intact = function(depvar, flux_summary){
  # 1. p-values for moisture ----
  wetting_label <- 
    flux_summary %>% 
    group_by(Moisture) %>% 
    do(fit_aov_wetting(.[[depvar]], .$Wetting)) %>% 
    mutate(x = 1.5,
           y = 0,
           label = paste("p =", p_value),
           label = if_else(p_value == 0, "p < 0.0001", label))
  
  # 2. HSD for amendments ----
  hsd_y <- 
    flux_summary %>% 
    filter(Homogenization=="Intact") %>% 
    group_by(Moisture, Wetting, Amendments) %>% 
    dplyr::summarize(
      y = max(cum_CO2C_mg_gC, na.rm = T) + 0.5)
  
  amend_label <- 
    flux_summary %>% 
    group_by(Moisture, Wetting) %>% 
    do(fit_hsd_amend(.$cum_CO2C_mg_gC, .$Amendments)) %>% 
    dplyr::mutate(skip = control==C & C==N) %>% 
    filter(!skip) %>% 
    dplyr::select(-skip) %>% 
    pivot_longer(-c(Moisture, Wetting),
                 names_to = "Amendments",
                 values_to = "label") %>% 
    mutate(w = dplyr::recode(Wetting, "precip"="1" , "groundw"="2"),
           am = dplyr::recode(Amendments, "control" = -0.2, "C" = 0, "N" = 0.2),
           x = as.numeric(w)+as.numeric(am)) %>% 
    left_join(hsd_y)
  
  
  # 4. combined label ----
  amend_label %>% rbind(wetting_label)
}
do_cumflux_boxplot = function(flux_summary){
  
  cumflux_label = do_labels_cumflux_intact("cum_CO2C_mg_gC", flux_summary)
  
  flux_summary %>% 
    filter(Homogenization=="Intact") %>% 
    ggplot(aes(x = Wetting, y = cum_CO2C_mg_gC))+
    geom_boxplot(width=0.6, fill = "grey90", color = "grey60", alpha = 0.3)+
    geom_point(size=4, stroke=1, position = position_dodge(width = 0.6), 
               aes(fill = Amendments), shape = 21)+ 
    #scale_shape_manual(values = c(21,22,23))+
    scale_fill_manual(values = pal3)+
    labs(title = "cumulative CO2-C evolved")+
    #annotate("text", label = "p = xx", x = 1.5, y = 20)+
    geom_text(data = cumflux_label, aes(x = x, y = y, label = label), size=5)+
    facet_grid(Homogenization~Moisture)+
    theme_kp()+
    theme(panel.grid = element_blank())+
    NULL
}

# scatter + boxplot (intact cores) -- #2
fit_aov_moisture = function(depvar, Moisture){
  # boxplot p-values
  a1 <- aov(log(depvar) ~ Moisture)
  label_a1 <- broom::tidy(a1) %>% 
    filter(term != "Residuals") %>% 
    mutate(p_value = round(p.value, 4)) %>% 
    dplyr::select(term, p_value) 
}
fit_aov_wetting2 = function(depvar, Wetting){
  a3 = aov(log(depvar) ~ Wetting)
  broom::tidy(a3) %>% 
    filter(term != "Residuals") %>% 
    dplyr::select(term, `p.value`) %>% 
    filter(`p.value` <= 0.05)
}

do_labels_cumflux_intact2 = function(depvar, flux_summary){
  # 1. p-values for moisture ----
  moisture_label <- 
    flux_summary %>% 
    do(fit_aov_moisture(.[[depvar]], .$Moisture)) %>% 
    mutate(x = 1.5,
           y = 0,
           label = paste("p =", p_value),
           label = if_else(p_value == 0, "p < 0.0001", label))
  
  # 2. HSD for amendments ----
  hsd_y <- flux_summary %>% 
    group_by(Moisture, Amendments) %>% 
    dplyr::summarize(max = max(cum_CO2C_mg_gC),
                     y = max(cum_CO2C_mg_gC, na.rm = T) + 200)
  
  amend_label <- flux_summary %>% 
    group_by(Moisture) %>% 
    do(fit_hsd_amend(.$cum_CO2C_mg_gC, .$Amendments)) %>% 
    dplyr::mutate(skip = control==C & C==N) %>% 
    filter(!skip) %>% 
    dplyr::select(-skip) %>% 
    pivot_longer(-c(Moisture),
                 names_to = "Amendments",
                 values_to = "label") %>% 
    mutate(m = dplyr::recode(Moisture, "fm"="1" , "drought"="2"),
           am = dplyr::recode(Amendments, "control" = -0.2, "C" = 0, "N" = 0.2),
           x = as.numeric(m)+as.numeric(am)) %>% 
    left_join(hsd_y)
  
  # 3. wetting label ----
  wetting_label <- 
    flux_summary %>% 
    group_by(Moisture, Amendments) %>% 
    do(fit_aov_wetting2(.$cum_CO2C_mg_gC, .$Wetting))
  
  # 4. combined label ----
  
  amend_label %>% rbind(moisture_label)
}
do_gg_cumfluxflux_boxplot2 <- function(flux_summary) {
  cumflux_label2 <- do_labels_cumflux_intact2("cum_CO2C_mg_gC", flux_summary %>% filter(Homogenization=="Intact"))

  flux_summary %>% 
    filter(Homogenization=="Intact") %>% 
    ggplot(aes(x = Moisture, y = cum_CO2C_mg_gC))+
    geom_boxplot(aes(group = Moisture), 
                 fill = "grey90", alpha = 0.3, color = "grey60", width = 0.6)+
    geom_point(aes(fill = Amendments, shape = Wetting, group = Amendments),
               size=4, stroke=1, position = position_dodge(width = 0.6))+
    geom_text(data = cumflux_label2, aes(x = x, y = y, label = label), size=5)+
    scale_fill_manual(values = pal3)+
    scale_shape_manual(values = c(21,23))+
    guides(fill=guide_legend(override.aes=list(shape=21)))+
    labs(title = "cumulative CO2C evolved",
         #y = "count",
         caption = "wetting sig for: dr/C")+
    facet_grid(Homogenization~.)+
    theme_kp()+
    NULL
}



# scatter + box plot (effect of homogenization)
fit_aov_homo = function(depvar, Homogenization){
  # boxplot p-values
  a1 <- aov(log(depvar) ~ Homogenization)
  label_a1 <- broom::tidy(a1) %>% 
    filter(term != "Residuals") %>% 
    mutate(p_value = round(p.value, 4)) %>% 
    dplyr::select(term, p_value) 
}
do_labels_cumflux_homo = function(depvar, flux_summary){
  flux_summary %>% 
    group_by(Amendments) %>% 
    do(fit_aov_homo(.[[depvar]], .$Homogenization)) %>% 
    mutate(x = 1.5,
           y = 0,
           label = paste("p =", p_value),
           label = if_else(p_value == 0, "p < 0.0001", label))
}
do_cumflux_boxplot_homo = function(flux_summary){
  
  homo_labels = do_labels_cumflux_homo("cum_CO2C_mg_gC", flux_summary)
  
  gg_cumflux_homo = 
    flux_summary %>% 
    ggplot(aes(x = Homogenization, y = cum_CO2C_mg_gC))+
    geom_boxplot(aes(group=Homogenization), width = 0.4)+
    geom_point(size=4, stroke=1, position = position_dodge(width = 0.6), 
               aes(fill = Moisture, shape = Wetting, group = Moisture))+
    scale_shape_manual(values = c(21,23))+
    scale_fill_manual(values = soilpalettes::soil_palette("crait",2))+
    geom_text(data = homo_labels, aes(x = x, y = y, label = label))+
    labs(title = "effect of homogenization")+
    facet_grid(.~Amendments)+
    theme_kp()+
    guides(fill = guide_legend(override.aes = list(shape=21)))+
    NULL
  
  list(gg_cumflux_homo = gg_cumflux_homo)
}

#
## IIb.  time-series ----------------------------------------------------------------

## by treatment 
do_flux_ts = function(flux){
  
  meanflux = 
    flux %>% 
    group_by(Homogenization, Moisture, Wetting, Amendments, Assignment, elapsed_min_bin) %>%
    dplyr::summarise(CO2C_mg_gC_s = mean(CO2C_mg_gC_s))
  
  gg_flux_ts = 
    ggplot()+
    geom_smooth(data = flux, 
                aes(x = elapsed_min_bin/60, y = CO2C_mg_gC_s*1000, group=CORE, color = Amendments), 
                size=0.5, alpha = 0.5, se=FALSE)+
    geom_smooth(data = meanflux,
                aes(x = elapsed_min_bin/60, y = CO2C_mg_gC_s*1000, color = Amendments),
                se=FALSE, size=1.5)+ #geom_point()+
    scale_color_manual(values = pal3)+
    labs(title = "mean CO2-C flux",
         subtitle = "LOESS smooth",
         x = "elapsed hours")+
    facet_grid(Homogenization~Moisture+Wetting)+
    theme_kp()+
    NULL
  
  list(gg_flux_ts = gg_flux_ts)
}

## by core 
do_flux_ts_bycore = function(flux){
  
  gg_flux_ts_core_intact = 
    flux %>% 
    filter(Homogenization=="Intact") %>% 
    arrange(CORE, elapsed_min_bin) %>% 
    ggplot(aes(x = elapsed_min_bin, y = CO2C_mg_gC_s*1000, color = as.character(CORE)))+
    geom_path()+ geom_point()+
    ylim(0, 30)+
    labs(title = "intact cores")+
    theme(legend.position = "none")+
    facet_wrap(~Assignment, ncol = 3)
  
  gg_flux_ts_core_homo = 
    flux %>% 
    filter(Homogenization=="Homogenized") %>% 
    arrange(CORE, elapsed_min_bin) %>% 
    ggplot(aes(x = elapsed_min_bin, y = CO2C_mg_gC_s*1000, color = as.character(CORE)))+
    geom_path()+ geom_point()+
    ylim(0, 30)+
    labs(title = "homogenized cores")+
    theme(legend.position = "none")+
    facet_wrap(~Assignment, ncol = 3)
}

#
# III. TABLES ----------------------------------------------------------------
do_flux_summarytable = function(flux_summary){
  flux_summarytable =
    flux_summary %>% 
    group_by(Homogenization,Assignment, Moisture, Wetting, Amendments) %>% 
    summarise(se_cum_CO2C_mg_gC = sd(cum_CO2C_mg_gC, na.rm = T)/sqrt(n()),
              cum_CO2C_mg_gC = mean(cum_CO2C_mg_gC, na.rm = T)) %>% 
    mutate(cum_CO2C_mg_gC = paste(round(cum_CO2C_mg_gC,2), "\u00b1", round(se_cum_CO2C_mg_gC,2))) %>% 
    ungroup %>% 
    select(Homogenization, Assignment, Moisture, Wetting, Amendments, cum_CO2C_mg_gC)
  
}

# IV. STATISTICS ----------------------------------------------------------

compute_lme_flux_overall = function(flux_summary){
  l = lme4::lmer(log(cum_CO2C_mg_gC) ~ (Homogenization+Moisture+Wetting+Amendments)^2 + (1|CORE), 
                 data = flux_summary)
  car::Anova(l, type = "III")
}
compute_aov_flux_intact = function(flux_summary){
  l = lm(log(cum_CO2C_mg_gC) ~ (Moisture + Amendments + Wetting)^2,
         data = flux_summary)
  
  car::Anova(l, type="III")
}




     