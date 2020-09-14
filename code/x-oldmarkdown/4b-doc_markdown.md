Spatial Access – DOC
================

![](markdown/doc/doc_graph-1.png)<!-- -->![](markdown/doc/doc_graph-2.png)<!-- -->![](markdown/doc/doc_graph-3.png)<!-- -->

-----

**what influenced DOC?**

    #> Anova Table (Type III tests)
    #> 
    #> Response: (DOC_ng_g)
    #>                            Sum Sq  Df F value    Pr(>F)    
    #> (Intercept)                 27016   1  0.5540   0.45786    
    #> Homogenization               2880   1  0.0591   0.80832    
    #> Suction                     26023   1  0.5336   0.46622    
    #> Moisture                   181596   1  3.7238   0.05553 .  
    #> Wetting                      2463   1  0.0505   0.82250    
    #> Amendments                4276677   2 43.8491 1.011e-15 ***
    #> Homogenization:Suction     139077   1  2.8519   0.09334 .  
    #> Homogenization:Moisture     88448   1  1.8137   0.18009    
    #> Homogenization:Wetting      32370   1  0.6638   0.41652    
    #> Homogenization:Amendments 4709620   2 48.2881 < 2.2e-16 ***
    #> Suction:Moisture           127599   1  2.6166   0.10785    
    #> Suction:Wetting             74563   1  1.5290   0.21820    
    #> Suction:Amendments         224976   2  2.3067   0.10311    
    #> Moisture:Wetting            37310   1  0.7651   0.38314    
    #> Moisture:Amendments        423724   2  4.3445   0.01465 *  
    #> Wetting:Amendments         330851   2  3.3922   0.03623 *  
    #> Residuals                 7314884 150                      
    #> ---
    #> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

DOC in **intact** cores was influenced by:  
1\. Amendments  
2\. Moisture

DOC in **homogenized** cores was influenced by:  
1\. Amendments  
2\. Moisture  
3\. Suction

<details>

<summary> </summary>

``` r
Anova(lm(DOC_ng_g ~ (Amendments+Suction+Moisture+Wetting)^2,
              data = doc %>% filter(Homogenization=="Intact")))
#> Anova Table (Type II tests)
#> 
#> Response: DOC_ng_g
#>                      Sum Sq Df F value    Pr(>F)    
#> Amendments          8587607  2 54.1738 7.175e-15 ***
#> Suction              189598  1  2.3921  0.126524    
#> Moisture             586255  1  7.3966  0.008260 ** 
#> Wetting              272573  1  3.4390  0.067949 .  
#> Amendments:Suction   315585  2  1.9908  0.144351    
#> Amendments:Moisture  796557  2  5.0250  0.009177 ** 
#> Amendments:Wetting   475696  2  3.0009  0.056277 .  
#> Suction:Moisture     472656  1  5.9634  0.017173 *  
#> Suction:Wetting       56533  1  0.7133  0.401282    
#> Moisture:Wetting      20242  1  0.2554  0.614916    
#> Residuals           5468924 69                      
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

summary(aov(DOC_ng_g ~ (Amendments+Suction+Moisture+Wetting)^2,
              data = doc %>% filter(Homogenization=="Homogenized")))
#>                     Df Sum Sq Mean Sq F value   Pr(>F)    
#> Amendments           2  78110   39055   5.622 0.005384 ** 
#> Suction              1  31703   31703   4.564 0.036051 *  
#> Moisture             1  43263   43263   6.228 0.014865 *  
#> Wetting              1   5883    5883   0.847 0.360514    
#> Amendments:Suction   2  21349   10674   1.537 0.222060    
#> Amendments:Moisture  2 136712   68356   9.841 0.000167 ***
#> Amendments:Wetting   2   5523    2762   0.398 0.673421    
#> Suction:Moisture     1   3179    3179   0.458 0.500888    
#> Suction:Wetting      1   1834    1834   0.264 0.608931    
#> Moisture:Wetting     1      1       1   0.000 0.989646    
#> Residuals           72 500132    6946                     
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

</details>

**how did amendments influence DOC?**

C addition increased DOC  
N addition decreased DOC - *N stimulated consumption of DOC?*

<details>

<summary> </summary>

``` r
## both C and N
aov1 = aov(DOC_ng_g ~ Amendments, data = doc); summary(aov1)
#>              Df   Sum Sq Mean Sq F value   Pr(>F)    
#> Amendments    2  4700758 2350379   25.74 1.77e-10 ***
#> Residuals   168 15339055   91304                     
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
h1 = agricolae::HSD.test(aov1, "Amendments"); h1$groups
#>           DOC_ng_g groups
#> C       369.584138      a
#> control  40.306491      b
#> N         1.304821      b

#DescTools::DunnettTest(DOC_mg ~ Amendments, data = doc, control="control")

## excluding C
aov2 = aov(DOC_ng_g ~ Amendments, data = doc %>% filter(!Amendments=="C")); summary(aov2)
#>              Df Sum Sq Mean Sq F value Pr(>F)  
#> Amendments    1  42969   42969   6.301 0.0135 *
#> Residuals   111 756944    6819                 
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
h2 = agricolae::HSD.test(aov1, "Amendments"); h2$groups
#>           DOC_ng_g groups
#> C       369.584138      a
#> control  40.306491      b
#> N         1.304821      b

##

# l = nlme::lme(DOC_mg ~ Amendments*Suction*Moisture*Wetting, random = ~1|CORE, 
#               data = doc %>% filter(Homogenization=="Intact"), na.action = na.omit)
# anova(l)
```

</details>

**control soils**

<details>

<summary> </summary>

``` r
doc_control = doc %>% filter(Amendments=="control")

summary(aov(DOC_ng_g ~ Suction*Moisture,
              data = doc_control %>% filter(Homogenization=="Intact")),
        na.action=na.omit)
#>                  Df Sum Sq Mean Sq F value Pr(>F)
#> Suction           1  0.026  0.0265   0.065  0.802
#> Moisture          1  0.089  0.0894   0.218  0.645
#> Suction:Moisture  1  0.004  0.0036   0.009  0.926
#> Residuals        22  9.030  0.4105
```

</details>

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

Date run: 2020-08-11

    #> R version 4.0.2 (2020-06-22)
    #> Platform: x86_64-apple-darwin17.0 (64-bit)
    #> Running under: macOS Catalina 10.15.6
    #> 
    #> Matrix products: default
    #> BLAS:   /Library/Frameworks/R.framework/Versions/4.0/Resources/lib/libRblas.dylib
    #> LAPACK: /Library/Frameworks/R.framework/Versions/4.0/Resources/lib/libRlapack.dylib
    #> 
    #> locale:
    #> [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8
    #> 
    #> attached base packages:
    #> [1] stats     graphics  grDevices utils     datasets  methods   base     
    #> 
    #> other attached packages:
    #>  [1] lme4_1.1-23     Matrix_1.2-18   car_3.0-8       carData_3.0-4  
    #>  [5] ggbiplot_0.55   PNWColors_0.1.0 forcats_0.5.0   stringr_1.4.0  
    #>  [9] dplyr_1.0.1     purrr_0.3.4     readr_1.3.1     tidyr_1.1.1    
    #> [13] tibble_3.0.3    ggplot2_3.3.2   tidyverse_1.3.0 here_0.1       
    #> 
    #> loaded via a namespace (and not attached):
    #>  [1] nlme_3.1-148      fs_1.5.0          lubridate_1.7.9   httr_1.4.2       
    #>  [5] rprojroot_1.3-2   tools_4.0.2       backports_1.1.8   R6_2.4.1         
    #>  [9] AlgDesign_1.2.0   DBI_1.1.0         questionr_0.7.1   colorspace_1.4-1 
    #> [13] withr_2.2.0       tidyselect_1.1.0  klaR_0.6-15       curl_4.3         
    #> [17] compiler_4.0.2    cli_2.0.2         rvest_0.3.6       xml2_1.3.2       
    #> [21] labeling_0.3      scales_1.1.1      digest_0.6.25     foreign_0.8-80   
    #> [25] minqa_1.2.4       rmarkdown_2.3     rio_0.5.16        pkgconfig_2.0.3  
    #> [29] htmltools_0.5.0   labelled_2.5.0    highr_0.8         fastmap_1.0.1    
    #> [33] dbplyr_1.4.4      rlang_0.4.7       readxl_1.3.1      rstudioapi_0.11  
    #> [37] shiny_1.5.0       farver_2.0.3      generics_0.0.2    combinat_0.0-8   
    #> [41] jsonlite_1.7.0    zip_2.0.4         magrittr_1.5      Rcpp_1.0.5       
    #> [45] munsell_0.5.0     fansi_0.4.1       abind_1.4-5       lifecycle_0.2.0  
    #> [49] stringi_1.4.6     yaml_2.2.1        MASS_7.3-51.6     plyr_1.8.6       
    #> [53] grid_4.0.2        blob_1.2.1        promises_1.1.1    crayon_1.3.4     
    #> [57] miniUI_0.1.1.1    lattice_0.20-41   haven_2.3.1       splines_4.0.2    
    #> [61] hms_0.5.3         knitr_1.29        pillar_1.4.6      boot_1.3-25      
    #> [65] reprex_0.3.0      glue_1.4.1        evaluate_0.14     data.table_1.13.0
    #> [69] agricolae_1.3-3   modelr_0.1.8      httpuv_1.5.4      vctrs_0.3.2      
    #> [73] nloptr_1.2.2.2    cellranger_1.1.0  gtable_0.3.0      assertthat_0.2.1 
    #> [77] xfun_0.16         openxlsx_4.1.5    mime_0.9          xtable_1.8-4     
    #> [81] broom_0.7.0       later_1.1.0.1     cluster_2.1.0     statmod_1.4.34   
    #> [85] ellipsis_0.3.1

</details>
