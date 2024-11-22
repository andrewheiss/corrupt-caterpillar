make_iv <- function(n, seed) {
  withr::with_seed(seed, {
    simulated_data_raw <- tibble(
      id = as.integer(1:n + 999)
    ) |>

      mutate(
        social_awareness = 100 * rbeta(n, shape1 = 7, shape2 = 3),
        age = rnorm(n, mean = 25, sd = 2.5),
        gpa = pmin(pmax(rnorm(n, mean = 3.25, sd = 0.6), 2.0), 4.0),
        income = pmax(rnorm(n, mean = 40000, sd = 15000), 15000)
      ) |>

      # Generate random promotion
      mutate(
        promoted = rbinom(n, 1, 0.5)
      ) |>

      # Generate treatment variable with confoudners and promotion
      mutate(
        treatment_logit = 
          -1.2 +  # Logit intercept (base rate, plogis(-1.2) = 23%)
          1.4 * promoted +  # Promotion increases the probability
          0.015 * social_awareness +
          0.08 * (age - 25) +
          0.4 * (gpa - 3.25) +
          0.00002 * (income - 40000),
        treatment_prob = plogis(treatment_logit),
        experiential_learning = rbinom(n, 1, treatment_prob)
      ) |>

      # Generate outcome
      mutate(
        prosocial_base = 
          50 +  # OLS intercept
          0.45 * social_awareness +
          0.6 * (age - 25) +
          3.3 * (gpa - 3.25) +
          0.0002 * (income - 40000) +
          11.25 * experiential_learning,  # Treatment effect
        prosocial_index = pmin(pmax(
          prosocial_base + rnorm(n, 0, 6),
          0), 100
        )
      )

    simulated_data <- simulated_data_raw |>
      mutate(
        across(c(prosocial_index, social_awareness, age),
               \(x) as.integer(round(x, 0))),
        gpa = round(gpa, 2),
        income = as.integer(signif(income, 3))
      ) |>
      select(
        id, promoted, experiential_learning, prosocial_index,
        social_awareness, age, gpa, income
      )

    return(simulated_data)
  })
}
