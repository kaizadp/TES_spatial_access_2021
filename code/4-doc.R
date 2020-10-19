## SPATIAL ACCESS
## KAIZAD F. PATEL
## 2-JULY-2020

## DOC-PROCESSING

source("code/0-packages.R")

## need core weights

# load files --------------------------------------------------------------

data = read.csv("data/doc.csv")
corekey = read.csv("data/processed/corekey.csv")
coreweights = read.csv("data/core_weights.csv") %>% 
  dplyr::select(CORE, Homogenization, dry_wt_fine_g, totalC_perc)

## clean the doc file
doc = 
  data %>% 
  pivot_longer(-c(CORE,Homogenization)) %>% 
  dplyr::mutate(Homogenization = dplyr::recode(Homogenization, " Intact" = "Intact")) %>% 
  mutate(Suction = case_when(grepl("1.5kPa", name)~"1.5",
                             grepl("15kPa", name)~"15",
                             grepl("50kPa", name)~"50"),
         variable = case_when(grepl("DOC", name)~"DOC_mg_L",
                              grepl("DN", name)~"DN_mg_L",
                              grepl("_ml", name)~"porewater_mL")) %>% 
  select(-name) %>% 
  spread(variable, value) %>% 
  left_join(coreweights, by = c("CORE", "Homogenization")) %>% 
  mutate(DOC_ng_g = round((DOC_mg_L * porewater_mL/dry_wt_fine_g),2),
         DOC_ng_gC = round(DOC_ng_g * 100/totalC_perc,2),
         DOC_ug_gC = round(DOC_ng_gC/1000,3)) %>% 
  left_join(corekey, by = c("CORE"="Core")) %>% 
  filter(!is.na(DOC_ng_g)) %>% 
  dplyr::select(CORE, Homogenization, Suction, Moisture, Wetting, Amendments, DOC_mg_L, DOC_ug_gC)


# output ------------------------------------------------------------------

write.csv(doc, "data/processed/doc.csv", row.names = F)





