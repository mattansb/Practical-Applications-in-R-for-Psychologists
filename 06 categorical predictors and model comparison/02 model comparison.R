
library(dplyr)
library(parameters)


anxiety_adhd <- read.csv("anxiety_adhd.csv") |>
  mutate(ID = factor(ID),
         treat_group = factor(treat_group),
         sex = factor(sex))


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
anova(fit1, fit2, fit3) # note - only supports nested models.
performance::compare_performance(fit1, fit2, fit3) # get some model indices


# For forward/backward step-wise regression, see `drop1`, `add1`.
# You might also be interested in `stepAIC` from the `MASS` package.





# Bayesian model comparison -----------------------------------------------


# Bayesian model comparison works similarly, but we use Bayes factors instead of
# p-values, and we are not limited to comparing nested models.

# There are a few ways to get Bayes factors. Here I will be showing the BIC
# approximation, where BF12 = exp((BIC2-BCI1)/2)

library(bayestestR)

bayesfactor_models(fit2, fit3, denominator = fit1)

bayesfactor_models(fit3, denominator = fit2) # etc...





# We also aren't limited to comparing nested models:
fit4 <- lm(anxiety ~ sex + treat_group, data = anxiety_adhd)

(BFs_sex_models <- bayesfactor_models(fit2, fit3, fit4, denominator = fit1))
# What is the worst model?




fit0 <- lm(anxiety ~ 1, data = anxiety_adhd)
fit5 <- lm(anxiety ~ treat_group, data = anxiety_adhd)

(BFs_all_models <- bayesfactor_models(fit1, fit2, fit3, fit4, fit5, denominator = fit0))









# We can also use Bayesian model averaging (BMA) to test terms specifically, not
# just by comparing 2 specific models:
bayesfactor_inclusion(BFs_sex_models, match_models = TRUE)
bayesfactor_inclusion(BFs_all_models, match_models = TRUE)
# which terms are most supported?
# which terms are least supported?



# read more about Bayesian model averaging:
# https://easystats.github.io/bayestestR/articles/bayes_factors.html




# For more Bayesian modeling, check out rstanarm and brms packages.
# However, note that full-on Bayesian modelling is hard - if all you want is to
# accept the null (H0), there are other ways to do it!






# Exercise ----------------------------------------------------------------

# 1. Import the "Exp_Psych_Grades.csv" dataset
#   - Group     - the group number
#   - in_couple - work was done in pairs or singles
#   - TA        - (anonimized) "Metargelet"
#   - DOI       - part of the grade
#   - OSF       - part of the grade
#   - Report    - final grade on the paper
#   - Test      - final grade on the test (averaged across the pair)
# 2. Predict `Report` grade from `Test` grade.
# 3. Predict the final Report grade from `Test` and `TA`.
# 4. Is there some variation between the TAs (when controlling for `Test`)?
#   (compare the two models.)
# 5. Explore the second model:
#   - Which TA gave the highest grades on average? (What was it?)
#   - Which gave the lowest? (What was it?)
#   - Is the difference between them significant?
# 6. Fit a third model, predicting `Report` grade from the `TA`, `Test` and
#    `in_couple`. Is it better to do the project alone or in a couple?
# 7. Compare all 3 models - which has the biggest adjusted R2?
