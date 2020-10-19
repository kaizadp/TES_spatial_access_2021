doc\_report
================

    #> $gg_doc_boxplot_suctions_combined

![](markdown-figs/doc/doc_boxplot4-1.png)<!-- -->

full core

![](markdown-figs/doc/doc_boxplot_intact-1.png)<!-- -->

![](markdown-figs/doc/doc_boxplot_homo-1.png)<!-- -->

## what influenced DOC?

DOC was influenced by:

  - Amendments
  - Homogenization:Amendments
  - Moisture:Amendments
  - Wetting: Amendments

DOC in **intact** cores was influenced by:  
1\. Amendments  
2\. Moisture

DOC in **homogenized** cores was influenced by:  
1\. Amendments  
2\. Moisture  
3\. Suction

<details>

<summary>click for stats</summary>

overall ANOVA

    #> Analysis of Deviance Table (Type III Wald chisquare tests)
    #> 
    #> Response: log(DOC_ug_gC)
    #>                              Chisq Df Pr(>Chisq)    
    #> (Intercept)                 8.1213  1  0.0043748 ** 
    #> Homogenization              6.8380  1  0.0089238 ** 
    #> Moisture                    6.0477  1  0.0139245 *  
    #> Wetting                     1.0524  1  0.3049538    
    #> Amendments                196.8836  2  < 2.2e-16 ***
    #> Homogenization:Moisture     5.1632  1  0.0230703 *  
    #> Homogenization:Wetting      0.4417  1  0.5062850    
    #> Homogenization:Amendments 107.7626  2  < 2.2e-16 ***
    #> Moisture:Wetting            1.0350  1  0.3089952    
    #> Moisture:Amendments        14.0543  2  0.0008875 ***
    #> Wetting:Amendments          0.8482  2  0.6543606    
    #> ---
    #> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

intact cores

    #> Anova Table (Type III tests)
    #> 
    #> Response: log(DOC_ug_gC)
    #>                      Sum Sq Df  F value    Pr(>F)    
    #> (Intercept)           8.114  1   8.6378  0.005717 ** 
    #> Moisture              1.583  1   1.6856  0.202441    
    #> Amendments          204.809  2 109.0199 5.311e-16 ***
    #> Wetting               0.017  1   0.0184  0.892995    
    #> Moisture:Amendments   1.380  2   0.7343  0.486878    
    #> Moisture:Wetting      0.000  1   0.0001  0.994395    
    #> Amendments:Wetting    2.163  2   1.1516  0.327498    
    #> Residuals            33.815 36                       
    #> ---
    #> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

homogenized cores

    #> [1] NA

</details>

**how did amendments influence DOC?**

C addition increased DOC  
N addition decreased DOC - *N stimulated consumption of DOC?*

-----

how much DOC was added as part of the amendment?

5 mL of 10.1 M acetate (CH3-COO-K)  
1 mole acetate = 2 mole C

10.1 M acetate = 20.2 M C = (20.2 \* 12) g/L C  
5 mL of 10.1 M acetate = 0.005 L \* 20.2 \* 12 g/L C = 1.212 g C

-----

#### Session Info

<details>

<summary>click to expand</summary>

Date run: 2020-10-19

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
    #>  [1] patchwork_1.0.1 car_3.0-9       carData_3.0-4   drake_7.12.4   
    #>  [5] ggbiplot_0.55   PNWColors_0.1.0 forcats_0.5.0   stringr_1.4.0  
    #>  [9] dplyr_1.0.1     purrr_0.3.4     readr_1.3.1     tidyr_1.1.1    
    #> [13] tibble_3.0.3    ggplot2_3.3.2   tidyverse_1.3.0
    #> 
    #> loaded via a namespace (and not attached):
    #>  [1] minqa_1.2.4        colorspace_1.4-1   ellipsis_0.3.1    
    #>  [4] rio_0.5.16         fs_1.5.0           rstudioapi_0.11   
    #>  [7] farver_2.0.3       soilpalettes_0.1.0 fansi_0.4.1       
    #> [10] lubridate_1.7.9    xml2_1.3.2         splines_4.0.2     
    #> [13] knitr_1.29         jsonlite_1.7.0     nloptr_1.2.2.2    
    #> [16] packrat_0.5.0      broom_0.7.0        cluster_2.1.0     
    #> [19] dbplyr_1.4.4       shiny_1.5.0        compiler_4.0.2    
    #> [22] httr_1.4.2         backports_1.1.8    assertthat_0.2.1  
    #> [25] Matrix_1.2-18      fastmap_1.0.1      cli_2.0.2         
    #> [28] later_1.1.0.1      htmltools_0.5.0    prettyunits_1.1.1 
    #> [31] tools_4.0.2        igraph_1.2.5       gtable_0.3.0      
    #> [34] agricolae_1.3-3    glue_1.4.1         Rcpp_1.0.5        
    #> [37] cellranger_1.1.0   vctrs_0.3.2        nlme_3.1-148      
    #> [40] xfun_0.16          openxlsx_4.1.5     lme4_1.1-23       
    #> [43] rvest_0.3.6        mime_0.9           miniUI_0.1.1.1    
    #> [46] lifecycle_0.2.0    statmod_1.4.34     MASS_7.3-51.6     
    #> [49] scales_1.1.1       hms_0.5.3          promises_1.1.1    
    #> [52] parallel_4.0.2     yaml_2.2.1         curl_4.3          
    #> [55] labelled_2.5.0     stringi_1.4.6      highr_0.8         
    #> [58] klaR_0.6-15        AlgDesign_1.2.0    filelock_1.0.2    
    #> [61] boot_1.3-25        zip_2.1.0          storr_1.2.1       
    #> [64] rlang_0.4.7        pkgconfig_2.0.3    evaluate_0.14     
    #> [67] lattice_0.20-41    labeling_0.3       tidyselect_1.1.0  
    #> [70] plyr_1.8.6         magrittr_1.5       R6_2.4.1          
    #> [73] generics_0.0.2     base64url_1.4      combinat_0.0-8    
    #> [76] txtq_0.2.3         DBI_1.1.0          pillar_1.4.6      
    #> [79] haven_2.3.1        foreign_0.8-80     withr_2.2.0       
    #> [82] abind_1.4-5        modelr_0.1.8       crayon_1.3.4      
    #> [85] questionr_0.7.1    rmarkdown_2.3      progress_1.2.2    
    #> [88] grid_4.0.2         readxl_1.3.1       data.table_1.13.0 
    #> [91] blob_1.2.1         reprex_0.3.0       digest_0.6.25     
    #> [94] xtable_1.8-4       httpuv_1.5.4       munsell_0.5.0

</details>
