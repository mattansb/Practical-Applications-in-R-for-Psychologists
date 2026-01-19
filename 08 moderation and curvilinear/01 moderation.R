library(dplyr)
library(ggplot2)
library(datawizard) # for `center()`

library(parameters)
library(performance) # for `compare_performance()`
library(bayestestR) # for `bayesfactor_models()`
library(marginaleffects) # for simple slope analysis and model plotting

parental_iris <- read.csv("parental_iris.csv")

glimpse(parental_iris)
head(parental_iris)

# Last time we saw that R doesn't need you to make dummy variables - if can deal
# with factors just fine. Today we will see that this is also true for
# moderation and interactions!
# (I will not be showing how to do these the long way...)

# Categorical moderator ---------------------------------------------------

# Let's prep the data for modeling:
parental_iris <- parental_iris |>
  mutate(
    attachment = relevel(factor(attachment), ref = "secure"),
    involvement_c = center(parental_involvement)
  )
# Here we want to center the variable around 0.
# It does reduce some local co-linearity, but not global co-linearity.

## 1. Fit the model(s) ----------------------------------------------------

m_additive <- lm(
  child_satisfaction ~ involvement_c + attachment,
  data = parental_iris
)


# all you need is to tell R to add an interaction!
m_moderation <- lm(
  child_satisfaction ~ involvement_c + attachment + involvement_c:attachment,
  data = parental_iris
)
# or use `*` -- A * B = A + B + A:B
m_moderation <- lm(
  child_satisfaction ~ involvement_c * attachment,
  data = parental_iris
)


# Does the model with an interaction have a better fit?
compare_performance(m_additive, m_moderation)
anova(m_additive, m_moderation)
bayesfactor_models(m_moderation, denominator = m_additive)


# Look at the parameters. What do they mean?
model_parameters(m_moderation)


## 2. Explore the model  --------------------------------------------------
# simple slope analysis!

# We don't (just) care about the model's parameters - what we usually care about
# are the different estimates the model can give us - the simple (conditional)
# slopes:
(mfx_inv <- avg_slopes(
  m_moderation,
  variables = "involvement_c",
  by = "attachment",

  newdata = datagrid(attachment = levels, grid_type = "counterfactual")
))
# We can see that the slope of involvement on satisfaction is significant for
# all attachment styles.

# But we can also use contrasts here to COMPARE slopes:
hypotheses(mfx_inv, hypothesis = ~pairwise)


# the difference between the conditional slope of secure attachment to anxious
# is 0.206 (not significant), etc...
?hypotheses


## Plot
plot_predictions(m_moderation, condition = c("involvement_c", "attachment")) +
  geom_point(
    aes(involvement_c, child_satisfaction, color = attachment),
    data = parental_iris,
  )


# Continuous moderator ----------------------------------------------------

## Prep the data
parental_iris <- parental_iris |>
  mutate(strictness_c = center(parental_strictness))


## 1. Fit the model(s) ----------------------------------------------------

m_additive <- lm(
  child_satisfaction ~ involvement_c + strictness_c,
  data = parental_iris
)

m_moderation <- lm(
  child_satisfaction ~ involvement_c * strictness_c,
  data = parental_iris
)

# compare models:
compare_performance(m_additive, m_moderation)
anova(m_additive, m_moderation)
bayesfactor_models(m_additive, m_moderation)


# Look at the parameters. What do they mean?
model_parameters(m_moderation)


## 2. Explore the model  --------------------------------------------------
# simple slope analysis!

### A. Probe with a function --------
avg_slopes(
  m_moderation,
  variables = "involvement_c",
  by = "strictness_c",
  newdata = datagrid(strictness_c = mean_sd, grid_type = "counterfactual")
)

# Or...
avg_slopes(
  m_moderation,
  variables = "involvement_c",
  by = "strictness_c",
  newdata = datagrid(strictness_c = fivenum, grid_type = "counterfactual")
)


plot_predictions(
  m_moderation,
  condition = list("involvement_c", "strictness_c" = mean_sd)
)

### B. Pick-a-point --------
# We can also ask for specific values at which to probe:

avg_slopes(
  m_moderation,
  variables = "involvement_c",
  by = "strictness_c",

  # Probe when `strictness_c` is -4, 78
  newdata = datagrid(strictness_c = c(-4, 78), grid_type = "counterfactual")
)

plot_predictions(
  m_moderation,
  condition = list("involvement_c", "strictness_c" = c(-4, 78)),
  points = 1
)


# Once again, note that in R, model fitting and hypothesis testing are not as
# closely knit as they are in SPSS. For simple slope analysis, in SPSS, we would
# re-fit new models for each simple slope, in R we instead (1) fit a model, (2)
# test the simple slope of interest.

# Why then do we center predictors? -------------------------------------------

# Let's fit the same moderation model with the original *non-centered*
# predictors. How does it differ from the moderation model with the centered
# predictors? How do the parameters differ? How does the model fit (R^2) differ?
# How do the simple slopes analysis differ?

m_moderation2 <- lm(
  child_satisfaction ~ parental_involvement * parental_strictness,
  data = parental_iris
)

model_parameters(m_moderation)
model_parameters(m_moderation2)
# We can see that the intercept and simple slopes are different in value and
# significance, but the interaction terms are not.

compare_performance(m_moderation, m_moderation2)
# We can see that the models have *identical* fit!

avg_slopes(
  m_moderation,
  variables = "involvement_c",
  by = "strictness_c",

  newdata = datagrid(strictness_c = mean_sd, grid_type = "counterfactual")
)

avg_slopes(
  m_moderation2,
  variables = "parental_involvement",
  by = "parental_strictness",

  newdata = datagrid(
    parental_strictness = mean_sd,
    grid_type = "counterfactual"
  )
)
# We can see that the simple slopes (and their tests) are identical!

# Though you might have been told that centering reduces co-linearity, this is
# not really true* - we saw that the model's performance was not affected by the
# non-centered variables, and the simple slope analysis gave the same results as
# well. Then why do we *do* we center? To make regression tables interpretable;
# centering make the coefficients conditional on the mean.
#
# * It does reduce some local co-linearity, but not global co-linearity.
#   Read more here: https://dx.doi.org/10.1177%2F0013164418817801

# Categorical by Categorical ----------------------------------------------

# What about a categorical variable moderating the effect of another categorical
# variable? We can do that just the same! We will see more of this in a few
# weeks, when we talk about ANOVAs...

# More syntax --------

# Johnson-Neyman plot ----------------------------------------------------

# The `modelbased::estimate_slopes()` function can be used to plot a
# Johnson-Neyman plot.
# What does it do? (Hint, read the axis titles.)

slope_grid <- modelbased::estimate_slopes(
  m_moderation,
  trend = "involvement_c",
  by = "strictness_c",
  length = 201
)
plot(slope_grid)

# See also:
?plot_slopes

# In a moderation model, a Johnson-Neyman plot gives the region of significance
# across the moderating variable. On the y-axis we have the size of the slope as
# a function of the moderator (which is on the x-axis). We can see the at low
# levels of Strictness (< -0.5) Involvment has a positive slope on Satisfaction,
# while at extreme large values of Strictness (>2) Involvment has a negative
# slope on Satisfaction.
