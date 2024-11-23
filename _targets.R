library(targets)
library(tarchetypes)

# General pipeline settings -----------------------------------------------
options(
  tidyverse.quiet = TRUE,
  dplyr.summarise.inform = FALSE
)

set.seed(4393)  # From random.org

# This hardcodes the absolute path in _targets.yaml, so to make this more
# portable, we rewrite it every time this pipeline is run (and we don't track
# _targets.yaml with git)
tar_config_set(
  store = here::here("_targets"),
  script = here::here("_targets.R")
)

# Global target options
tar_option_set(
  packages = c("tidyverse"),  # Packages available to all targets
  format = "qs",  # Storage format
  workspace_on_error = TRUE  # Automatically create a debug workspace on errors
)


# R functions -------------------------------------------------------------

# here::here() returns an absolute path, which then gets stored in tar_meta and
# becomes computer-specific (i.e. /Users/andrew/Research/blah/thing.Rmd).
# There's no way to get a relative path directly out of here::here(), but
# fs::path_rel() works fine with it (see
# https://github.com/r-lib/here/issues/36#issuecomment-530894167)
here_rel <- function(...) {fs::path_rel(here::here(...))}

# Load all the scripts in the R/ folder that contain the functions to be used in
# the pipeline
tar_source()

# Set some conditional flags
should_deploy <- identical(Sys.getenv("UPLOAD_WEBSITES"), "TRUE")


# Pipeline ----------------------------------------------------------------

list(
  
  ## Helper functions ----
  tar_target(graphic_functions, lst(
    register_fonts, set_annotation_fonts,  
    theme_np, theme_np_dag, 
    clrs, get_latex_rgb, print.color_table)
  ),

  ## Data generation ----
  tar_target(data_observational, make_observational(n = 1135, seed = 536406)),
  tar_target(data_rct, make_rct(n = 1328, seed = 180295)),
  tar_target(data_did, make_diff_in_diff(n_per_school_year = 126, seed = 417724)),
  tar_target(data_rdd_sharp, make_rdd(n = 967, seed = 635404, fuzzy = FALSE)),
  tar_target(data_rdd_fuzzy, make_rdd(n = 992, seed = 995303, fuzzy = TRUE)),
  tar_target(data_iv, make_iv(n = 914, seed = 266416)),

  ## Save data -----
  # TODO: Use static/dynamic branching here instead of this gross repetitive mess
  tar_target(
    data_observational_rds, 
    save_r(data_observational, here_rel("data", "simulated_data", "observational.rds")),
    format = "file"
  ),
  tar_target(
    data_observational_csv, 
    save_csv(data_observational, here_rel("data", "simulated_data", "observational.csv")),
    format = "file"
  ),
  tar_target(
    data_observational_dta, 
    save_dta(data_observational, here_rel("data", "simulated_data", "observational.dta")),
    format = "file"
  ),
  tar_target(
    data_rct_rds, 
    save_r(data_rct, here_rel("data", "simulated_data", "rct.rds")),
    format = "file"
  ),
  tar_target(
    data_rct_csv, 
    save_csv(data_rct, here_rel("data", "simulated_data", "rct.csv")),
    format = "file"
  ),
  tar_target(
    data_rct_dta, 
    save_dta(data_rct, here_rel("data", "simulated_data", "rct.dta")),
    format = "file"
  ),
  tar_target(
    data_did_rds, 
    save_r(data_did, here_rel("data", "simulated_data", "did.rds")),
    format = "file"
  ),
  tar_target(
    data_did_csv, 
    save_csv(data_did, here_rel("data", "simulated_data", "did.csv")),
    format = "file"
  ),
  tar_target(
    data_did_dta, 
    save_dta(data_did, here_rel("data", "simulated_data", "did.dta")),
    format = "file"
  ),

  ## Manuscript targets ----
  tar_quarto(manuscript, path = "manuscript", working_directory = "manuscript", quiet = FALSE),

  ## Website targets ----
  tar_quarto(website, path = ".", quiet = FALSE),

  tar_target(deploy_script, here_rel("deploy.sh"), format = "file", cue = tar_cue_skip(!should_deploy)),
  tar_target(deploy, {
    # Force a dependency
    website
    # Run the deploy script
    if (should_deploy) processx::run(paste0("./", deploy_script))
  }, cue = tar_cue_skip(!should_deploy)),

  ## Render the README ----
  tar_quarto(readme, here_rel("README.qmd"))
)
