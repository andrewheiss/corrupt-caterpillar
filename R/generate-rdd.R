make_rdd <- function(n, seed, fuzzy = FALSE) {
  withr::with_seed(seed, {
    simulated_data_raw <- tibble(
      id = as.integer(1:n + 999)
    ) |>

      # Generate confounders
      mutate(
        social_awareness = 100 * rbeta(n, shape1 = 7, shape2 = 3),
        age = rnorm(n, mean = 25, sd = 2.5),
        gpa = pmin(pmax(rnorm(n, mean = 3.25, sd = 0.6), 2.0), 4.0),
        income = pmax(rnorm(n, mean = 40000, sd = 15000), 15000)
      ) |>

      # Generate entrance exam score (running variable)
      mutate(
        entrance_score_base = 
          65 +  # Base score
          0.15 * social_awareness +
          0.3 * (age - 25) +
          8 * (gpa - 3.25) +
          0.0001 * (income - 40000),
        entrance_score = pmin(pmax(
          entrance_score_base + rnorm(n, mean = 0, sd = 8),
          0), 100
        )
      ) |>

      # Generate treatment assignment
      mutate(
        # For fuzzy RDD, use logistic function where probabilities shift at 75
        # For sharp RDD, they're in if the score is ≥75
        treatment_prob = case_when(
          fuzzy ~ plogis(0 + 0.7 * (entrance_score - 75)),
          !fuzzy ~ as.numeric(entrance_score >= 75)
        ),
        experiential_learning = rbinom(n, 1, treatment_prob)
      ) |>

      # Generate outcome
      mutate(
        prosocial_base = 
          50 +  # Base level
          0.45 * social_awareness +
          0.6 * (age - 25) +
          3.3 * (gpa - 3.25) +
          0.0002 * (income - 40000) +
          0.15 * (entrance_score - 75) +
          8.5 * experiential_learning,  # Treatment effect!
        prosocial_index = pmin(pmax(prosocial_base + rnorm(n, 0, 6), 0), 100)
      )

    simulated_data <- simulated_data_raw |>
      mutate(
        across(c(prosocial_index, social_awareness, age, entrance_score),
               \(x) as.integer(round(x, 0))),
        gpa = round(gpa, 2),
        income = as.integer(signif(income, 3))
      ) |>
      select(
        id, entrance_score, experiential_learning, prosocial_index,
        social_awareness, age, gpa, income
      )

    return(simulated_data)
  })
}
