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
    gg_cumflux_scatter = do_cumflux_scatterplot(flux_summary),
    
    # intact cores (boxplot)
    gg_flux_cum_intact_boxplot = do_cumflux_boxplot(flux_summary),
    
    # effect of homogenization (boxplot)
    gg_cumflux_homo = do_cumflux_boxplot_homo(flux_summary),    
    
    
    ## IIb.  time-series ----------------------------------------------------------------
    gg_flux_ts = do_flux_ts(flux),
    
    gg_flux_ts_bycore = do_flux_ts_bycore(flux),
    
    #
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
    aov_flux_intact = flux_summary %>% 
      filter(Homogenization=="Intact") %>% 
      do(compute_aov_flux_intact(.)),
    
    ## homogenization:amendments ----
    flux_interx_plot =  
      flux_summary %>% 
      # filter(Homogenization=="Intact") %>% 
      group_by(Amendments, Homogenization) %>% 
      dplyr::summarize(cum_CO2C_mg_g = mean(cum_CO2C_mg_g, na.rm = TRUE)) %>% 
      ggplot(aes(x = Amendments, y = cum_CO2C_mg_g, color = Homogenization))+
      geom_point()+geom_path(aes(group = Homogenization))+
      NULL,
    
    aov_homo_c =     
      car::Anova(lmer(log(cum_CO2C_mg_g) ~ Homogenization + (1|CORE), 
                      data = flux_summary %>% filter(Amendments == "C")), 
                 type = "III"),
    
    aov_homo_n =     
      car::Anova(lmer(log(cum_CO2C_mg_g) ~ Homogenization + (1|CORE), 
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
make(respiration_plan, lock_cache = F)
