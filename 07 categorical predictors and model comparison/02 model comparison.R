library(tidyverse)

library(parameters)
library(performance) # for model comparison
library(bayestestR) # for Bayesian model comparison with BICs

anxiety_adhd <- read.csv("anxiety_adhd.csv") |>
  mutate(
    ID = factor(ID),
    treat_group = factor(treat_group),
    sex = factor(sex)
  )


# When working with categorical predictors that produce more than 1 dummy
# variable, it is hard to infer the over all effect of the categorical variable.
# To do this, we can ask about the additional variance explained by all the
# dummy variables combined by comparing models with or without this predictor
# term.

# Testing (hierarchical) --------------------------------------------------

# Model comparison in R is pretty straight forward:
# 1) Build your models.
fit1 <- lm(anxiety ~ sex, data = anxiety_adhd)
fit2 <- lm(anxiety ~ sex + ADHD_symptoms, data = anxiety_adhd)
fit3 <- lm(anxiety ~ sex + ADHD_symptoms + treat_group, data = anxiety_adhd)

# 2) Compare with the `anova()` function.
anova(fit1, fit2, fit3)
# Note - only supports nested models.

compare_performance(fit1, fit2, fit3) # get some model indices

# NOTE - how do we calculate AIC/BIC?
# Akaike Information Criterion (AIC) = 2K-2(log-likelihood)
# Bayesian Information Criterion(BIC) = K*log(n)-2(log-likelihood)
# That means that BIC penalized more than AIC (for n>7, log(n)>2)

# For forward/backward step-wise regression, see `drop1`, `add1`.
# You might also be interested in `stepAIC` from the `MASS` package.

# "Bayesian" model comparison -----------------------------------------------

# Bayesian model comparison works similarly, but we use Bayes factors instead of
# p-values, and we are not limited to comparing nested models.

# There are a few ways to get Bayes factors. Here we will be looking at the BIC
# approximation, where BF12 = exp((BIC2-BIC1)/2)

bayesfactor_models(fit2, fit3, denominator = fit1)
bayesfactor_models(fit3, denominator = fit2) # etc...


# We also aren't limited to comparing nested models:
fit4 <- lm(anxiety ~ sex + treat_group, data = anxiety_adhd)

(BFs_sex_models <- bayesfactor_models(fit1, fit3, fit4, denominator = fit2))
# What is the worst model?

fit0 <- lm(anxiety ~ 1, data = anxiety_adhd) # what's this?
fit5 <- lm(anxiety ~ treat_group, data = anxiety_adhd)

(BFs_all_models <- bayesfactor_models(
  fit1,
  fit2,
  fit3,
  fit4,
  fit5,
  denominator = fit0
))

# For more Bayesian modeling, check out rstanarm and brms packages.
# https://mc-stan.org/rstanarm/
# https://paulbuerkner.com/brms/
