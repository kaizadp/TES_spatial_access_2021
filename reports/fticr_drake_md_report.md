drake\_md\_report
================

-----

## HYPOTHESES

  - C amendments will increase diversity of SOM molecules
  - C amendments will cause a depletion of aromatic molecules,
    especially in fine pores
  - Homogenization will increase (a) total peaks, (b) diversity of
    peaks, (c) aromatic peaks

We selected only peaks seen in \>2/3 of the replicates

-----

**Color Palette:**  
[SoilPalettes:redox2](https://github.com/kaizadp/soilpalettes)

control: \#FFE733 (yellow)  
C: \#96001B (red)  
N: \#2E5894 (blue)

-----

### setup

how many FTICR reps per treatment type?

<details>

<summary>click to open</summary>

| SampleAssignment                        | reps |
| :-------------------------------------- | ---: |
| 50-drought-groundw-control-Intact       |    2 |
| 50-drought-precip-C-Intact              |    2 |
| 1.5-drought-groundw-C-Homogenized       |    3 |
| 1.5-drought-groundw-C-Intact            |    3 |
| 1.5-drought-groundw-control-Homogenized |    3 |
| 1.5-drought-groundw-N-Intact            |    3 |
| 1.5-drought-precip-C-Homogenized        |    3 |
| 1.5-drought-precip-N-Homogenized        |    3 |
| 1.5-fm-precip-C-Intact                  |    3 |
| 1.5-fm-precip-N-Homogenized             |    3 |
| 50-drought-groundw-control-Homogenized  |    3 |
| 50-drought-groundw-N-Intact             |    3 |
| 50-drought-precip-control-Homogenized   |    3 |
| 50-fm-groundw-control-Intact            |    3 |
| 50-fm-groundw-N-Homogenized             |    3 |
| 50-fm-precip-control-Homogenized        |    3 |
| 50-fm-precip-N-Homogenized              |    3 |
| 1.5-drought-groundw-control-Intact      |    4 |
| 1.5-drought-groundw-N-Homogenized       |    4 |
| 1.5-drought-precip-C-Intact             |    4 |
| 1.5-drought-precip-control-Homogenized  |    4 |
| 1.5-drought-precip-control-Intact       |    4 |
| 1.5-drought-precip-N-Intact             |    4 |
| 1.5-fm-groundw-C-Homogenized            |    4 |
| 1.5-fm-groundw-C-Intact                 |    4 |
| 1.5-fm-groundw-control-Homogenized      |    4 |
| 1.5-fm-groundw-control-Intact           |    4 |
| 1.5-fm-groundw-N-Homogenized            |    4 |
| 1.5-fm-groundw-N-Intact                 |    4 |
| 1.5-fm-precip-C-Homogenized             |    4 |
| 1.5-fm-precip-control-Homogenized       |    4 |
| 1.5-fm-precip-control-Intact            |    4 |
| 1.5-fm-precip-N-Intact                  |    4 |
| 50-drought-groundw-C-Homogenized        |    4 |
| 50-drought-groundw-C-Intact             |    4 |
| 50-drought-groundw-N-Homogenized        |    4 |
| 50-drought-precip-C-Homogenized         |    4 |
| 50-drought-precip-control-Intact        |    4 |
| 50-drought-precip-N-Homogenized         |    4 |
| 50-drought-precip-N-Intact              |    4 |
| 50-fm-groundw-C-Homogenized             |    4 |
| 50-fm-groundw-C-Intact                  |    4 |
| 50-fm-groundw-control-Homogenized       |    4 |
| 50-fm-groundw-N-Intact                  |    4 |
| 50-fm-precip-C-Homogenized              |    4 |
| 50-fm-precip-C-Intact                   |    4 |
| 50-fm-precip-control-Intact             |    4 |
| 50-fm-precip-N-Intact                   |    4 |

**so we select formulae seen in at least 2 reps per treatment type**

</details>

-----

## van krevelens

<details>

<summary>domains, baseline</summary>

#### fticr domains

![](markdown-figs/fticr2/domains-1.png)<!-- -->

![](markdown-figs/fticr2/vk_baseline-1.png)<!-- -->

</details>

<details>

<summary>VK by replication</summary>

#### VK by replication

    #> $gg_fticr_reps_1_5_intact

![](markdown-figs/fticr2/vk_reps-1.png)<!-- -->

    #> 
    #> $gg_fticr_reps_50_intact

![](markdown-figs/fticr2/vk_reps-2.png)<!-- -->

    #> 
    #> $gg_fticr_reps_1_5_homo

![](markdown-figs/fticr2/vk_reps-3.png)<!-- -->

    #> 
    #> $gg_fticr_reps_50_homo

![](markdown-figs/fticr2/vk_reps-4.png)<!-- -->

</details>

<details>

<summary>VK by treatment</summary>

#### VK diagrams by treatment

    #> $gg_fticr_pores_intact

![](markdown-figs/fticr2/vk_pores-1.png)<!-- -->

    #> 
    #> $gg_fticr_pores_homo

![](markdown-figs/fticr2/vk_pores-2.png)<!-- -->

    #> $gg_fticr_pores_control

![](markdown-figs/fticr2/vk_pores2-1.png)<!-- -->

    #> 
    #> $gg_fticr_pores_c

![](markdown-figs/fticr2/vk_pores2-2.png)<!-- -->

    #> 
    #> $gg_fticr_pores_n

![](markdown-figs/fticr2/vk_pores2-3.png)<!-- -->

</details>

#### VK comparisons

![](markdown-figs/fticr2/vk_comparisons1-1.png)<!-- -->

![](markdown-figs/fticr2/vk_comparisons2-1.png)<!-- -->![](markdown-figs/fticr2/vk_comparisons2-2.png)<!-- -->![](markdown-figs/fticr2/vk_comparisons2-3.png)<!-- -->

![](markdown-figs/fticr2/vk_comparisons3-1.png)<!-- -->

<details>

<summary>VK unique</summary>

#### VK unique

unique to each amendment, in each incubation type

Yellow peaks are peaks seen in control soils (all peaks)  
Blue and red are unique peaks in their respective treatments

    #> $gg_fticr_unique_int

![](markdown-figs/fticr2/vk_unique-1.png)<!-- -->

    #> 
    #> $gg_fticr_unique_homo

![](markdown-figs/fticr2/vk_unique-2.png)<!-- -->

#### VK - peaks introduced after homogenization

![](markdown-figs/fticr2/vk_homo_new-1.png)<!-- -->

</details>

-----

## peaks

<details>

<summary>graphs</summary>

![](markdown-figs/fticr2/fticr_peaks_bar-1.png)<!-- -->

total peaks

![](markdown-figs/fticr2/fticr_totalpeaks_scatter-1.png)<!-- -->

![](markdown-figs/fticr2/fticr_totalpeaks_scatter_homo-1.png)<!-- -->

complex:simple compounds

    #> $gg_aliph_aromatic

![](markdown-figs/fticr2/fticr_peaks_aliph_arom-1.png)<!-- -->

    #> 
    #> $gg_aliph_aromatic_intact_suction

![](markdown-figs/fticr2/fticr_peaks_aliph_arom-2.png)<!-- -->

</details>

<details>

<summary>peak count tables</summary>

tables – total peaks

tables – complex peaks

</details>

-----

### relative abundances

    #> $gg_fticr_relabund_barplots

![](markdown-figs/fticr2/fticr_relabund-1.png)<!-- -->

relative abundance of complex peaks

![](markdown-figs/fticr2/fticr_relabund_complex-1.png)<!-- -->

![](markdown-figs/fticr2/fticr_relabund_complex_homo-1.png)<!-- -->

### PCA

![](markdown-figs/fticr2/gg_pca-1.png)<!-- -->

### STATS

<details>

<summary>PERMANOVA</summary>

#### PERMANOVA

**overall**

    #> # A tibble: 17 x 7
    #>    term                        df SumsOfSqs MeanSqs F.Model      R2 p.value
    #>    <chr>                    <dbl>     <dbl>   <dbl>   <dbl>   <dbl>   <dbl>
    #>  1 Amendments                   2    0.222   0.111    5.78  0.0393    0.002
    #>  2 Moisture                     1    0.468   0.468   24.4   0.0829    0.001
    #>  3 Wetting                      1    0.0147  0.0147   0.766 0.00261   0.475
    #>  4 Suction                      1    0.705   0.705   36.7   0.125     0.001
    #>  5 Homogenization               1    0.519   0.519   27.0   0.0918    0.001
    #>  6 Amendments:Moisture          2    0.0420  0.0210   1.09  0.00745   0.344
    #>  7 Amendments:Wetting           2    0.142   0.0712   3.71  0.0252    0.013
    #>  8 Amendments:Suction           2    0.0881  0.0441   2.29  0.0156    0.055
    #>  9 Amendments:Homogenizati…     2    0.234   0.117    6.08  0.0414    0.001
    #> 10 Moisture:Wetting             1    0.0607  0.0607   3.16  0.0107    0.053
    #> 11 Moisture:Suction             1    0.0731  0.0731   3.80  0.0129    0.021
    #> 12 Moisture:Homogenization      1    0.0137  0.0137   0.715 0.00243   0.497
    #> 13 Wetting:Suction              1    0.0742  0.0742   3.86  0.0131    0.028
    #> 14 Wetting:Homogenization       1    0.0507  0.0507   2.64  0.00898   0.07 
    #> 15 Suction:Homogenization       1    0.0175  0.0175   0.912 0.00310   0.416
    #> 16 Residuals                  152    2.92    0.0192  NA     0.517    NA    
    #> 17 Total                      172    5.65   NA       NA     1        NA

**permanova for intact**

    #> # A tibble: 12 x 7
    #>    term                   df SumsOfSqs MeanSqs F.Model      R2 p.value
    #>    <chr>               <dbl>     <dbl>   <dbl>   <dbl>   <dbl>   <dbl>
    #>  1 Suction                 1    0.377   0.377    26.0  0.180     0.001
    #>  2 Amendments              2    0.103   0.0514    3.54 0.0492    0.012
    #>  3 Moisture                1    0.147   0.147    10.2  0.0706    0.001
    #>  4 Wetting                 1    0.0708  0.0708    4.88 0.0339    0.016
    #>  5 Suction:Amendments      2    0.143   0.0714    4.92 0.0683    0.003
    #>  6 Suction:Moisture        1    0.0282  0.0282    1.94 0.0135    0.155
    #>  7 Suction:Wetting         1    0.0157  0.0157    1.08 0.00753   0.344
    #>  8 Amendments:Moisture     2    0.0648  0.0324    2.23 0.0310    0.069
    #>  9 Amendments:Wetting      2    0.0463  0.0232    1.60 0.0222    0.179
    #> 10 Moisture:Wetting        1    0.0496  0.0496    3.42 0.0237    0.04 
    #> 11 Residuals              72    1.04    0.0145   NA    0.500    NA    
    #> 12 Total                  86    2.09   NA        NA    1        NA
    #> # A tibble: 8 x 7
    #>   term                   df SumsOfSqs  MeanSqs F.Model     R2 p.value
    #>   <chr>               <dbl>     <dbl>    <dbl>   <dbl>  <dbl>   <dbl>
    #> 1 Amendments              2   0.0163   0.00816   0.746 0.0235   0.607
    #> 2 Moisture                1   0.113    0.113    10.3   0.162    0.001
    #> 3 Wetting                 1   0.0377   0.0377    3.45  0.0542   0.024
    #> 4 Amendments:Moisture     2   0.0538   0.0269    2.46  0.0773   0.049
    #> 5 Amendments:Wetting      2   0.0831   0.0415    3.79  0.119    0.009
    #> 6 Moisture:Wetting        1   0.00923  0.00923   0.844 0.0133   0.467
    #> 7 Residuals              35   0.383    0.0109   NA     0.550   NA    
    #> 8 Total                  44   0.696   NA        NA     1       NA
    #> # A tibble: 8 x 7
    #>   term                   df SumsOfSqs MeanSqs F.Model     R2 p.value
    #>   <chr>               <dbl>     <dbl>   <dbl>   <dbl>  <dbl>   <dbl>
    #> 1 Amendments              2    0.236   0.118     7.64 0.233    0.001
    #> 2 Moisture                1    0.0660  0.0660    4.26 0.0649   0.016
    #> 3 Wetting                 1    0.0385  0.0385    2.49 0.0379   0.097
    #> 4 Amendments:Moisture     2    0.0522  0.0261    1.69 0.0513   0.169
    #> 5 Amendments:Wetting      2    0.0349  0.0174    1.13 0.0343   0.325
    #> 6 Moisture:Wetting        1    0.0935  0.0935    6.04 0.0919   0.005
    #> 7 Residuals              32    0.495   0.0155   NA    0.487   NA    
    #> 8 Total                  41    1.02   NA        NA    1       NA

**PERMANOVA for treatments**

1.5 kPa intact cores

    #> # A tibble: 8 x 7
    #>   term                   df SumsOfSqs  MeanSqs F.Model     R2 p.value
    #>   <chr>               <dbl>     <dbl>    <dbl>   <dbl>  <dbl>   <dbl>
    #> 1 Amendments              2   0.0163   0.00816   0.746 0.0235   0.607
    #> 2 Moisture                1   0.113    0.113    10.3   0.162    0.001
    #> 3 Wetting                 1   0.0377   0.0377    3.45  0.0542   0.024
    #> 4 Amendments:Moisture     2   0.0538   0.0269    2.46  0.0773   0.049
    #> 5 Amendments:Wetting      2   0.0831   0.0415    3.79  0.119    0.009
    #> 6 Moisture:Wetting        1   0.00923  0.00923   0.844 0.0133   0.467
    #> 7 Residuals              35   0.383    0.0109   NA     0.550   NA    
    #> 8 Total                  44   0.696   NA        NA     1       NA

50 kPa intact cores

    #> # A tibble: 8 x 7
    #>   term                   df SumsOfSqs MeanSqs F.Model     R2 p.value
    #>   <chr>               <dbl>     <dbl>   <dbl>   <dbl>  <dbl>   <dbl>
    #> 1 Amendments              2    0.236   0.118     7.64 0.233    0.001
    #> 2 Moisture                1    0.0660  0.0660    4.26 0.0649   0.016
    #> 3 Wetting                 1    0.0385  0.0385    2.49 0.0379   0.097
    #> 4 Amendments:Moisture     2    0.0522  0.0261    1.69 0.0513   0.169
    #> 5 Amendments:Wetting      2    0.0349  0.0174    1.13 0.0343   0.325
    #> 6 Moisture:Wetting        1    0.0935  0.0935    6.04 0.0919   0.005
    #> 7 Residuals              32    0.495   0.0155   NA    0.487   NA    
    #> 8 Total                  41    1.02   NA        NA    1       NA

</details>

#### PCA

<details>

<summary>overall PCA</summary>

    #> $gg_fticr_pca_intact

![](markdown-figs/fticr2/fticr_pca_overall-1.png)<!-- -->

    #> $gg_fticr_pca_homo

![](markdown-figs/fticr2/fticr_pca_overall-2.png)<!-- -->

</details>

<details>

<summary>PCA individual treatments</summary>

**individual cores**

![](markdown-figs/fticr2/fticr_pca_indiv-1.png)<!-- -->![](markdown-figs/fticr2/fticr_pca_indiv-2.png)<!-- -->

</details>

-----

#### LME-AOV

peak counts stats

    #> Analysis of Deviance Table (Type III Wald chisquare tests)
    #> 
    #> Response: log(counts)
    #>                              Chisq Df            Pr(>Chisq)    
    #> (Intercept)               820.5353  1 < 0.00000000000000022 ***
    #> Homogenization              6.6760  1             0.0097718 ** 
    #> Moisture                    3.4725  1             0.0623985 .  
    #> Wetting                     1.3145  1             0.2515799    
    #> Amendments                  3.7139  2             0.1561465    
    #> Suction                    35.2551  1        0.000000002892 ***
    #> Homogenization:Moisture     0.8487  1             0.3569222    
    #> Homogenization:Wetting      6.0360  1             0.0140168 *  
    #> Homogenization:Amendments  14.5153  2             0.0007047 ***
    #> Homogenization:Suction      0.9320  1             0.3343550    
    #> Moisture:Wetting           10.0645  1             0.0015116 ** 
    #> Moisture:Amendments         3.9792  2             0.1367469    
    #> Moisture:Suction           25.5491  1        0.000000431271 ***
    #> Wetting:Amendments          8.5026  2             0.0142454 *  
    #> Wetting:Suction             0.2874  1             0.5919089    
    #> Amendments:Suction          2.8002  2             0.2465782    
    #> ---
    #> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    #> Anova Table (Type III tests)
    #> 
    #> Response: log(counts)
    #>              Sum Sq Df   F value               Pr(>F)    
    #> (Intercept) 297.479  1 1642.5218 0.000000000000004525 ***
    #> Wetting       0.825  1    4.5561              0.05242 .  
    #> Residuals     2.354 13                                   
    #> ---
    #> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

relabund\_complex stats

    #> [1] NA
    #> Anova Table (Type III tests)
    #> 
    #> Response: log(relabund)
    #>                      Sum Sq Df    F value                Pr(>F)    
    #> (Intercept)         101.503  1 14616.8842 < 0.00000000000000022 ***
    #> Moisture              0.037  1     5.3104              0.024086 *  
    #> Amendments            0.025  2     1.8212              0.169205    
    #> Wetting               0.008  1     1.1850              0.279965    
    #> Suction               0.188  1    27.1364           0.000001731 ***
    #> Moisture:Amendments   0.018  2     1.2602              0.289775    
    #> Moisture:Wetting      0.023  1     3.2422              0.075951 .  
    #> Moisture:Suction      0.008  1     1.1769              0.281604    
    #> Amendments:Wetting    0.046  2     3.3398              0.041014 *  
    #> Amendments:Suction    0.079  2     5.7214              0.004943 ** 
    #> Wetting:Suction       0.010  1     1.4352              0.234846    
    #> Residuals             0.500 72                                     
    #> ---
    #> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### others

<details>

<summary>other plots</summary>

#### NOSC

![](markdown-figs/fticr2/NOSC-1.png)<!-- -->

#### elements

    #> $gg_elements_n

![](markdown-figs/fticr2/elements-1.png)<!-- -->

    #> 
    #> $gg_elements_o

![](markdown-figs/fticr2/elements-2.png)<!-- -->

</details>

## Session Info

<details>

<summary>click to expand</summary>

Date run: 2020-12-07

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
    #>  [1] ggpubr_0.4.0     patchwork_1.0.1  lme4_1.1-23      Matrix_1.2-18   
    #>  [5] car_3.0-9        carData_3.0-4    visNetwork_2.0.9 vegan_2.5-6     
    #>  [9] lattice_0.20-41  permute_0.9-5    rmarkdown_2.3    drake_7.12.4    
    #> [13] ggbiplot_0.55    PNWColors_0.1.0  forcats_0.5.0    stringr_1.4.0   
    #> [17] dplyr_1.0.1      purrr_0.3.4      readr_1.3.1      tidyr_1.1.1     
    #> [21] tibble_3.0.3     ggplot2_3.3.2    tidyverse_1.3.0  here_0.1        
    #> 
    #> loaded via a namespace (and not attached):
    #>   [1] minqa_1.2.4        colorspace_1.4-1   ggsignif_0.6.0    
    #>   [4] class_7.3-17       ellipsis_0.3.1     rio_0.5.16        
    #>   [7] rprojroot_1.3-2    fs_1.5.0           gld_2.6.2         
    #>  [10] rstudioapi_0.11    farver_2.0.3       soilpalettes_0.1.0
    #>  [13] mvtnorm_1.1-1      fansi_0.4.1        lubridate_1.7.9   
    #>  [16] xml2_1.3.2         splines_4.0.2      rootSolve_1.8.2.1 
    #>  [19] knitr_1.29         jsonlite_1.7.0     nloptr_1.2.2.2    
    #>  [22] packrat_0.5.0      broom_0.7.0        cluster_2.1.0     
    #>  [25] dbplyr_1.4.4       shiny_1.5.0        compiler_4.0.2    
    #>  [28] httr_1.4.2         backports_1.1.8    assertthat_0.2.1  
    #>  [31] fastmap_1.0.1      cli_2.0.2          later_1.1.0.1     
    #>  [34] htmltools_0.5.0    prettyunits_1.1.1  tools_4.0.2       
    #>  [37] igraph_1.2.5       lmom_2.8           gtable_0.3.0      
    #>  [40] agricolae_1.3-3    glue_1.4.1         reshape2_1.4.4    
    #>  [43] Rcpp_1.0.5         cellranger_1.1.0   vctrs_0.3.2       
    #>  [46] nlme_3.1-148       xfun_0.16          openxlsx_4.1.5    
    #>  [49] rvest_0.3.6        mime_0.9           miniUI_0.1.1.1    
    #>  [52] lifecycle_0.2.0    rstatix_0.6.0      statmod_1.4.34    
    #>  [55] MASS_7.3-51.6      scales_1.1.1       hms_0.5.3         
    #>  [58] promises_1.1.1     parallel_4.0.2     expm_0.999-5      
    #>  [61] Exact_2.1          yaml_2.2.1         curl_4.3          
    #>  [64] gridExtra_2.3      labelled_2.5.0     stringi_1.4.6     
    #>  [67] AlgDesign_1.2.0    highr_0.8          klaR_0.6-15       
    #>  [70] e1071_1.7-3        filelock_1.0.2     boot_1.3-25       
    #>  [73] zip_2.1.0          storr_1.2.1        rlang_0.4.7       
    #>  [76] pkgconfig_2.0.3    evaluate_0.14      labeling_0.3      
    #>  [79] htmlwidgets_1.5.1  cowplot_1.0.0      tidyselect_1.1.0  
    #>  [82] plyr_1.8.6         magrittr_1.5       R6_2.4.1          
    #>  [85] DescTools_0.99.38  generics_0.0.2     base64url_1.4     
    #>  [88] combinat_0.0-8     txtq_0.2.3         DBI_1.1.0         
    #>  [91] pillar_1.4.6       haven_2.3.1        foreign_0.8-80    
    #>  [94] withr_2.2.0        mgcv_1.8-31        abind_1.4-5       
    #>  [97] modelr_0.1.8       crayon_1.3.4       questionr_0.7.1   
    #> [100] utf8_1.1.4         progress_1.2.2     grid_4.0.2        
    #> [103] readxl_1.3.1       data.table_1.13.0  blob_1.2.1        
    #> [106] reprex_0.3.0       digest_0.6.25      xtable_1.8-4      
    #> [109] httpuv_1.5.4       munsell_0.5.0

</details>
