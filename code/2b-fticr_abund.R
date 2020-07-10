## SPATIAL ACCESS
## KAIZAD F. PATEL
## 6-JULY-2020

## FTICR-RELATIVE-ABUNDANCE

source("code/0-packages.R")

# ------------------------------------------------------- ----

# I. LOAD FILES ----

fticr_data = read.csv("data/processed/fticr_long.csv.gz")
fticr_data_key = read.csv("data/processed/fticr_long_key.csv.gz")
fticr_meta = read.csv("data/processed/fticr_meta.csv")

#
# II. RELATIVE ABUNDANCE ----
## IIa. calculate relative abundance of classes in each core 
relabund_cores = 
  fticr_data_key %>% 
  # add the Class column to the data
  left_join(dplyr::select(fticr_meta, formula, class), by = "formula") %>% 
  # calculate abundance of each Class as the sum of all counts
  group_by(Core, SampleAssignment, Moisture, Wetting, Suction, Homogenization, Amendments, class) %>%       #$$$$#
  dplyr::summarise(abund = sum(presence)) %>%
  filter(!is.na(class)) %>% 
  ungroup %>% 
  # create a new column for total counts per core assignment
  # and then calculate relative abundance  
  group_by(Core, SampleAssignment) %>%      #$$$$#
  dplyr::mutate(total = sum(abund),
                relabund  = round((abund/total)*100,2))

## IIb. calculate mean relative abundance across all replicates of the treatments
relabund_trt = 
  relabund_cores %>% 
  group_by(SampleAssignment, Moisture, Wetting, Suction, Homogenization, Amendments, class) %>%       #$$$$#
  dplyr::summarize(rel_abund = round(mean(relabund),2),
                   se  = round((sd(relabund/sqrt(n()))),2),
                   relative_abundance = paste(rel_abund, "\u00b1",se))


# IV. OUTPUT ----
write.csv(relabund_cores, "data/processed/fticr_relabund_cores.csv", row.names=FALSE)
write.csv(relabund_trt, "data/processed/fticr_relabund_trt.csv", row.names=FALSE)




