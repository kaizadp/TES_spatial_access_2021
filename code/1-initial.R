
# corekey -----------------------------------------------------------------

fticr_key = read.csv("data/fticr_key.csv")

corekey = 
  fticr_key %>% 
  select(Core,  Soil_Moisture, Rewetting, Amendments) %>% 
  distinct() %>% 
  arrange(Core)

write.csv(corekey, "data/processed/corekey.csv", row.names = F)
