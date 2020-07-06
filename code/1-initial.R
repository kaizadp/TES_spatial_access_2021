## SPATIAL ACCESS
## KAIZAD F. PATEL
## 2-JULY-2020

## INITIAL-PROCESSING

source("code/0-packages.R")

# corekey -----------------------------------------------------------------
fticr_key = read.csv("data/fticr_key.csv")

corekey = 
  fticr_key %>% 
  select(Core,  Soil_Moisture, Rewetting, Amendments) %>% 
  distinct() %>% 
  mutate(Moisture = recode(Soil_Moisture, "Field Moisture" = "fm", "Drought Induced" = "drought"),
         Wetting = recode(Rewetting, "precipitation" = "precip", "groundwater rise" = "groundw"),
         Assignment = paste0(Moisture, "-", Wetting, "-", Amendments)) %>% 
  select(Core, Moisture, Wetting, Amendments, Assignment) %>% 
  arrange(Core)

write.csv(corekey, "data/processed/corekey.csv", row.names = F)
