Spatial Access – DOC
================

![](markdown/doc/doc_graph-1.png)<!-- -->![](markdown/doc/doc_graph-2.png)<!-- -->

-----

**what influenced DOC?**

DOC in **intact** cores was influenced by:  
1\. Amendments  
2\. Wetting direction  
DOC in **homogenized** cores was influenced by:  
1\. Amendments  
2\. Wetting direction  
3\. Suction

<details>

<summary> </summary>

``` r
summary(aov(DOC_mg ~ Amendments*Suction*Moisture*Wetting,
              data = doc %>% filter(Homogenization=="Intact")))
#>                                      Df Sum Sq Mean Sq F value   Pr(>F)    
#> Amendments                            2 364660  182330  26.750 4.57e-10 ***
#> Suction                               1   7440    7440   1.092   0.2986    
#> Moisture                              1   3638    3638   0.534   0.4667    
#> Wetting                               1  31861   31861   4.674   0.0330 *  
#> Amendments:Suction                    2  13867    6933   1.017   0.3652    
#> Amendments:Moisture                   2   6458    3229   0.474   0.6241    
#> Suction:Moisture                      1    691     691   0.101   0.7508    
#> Amendments:Wetting                    2  55997   27999   4.108   0.0192 *  
#> Suction:Wetting                       1     30      30   0.004   0.9476    
#> Moisture:Wetting                      1  10741   10741   1.576   0.2122    
#> Amendments:Suction:Moisture           2    857     428   0.063   0.9391    
#> Amendments:Suction:Wetting            2    283     141   0.021   0.9795    
#> Amendments:Moisture:Wetting           2  18142    9071   1.331   0.2688    
#> Suction:Moisture:Wetting              1   1140    1140   0.167   0.6834    
#> Amendments:Suction:Moisture:Wetting   2   1923     961   0.141   0.8686    
#> Residuals                           102 695238    6816                     
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#> 18 observations deleted due to missingness

summary(aov(DOC_mg ~ Amendments*Suction*Moisture*Wetting,
              data = doc %>% filter(Homogenization=="Homogenized")))
#>                                      Df Sum Sq Mean Sq F value   Pr(>F)    
#> Amendments                            2   1748   874.0   7.686 0.000774 ***
#> Suction                               1    711   711.0   6.252 0.013981 *  
#> Moisture                              1    959   958.7   8.431 0.004514 ** 
#> Wetting                               1    104   104.1   0.916 0.340867    
#> Amendments:Suction                    2    452   226.1   1.988 0.142140    
#> Amendments:Moisture                   2   3332  1666.1  14.651 2.51e-06 ***
#> Suction:Moisture                      1     88    88.1   0.775 0.380761    
#> Amendments:Wetting                    2     45    22.7   0.200 0.819371    
#> Suction:Wetting                       1     48    47.8   0.420 0.518336    
#> Moisture:Wetting                      1     13    12.5   0.110 0.740581    
#> Amendments:Suction:Moisture           2   1298   648.8   5.705 0.004469 ** 
#> Amendments:Suction:Wetting            2     15     7.6   0.067 0.935477    
#> Amendments:Moisture:Wetting           2    190    95.0   0.835 0.436769    
#> Suction:Moisture:Wetting              1      3     2.5   0.022 0.881349    
#> Amendments:Suction:Moisture:Wetting   2     34    17.1   0.151 0.860370    
#> Residuals                           103  11713   113.7                     
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#> 14 observations deleted due to missingness
```

</details>

**how did amendments influence DOC?**

C addition increased DOC  
N addition decreased DOC - *N stimulated consumption of DOC?*

<details>

<summary> </summary>

``` r
## both C and N
aov1 = aov(DOC_mg ~ Amendments, data = doc); summary(aov1)
#>              Df  Sum Sq Mean Sq F value   Pr(>F)    
#> Amendments    2  196357   98178   21.97 1.63e-09 ***
#> Residuals   250 1117405    4470                     
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#> 32 observations deleted due to missingness
h1 = agricolae::HSD.test(aov1, "Amendments"); h1$groups
#>             DOC_mg groups
#> C       61.4317647      a
#> control  4.9796471      b
#> N        0.1563855      b

#DescTools::DunnettTest(DOC_mg ~ Amendments, data = doc, control="control")

## excluding C
aov2 = aov(DOC_mg ~ Amendments, data = doc %>% filter(!Amendments=="C")); summary(aov2)
#>              Df Sum Sq Mean Sq F value  Pr(>F)   
#> Amendments    1    977   976.9   8.624 0.00379 **
#> Residuals   166  18804   113.3                   
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#> 24 observations deleted due to missingness
h2 = agricolae::HSD.test(aov1, "Amendments"); h2$groups
#>             DOC_mg groups
#> C       61.4317647      a
#> control  4.9796471      b
#> N        0.1563855      b

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

summary(aov(DOC_mg ~ Suction*Moisture,
              data = doc_control %>% filter(Homogenization=="Intact")),
        na.action=na.omit)
#>                  Df  Sum Sq  Mean Sq F value Pr(>F)
#> Suction           1 0.00000 0.000003   0.000  0.983
#> Moisture          1 0.01451 0.014510   2.066  0.160
#> Suction:Moisture  1 0.00053 0.000532   0.076  0.785
#> Residuals        35 0.24585 0.007024               
#> 9 observations deleted due to missingness
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

Date run: 2020-07-10

    #> R version 4.0.1 (2020-06-06)
    #> Platform: x86_64-apple-darwin17.0 (64-bit)
    #> Running under: macOS Mojave 10.14.6
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
    #>  [1] ggbiplot_0.55   PNWColors_0.1.0 forcats_0.5.0   stringr_1.4.0  
    #>  [5] dplyr_1.0.0     purrr_0.3.4     readr_1.3.1     tidyr_1.1.0    
    #>  [9] tibble_3.0.1    ggplot2_3.3.2   tidyverse_1.3.0 here_0.1       
    #> 
    #> loaded via a namespace (and not attached):
    #>  [1] httr_1.4.1       jsonlite_1.6.1   modelr_0.1.8     shiny_1.5.0     
    #>  [5] assertthat_0.2.1 highr_0.8        blob_1.2.1       cellranger_1.1.0
    #>  [9] yaml_2.2.1       pillar_1.4.4     backports_1.1.8  lattice_0.20-41 
    #> [13] glue_1.4.1       digest_0.6.25    promises_1.1.1   rvest_0.3.5     
    #> [17] colorspace_1.4-1 htmltools_0.5.0  httpuv_1.5.4     plyr_1.8.6      
    #> [21] klaR_0.6-15      pkgconfig_2.0.3  labelled_2.5.0   broom_0.5.6     
    #> [25] haven_2.3.1      questionr_0.7.1  xtable_1.8-4     scales_1.1.1    
    #> [29] later_1.1.0.1    combinat_0.0-8   generics_0.0.2   farver_2.0.3    
    #> [33] ellipsis_0.3.1   withr_2.2.0      agricolae_1.3-3  cli_2.0.2       
    #> [37] magrittr_1.5     crayon_1.3.4     readxl_1.3.1     mime_0.9        
    #> [41] evaluate_0.14    fs_1.4.1         fansi_0.4.1      nlme_3.1-148    
    #> [45] MASS_7.3-51.6    xml2_1.3.2       tools_4.0.1      hms_0.5.3       
    #> [49] lifecycle_0.2.0  munsell_0.5.0    reprex_0.3.0     cluster_2.1.0   
    #> [53] compiler_4.0.1   rlang_0.4.6      grid_4.0.1       rstudioapi_0.11 
    #> [57] miniUI_0.1.1.1   labeling_0.3     rmarkdown_2.3    gtable_0.3.0    
    #> [61] DBI_1.1.0        AlgDesign_1.2.0  R6_2.4.1         lubridate_1.7.9 
    #> [65] knitr_1.28       fastmap_1.0.1    rprojroot_1.3-2  stringi_1.4.6   
    #> [69] Rcpp_1.0.4.6     vctrs_0.3.1      dbplyr_1.4.4     tidyselect_1.1.0
    #> [73] xfun_0.15

</details>
