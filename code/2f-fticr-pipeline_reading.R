# File reading for various pipeline targets

read_fticr_key <- function(fn) {
  read.csv(file_in(fn)) %>% 
    distinct(SampleAssignment, Moisture, Wetting, Amendments, Suction, Homogenization)
}

read_fticr_file <- function(fn) {
  read.csv(file_in(fn)) %>% 
    filter(!Suction=="15") %>% 
    dplyr::mutate(
      Homogenization = factor(Homogenization, levels = c("Intact", "Homogenized")),
      Amendments = factor(Amendments, levels = c("control", "C", "N")),
      Moisture = factor(Moisture, levels = c("fm", "drought")),
      Wetting = factor(Wetting, levels = c("precip", "groundw")))
}


read_fticr_file_classes <- function(fn) {
  read.csv(file_in(fn)) %>% 
    filter(!Suction=="15") %>% 
    dplyr::mutate(
      class = factor(class, levels = 
                       c("aliphatic","unsaturated/lignin","aromatic","condensed_arom")),
      Amendments = factor(Amendments, levels = c("control", "C", "N")),
      Homogenization = factor(Homogenization, levels = c("Intact", "Homogenized")),
      Moisture = factor(Moisture, levels = c("fm", "drought")),
      Wetting = factor(Wetting, levels = c("precip", "groundw")))
}




# old read functions ------------------------------------------------------

    ## 
    ## read_data_key <- function(fn) {
    ##   read.csv(file_in(fn)) %>%
    ##     mutate(Homogenization = factor(Homogenization, levels = c("Intact", "Homogenized")),
    ##            Amendments = factor(Amendments, levels = c("control", "C", "N")),
    ##            Moisture = factor(Moisture, levels = c("fm", "drought")),
    ##            Wetting = factor(Wetting, levels = c("precip", "groundw")))
    ## }
    ## 
    ## read_data_long_trt <- function(fn) {
    ##   read.csv(file_in(fn)) %>% 
    ##     mutate(Homogenization = factor(Homogenization, levels = c("Intact", "Homogenized")),
    ##            Amendments = factor(Amendments, levels = c("control", "C", "N")),
    ##            Moisture = factor(Moisture, levels = c("fm", "drought")),
    ##            Wetting = factor(Wetting, levels = c("precip", "groundw")))
    ## }
    ## 
    ## read_relabund_trt <- function(fn) {
    ##   
    ##   read.csv(file_in(fn)) %>% 
    ##     filter(!Suction=="15") %>% 
    ##     dplyr::mutate(
    ##       class = factor(class, levels = 
    ##                        c("aliphatic", "unsaturated/lignin",
    ##                          "aromatic","condensed_arom")),
    ##       Amendments = factor(Amendments, levels = c("control", "C", "N")),
    ##       Homogenization = factor(Homogenization, levels = c("Intact", "Homogenized")),
    ##       Moisture = factor(Moisture, levels = c("fm", "drought")))
    ## }
    ## 
    ## read_relabund_cores <- function(fn) {
    ##   read.csv(file_in(fn)) %>% 
    ##     filter(!Suction=="15") %>% 
    ##     dplyr::mutate(
    ##       class = factor(class, levels = 
    ##                        c("aliphatic","unsaturated/lignin","aromatic","condensed_arom")),
    ##       Amendments = factor(Amendments, levels = c("control", "C", "N")),
    ##       Homogenization = factor(Homogenization, levels = c("Intact", "Homogenized")),
    ##       Moisture = factor(Moisture, levels = c("fm", "drought")))
    ## }
    ## 


