library(dplyr)
library(parameters)
library(performance)
library(interactions)
library(emmeans)

parental_iris <- read.csv("parental_iris.csv") %>%
  mutate(
    # center parental_involvement
    involvement_c = scale(parental_involvement, TRUE, FALSE),
    # center parental_strictness
    strictness_c = scale(parental_strictness, TRUE, FALSE),
  )


# 1. Fit the following moderation model -----------------------------------

#    child_satisfaction ~ parental_involvement * parental_strictness (uncentered!)
fit_centered <- lm(child_satisfaction ~ involvement_c * strictness_c,
                   data = parental_iris)
fit_uncentered <- lm(child_satisfaction ~ parental_involvement * parental_strictness,
                     data = parental_iris)


# 2. How does it differ from the moderation model with the centere --------

#    A. How do the parameters differ?
model_parameters(fit_centered)
model_parameters(fit_uncentered)
# The simple slopes differ in their value, SE, and significance.
# But the interaction term does not differ between the models!

#    B. How does the model fit (R^2) differ?
compare_performance(fit_centered, fit_uncentered)
# They don't differ at all! The models explain the same % of variance!

#    C. How does the simple slopes analysis differ?
sim_slopes(fit_centered, pred = involvement_c, modx = strictness_c)
sim_slopes(fit_uncentered, pred = parental_involvement, modx = parental_strictness)
# They also do not differ - not in slope and not in SE or significance!


# 3. Using the `interactions` package ----------------------------------------

#    A. Plot an interaction plot (`interact_plot`).
interact_plot(fit_uncentered, pred = parental_involvement, modx = parental_strictness,
              interval = TRUE)

#    B. Plot a Johnson-Neyman plot (`johnson_neyman`). What does it do?
johnson_neyman(fit_uncentered, pred = parental_involvement, modx = parental_strictness)


# *. Do the simple slopes analysis with `emmeans`. ------------------------

# We need a function that makes c(M - SD, M, M + SD)
mean_sd <- function(x){
  M <- mean(x, na.rm = TRUE)
  S <- sd(x, na.rm = TRUE)

  c(M - S, M, M + S)
}

# 1. Continuous * Continuous
emtrends(fit_uncentered, var = "parental_involvement", specs = "parental_strictness",
        cov.reduce = mean_sd) %>%
  summary(infer = TRUE)

# 2. Categorical * Continuous
# Fit the model:
fit2 <- lm(child_satisfaction ~ parental_involvement * attachment,
           data = parental_iris)
#  A. Categorical moderator
emtrends(fit2, var = "parental_involvement", specs = "attachment") %>%
  summary(infer = TRUE)

# difference between slopes!
emtrends(fit2, var = "parental_involvement", specs = "attachment") %>%
  contrast("pairwise") %>%
  summary(infer = TRUE)

#  B. Continuous moderator (THIS IS ADVANCED!)
emmeans(fit2, specs = c("attachment", "parental_involvement"),
        cov.reduce = mean_sd) %>%
  contrast("pairwise", by = "parental_involvement") %>%
  summary(infer = TRUE)

