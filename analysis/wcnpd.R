library(tidyverse)
library(here)

source(here("R", "graphics.R"))
clrs_np <- np_palette()

articles <- read_csv(here("data", "manual_data", "Skimming notes_coding.csv"))

nvsq_counts <- read_csv(here("data", "manual_data", "nvsq_counts.csv"))

nvsq_counts_year <- nvsq_counts |> 
  filter(Year <= 2020) |> 
  # filter(Year <= 2021 & !(Year == 2021 & Issue > 3)) |> 
  # mutate(Year = recode(Year, "2021" = 2020)) |> 
  group_by(Year) |> 
  summarize(total = sum(Count))

plot_data <- articles |> 
  filter(year <= 2020) |> 
  # mutate(year = recode(year, "2021" = 2020)) |> 
  count(year) |> 
  left_join(nvsq_counts_year, by = c("year" = "Year")) |> 
  mutate(pct = n / total)

nvsq_count <- ggplot(plot_data, aes(x = factor(year), y = n)) +
  geom_col(fill = clrs_np$orange) +
  labs(x = NULL, y = "Number of articles", 
       title = "Count of quantitative nonprofit-focused articles\nthat make an explicit causal claim",
       subtitle = "Articles published between 2010–2020 in NVSQ\n(Voluntas, NML, PAR, JPART, JPAM, and PMR forthcoming)",
       caption = "Article uses an experiment, difference-in-differences, regression discontinuity,\ninstrumental variables, or other method for statistically identifying a causal mechanism") +
  theme_np() +
  theme(panel.grid.major.x = element_blank())
nvsq_count
ggsave(here("analysis", "output", "nvsq_count.png"), nvsq_count,
       width = 19/2, height = 9/2, units = "in",
       device = ragg::agg_png, res = 300)

nvsq_pct <- ggplot(plot_data, aes(x = factor(year), y = pct)) +
  geom_col(fill = clrs_np$purple) +
  labs(x = NULL, y = "Percent of articles", 
       title = "Proportion of quantitative nonprofit-focused articles\nthat make an explicit causal claim",
       subtitle = "Articles published between 2010–2020 in NVSQ\n(Voluntas, NML, PAR, JPART, JPAM, and PMR forthcoming)",
       caption = "Article uses an experiment, difference-in-differences, regression discontinuity,\ninstrumental variables, or other method for statistically identifying a causal mechanism") +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  theme_np() +
  theme(panel.grid.major.x = element_blank())
nvsq_pct
ggsave(here("analysis", "output", "nvsq_pct.png"), nvsq_pct,
       width = 19/2, height = 9/2, units = "in",
       device = ragg::agg_png, res = 300)
  
