# Windows fonts
register_fonts <- function() {
  if (Sys.info()["sysname"] == "Windows") {
    # Register these fonts if running R on Windows
    windowsFonts(`Assistant` = windowsFont("Assistant"))
    windowsFonts(`Assistant Light` = windowsFont("Assistant Light"))
    windowsFonts(`Assistant SemiBold` = windowsFont("Assistant SemiBold"))
  }
}


# ggplot themes -----------------------------------------------------------
set_annotation_fonts <- function() {
  ggplot2::update_geom_defaults(
    "label",
    list(family = "Assistant", fontface = "bold", color = "black")
  )
  ggplot2::update_geom_defaults(
    "text",
    list(family = "Assistant", fontface = "bold", color = "black")
  )

  if (isNamespaceLoaded("ggdag")) {
    ggplot2::update_geom_defaults(
      ggdag:::GeomDagText,
      list(family = "Assistant", fontface = "bold", color = "black")
    )
  }
}

#' theme_np
#'
#' A custom ggplot2 theme used throughout this project
#'
#' @param base_size base font size (default is 11)
#' @param base_family base font family (default is Assistant)
#'
#' @export
#'
#' @examples
#' library(ggplot2)
#'
#' ggplot(mpg, aes(x = displ, y = hwy, color = drv)) +
#'   geom_point() +
#'   labs(x = "Engine displacement", y = "Highway miles per gallon",
#'        title = "A standard graph about cars",
#'        subtitle = "Heavier cars get lower mileage",
#'        caption = "Source: A dataset included in ggplot2",
#'        color = "Drive") +
#'   theme_np()
theme_np <- function(base_size = 11, base_family = "Assistant") {
  theme_bw(base_size, base_family) + 
    theme(plot.title = element_text(size = rel(1.4), face = "bold",
                                    family = "Assistant"),
          plot.subtitle = element_text(size = rel(1), face = "plain",
                                       family = "Assistant Light"),
          plot.caption = element_text(size = rel(0.8), color = "grey50", face = "plain",
                                      family = "Assistant Light",
                                      margin = margin(t = 10), hjust = 0),
          plot.tag = element_text(size = rel(1.4), face = "bold",
                                  family = "Assistant"),
          panel.border = element_rect(color = "grey50", fill = NA, linewidth = 0.15),
          panel.spacing = unit(1, "lines"),
          panel.grid.minor = element_blank(),
          strip.text = element_text(size = rel(0.9), hjust = 0,
                                    family = "Assistant", face = "bold"),
          strip.background = element_rect(fill = "#ffffff", colour = NA),
          axis.ticks = element_blank(),
          axis.title = element_text(family = "Assistant SemiBold", face = "plain", 
                                    size = rel(0.8)),
          axis.title.x = element_text(margin = margin(t = 5)),
          axis.text = element_text(family = "Assistant Light", face = "plain"),
          legend.key = element_blank(),
          legend.title = element_text(size = rel(0.8),
                                      family = "Assistant SemiBold", face = "plain"),
          legend.text = element_text(size = rel(0.8), 
                                     family = "Assistant Light", face = "plain"),
          legend.spacing = unit(0.1, "lines"),
          legend.box.margin = margin(t = -0.25, unit = "lines"),
          legend.margin = margin(t = 0),
          legend.position = "bottom")
}

#' theme_np_dag
#'
#' A custom ggplot2 theme used for DAGs
#'
#' @param ... arguments passed to `theme_np()`
#'
#' @export
#' @md
#'
#' @examples
#' library(ggdag)
#'
#' ggdag(confounder_triangle()) +
#'   theme_np_dag()
theme_np_dag <- function(...) {
  theme_np(...) + 
    theme(axis.text = element_blank(), 
          axis.title = element_blank(), 
          axis.title.x = element_blank(), 
          axis.ticks = element_blank(),
          panel.grid = element_blank(), 
          panel.border = element_blank(),
          panel.background = element_blank())
}


# Colors ------------------------------------------------------------------

# clrs <- viridisLite::turbo(6, begin = 0, end = 1) |> 
#   purrr::set_names(c("purple", "blue", "green", "yellow", "orange", "red")) |> 
#   as.list()

# https://carto.com/carto-colors/
clrs <- list(
  Prism = rcartocolor::carto_pal(n = 12, "Prism"),
  Sunset = rcartocolor::carto_pal(7, "Sunset")
)

#' Convert colors to LaTeX RGB definitions
#'
#' Take a named list of hex colors and convert them to RGB values.
#'
#' The resulting output has the class `clrs` and will print only the LaTeX color
#' definitions by default using `print.clrs()`
#'
#' @param clrs named list of hex colors
#'
#' @return A tibble with columns for the color name, hex code, red value, green
#'   value, blue value, comma-separated RGB value, and a LaTeX color definition
#'
#' @export
#' @md
#' 
#' @example 
#' get_latex_rgb()
get_latex_rgb <- function(clrs) {
  clrs <- unlist(clrs)
  
  clrs_table <- tibble::enframe(x, name = "color_name", value = "hex") |> 
    bind_cols(as_tibble(t(col2rgb(x)))) |>
    mutate(rgb = paste(red, green, blue, sep = ", ")) |>
    mutate(latex = glue::glue("\\definecolor{<<color_name>>}{RGB}{<<rgb>>}",
                              .open = "<<", .close = ">>"))
  
  class(clrs_table) <- append("color_table", class(clrs_table))
  clrs_table
}

print.color_table <- function(x) {
  cat(x$latex, sep = "\n")
}
