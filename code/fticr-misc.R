fticr_elements %>% 
  ggplot(aes(x = O, color = Amendments, fill = Amendments))+
  geom_density(alpha = 0.5)+
  #geom_density(alpha = 0.2)+
  geom_boxplot(aes(x = O, y = 0.3), width = 0.05)+
  facet_grid(Suction + Wetting ~ Moisture)
  

# -------------------------------------------------------------------------

data_long_trt_subset = 
  data_long_trt %>% 
  filter(Homogenization == "Intact")

  
data_long_trt_subset %>% 
  filter(Amendments=="control") %>% 
  gg_vankrev((aes(x = OC, y = HC, color = Wetting)))+
  stat_ellipse(show.legend = F)+
  facet_grid(Suction~Moisture+Wetting)+
  labs(title = "control")+
  theme_kp()

data_long_trt_subset %>% 
  filter(Amendments=="C") %>% 
  gg_vankrev((aes(x = OC, y = HC, color = Wetting)))+
  stat_ellipse(show.legend = F)+
  facet_grid(Suction~Moisture+Wetting)+
  labs(title = "+C")+
  theme_kp()


data_long_trt_subset %>% 
  filter(Amendments=="control" & Moisture=="drought") %>% 
  gg_vankrev((aes(x = OC, y = HC, color = Wetting)))+
  stat_ellipse(show.legend = F)+
  facet_grid(Suction~Moisture+Wetting)+
  labs(title = "control")+
  theme_kp()

data_long_trt_subset %>% 
  filter(Amendments=="C" & Moisture=="drought") %>% 
  gg_vankrev((aes(x = OC, y = HC, color = Wetting)))+
  stat_ellipse(show.legend = F)+
  facet_grid(Suction~Moisture+Wetting)+
  labs(title = "+C")+
  theme_kp()



# -------------------------------------------------------------------------

relabund_wide = 
  relabund_cores %>% 
  filter(!Suction==15) %>% 
  dplyr::select(Core, SampleAssignment, class, relabund, 
                Moisture, Wetting, Suction, Homogenization, Amendments) %>% 
  spread(class, relabund) %>% 
  replace(is.na(.), 0)

relabund_pca=
  relabund_wide %>% 
  select(-1)

### IIIb1. intact cores -----------------------------------------------------

do_gg_pca_intact_plots <- function(pca_int, relabund_pca_grp_intact) {
  gg_pca_intact_suction <- 
    ggbiplot(pca_int, obs.scale = 1, var.scale = 1, 
             groups = as.character(relabund_pca_grp_intact$Suction), ellipse = TRUE, circle = FALSE,
             var.axes = TRUE) +
    geom_point(size=5,stroke=1, 
               aes(color = groups, 
                   shape = interaction(as.factor(relabund_pca_grp_intact$Moisture),
                                       as.factor(relabund_pca_grp_intact$Wetting))))+
    scale_shape_manual(values = c(1, 2, 19, 17))+
    scale_color_manual(values = pal)+
    labs(shape="",
         title = "INTACT",
         subtitle = "grouped by suction")+
    NULL
  
  gg_pca_intact_amend  <-  
    ggbiplot(pca_int, obs.scale = 1, var.scale = 1, 
             groups = relabund_pca_grp_intact$Moisture, ellipse = TRUE, circle = FALSE,
             var.axes = TRUE)+
    geom_point(size=5,stroke=1, 
               aes(color = groups, 
                   shape = as.factor(relabund_pca_grp_intact$Wetting)))+
    scale_shape_manual(values = c(1, 19))+
    #scale_color_manual(values = pal3)+
    labs(shape="",
         title = "INTACT",
         subtitle = "grouped by amendment")+
    NULL
  
  list(#gg_pca_intact_suction = gg_pca_intact_suction,
    #gg_pca_intact_amend = gg_pca_intact_amend,
    gg_fticr_pca_intact = gg_pca_intact_suction + gg_pca_intact_amend
  )
}



relabund_pca_num_intact = 
  relabund_pca %>% 
  filter(Homogenization=="Intact" & Amendments=="control") %>% 
  dplyr::select(.,-(1:6))

relabund_pca_grp_intact = 
  relabund_pca %>% 
  filter(Homogenization=="Intact"& Amendments=="control") %>% 
  dplyr::select(.,(1:6)) %>% 
  dplyr::mutate(row = row_number())

pca_int = prcomp(relabund_pca_num_intact, scale. = T)
#summary(pca)

gg_pca_intact_plots = do_gg_pca_intact_plots(pca_int, relabund_pca_grp_intact)



# -------------------------------------------------------------------------

relabund_wide = 
  relabund_cores %>% 
  filter(!Suction==15 & 
           Amendments=="N" &Suction==50 ) %>% 
  dplyr::select(Core, SampleAssignment, class, relabund, 
                Moisture, Wetting, Suction, Homogenization, Amendments) %>% 
  spread(class, relabund) %>% 
  replace(is.na(.), 0)




  adonis(relabund_wide %>% select(aliphatic:condensed_arom) ~ (Suction+Moisture+Wetting)^2, 
         data = relabund_wide)

  

# -------------------------------------------------------------------------
library(vegan)
data(dune)
data("dune.env")

dune.mds <- metaMDS(dune, distance = "bray", autotransform = FALSE)
plot(dune.mds)
points(dune.mds, display = "sites", pch = c(16, 8, 17, 11) [as.numeric(dune.env$Management)], col = c("blue", "orange", "black") [as.numeric(dune.env$Use)]) # displays site points where symbols (pch) are different management options and colour (col) are different land uses
legend("topright", legend = c(levels(dune.env$Management), levels(dune.env$Use)), pch = c(16, 8, 17, 11, 16, 16, 16), col = c("black","black","black","black","blue", "orange", "black"), bty = "n", cex = 1) # displays symbol and colour legend
legend("topleft", "stress = 0.118", bty = "n", cex = 1)


fticr.nmds = metaMDS(relabund_pca_num_intact, distance = "bray", autotransform = FALSE)
plot(fticr.nmds)
points(fticr.nmds, col = c("red", "blue")[as.numeric(relabund_pca_grp_intact$Suction2)]) 

relabund_pca_grp_intact = 
  relabund_pca_grp_intact %>% 
  mutate(Suction2 = as.factor(paste0(Suction, "kPa"))) %>% 
  dplyr::select(-SampleAssignment)

ordiplot(fticr.nmds, type = "n", main = "ellipses")
orditorp(fticr.nmds, 
         display = "sites", labels = F,
         pch = c(1,1)[as.numeric(relabund_pca_grp_intact$Suction2)],
         col = c("red", "blue") [as.numeric(relabund_pca_grp_intact$Suction2)], cex = 1)
ordiellipse(fticr.nmds, groups = relabund_pca_grp_intact$Suction2, draw = "polygon", lty = 1, col = "grey90")

fticr.spp.fit <- envfit(fticr.nmds, relabund_pca_num_intact, permutations = 999)
plot(fticr.spp.fit, p.max = 0.05, col = "black", cex = 0.7)


fticr.envfit <- envfit(fticr.nmds, relabund_pca_grp_intact, permutations = 999)

plot(fticr.envfit, col = "black", cex = 0.7, p.max = 0.05)
legend("bottomleft", 
       legend = c("1.5 kPa", "50 kPa"), pch = 1:1,
                  col = c("red","blue")) 


#######################

relabund_pca_num_intact_1 = 
  relabund_pca %>% 
  filter(Homogenization=="Intact" & Suction==1.5) %>% 
  dplyr::select(.,-(1:6))

relabund_pca_grp_intact_1 = 
  relabund_pca %>% 
  filter(Homogenization=="Intact"& Suction==1.5) %>% 
  dplyr::select(.,(1:6)) %>% 
  dplyr::mutate(row = row_number())

fticr.nmds_1 = metaMDS(relabund_pca_num_intact_1, distance = "bray", autotransform = FALSE)

ordiplot(fticr.nmds_1, type = "n", main = "ellipses")
orditorp(fticr.nmds_1, 
         display = "sites", labels = F,
         pch = c(1,1)[as.numeric(relabund_pca_grp_intact_1$Moisture)],
         col = c("red", "blue") [as.numeric(relabund_pca_grp_intact_1$Moisture)], cex = 1)
ordiellipse(fticr.nmds_1, groups = relabund_pca_grp_intact_1$Moisture, draw = "polygon", lty = 1, col = "grey90")

fticr.spp.fit <- envfit(fticr.nmds_1, relabund_pca_num_intact_1, permutations = 999)
plot(fticr.spp.fit, p.max = 0.05, col = "black", cex = 0.7)


fticr.envfit <- envfit(fticr.nmds_1, relabund_pca_grp_intact_1, permutations = 999)

legend("bottomleft", 
       legend = c("fm", "drought"), pch = 1:1,
       col = c("red","blue")) 




relabund_pca_num_intact_5 = 
  relabund_pca %>% 
  filter(Homogenization=="Intact" & Suction==50) %>% 
  dplyr::select(.,-(1:6))

relabund_pca_grp_intact_5 = 
  relabund_pca %>% 
  filter(Homogenization=="Intact"& Suction==50) %>% 
  dplyr::select(.,(1:6)) %>% 
  dplyr::mutate(row = row_number()) %>% 
  dplyr::select(-SampleAssignment)

fticr.nmds_5 = metaMDS(relabund_pca_num_intact_5, distance = "bray", autotransform = FALSE)

ordiplot(fticr.nmds_5, type = "n", main = "ellipses")
orditorp(fticr.nmds_5, 
         display = "sites", labels = F,
         pch = c(1,1)[as.numeric(relabund_pca_grp_intact_5$Moisture)],
         col = c("red", "blue") [as.numeric(relabund_pca_grp_intact_5$Moisture)], cex = 1)
ordiellipse(fticr.nmds_5, groups = relabund_pca_grp_intact_5$Moisture, draw = "polygon", lty = 1, col = "grey90")

fticr.spp.fit <- envfit(fticr.nmds_5, relabund_pca_num_intact_5, permutations = 999)
plot(fticr.spp.fit, p.max = 0.05, col = "black", cex = 0.7)


fticr.envfit <- envfit(fticr.nmds_5, relabund_pca_grp_intact_5, permutations = 999)

#plot(fticr.envfit, col = "black", cex = 0.7, p.max = 0.05)
legend("bottomleft", 
       legend = c("fm", "drought"), pch = 1:1,
       col = c("red","blue"))



############### baseline

relabund_pca_num_intact_fm = 
  relabund_pca %>% 
  filter(Homogenization=="Intact" & Moisture=="fm" & Amendments=="control") %>% 
  dplyr::select(.,-(1:6))

relabund_pca_grp_intact_fm = 
  relabund_pca %>% 
  filter(Homogenization=="Intact"& Moisture=="fm"& Amendments=="control") %>% 
  dplyr::select(.,(1:6)) %>% 
  dplyr::mutate(row = row_number(),
                Suction = as.factor(Suction)) %>% 
  dplyr::select(-SampleAssignment)

fticr.nmds_fm = metaMDS(relabund_pca_num_intact_fm, distance = "bray", autotransform = FALSE)

ordiplot(fticr.nmds_fm, type = "n", main = "ellipses")
orditorp(fticr.nmds_fm, 
         display = "sites", labels = F,
         pch = c(1,2)[as.factor(relabund_pca_grp_intact_fm$Suction)],
         col = c("red", "blue") [as.numeric(relabund_pca_grp_intact_fm$Wetting)], cex = 1)
ordiellipse(fticr.nmds_fm, groups = relabund_pca_grp_intact_fm$Wetting, draw = "polygon", lty = 1, col = "grey90")

fticr.spp.fit <- envfit(fticr.nmds_fm, relabund_pca_num_intact_fm, permutations = 999)
plot(fticr.spp.fit, p.max = 0.05, col = "black", cex = 0.7)


fticr.envfit <- envfit(fticr.nmds_fm, relabund_pca_grp_intact_fm, permutations = 999)

#plot(fticr.envfit, col = "black", cex = 0.7, p.max = 0.05)
legend("bottomleft", 
       legend = c("fm", "drought"), pch = 1:1,
       col = c("red","blue"))

# -------------------------------------------------------------------------

data_control = 
  data_long_trt %>% 
  filter(Homogenization=="Intact" & Amendments == "control" & Suction != 15)

ggvk_control_fm = 
  gg_vankrev(data = data_control %>% filter(Moisture=="fm"), aes(x = OC, y = HC, color = Wetting))+
  facet_grid(Suction ~ Moisture)+
  labs(title = "control soils")+
  theme_kp()

data_control_drought_new = 
  data_control %>% 
  group_by(Suction, Wetting, formula, HC, OC) %>% 
  dplyr::mutate(n = n()) %>% 
  ungroup() %>% 
  dplyr::filter(n == 1 & Moisture == "drought") %>% 
  dplyr::select(formula, HC, OC, Suction, Moisture, Wetting, Amendments, Homogenization)

ggvk_control_drought = 
  data_control_drought_new %>% 
  mutate(Moisture = dplyr::recode(Moisture, 
                           "drought" = "new peaks following drought", )) %>% 
  gg_vankrev(aes(x = OC, y = HC, color = Wetting))+
  facet_grid(Suction ~ Moisture)+
  stat_ellipse(level = 0.9, show.legend = F)+
  theme_kp()

library(patchwork)

ggvk_control_fm + ggvk_control_drought+
  plot_layout(guides = "collect") & theme(legend.position = "top")


