source(("code/0-packages.R"))
library(drake)
library(lme4)


respiration_plan = 
  drake_plan(
    # I. load files --------------------------------------------------------------
    theme_set(theme_bw()),
    
    flux = 
      read.csv(file_in("data/processed/flux.csv")) %>% 
      mutate(Amendments = factor(Amendments, levels = c("control", "C", "N")),
             Homogenization = factor(Homogenization, levels = c("Intact", "Homogenized")),
             Moisture = factor(Moisture, levels = c("fm", "drought")),
             Wetting = factor(Wetting, levels = c("precip", "groundw"))),
    
    flux_summary = 
      read.csv(file_in("data/processed/flux_summary.csv")) %>% 
      mutate(Amendments = factor(Amendments, levels = c("control", "C", "N")),
             Homogenization = factor(Homogenization, levels = c("Intact", "Homogenized")),
             Moisture = factor(Moisture, levels = c("fm", "drought")),
             Wetting = factor(Wetting, levels = c("precip", "groundw"))),
    
    # ----- ---------------------------------------------------------------------
    # II. graphs ------------------------------------------------------------------
    ## IIa.  cum-flux ----------------------------------------------------------------
    
    ### get HSD letters for plot
    fit_hsd = function(dat) {
      a = aov(log(cum_CO2C_mg) ~ Amendments, data = dat)
      h = agricolae::HSD.test(a,"Amendment")
      #create a tibble with one column for each treatment
      #the hsd results are row1 = drought, row2 = saturation, row3 = time zero saturation, row4 = field moist. hsd letters are in column 2
      tibble(`control` = h$groups["control",2], 
             `C` = h$groups["C",2],
             `N` = h$groups["N",2])
    },  
    
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
                   values_to = "label"),
    
    ## make labels with hsd
    flux_cum_labels = 
      flux_summary %>% 
      na.omit() %>% 
      group_by(Moisture, Wetting, Homogenization, Amendments) %>% 
      summarize(y_lab = max(cum_CO2C_mg)) %>% 
      left_join(flux_hsd) %>% 
      na.omit(),
    
    ## plot
    gg_flux_cum = 
      flux_summary %>% 
      ggplot(aes(x = Amendments, y = cum_CO2C_mg))+
      geom_point(size=2)+ 
      geom_text(data = flux_cum_labels, aes(x = Amendments, y = y_lab+70, label = label))+
      #scale_color_manual(values = soilpalettes::soil_palette("redox2",3))+
      labs(title = "cumulative CO2-C evolved")+
      facet_grid(Homogenization~Moisture+Wetting)+
      theme_kp()+
      theme(panel.grid = element_blank()),
    
    
    flux_boxplotlabel = tribble(
      ~x, ~y, ~Moisture, ~label,
      1.5, 20, "fm", "p = 0.056",
      1.5, 20, "drought", "p = 0.11",
      1, 600, "fm", "a",
      1.18, 500, "fm", "a",
      0.82, 180, "fm", "b",
      2, 430, "fm", "a",
      2.18, 180, "fm", "b",
      1.82, 180, "fm", "ab"
    ) %>% 
      dplyr::mutate(Moisture = factor(Moisture, levels = c("fm", "drought"))),
    
    gg_flux_cum_intact_boxplot = 
      flux_summary %>% 
      filter(Homogenization=="Intact") %>% 
      ggplot(aes(x = Wetting, y = cum_CO2C_mg))+
      geom_boxplot(width=0.5, fill = "grey90", color = "grey60", alpha = 0.4)+
      geom_point(size=4, position = position_dodge(width = 0.5), aes(color = Amendments, shape = Amendments))+ 
      scale_color_manual(values = soilpalettes::soil_palette("redox2",3))+
      labs(title = "cumulative CO2-C evolved")+
      #annotate("text", label = "p = xx", x = 1.5, y = 20)+
      geom_text(data = flux_boxplotlabel, aes(x = x, y = y, label = label), size=5)+
      facet_grid(.~Moisture)+
      theme_kp()+
      theme(panel.grid = element_blank()),
    
    gg_flux_cum_intact_boxplot2 = 
      flux_summary %>% 
      filter(Homogenization=="Intact") %>% 
      ggplot(aes(x = Wetting, y = cum_CO2C_mg))+
      geom_boxplot(width=0.5, fill = "grey90", color = "grey60", alpha = 0.4)+
      geom_point(size=4, position = position_dodge(width = 0.5), 
                 aes(fill = Amendments, shape = Amendments))+ 
      scale_shape_manual(values = c(21,22,23))+
      scale_fill_manual(values = rev(soilpalettes::soil_palette("rendoll",5)))+
      labs(title = "cumulative CO2-C evolved")+
      #annotate("text", label = "p = xx", x = 1.5, y = 20)+
      geom_text(data = flux_boxplotlabel, aes(x = x, y = y, label = label), size=5)+
      facet_grid(.~Moisture)+
      theme_kp()+
      theme(panel.grid = element_blank())+
      NULL,
    
    
    flux_subset = flux_summary %>% 
      filter(Homogenization=="Intact" & Moisture=="drought"),
    
    #    car::Anova(lm(log(cum_CO2C_mg) ~ Wetting * Amendments, data = flux_subset), type="III")
    
    ## IIb.  time-series ----------------------------------------------------------------
    gg_flux_cum_ts = 
      ggplot()+
      geom_line(stat = "smooth",
                data = flux, 
                aes(x = elapsed_min_bin/60, y = CO2C_mg_g_s*1000, group=CORE, color = Amendments), 
                size=0.5, geom="line", alpha = 0.5, se=FALSE, size=3)+
      geom_smooth(data = flux %>% 
                    group_by(Homogenization, Moisture, Wetting, Amendments, 
                             Assignment, elapsed_min_bin) %>%
                    summarise(CO2C_mg_g_s = mean(CO2C_mg_g_s)),
                  aes(x = elapsed_min_bin/60, y = CO2C_mg_g_s*1000, color = Amendments),
                  se=FALSE, size=1.5)+ #geom_point()+
      scale_color_manual(values = soilpalettes::soil_palette("redox2",3))+
      labs(title = "mean CO2-C flux",
           subtitle = "LOESS smooth",
           x = "elapsed hours")+
      facet_grid(Homogenization~Moisture+Wetting)+
      theme_kp()+
      NULL,
    
    ## IIc.  time-series by core ----------------------------------------------------------------
    
    gg_flux_ts_core_intact = 
      flux %>% 
      filter(Homogenization=="Intact") %>% 
      arrange(CORE, elapsed_min_bin) %>% 
      ggplot(aes(x = elapsed_min_bin, y = CO2_umol_g_s*1000, color = as.character(CORE)))+
      geom_path()+ geom_point()+
      ylim(0, 30)+
      labs(title = "intact cores")+
      theme(legend.position = "none")+
      facet_wrap(~Assignment, ncol = 3),
    
    gg_flux_ts_core_homo = 
      flux %>% 
      filter(Homogenization=="Homogenized") %>% 
      arrange(CORE, elapsed_min_bin) %>% 
      ggplot(aes(x = elapsed_min_bin, y = CO2_umol_g_s*1000, color = as.character(CORE)))+
      geom_path()+ geom_point()+
      ylim(0, 30)+
      labs(title = "homogenized cores")+
      theme(legend.position = "none")+
      facet_wrap(~Assignment, ncol = 3),
    
    
    ## IId. cum-flux by homogenization -----------------------------------------
    homo_labels = tribble(
      ~x, ~y, ~ Amendments, ~label,
      1.5, 10, "control", "p = 0.353",
      1.5, 10, "C", "p = 0.019",
      1.5, 10, "N", "p = 0.049",
    ) %>% 
      mutate(Amendments = factor(Amendments, levels = c("control", "C", "N"))),
    
    gg_cumflux_homo = 
      flux_summary %>% 
      ggplot(aes(x = Homogenization, y = cum_CO2C_mg))+
      geom_boxplot(aes(group=Homogenization), width = 0.4)+
      geom_point(size=4, position = position_dodge(width = 0.6), 
                 aes(fill = Moisture, shape = Wetting, group = Wetting))+
      scale_shape_manual(values = c(21,23))+
      geom_text(data = homo_labels, aes(x = x, y = y, label = label))+
      labs(title = "effect of homogenization")+
      facet_grid(.~Amendments)+
      theme_kp()+
      NULL,
    
    gg_cumflux_homo2 = 
      flux_summary %>% 
      ggplot(aes(x = Homogenization, y = cum_CO2C_mg))+
      geom_boxplot(aes(group = Homogenization), 
                   fill = "grey90", alpha = 0.3, color = "grey60", width = 0.4)+      
      geom_point(size=4, stroke=1, position = position_dodge(width = 0.6), 
                 aes(fill = Amendments, shape = Wetting, group = Amendments))+ 
      scale_shape_manual(values = c(21,23))+
      scale_fill_manual(values = rev(soilpalettes::soil_palette("rendoll",5)))+
      guides(fill=guide_legend(override.aes=list(shape=21)))+
      labs(title = "effect of homogenization")+
      theme_kp()+
      NULL,
    
    # ----- ---------------------------------------------------------------------
    # III. summary table -----------------------------------------------------------
    flux_summarytable =
      flux_summary %>% 
      group_by(Homogenization,Assignment, Moisture, Wetting, Amendments) %>% 
      summarise(se_cum_CO2C_mg = sd(cum_CO2C_mg, na.rm = T)/sqrt(n()),
                cum_CO2C_mg = mean(cum_CO2C_mg, na.rm = T)) %>% 
      mutate(cum_CO2C_mg = paste(round(cum_CO2C_mg,2), "\u00b1", round(se_cum_CO2C_mg,2))) %>% 
      ungroup %>% 
      select(Homogenization, Assignment, Moisture, Wetting, Amendments, cum_CO2C_mg), 
    
    # ----- ---------------------------------------------------------------------
    # IV. stats -------------------------------------------------------------------
    ## overall LME -- NOT WORKING ----
    #    aov_flux_all = 
    #      car::Anova(lme4::lmer(cum_CO2C_mg ~ 
    #                        (Homogenization + Moisture + Amendments + Wetting)^3 + (1|CORE),
    #                        data = flux_summary), 
    #                 type="III"),
    
    ## intact and homogenized ----
    aov_flux_intact = 
      car::Anova(lm(log(cum_CO2C_mg) ~ 
                      (Moisture + Amendments + Wetting)^2,
                    data = flux_summary %>% filter(Homogenization=="Intact")), 
                 type="III"),
    
    aov_flux_homo = 
      car::Anova(lm(log(cum_CO2C_mg) ~ 
                      (Moisture + Amendments + Wetting)^2,
                    data = flux_summary %>% filter(Homogenization=="Homogenized")), 
                 type="III"),
    
    ## homogenization:amendments ----
    flux_interx_plot =  
      flux_summary %>% 
      # filter(Homogenization=="Intact") %>% 
      group_by(Amendments, Homogenization) %>% 
      dplyr::summarize(cum_CO2C_mg = mean(cum_CO2C_mg, na.rm = TRUE)) %>% 
      ggplot(aes(x = Amendments, y = cum_CO2C_mg, color = Homogenization))+
      geom_point()+geom_path(aes(group = Homogenization))+
      NULL,
    
    aov_homo_c =     
      car::Anova(lmer(log(cum_CO2C_mg) ~ Homogenization + (1|CORE), 
                      data = flux_summary %>% filter(Amendments == "C")), 
                 type = "III"),
    
    aov_homo_n =     
      car::Anova(lmer(log(cum_CO2C_mg) ~ Homogenization + (1|CORE), 
                      data = flux_summary %>% filter(Amendments == "N")), 
                 type = "III"),
    
    # ----- ---------------------------------------------------------------------
    # V. report ------------------------------------------------------------------
    report1 = rmarkdown::render(
      knitr_in("reports/flux_drake_md_report.Rmd"),
      output_format = rmarkdown::github_document())
    
    #    report2 = rmarkdown::render(
    #      knitr_in("reports/results.Rmd"),
    #      output_format = rmarkdown::github_document())
    
    # ----- ---------------------------------------------------------------------
  )


# make plan ---------------------------------------------------------------

make(respiration_plan)
