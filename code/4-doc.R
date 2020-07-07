## SPATIAL ACCESS
## KAIZAD F. PATEL
## 2-JULY-2020

## DOC-PROCESSING

source("code/0-packages.R")


# load files --------------------------------------------------------------

data = read.csv("data/doc.csv")
corekey = read.csv("data/processed/corekey.csv")

## clean the doc file
doc = 
  data %>% 
  pivot_longer(-c(CORE,Homogenization)) %>% 
  mutate(Homogenization = recode(Homogenization, " Intact" = "Intact")) %>% 
  mutate(Suction = case_when(grepl("1.5kPa", name)~"1.5",
                             grepl("15kPa", name)~"15",
                             grepl("50kPa", name)~"50"),
         variable = case_when(grepl("DOC", name)~"DOC_mg_L",
                              grepl("DN", name)~"DN_mg_L",
                              grepl("_ml", name)~"porewater_mL")) %>% 
  select(-name) %>% 
  spread(variable, value) %>% 
  mutate(DOC_mg = round(DOC_mg_L * porewater_mL/1000,2)) %>% 
  left_join(corekey, by = c("CORE"="Core"))


# output ------------------------------------------------------------------

write.csv(doc, "data/processed/doc.csv", row.names = F)





