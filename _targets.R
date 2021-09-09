library(targets)
library(tarchetypes)

# General pipeline settings -----------------------------------------------

options(tidyverse.quiet = TRUE,
        dplyr.summarise.inform = FALSE)

set.seed(4393)  # From random.org


# R functions -------------------------------------------------------------

# source("R/whatever.R")

# here::here() returns an absolute path, which then gets stored in tar_meta and
# becomes computer-specific (i.e. /Users/andrew/Research/blah/thing.Rmd).
# There's no way to get a relative path directly out of here::here(), but
# fs::path_rel() works fine with it (see
# https://github.com/r-lib/here/issues/36#issuecomment-530894167)
here_rel <- function(...) {fs::path_rel(here::here(...))}


# Pipeline ----------------------------------------------------------------

list(
  # Knit the README
  tar_render(readme, here_rel("README.Rmd"), output_options = list(html_preview = FALSE))
)
