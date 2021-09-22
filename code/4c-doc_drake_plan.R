

source("code/0-packages.R")
library(drake)
library(car)

source("code/4b-doc_functions.R")

doc_plan = drake_plan(
  # I. load files --------------------------------------------------------------
  doc = read_file("data/processed/doc.csv"),

  # II. plots -------------------------------------------------------------------
  
  gg_doc_suctions = plot_doc_suctions(doc),
  gg_doc_fullcore_intact = plot_doc_fullcore(doc)$gg_doc_boxdotplot_fullcore,
  gg_doc_fullcore_homo = plot_doc_fullcore(doc)$gg_doc_boxdotplot_fullcore_homo,

  # III. stats -------------------------------------------------------------------
  aov_doc_all = compute_lme_doc_overall(doc),
  aov_doc_intact = compute_aov_flux_intact(doc),
  
  
  # IV. tables --------------------------------------------------------------
  doc_table = make_doc_table(doc),

  # IV. report ------------------------------------------------------------------
  
  report1 = rmarkdown::render(
    knitr_in("reports/doc_drake_md_report.Rmd"),
    output_format = rmarkdown::github_document()),

  
  # ----- ---------------------------------------------------------------------
)

make(doc_plan, lock_cache = F)
