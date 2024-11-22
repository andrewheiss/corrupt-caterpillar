make_diff_in_diff <- function(n_per_school_year, seed) {
  withr::with_seed(seed, {
    # Make a skeleton of school-year combinations
    school_years <- expand_grid(
      school = c("School A", "School B"),
      # 3 pre-treatment years (2020-2022) and 2 post (2023-2024)
      # We'll pretend the pandemic never happend
      year = 2020:2024
    ) |> 
      # Add year-specific random offsets for each school
      group_by(school, year) |>
      mutate(year_effect = rnorm(1, mean = 0, sd = 0.2)) |> 
      ungroup()

    # Replicate each combination n times
    base_data <- school_years |>
      slice(rep(1:n(), each = n_per_school_year)) |>
      mutate(id = row_number() + 999)

    simulated_data <- base_data |>
      # Create confounders that vary a little by school, for fun
      mutate(
        social_awareness = case_when(
          school == "School A" ~ 100 * rbeta(n(), shape1 = 7, shape2 = 3),
          school == "School B" ~ 100 * rbeta(n(), shape1 = 7.2, shape2 = 2.8)
        ),
        age = case_when(
          school == "School A" ~ rnorm(n(), mean = 25, sd = 2.5),
          school == "School B" ~ rnorm(n(), mean = 25.2, sd = 2.4)
        ),
        gpa = pmin(pmax(
          case_when(
            school == "School A" ~ rnorm(n(), mean = 3.25, sd = 0.6),
            school == "School B" ~ rnorm(n(), mean = 3.28, sd = 0.58)
          ), 2.0), 4.0
        ),
        income = pmax(
          case_when(
            school == "School A" ~ rnorm(n(), mean = 40000, sd = 15000),
            school == "School B" ~ rnorm(n(), mean = 41000, sd = 14500)
          ), 15000
        )
      ) |>

      # Generate outcome
      mutate(
        prosocial_base = 
          30 +  # Intercept
          0.45 * social_awareness +
          0.6 * (age - 25) +
          3.3 * (gpa - 3.25) +
          0.0002 * (income - 40000) +

          # School fixed effect
          case_when(
            school == "School A" ~ 0,
            school == "School B" ~ 2
          ) +

          # Time trend
          1.5 * (year - 2020) +  # Base trend
          year_effect +  # Add the school-year specific noise

          # Treatment effect (only for School B in 2023-2024)
          case_when(
            school == "School B" & year >= 2023 ~ 7.8,
            TRUE ~ 0
          ),

        prosocial_index = pmin(pmax(prosocial_base + rnorm(n(), 0, 6), 0), 100)
      ) |>

      mutate(
        across(c(prosocial_index, social_awareness, age), 
               \(x) as.integer(round(x, 0))),
        gpa = round(gpa, 2),
        income = as.integer(signif(income, 3))
      ) |>
      select(
        id, school, year, prosocial_index, 
        social_awareness, age, gpa, income
      )
  })

  return(simulated_data)
}
