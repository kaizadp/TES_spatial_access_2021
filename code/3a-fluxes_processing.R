## SPATIAL ACCESS
## KAIZAD F. PATEL
## 6-JULY-2020

## GREENHOUSE GAS FLUXES

# the data are processed and outliers have been removed
# data are available here as flux values per time point

source("code/0-packages.R")


# load files --------------------------------------------------------------
corekey = read.csv("data/processed/corekey.csv")
fluxes_input = read.csv("data/GHG_Flux_exclOutliers.csv")
coreweights = read.csv("data/core_weights.csv") %>% 
  dplyr::select(CORE, Homogenization, dry_wt_fine_g, totalC_perc)
## clean the flux data

flux = 
  fluxes_input %>% 
  select(ID, DATETIME, CORE, Homogenization, elapsed_minutes, `ElapsedMin.BIN.`,
         `CO2_flux_umol.g.s`, `CH4_flux_umol.g.s`, `cumCO2.C..mg.`, `cumCH4.C..mg.`) %>% 
  rename(CO2_umol_g_s = `CO2_flux_umol.g.s`,
         CH4_umol_g_s = `CH4_flux_umol.g.s`,
         CO2C_cum_mg = `cumCO2.C..mg.`,
         CH4C_cum_mg = `cumCH4.C..mg.`,
         elapsed_min_bin = `ElapsedMin.BIN.`) %>% 
  mutate(CO2C_mg_g_s = CO2_umol_g_s*12/1000,
         CH4C_mg_g_s = CH4_umol_g_s*12/1000,) %>% 
  left_join(corekey, by = c("CORE"="Core")) %>% 
  dplyr::mutate(Homogenization = dplyr::recode(Homogenization, " Intact" = "Intact")) %>% 
  left_join(dplyr::select(coreweights, CORE, Homogenization, totalC_perc), by = c("CORE", "Homogenization")) %>% 
  mutate(CO2C_mg_gC_s = CO2C_mg_g_s*100/totalC_perc,
         CH4C_mg_gC_s = CH4C_mg_g_s*100/totalC_perc)


# summaries ---------------------------------------------------------------

## calculate summaries

flux_summary = 
  flux %>% 
  group_by(ID, CORE, Homogenization) %>% 
  summarise(mean_CO2C_mg_gC_s = round(mean(CO2C_mg_gC_s),2),
            cum_CO2C_mg = max(CO2C_cum_mg),
            mean_CH4C_mg_gC_s = round(mean(CH4C_mg_gC_s),2),
            cum_CH4C_mg = max(CH4C_cum_mg)) %>% 
  ungroup() %>% 
  left_join(coreweights, by = c("CORE", "Homogenization")) %>% 
  mutate(cum_CO2C_mg_g = round(cum_CO2C_mg/dry_wt_fine_g,2),
         cum_CO2C_mg_gC = round(cum_CO2C_mg_g*100/totalC_perc,2),
         cum_CH4C_mg_g = round(cum_CH4C_mg/dry_wt_fine_g,2),
         cum_CH4C_mg_gC = round(cum_CH4C_mg_g*100/totalC_perc,2)) %>% 
  dplyr::select(CORE, Homogenization, mean_CO2C_mg_gC_s, cum_CO2C_mg_gC, cum_CH4C_mg_g, cum_CH4C_mg_gC) %>% 
  left_join(corekey, by = c("CORE"="Core"))


#
# output ------------------------------------------------------------------

write.csv(flux, "data/processed/flux.csv", row.names = F)
write.csv(flux_summary, "data/processed/flux_summary.csv", row.names = F)



