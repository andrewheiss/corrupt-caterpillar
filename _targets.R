library(targets)
library(tarchetypes)

# General pipeline settings -----------------------------------------------
csl <- "pandoc/csl/apa.csl"
bibstyle <- "bibstyle-apa"

options(tidyverse.quiet = TRUE,
        dplyr.summarise.inform = FALSE)

set.seed(4393)  # From random.org


# R functions -------------------------------------------------------------

# source("R/whatever.R")
source("R/funs_knitting.R")

# here::here() returns an absolute path, which then gets stored in tar_meta and
# becomes computer-specific (i.e. /Users/andrew/Research/blah/thing.Rmd).
# There's no way to get a relative path directly out of here::here(), but
# fs::path_rel() works fine with it (see
# https://github.com/r-lib/here/issues/36#issuecomment-530894167)
here_rel <- function(...) {fs::path_rel(here::here(...))}


# Pipeline ----------------------------------------------------------------

list(

  ## Manuscript targets ------------------------------------------------------

  # tarchetypes::tar_render() automatically detects target dependencies in Rmd
  # files and knits them, but there's no easy way to pass a custom rendering
  # script like bookdown::html_document2(), so two things happen here:
  #   1. Set a file-based target with tar_target_raw() and use tar_knitr_deps()
  #      to detect the target dependencies in the Rmd file
  #   2. Use a bunch of other file-based targets to actually render the document
  #      through different custom functions
  tar_target(bib_file,
             here_rel("manuscript", "bibliography.bib"),
             format = "file"),
  
  tar_target_raw("main_manuscript", here_rel("manuscript", "manuscript.Rmd"),
                 format = "file",
                 deps = c("bib_file",
                          tar_knitr_deps(here_rel("manuscript", "manuscript.Rmd")))),
  tar_target(html,
             render_html(
               input = main_manuscript,
               output = here_rel("manuscript", "output", "manuscript.html"),
               csl = csl,
               bib_file,
               support_folder = "output/html-support"),
             format = "file"),
  tar_target(pdf,
             render_pdf(
               input = main_manuscript,
               output = here_rel("manuscript", "output", "manuscript.pdf"),
               bibstyle = bibstyle,
               bib_file),
             format = "file"),
  tar_target(ms_pdf,
             render_pdf_ms(
               input = main_manuscript,
               output = here_rel("manuscript", "output", "manuscript-ms.pdf"),
               bibstyle = bibstyle,
               bib_file),
             format = "file"),
  tar_target(docx,
             render_docx(
               input = main_manuscript,
               output = here_rel("manuscript", "output", "manuscript.docx"),
               csl = csl,
               bib_file),
             format = "file"),
  tar_target(bib,
             extract_bib(
               input_rmd = main_manuscript,
               input_bib = bib_file,
               output = here_rel("manuscript", "output", "extracted-citations.bib")),
             format = "file"),
  
  # Always show a word count
  tar_target(word_count, count_words(html)),
  tar_force(show_word_count, print(word_count), TRUE),
  
  # Knit the README
  tar_render(readme, here_rel("README.Rmd"),
             output_options = list(html_preview = FALSE))
)
