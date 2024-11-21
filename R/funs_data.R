# When using a file-based target, {targets} requires that the function that
# saves the file returns a path to the file. write_csv() and write_dta() both
# invisibly return the data frame being written, and saveRDS() returns NULL, so
# we need some wrapper functions to save the files and return the paths.
save_csv <- function(df, path) {
  readr::write_csv(df, path)
  return(path)
}

save_r <- function(df, path) {
  saveRDS(df, path)
  return(path)
}

save_dta <- function(df, path) {
  haven::write_dta(df, path)
  return(path)
}
