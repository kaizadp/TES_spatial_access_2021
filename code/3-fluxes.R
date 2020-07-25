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

## clean the flux data

flux = 
  fluxes_input %>% 
  select(ID, DATETIME, CORE, Homogenization, elapsed_minutes, `ElapsedMin.BIN.`,
         `CO2_flux_umol.g.s`, `CH4_flux_umol.g.s`, `cumCO2.C..mg.`) %>% 
  rename(CO2_umol_g_s = `CO2_flux_umol.g.s`,
         CH4_umol_g_s = `CH4_flux_umol.g.s`,
         CO2C_cum_mg = `cumCO2.C..mg.`,
         elapsed_min_bin = `ElapsedMin.BIN.`) %>% 
  mutate(CO2C_mg_g_s = CO2_umol_g_s*12/1000) %>% 
  left_join(corekey, by = c("CORE"="Core")) %>% 
  mutate(Homogenization = recode(Homogenization, " Intact" = "Intact"))


# summaries ---------------------------------------------------------------

## calculate summaries

flux_summary = 
  flux %>% 
  group_by(ID, CORE, Homogenization) %>% 
  summarise(mean_CO2_nmol_g_s = mean(CO2_umol_g_s*1000),
            cum_CO2C_mg = max(CO2C_cum_mg)) %>% 
  left_join(corekey, by = c("CORE"="Core"))

#
# cumulative evolution ----------------------------------------------------




#
# output ------------------------------------------------------------------

write.csv(flux, "data/processed/flux.csv", row.names = F)
write.csv(flux_summary, "data/processed/flux_summary.csv", row.names = F)



