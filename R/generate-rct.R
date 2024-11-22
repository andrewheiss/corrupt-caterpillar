make_rct <- function(n, seed) {
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

    # Generate treatment variable
    # lol this is so easy compared to the full observational DAG
    mutate(treatment = rbinom(n, 1, 0.5)) |> 

    # Generate mediator
    mutate(community_connections = rpois(n, lambda = 3 + 2.75 * treatment)) |> 

    # Generate outcome
    mutate(
      prosocial_base = 
        50 +  # OLS intercept
        0.45 * social_awareness +
        0.6 * (age - 25) +
        3.3 * (gpa - 3.25) +
        0.0002 * (income - 40000) +
        9.7 * treatment +
        1.3 * community_connections,  # Mediator
      prosocial_index = pmin(pmax(prosocial_base + rnorm(n, 0, 6), 0), 100)
    ) |> 

    # Generate collider
    mutate(
      employed_logit = 
        -23 +
        1.3 * treatment +
        0.25 * prosocial_index,
      employed_prob = plogis(employed_logit),
      employed_nonprofit = rbinom(n, 1, employed_prob)
    )
  })

  simulated_data <- simulated_data_raw |> 
    mutate(
      across(c(prosocial_index, social_awareness, age), 
      \(x) as.integer(round(x, 0)))
    ) |> 
    mutate(
      gpa = round(gpa, 2),
      income = as.integer(signif(income, 3))
    ) |> 
    select(
      id, experiential_learning = treatment, prosocial_index, 
      social_awareness, age, gpa, income, 
      community_connections, employed_nonprofit
    )

  return(simulated_data)
}
