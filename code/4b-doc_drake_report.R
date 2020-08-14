

source("code/0-packages.R")
library(drake)

doc_plan = drake_plan(
  # I. load files --------------------------------------------------------------
  theme_set(theme_bw()),
  doc = read.csv(file_in("data/processed/doc.csv"))  %>% 
    filter(!Suction==15) %>% 
    mutate(Amendments = factor(Amendments, levels = c("control", "C", "N")),
           Homogenization = factor(Homogenization, levels = c("Intact", "Homogenized")),
           Moisture = factor(Moisture, levels = c("fm", "drought")),
           Wetting = factor(Wetting, levels = c("precip", "groundw"))),
  
  # II. plots -------------------------------------------------------------------
  gg_doc_allpanels = 
    doc %>% 
    ggplot(aes(x = Amendments, y = DOC_ng_g, color = Amendments))+
    geom_point()+
    scale_y_continuous(trans = "log10", labels = scales::comma)+
    facet_grid(Homogenization+Suction~Moisture+Wetting, scales = "free_y")+
    theme(legend.position = "none"),
  
  gg_doc_boxdotplot = 
    doc %>% 
    #filter(Homogenization=="Intact") %>% 
    ggplot(aes(x = Amendments, y = DOC_ng_g, color = Moisture, shape = Wetting))+
    geom_boxplot(aes(group = Amendments), color = "grey")+
    geom_point(size=3, position = position_dodge(width = 0.7))+
    scale_y_continuous(trans = "log10", labels = scales::comma)+
    facet_grid(Homogenization~Suction)+
    #  theme(legend.position = "none")+
    NULL,
  
  
  gg_doc_boxdotplot2 = 
    doc %>% 
    #filter(Homogenization=="Intact") %>% 
    ggplot(aes(x = Wetting, y = DOC_ng_g, color = Amendments, shape = Amendments))+
    geom_boxplot(aes(group = Wetting), fill = "grey90", alpha = 0.9, color = "grey60", width = 0.4)+
    geom_point(size=3, position = position_dodge(width = 0.7))+
    scale_y_continuous(trans = "log10", labels = scales::comma)+
    facet_grid(Homogenization+Suction ~ Moisture)+
    theme_kp()+
    #  theme(legend.position = "none")+
    NULL,
  
  # III. stats -------------------------------------------------------------------
  ## overall ANOVA
  aov_doc_all = 
    Anova(lm((DOC_ng_g) ~ 
               (Homogenization + Suction + Moisture + Wetting + Amendments)^2,
             data = doc),
          type = "III"),
  
  ## intact and homogenized
  aov_doc_intact = 
    Anova(lm(DOC_ng_g ~ (Amendments+Suction+Moisture+Wetting)^2,
             data = doc %>% filter(Homogenization=="Intact")),
          type = "III"),
  
  aov_doc_homo = 
    Anova(lm(DOC_ng_g ~ (Amendments+Suction+Moisture+Wetting)^2,
             data = doc %>% filter(Homogenization=="Homogenized")),
          type = "III"),  
  
  # IV. report ------------------------------------------------------------------
  
  report1 = rmarkdown::render(
    knitr_in("reports/doc_drake_md_report.Rmd"),
    #  output_file = file_out("drake_md_report.md"))
    #      output_format = rmarkdown::html_document(toc = TRUE))
    output_format = rmarkdown::github_document()),
  
  report2 = rmarkdown::render(
    knitr_in("reports/results.Rmd"),
    output_format = rmarkdown::github_document())
  
  # ----- ---------------------------------------------------------------------
)

make(doc_plan)
