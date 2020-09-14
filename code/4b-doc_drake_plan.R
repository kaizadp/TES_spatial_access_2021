

source("code/0-packages.R")
library(drake)
library(car)

source("code/4c-doc-functions.R")

doc_plan = drake_plan(
  # I. load files --------------------------------------------------------------
  doc = read_file("data/processed/doc.csv"),

  # II. plots -------------------------------------------------------------------
  
  gg_doc_suctions = plot_doc_suctions(doc),
  # gg_doc_fullcore = plot_doc_fullcore(doc),
  
  gg_doc_fullcore_intact = plot_doc_fullcore_intact2(doc),
  gg_doc_fullcore_homo = plot_doc_fullcore_homo(doc),

  # III. stats -------------------------------------------------------------------
  aov_doc_all = compute_lme_doc_overall(doc),
  aov_doc_intact = compute_aov_flux_intact(doc),
  
  # IV. report ------------------------------------------------------------------
  
  report1 = rmarkdown::render(
    knitr_in("reports/doc_drake_md_report.Rmd"),
    #  output_file = file_out("drake_md_report.md"))
    #      output_format = rmarkdown::html_document(toc = TRUE))
    output_format = rmarkdown::github_document()),
  
#  report2 = rmarkdown::render(
#    knitr_in("reports/results.Rmd"),
#    output_format = rmarkdown::github_document())
  
  # ----- ---------------------------------------------------------------------
)

make(doc_plan, lock_cache = F)
