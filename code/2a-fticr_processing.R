## SPATIAL ACCESS
## KAIZAD F. PATEL
## 2-JULY-2020

## FTICR-PROCESSING

source("code/0-packages.R")
library(drake)

fticr_processing_plan = drake_plan(
  # load files --------------------------------------------------------------
  fticr_data = read.csv(file_in("data/SpatAccess_eData.csv")),
  fticr_meta = read.csv(file_in("data/SpatAccess_eMeta.csv")),
  #report = read.csv("data/SpatAccess_dwp14_FTICR_Report.csv")
  fticr_key = read.csv(file_in("data/fticr_key.csv")),
  
  # ---
  # fticr_report  =
  #   report %>% 
  #   # filter appropriate mass range
  #   filter(Mass>200 & Mass<900) %>% 
  #   # remove isotopes
  #   filter(C13==0) %>% 
  #   # remove peaks without C assignment
  #   filter(C>0)
  # ---
  
  classes = read.csv(file_in("data/fticr_meta_classes.csv")),
  
  
  # fticr_key -----------------------------------------------------------------
  fticr_key_cleaned =
    fticr_key %>% 
    mutate(Moisture = recode(Soil_Moisture, "Field Moisture" = "fm", "Drought Induced" = "drought"),
           Wetting = recode(Rewetting, "precipitation" = "precip", "groundwater rise" = "groundw"),
           SampleAssignment = paste0(Suction, "-", Moisture, "-", Wetting, "-", Amendments, "-", Homogenization)) %>% 
    select(FTICR_ID, Core, Suction, Moisture, Wetting, Amendments, Homogenization, SampleAssignment),
  
  #
  # fticr_meta ---------------------------------------------------------
  meta = 
    fticr_meta %>% 
    # filter appropriate mass range
    filter(Mass>200 & Mass<900) %>% 
    # remove isotopes
    filter(C13==0) %>% 
    # remove peaks without C assignment
    filter(C>0) %>% 
    #  left_join(classes, by = "Mass")
    
    # create columns for indices
    dplyr::mutate(AImod = round((1+C-(0.5*O)-S-(0.5*(N+P+H)))/(C-(0.5*O)-S-N-P),4),
                  NOSC =  round(4-(((4*C)+H-(3*N)-(2*O)-(2*S))/C),4),
                  HC = round(H/C,2),
                  OC = round(O/C,2)) %>% 
    
    # create column/s for formula
    # first, create columns for individual elements
    # then, combine
    dplyr::mutate(formula_c = if_else(C>0,paste0("C",C),as.character(NA)),
                  formula_h = if_else(H>0,paste0("H",H),as.character(NA)),
                  formula_o = if_else(O>0,paste0("O",O),as.character(NA)),
                  formula_n = if_else(N>0,paste0("N",N),as.character(NA)),
                  formula_s = if_else(S>0,paste0("S",S),as.character(NA)),
                  formula_p = if_else(P>0,paste0("P",P),as.character(NA)),
                  formula = paste0(formula_c,formula_h, formula_o, formula_n, formula_s, formula_p),
                  formula = str_replace_all(formula,"NA","")) %>% 
    
    # elemental composition (CHONS, etc)
    # create column/s for formula
    dplyr::mutate(element_c = if_else(C>0,paste0("C"),as.character(NA)),
                  element_h = if_else(H>0,paste0("H"),as.character(NA)),
                  element_o = if_else(O>0,paste0("O"),as.character(NA)),
                  element_n = if_else(N>0,paste0("N"),as.character(NA)),
                  element_s = if_else(S>0,paste0("S"),as.character(NA)),
                  element_p = if_else(P>0,paste0("P"),as.character(NA)),
                  element_comp = paste0(element_c,element_h, element_o, element_n, element_s, element_p),
                  element_comp = str_replace_all(element_comp,"NA","")) %>%
    
    #  dplyr::select(Mass, formula, El_comp, Class, HC, OC, AImod, NOSC, C:P)
    
    # assign compound classes
    mutate(
      class = case_when(AImod > 0.66 ~ "condensed_arom",
                        AImod <=0.66 & AImod >= 0.50 ~ "aromatic",
                        AImod < 0.50 & HC < 1.5 ~ "unsaturated/lignin",
                        HC >= 1.5 & N==0 ~ "aliphatic",
                        HC >= 1.5 & N>0 ~ "aliphatic",
                        HC >= 2 ~ "aliphatic"),
      
      # old classes
      #    class = case_when(HC >= 1.5 & HC < 2.0 & N==0 & OC < 0.9 ~ "aliphatic",
      #                      HC >= 1.5 & HC < 2.0 & N>0 & OC < 0.9 ~ "aliphatic+N",
      #                      HC >= 2 | OC >= 0.9 ~ "saturated",
      #                      AImod > 0.66 ~ "condensed_arom",
      #                      AImod <=0.66 & AImod >= 0.50 ~ "aromatic",
      #                      AImod < 0.50 & HC < 1.5 ~ "unsaturated/lignin"
      #                      ),
      
      # class_vk = case_when((OC>0 & OC <= 0.3 & HC >= 1.5 & HC <= 2.5)~"lipid",
      #                        (0 <= OC & OC <= 0.125 & 0.8 <= HC & HC <= 2.5) ~ "unsat_hc",
      #                        (0.3 < OC & OC <= 0.55 & 1.5 <= HC & HC <= 2.3) ~ "protein",
      #                        (0.55 < OC & OC <= 0.7 & 1.5 <= HC & HC <= 2.2) ~ "amino_sugar",
      #                        (0.7 < OC & OC <= 1.5 & 1.5 <= HC & HC <= 2.5) ~ "carbohydrate",
      #                        (0.125 < OC & OC <= 0.65 & 0.8 <= HC & HC < 1.5) ~ "lignin",
      #                        (0.65 < OC & OC <= 1.1 & 0.8 <= HC & HC < 1.5) ~ "tannin",
      #                        (0 <= OC & OC <= 0.95 & 0.2 <= HC & HC < 0.8) ~ "condensed_hc"),
      
      class = if_else(is.na(class)&!is.na(formula), "other", class)) %>%
    filter(!class=="other") %>% 
    
    # select only required columns
    dplyr::select(Mass, formula, element_comp, class, HC, OC, AImod, NOSC, C:P, -C13),
  
  mass_list = 
    meta %>% pull(Mass),
  
  #
  # fticr_data --------------------------------------------------------------------
  data_long = 
    fticr_data %>% 
    filter(Mass %in% mass_list) %>% 
    select(-NeutralMass, -ErrorPPM, -Candidates) %>% 
    pivot_longer(-Mass,
                 names_to = "FTICR_ID",
                 values_to = "intensity") %>% 
    mutate(presence = if_else(intensity>0, 1, 0)) %>% 
    filter(presence==1) %>% 
    # add the molecular formula column
    left_join(select(meta, Mass, formula), by = "Mass") %>% 
    # some formulae have multiple m/z. drop the multiples
    distinct(FTICR_ID, formula, presence), 
  
  data_long_key =
    data_long %>% 
    left_join(fticr_key_cleaned, by = "FTICR_ID") %>%
    filter(!Suction==15) %>% 
    na.omit() %>% 
    group_by(SampleAssignment, formula) %>% 
    mutate(n = n()) %>% 
    filter(n>1),
  
  data_long_trt = 
    data_long_key %>% 
    group_by(SampleAssignment, Suction, Homogenization, Moisture, Wetting, Amendments) %>% 
    distinct(formula, presence),
  
  #
  # gg_vankrev(meta, aes(x = OC, y = HC, color = class))
  
  
  meta_hcoc = 
    meta %>% 
    select(formula, HC, OC),
  
  #
  # outputs -----------------------------------------------------------------
  #write.csv(data_long, "data/processed/fticr_long.csv", row.names = F)
  #write.csv(data_long_key, "data/processed/fticr_long_key.csv", row.names = F)
  write.csv(meta, "data/processed/fticr_meta.csv", row.names = F),
  write.csv(fticr_key_cleaned, "data/processed/fticr_key.csv", row.names = F),
  crunch::write.csv.gz(data_long, "data/processed/fticr_long_core.csv.gz", row.names = F, na=""),
  crunch::write.csv.gz(data_long_key, "data/processed/fticr_long_key.csv.gz", row.names = F, na=""),
  crunch::write.csv.gz(data_long_trt, "data/processed/fticr_long_trt.csv.gz", row.names = F, na="")
  
  # -----------------------------------------------------------------
)

make(fticr_processing_plan)
