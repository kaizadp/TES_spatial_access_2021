source(("code/0-packages.R"))
library(drake)
library(lme4)

source("code/3e-fluxes-functions.R")

respiration_plan = 
  drake_plan(
    # I. load files --------------------------------------------------------------
    theme_set(theme_bw()),
    
    flux = read_file("data/processed/flux.csv"),
    flux_summary = read_file("data/processed/flux_summary.csv"),
    
    
    # ----- ---------------------------------------------------------------------
    # II. graphs ------------------------------------------------------------------
    ## IIa.  cum-flux ----------------------------------------------------------------
    
    # intact cores (scatterplot)
    ## gg_cumflux_scatter = do_cumflux_scatterplot(flux_summary),
    
    # intact cores (boxplot)
    ## gg_flux_cum_intact_boxplot = do_gg_cumfluxflux_boxplot2(flux_summary),
    gg_flux_cum_intact_boxplot = do_cumflux_boxplot(flux_summary)$gg_cumflux_intact,
    gg_flux_cum_homo_boxplot = do_cumflux_boxplot(flux_summary)$gg_cumflux_homo,
    
    # effect of homogenization (boxplot)
    ## gg_cumflux_homo = do_cumflux_boxplot_homo(flux_summary),    
    
    
    ## IIb.  time-series ----------------------------------------------------------------
    gg_flux_ts = do_flux_ts(flux),
    
    gg_flux_ts_bycore = do_flux_ts_bycore(flux),
    
    #
    
    
    # IIc. combined plot ------------------------------------------------------
    
    gg_flux_combined = ggpubr::ggarrange(do_cumflux_boxplot(flux_summary)$gg_cumflux, 
                                         do_flux_ts_bycore(flux)$gg_flux_ts_intact_panels, 
                                         nrow = 2, heights = c(1, 2.1),
                                         labels = c("A", "B")),
    
    gg_flux_combined_tsonly = do_flux_ts_bycore(flux)$gg_flux_ts_intact_panels,

    # III. summary table -----------------------------------------------------------
    flux_summarytable = do_flux_summarytable(flux_summary),
    
    # ----- ---------------------------------------------------------------------
    
    flux_subset = flux_summary %>% 
      filter(Homogenization=="Intact" & Moisture=="drought"),
    
    #    car::Anova(lm(log(cum_CO2C_mg) ~ Wetting * Amendments, data = flux_subset), type="III")
    
    # ----- ---------------------------------------------------------------------
    # IV. stats -------------------------------------------------------------------
    # overall LME 
    aov_flux_all =  
      flux_summary %>% 
      do(compute_lme_flux_overall(.)),
    
    # intact
    aov_flux_intact = 
      flux_summary %>% 
      filter(Homogenization=="Intact") %>% 
      do(compute_aov_flux_intact(.)),
    
    ## homogenization:amendments ----
    flux_interx_plot =  
      flux_summary %>% 
      # filter(Homogenization=="Intact") %>% 
      group_by(Amendments, Homogenization) %>% 
      dplyr::summarize(cum_CO2C_mg_gC = mean(cum_CO2C_mg_gC, na.rm = TRUE)) %>% 
      ggplot(aes(x = Amendments, y = cum_CO2C_mg_gC, color = Homogenization))+
      geom_point()+geom_path(aes(group = Homogenization))+
      NULL,
    
    #     aov_homo_c =     
    #       car::Anova(lmer(log(cum_CO2C_mg_gC) ~ Homogenization + (1|CORE), 
    #                       data = flux_summary %>% filter(Amendments == "C")), 
    #                  type = "III"),
    #     
    #     aov_homo_n =     
    #       car::Anova(lmer(log(cum_CO2C_mg_gC) ~ Homogenization + (1|CORE), 
    #                       data = flux_summary %>% filter(Amendments == "N")), 
    #                  type = "III"),
    
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
make(respiration_plan, lock_cache = F)






# CH4 ---------------------------------------------------------------------

flux = read_file("data/processed/flux.csv")
flux_summary = read_file("data/processed/flux_summary.csv")

flux_summary %>% 
  ggplot()+
  geom_smooth(data = flux, 
              aes(x = elapsed_min_bin/60, y = CO2C_mg_gC_s*1000, group=CORE, color = Amendments), 
              size=0.5, alpha = 0.5, se=FALSE)+
#  geom_smooth(data = meanflux,
#              aes(x = elapsed_min_bin/60, y = CO2C_mg_gC_s*1000, color = Amendments),
#              se=FALSE, size=1.5)+ #geom_point()+
  scale_color_manual(values = pal3)+
  labs(title = "mean CO2-C flux",
       subtitle = "LOESS smooth",
       x = "elapsed hours")+
  facet_grid(Homogenization~Moisture+Wetting)+
  theme_kp()+
  NULL

flux %>% 
  filter(Homogenization=="Intact") %>% 
  arrange(CORE, elapsed_min_bin) %>% 
  ggplot(aes(x = elapsed_min_bin, y = CO2C_mg_gC_s*1000, color = as.character(CORE)))+
  geom_path()+ geom_point()+
  geom_vline(xintercept = 200, linetype = "dashed")+
  #ylim(0, 30)+
  labs(title = "intact cores",
       x = "elapsed time (minutes)")+
  #facet_wrap(~Assignment, ncol = 3)+
  facet_grid(Amendments ~ Moisture + Wetting)+
  theme_kp()+
  theme(legend.position = "none")+
  NULL



flux %>% 
  mutate(Amendments = dplyr::recode(Amendments, "control" = "unamended", "C" = "+C", "N" = "+N"),
         Amendments = factor(Amendments, levels = c("unamended", "+C", "+N")),
         Wetting = dplyr::recode(Wetting, "precip" = "PR", "groundw" = "GW"),
         Wetting = factor(Wetting, levels = c("PR", "GW"))) %>% 
  #filter(Amendments == "C") %>% 
  filter(Homogenization=="Intact") %>% 
  arrange(CORE, elapsed_min_bin) %>% 
  ggplot(aes(x = elapsed_min_bin, y = CH4C_mg_gC_s*1000, color = Wetting))+
  geom_path(alpha = 0.2, aes(group = CORE))+ 
  geom_point(alpha = 0.3)+
  geom_smooth(se = F, span = 0.2)+
  geom_vline(xintercept = 200, linetype = "dashed")+
  scale_color_manual(values = c("#0f85a0", "#ed8b00"))+
  #ylim(0, 30)+
  labs(#title = "intact cores",
    x = "elapsed time (minutes)",
    y = expression(bold("CH"[4]*"-C, μg gC"^-1 *" s"^-1)))+
  #facet_wrap(~Assignment, ncol = 3)+
  facet_grid(Amendments ~ Moisture)+
  theme_kp()+
  guides(color = guide_legend(override.aes = list(alpha=1)))+
  theme(legend.position = c(0.3, 0.9))+
  NULL
