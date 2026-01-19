# GLMs (generalized linear models) allow modeling non-normal dependent variables
# with non-linear models.
#
# Unlike linear models, where the model is fit to the outcome directly, in GLMs
# the model is fit to some function of the outcome - f(outcome) - where this
# function is called the "link function".
#
# These link function can make interpretation of the models a bit less
# straightforward, but we will demonstrate how to do just this in the two most
# common GLMs: binomial (logistic) regression and Poisson regression.
#
# Another difference is that GLMs do not use OLS to fit the model's parameters,
# instead using maximum likelihood  methods, which are unique for each type of
# outcome. In general, the maximum likelihood method measure of the
# probability of observing a set of data given the values of the parameters.

# You can see a list of families and link functions provided by R (but there are
# many more!)
?family

# Suggested reading: Chapter 15 in Fox, J. (2015). Applied regression analysis
# and generalized linear models. Sage Publications.

library(dplyr)
library(ggplot2)

library(parameters)
library(performance)
library(marginaleffects)

depression_language <- read.csv("depression_language.csv") |>
  mutate(is.depressed = factor(is.depressed))
head(depression_language)

# The variables:
#              is.depressed : is the participant depressed?
#   neg_emotion_words_count : In a free association task, how many negative
#                             words were used?
#              mean_valence : In a free association task, how positive were the
#                             words on average?

# 1. Binomial Regression --------------------------------------------------

# In this example we will explore a binomial regression model, which is suitable
# for binary outcomes. The most common link function for modeling such data is
# the logit function, which is why most often people just call this type of
# model "logistic regression", where:
#
# eta ~ a + b * X
#
# and
#
# Pr(DV==1) = (1 / (1 + exp(-eta)))
# which is the same as
# P(DV==1) = exp(eta) / (1 + exp(eta))
#
# log(Pr(DV==1)/Pr(DV==0)) = eta
#
# When comparing two probabilities or odds, the ratio between the odds is called
# the OR (Odds Ratio), which is what is usually reported for comparisons.

# we will try to predict depression from mean_valence

## I. Fit the model --------------------------------------------------------

fit <- glm(
  is.depressed ~ mean_valence,
  family = binomial(link = "logit"), # we need to specify the family!
  data = depression_language
)

### Interpreting coefficients -----------------------------------------

model_parameters(fit)
# eta = 2.76 + -0.48 * mean_valence
#
# P(is.depressed==1) = 1 / (1 + exp(-eta))
#                    = 1 / (1 + exp(-(2.76 - 0.48 * mean_valence)))
#
# So someone with a valance of 6 (around the median) will have:
# eta = 2.76 + -0.48 * mean_valence = 2.76 + -0.48 * 6 = -0.12
# P(is.depressed==1) = 1 / (1 + exp(-(-0.12))) = 0.4729

# We can use the `plogis()` function to convert eta to P(y==1):
plogis(2.76 + -0.48 * 6)
predict(fit, newdata = data.frame(mean_valence = 6), type = "response")
exp(-0.48)
model_parameters(fit, exponentiate = TRUE)
# Which is the same as: coef(fit) |> exp()
# When the valance is 0 (as negative as possible), the odds of being depressed
# are 15.8, or P(y==depressed) = 15.8 / (1 + 15.8) = 0.94! For every increase in
# one unit of mean valence, the odds INCREASE by a factor of 0.62 (or DECREASE
# by a factor of 1/0.62)

# We can also use the `qlogis()` to convert P(y==1) to eta:
qlogis(0.94)

# As in linear regression, we can use standardized coefficients (but why?)
model_parameters(fit, standardize = "basic")
model_parameters(fit, standardize = "basic", exponentiate = TRUE)
# Note that the standardization is only on the predictors, as the outcome
# variable is binary and has no scale! (Yes... This is very tricky stuff) - so
# the standardized coefficient represents the change in the *logit* variable
# after a change in 1 SD of X. This has a different interpretation than the
# classic "beta", but still allows for comparing between predictors.

### Model performance -------------------------------------------

model_performance(fit)
# These are slightly different indices than from linear models...
# For example, since the predictor has not variance, `R2_Tjur` isn't really a
# measure of variance explained.

# You can read more about these in the function's documentation.

# Since logistic models can also be used as classifiers, we can also look at ROC
# curves (with the `pROC` package), a confusion matrix (with the `yardstick`
# package), and more...
#
# We will meet in depth these concepts of prediction and classification next
# semester in the Machine Learning module.

### Predicted values: on the link vs response scale ------------------------

# The function `predict` returns the result of the linear part of the model.
# That is, it returns the values of the logit, eta:
predict(fit)

# For predictions on the response scale - the transformed eta values - that it
# the P(y==1):
predict(fit, type = "response")


## II. Explore the model ---------------------------------------------------
## Follow-up analyses: on the link vs response scale

# We have the same link/response problem when conducting follow-up analyses
# (contrasts, simple slopes, simple effects, etc.). We will usually prefer to
# look at the response scale, as this is usually what we're interested in (who
# cares about the log of the odds??).

# marginaleffects plots the response scale by default:
plot_predictions(fit, condition = "mean_valence") +
  coord_cartesian(ylim = c(0, 1))

# But we can also look at the link scale (log-odds)
plot_predictions(fit, condition = "mean_valence", type = "link") +
  labs(y = expression(eta))
# Why is this line straight?
# Because the relationship between mean_valence and eta is linear!

# Note that change in odds are easier to interpret when the predictor is
# categorical, where we can compare groups. But for continuous predictors, we
# need to use the **pick-a-point** / models as prediction machines to see the
# change between the two points!

# We can get predicted values on the response scale with `marginaleffects`:
predictions(fit, newdata = datagrid(mean_valence = c(4, 5)))

# # If we want the log-odds (for some reason?)
# predictions(fit, newdata = datagrid(mean_valence = c(4, 5)), type = "link")

# # If we want the odds (for some reason?)
# predictions(
#   fit,
#   newdata = datagrid(mean_valence = c(4, 5)),
#   transform = effectsize::probs_to_odds
# )

# Compare probabilities between two points on the predictor:
avg_comparisons(fit, variables = list(mean_valence = c(4, 5)))

# # Or in terms of odds ratios (OR) (again, why?)
# avg_comparisons(
#   fit,
#   variables = list(mean_valence = c(4, 5)),
#   type = "link", # compare on the link scale
#   transform = "exp" # then transform to get OR
# )

# In terms of probabilities (default):
avg_slopes(fit, variables = "mean_valence")

# Compare to the log-odds link - very hard to interpret:
avg_slopes(fit, variables = "mean_valence", type = "link")

# 2. Poisson Regression ---------------------------------------------------

# The Poisson distribution is characterized by the rate parameter, which
# represents the expected number of occurrences of an event in a given variable
# (usually given time period).Poisson regression is suitable for count outcomes,
# and the link function is:
#
# eta = a + b * X
#
# and
#
# rate = exp(eta)

fit2 <- glm(
  neg_emotion_words_count ~ is.depressed,
  family = poisson(link = "log"), # family!
  data = depression_language
)

model_parameters(fit2)
# eta = 2.14 - 0.15 * is_depressed
# rate = exp(eta)
#
# For is.depressed = 0:
# rate = exp(2.14) = 8.49
# For is.depressed = 1:
# rate = exp(2.14 - 0.15 * 1) = 7.31

predict(
  fit2,
  newdata = data.frame(is.depressed = c("0", "1")),
  type = "response"
)


# Here too we can exponentiate (with `exp()`) these results, or we can directly
# ask `model_parameters()` to do that for us, to get the IRR: the IRR (Incidence
# Rate Ratio) is the ratio of two rates, which is what is usually reported for
# comparisons.
model_parameters(fit2, exponentiate = TRUE)
# The difference between the two groups in negative emotion words count is a
# factor of 0.86, or a decrease of 14%!

# Here too the standardization is only on the predictors, as the outcome in not
# on an arbitrary scale!
# model_parameters(fit2, standardize = "basic")
# model_parameters(fit2, standardize = "basic", exponentiate = TRUE)

model_performance(fit2)

plot_predictions(fit2, condition = "is.depressed") +
  expand_limits(y = 0)

# Even MORE ---------------------------------------------------------------

# Logistic and Poisson regression models are the most popular GLMs in
# psychology, but they are by no means the only ones! There are models for
# *ordinal* outcomes, for *truncated* outcomes, for *reaction times*, and more
# and more and more...
#
# See a short review of the different outcomes and their corresponding models
# and packages: https://strengejacke.github.io/mixed-models-snippets/overview_modelling_packages
# and for RTs: https://lindeloev.github.io/shiny-rt/
