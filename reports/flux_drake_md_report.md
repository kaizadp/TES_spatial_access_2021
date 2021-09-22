flux\_drake\_plan
================

### HYPOTHESES

-   C amendments will increase CO2 flux

    -   especially in cores wet from below

-   post-rewetting CO2 flush: drought &gt; fm for unamended soils, but
    drought &lt; fm for C-amended soils

-   N amendments will increase CO2 flux when wet from above

------------------------------------------------------------------------

## stats

<details>
<summary>
stats
</summary>

intact cores

    #> Analysis of Deviance Table (Type III Wald chisquare tests)
    #> 
    #> Response: log(cum_CO2C_mg_gC)
    #>                              Chisq Df Pr(>Chisq)    
    #> (Intercept)               271.9808  1  < 2.2e-16 ***
    #> Homogenization              1.6284  1  0.2019312    
    #> Moisture                   11.6195  1  0.0006526 ***
    #> Wetting                     3.5209  1  0.0605982 .  
    #> Amendments                  8.0665  2  0.0177166 *  
    #> Homogenization:Moisture     6.3080  1  0.0120194 *  
    #> Homogenization:Wetting      9.7214  1  0.0018213 ** 
    #> Homogenization:Amendments  12.3807  2  0.0020491 ** 
    #> Moisture:Wetting            1.7002  1  0.1922639    
    #> Moisture:Amendments        17.2625  2  0.0001784 ***
    #> Wetting:Amendments          8.8564  2  0.0119359 *  
    #> ---
    #> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    #> Anova Table (Type III tests)
    #> 
    #> Response: log(cum_CO2C_mg_gC)
    #>                     Sum Sq Df  F value    Pr(>F)    
    #> (Intercept)         85.617  1 257.9917 < 2.2e-16 ***
    #> Moisture             6.033  1  18.1805 0.0001386 ***
    #> Amendments           6.755  2  10.1777 0.0003138 ***
    #> Wetting              0.113  1   0.3400 0.5634526    
    #> Moisture:Amendments  4.697  2   7.0770 0.0025583 ** 
    #> Moisture:Wetting     0.009  1   0.0263 0.8719919    
    #> Amendments:Wetting   1.768  2   2.6644 0.0833505 .  
    #> Residuals           11.947 36                       
    #> ---
    #> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

homogenized cores

    #> [1] NA

intact cores: interaction of Amendments and Moisture
![](markdown-figs/flux/flux_interx_plot-1.png)<!-- -->![](markdown-figs/flux/flux_interx_plot-2.png)<!-- -->![](markdown-figs/flux/flux_interx_plot-3.png)<!-- -->

</details>

Homogenization:

-   interactive response with Amendment  
-   Homogenization increased respiration in the control soils  
-   Homogenization decreased respiration in the amended soils

For intact cores,

-   respiration was influenced by Moisture:Amendments
    -   drought+rewetting increased flux for control soils only
    -   for +C/+N amended soils, drought did not have a strong effect
-   C-amendments increased respiration in FM soils  
-   N-amendments increased respiration only in FM-precip soils

## graphs

![](markdown-figs/flux/cum_flux_boxplot_homo-1.png)<!-- -->

![](markdown-figs/flux/flux_combined-1.png)<!-- -->

![](markdown-figs/flux/flux_ts-1.png)<!-- -->

-   drought increased respiration only in control soils
    -   microbes limited by substrate as well as N, which were released
        during drought?
    -   the C/N amendments alleviated these limitations, and therefore
        drought did not alter mineralization
-   in the drought soils, precip had more min than groundw, but only in
    control soils
    -   possibly because there was more C available in the top 3 cm,
        which stimulated respiration when rewet.
    -   but when we consider all the amendments, this effect of wetting
        direction is lost
-   fm soils, on the other hand, showed greater response to amendments
    -   possibly because less C was available, and therefore microbes
        were more limited
    -   N??

<!-- -->

    #> [1] NA

    #> $gg_flux_ts

![](markdown-figs/flux/meanflux_ts-1.png)<!-- -->

<details>
<summary>
time series by core
</summary>

    #> [1] NA
    #> [1] NA

</details>

## summary table

cumulative CO2-C, mgC/g C

| Homogenization | Moisture | Wetting | control         | C               | N              |
|:---------------|:---------|:--------|:----------------|:----------------|:---------------|
| Intact         | fm       | precip  | 73.18 ± 32.93   | 460.58 ± 183.17 | 303.24 ± 82.36 |
| Intact         | fm       | groundw | 115.36 ± 26.67  | 268.21 ± 47.75  | 147.65 ± 40.97 |
| Intact         | drought  | precip  | 370.13 ± 28.76  | 235.6 ± 29.9    | 333.8 ± 58.3   |
| Intact         | drought  | groundw | 284.85 ± 62.71  | 368.72 ± 46.64  | 184.42 ± 37.1  |
| Homogenized    | fm       | precip  | 246.75 ± 60.14  | 181.4 ± 61.43   | 150.26 ± 16.35 |
| Homogenized    | fm       | groundw | 229.07 ± 99.94  | 434.82 ± 56.78  | 247.68 ± 98.32 |
| Homogenized    | drought  | precip  | 330.66 ± 62.16  | 47.29 ± 23.88   | 96.38 ± 32.15  |
| Homogenized    | drought  | groundw | 360.16 ± 103.62 | 311.76 ± 78.33  | 257.53 ± 51.06 |

------------------------------------------------------------------------

#### Session Info

<details>
<summary>
click to expand
</summary>

Date run: 2021-06-08

    #> R version 4.0.2 (2020-06-22)
    #> Platform: x86_64-apple-darwin17.0 (64-bit)
    #> Running under: macOS Catalina 10.15.7
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
    #>  [1] lme4_1.1-26     Matrix_1.3-2    drake_7.13.1    ggbiplot_0.55   PNWColors_0.1.0
    #>  [6] forcats_0.5.1   stringr_1.4.0   dplyr_1.0.6     purrr_0.3.4     readr_1.4.0    
    #> [11] tidyr_1.1.3     tibble_3.1.2    ggplot2_3.3.3   tidyverse_1.3.1
    #> 
    #> loaded via a namespace (and not attached):
    #>   [1] minqa_1.2.4        colorspace_2.0-0   ggsignif_0.6.0     ellipsis_0.3.2    
    #>   [5] class_7.3-18       rio_0.5.16         fs_1.5.0           gld_2.6.2         
    #>   [9] crunch_1.27.5      rstudioapi_0.13    farver_2.0.3       ggpubr_0.4.0      
    #>  [13] soilpalettes_0.1.0 fansi_0.4.2        mvtnorm_1.1-1      lubridate_1.7.10  
    #>  [17] xml2_1.3.2         splines_4.0.2      rootSolve_1.8.2.1  knitr_1.31        
    #>  [21] jsonlite_1.7.2     nloptr_1.2.2.2     broom_0.7.6        cluster_2.1.0     
    #>  [25] dbplyr_2.1.1       shiny_1.6.0        compiler_4.0.2     httr_1.4.2        
    #>  [29] backports_1.2.1    fastmap_1.1.0      assertthat_0.2.1   cli_2.5.0         
    #>  [33] later_1.1.0.1      htmltools_0.5.1.1  prettyunits_1.1.1  tools_4.0.2       
    #>  [37] igraph_1.2.6       gtable_0.3.0       agricolae_1.3-3    glue_1.4.2        
    #>  [41] lmom_2.8           tinytex_0.29       Rcpp_1.0.6         carData_3.0-4     
    #>  [45] cellranger_1.1.0   vctrs_0.3.8        nlme_3.1-152       xfun_0.20         
    #>  [49] openxlsx_4.2.3     rvest_1.0.0        mime_0.9           miniUI_0.1.1.1    
    #>  [53] lifecycle_1.0.0    statmod_1.4.35     rstatix_0.6.0      MASS_7.3-53       
    #>  [57] scales_1.1.1       promises_1.1.1     hms_1.0.0          parallel_4.0.2    
    #>  [61] httpcache_1.2.0    expm_0.999-6       yaml_2.2.1         curl_4.3          
    #>  [65] Exact_2.1          labelled_2.7.0     stringi_1.5.3      AlgDesign_1.2.0   
    #>  [69] highr_0.8          klaR_0.6-15        e1071_1.7-4        filelock_1.0.2    
    #>  [73] boot_1.3-26        zip_2.1.1          storr_1.2.5        rlang_0.4.10      
    #>  [77] pkgconfig_2.0.3    evaluate_0.14      lattice_0.20-41    labeling_0.4.2    
    #>  [81] cowplot_1.1.1      tidyselect_1.1.0   plyr_1.8.6         magrittr_2.0.1    
    #>  [85] R6_2.5.0           DescTools_0.99.40  generics_0.1.0     base64url_1.4     
    #>  [89] combinat_0.0-8     txtq_0.2.3         DBI_1.1.1          mgcv_1.8-33       
    #>  [93] pillar_1.6.1       haven_2.3.1        foreign_0.8-81     withr_2.4.1       
    #>  [97] abind_1.4-5        questionr_0.7.4    modelr_0.1.8       crayon_1.4.1      
    #> [101] car_3.0-10         utf8_1.1.4         rmarkdown_2.6.6    progress_1.2.2    
    #> [105] grid_4.0.2         readxl_1.3.1       data.table_1.13.6  reprex_2.0.0      
    #> [109] digest_0.6.27      xtable_1.8-4       httpuv_1.5.5       munsell_0.5.0

</details>
