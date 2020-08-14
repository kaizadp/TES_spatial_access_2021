flux\_drake\_plan
================

### HYPOTHESES

  - C amendments will increase CO2 flux
    
      - especially in cores wet from below

  - post-rewetting CO2 flush: drought \> fm for unamended soils, but
    drought \< fm for C-amended soils

  - N amendments will increase CO2 flux when wet from above

-----

## stats

<details>

<summary>stats</summary>

intact cores

    #> Anova Table (Type III tests)
    #> 
    #> Response: log(cum_CO2C_mg)
    #>                     Sum Sq Df  F value    Pr(>F)    
    #> (Intercept)         79.287  1 241.6145 < 2.2e-16 ***
    #> Moisture             3.510  1  10.6970  0.002369 ** 
    #> Amendments           4.212  2   6.4184  0.004131 ** 
    #> Wetting              0.119  1   0.3618  0.551283    
    #> Moisture:Amendments  3.729  2   5.6818  0.007169 ** 
    #> Moisture:Wetting     0.005  1   0.0152  0.902494    
    #> Amendments:Wetting   1.895  2   2.8874  0.068706 .  
    #> Residuals           11.814 36                       
    #> ---
    #> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

homogenized cores

    #> Anova Table (Type III tests)
    #> 
    #> Response: log(cum_CO2C_mg)
    #>                      Sum Sq Df  F value    Pr(>F)    
    #> (Intercept)         109.678  1 158.7171 9.264e-15 ***
    #> Moisture              0.140  1   0.2022  0.655667    
    #> Amendments            1.197  2   0.8662  0.429114    
    #> Wetting               0.598  1   0.8655  0.358398    
    #> Moisture:Amendments   4.970  2   3.5958  0.037692 *  
    #> Moisture:Wetting      2.431  1   3.5182  0.068825 .  
    #> Amendments:Wetting    7.521  2   5.4416  0.008613 ** 
    #> Residuals            24.877 36                       
    #> ---
    #> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

intact cores: interaction of Amendments and Moisture
![](markdown/flux/flux_interx_plot-1.png)<!-- -->

</details>

Homogenization:

  - interactive response with Amendment  
  - Homogenization increased respiration in the control soils  
  - Homogenization decreased respiration in the amended soils

For intact cores,

  - respiration was influenced by Moisture:Amendments
      - drought+rewetting increased flux for control soils only
      - for +C/+N amended soils, drought did not have a strong effect
  - C-amendments increased respiration in FM soils  
  - N-amendments increased respiration only in FM-precip soils

## graphs

![](markdown/flux/cum_flux_boxplot-1.png)<!-- -->

![](markdown/flux/cum_flux_ggplot-1.png)<!-- -->

![](markdown/flux/meanflux_ts-1.png)<!-- -->

<details>

<summary>time series by core</summary>

![](markdown/flux/corewise_flux-1.png)<!-- -->![](markdown/flux/corewise_flux-2.png)<!-- -->

</details>

## summary table

| Homogenization | Moisture | Wetting |    control     |        C        |       N        |
| :------------: | :------: | :-----: | :------------: | :-------------: | :------------: |
|     Intact     |    fm    | precip  |   52 ± 20.16   | 270.95 ± 103.11 | 244.8 ± 85.34  |
|     Intact     |    fm    | groundw | 100.22 ± 4.12  | 199.62 ± 57.58  |  85.92 ± 6.79  |
|     Intact     | drought  | precip  | 245.11 ± 17.38 | 125.07 ± 36.68  | 186.55 ± 49.75 |
|     Intact     | drought  | groundw | 161.18 ± 34.49 | 227.34 ± 32.09  | 119.25 ± 18.59 |
|  Homogenized   |    fm    | precip  | 108.62 ± 28.23 |  96.28 ± 34.16  | 99.67 ± 22.65  |
|  Homogenized   |    fm    | groundw | 118.74 ± 45.04 | 261.79 ± 51.91  | 107.47 ± 33.66 |
|  Homogenized   | drought  | precip  | 208.65 ± 41.69 |  35.29 ± 23.78  | 50.76 ± 19.67  |
|  Homogenized   | drought  | groundw | 201.98 ± 51.46 | 217.43 ± 60.18  | 177.38 ± 46.22 |

-----

#### Session Info

<details>

<summary>click to expand</summary>

Date run: 2020-08-14

    #> R version 4.0.2 (2020-06-22)
    #> Platform: x86_64-apple-darwin17.0 (64-bit)
    #> Running under: macOS Catalina 10.15.6
    #> 
    #> Matrix products: default
    #> BLAS:   /System/Library/Frameworks/Accelerate.framework/Versions/A/Frameworks/vecLib.framework/Versions/A/libBLAS.dylib
    #> LAPACK: /Library/Frameworks/R.framework/Versions/4.0/Resources/lib/libRlapack.dylib
    #> 
    #> locale:
    #> [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8
    #> 
    #> attached base packages:
    #> [1] stats     graphics  grDevices utils     datasets  methods   base     
    #> 
    #> other attached packages:
    #>  [1] drake_7.12.4    ggbiplot_0.55   PNWColors_0.1.0 forcats_0.5.0  
    #>  [5] stringr_1.4.0   dplyr_1.0.1     purrr_0.3.4     readr_1.3.1    
    #>  [9] tidyr_1.1.1     tibble_3.0.3    ggplot2_3.3.2   tidyverse_1.3.0
    #> 
    #> loaded via a namespace (and not attached):
    #>  [1] nlme_3.1-148       fs_1.5.0           lubridate_1.7.9   
    #>  [4] filelock_1.0.2     progress_1.2.2     httr_1.4.2        
    #>  [7] tools_4.0.2        backports_1.1.8    R6_2.4.1          
    #> [10] AlgDesign_1.2.0    mgcv_1.8-31        questionr_0.7.1   
    #> [13] DBI_1.1.0          colorspace_1.4-1   withr_2.2.0       
    #> [16] tidyselect_1.1.0   prettyunits_1.1.1  klaR_0.6-15       
    #> [19] curl_4.3           compiler_4.0.2     cli_2.0.2         
    #> [22] rvest_0.3.6        xml2_1.3.2         labeling_0.3      
    #> [25] scales_1.1.1       digest_0.6.25      foreign_0.8-80    
    #> [28] txtq_0.2.3         minqa_1.2.4        rmarkdown_2.3     
    #> [31] rio_0.5.16         pkgconfig_2.0.3    htmltools_0.5.0   
    #> [34] lme4_1.1-23        labelled_2.5.0     highr_0.8         
    #> [37] fastmap_1.0.1      dbplyr_1.4.4       rlang_0.4.7       
    #> [40] readxl_1.3.1       rstudioapi_0.11    shiny_1.5.0       
    #> [43] farver_2.0.3       generics_0.0.2     combinat_0.0-8    
    #> [46] jsonlite_1.7.0     zip_2.0.4          car_3.0-8         
    #> [49] magrittr_1.5       Matrix_1.2-18      Rcpp_1.0.5        
    #> [52] munsell_0.5.0      fansi_0.4.1        abind_1.4-5       
    #> [55] lifecycle_0.2.0    stringi_1.4.6      yaml_2.2.1        
    #> [58] carData_3.0-4      MASS_7.3-51.6      storr_1.2.1       
    #> [61] plyr_1.8.6         grid_4.0.2         blob_1.2.1        
    #> [64] promises_1.1.1     parallel_4.0.2     crayon_1.3.4      
    #> [67] miniUI_0.1.1.1     lattice_0.20-41    haven_2.3.1       
    #> [70] splines_4.0.2      hms_0.5.3          knitr_1.29        
    #> [73] pillar_1.4.6       igraph_1.2.5       boot_1.3-25       
    #> [76] base64url_1.4      soilpalettes_0.1.0 reprex_0.3.0      
    #> [79] glue_1.4.1         evaluate_0.14      agricolae_1.3-3   
    #> [82] data.table_1.13.0  modelr_0.1.8       httpuv_1.5.4      
    #> [85] vctrs_0.3.2        nloptr_1.2.2.2     cellranger_1.1.0  
    #> [88] gtable_0.3.0       assertthat_0.2.1   xfun_0.16         
    #> [91] openxlsx_4.1.5     mime_0.9           xtable_1.8-4      
    #> [94] broom_0.7.0        later_1.1.0.1      cluster_2.1.0     
    #> [97] statmod_1.4.34     ellipsis_0.3.1

</details>
