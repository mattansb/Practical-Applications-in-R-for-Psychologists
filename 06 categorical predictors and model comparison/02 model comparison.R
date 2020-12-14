
library(dplyr)
library(parameters)


anxiety_adhd <- read.csv("anxiety_adhd.csv") %>%
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

library(BayesFactor)
library(bayestestR)

# 1) Build your models.
fit1B <- lmBF(anxiety ~ sex, data = anxiety_adhd)
fit2B <- lmBF(anxiety ~ sex + ADHD_symptoms, data = anxiety_adhd)
fit3B <- lmBF(anxiety ~ sex + ADHD_symptoms + treat_group, data = anxiety_adhd)
fit4B <- lmBF(anxiety ~ ADHD_symptoms, data = anxiety_adhd)


# 2) Compare them:
c(fit1B, fit2B, fit3B, fit4B) # Third model looks the best, but is it?

# compare models by dividing them:
fit3B / fit2B
fit1B / fit4B
# ALWAYS remember - BFs are comparative! Who are you comparing to?







# 1) Build your models.
# generalTestBF() makes models from all combinations of specified effects:
fit_allB <- generalTestBF(
  anxiety ~ sex + ADHD_symptoms + treat_group,
  # method = "laplace", # for large sample sizes
  data = anxiety_adhd
)
fit_allB
head(fit_allB) # best models




# 2) Compare them:
fit_allB[2] # select model BF
fit_allB[3] / fit_allB[2] # new BFs comparing the two models
# etc...





# We can also use Bayesian model averaging (BMA) to test terms specifically, not
# just by comparing 2 specific models:
bayesfactor_inclusion(fit_allB, match_models = TRUE)
bayesfactor_inclusion(c(fit1B, fit2B, fit3B, fit4B), match_models = TRUE)



# which terms are most supported?
# which terms are least supported?





# read more about Bayesian model averaging:
# https://easystats.github.io/bayestestR/articles/bayes_factors.html

# For more Bayesian modeling, check out that BAS, rstanarm and brms packages.






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
# 3. Predict the final Report grade from the `Test` and `TA`.
# 4. Is there some variation between the TAs (when controlling for `Test`)?
#   (compare the two models.)
# 5. Explore the second model:
#   - Which TA gave the highest grades on average? (What was it?)
#   - Which gave the lowest? (What was it?)
#   - Is the difference between them significant?
# 6. Fit a third model, predicting `Report` grade from the `TA`, `Test` and
#    `in_couple`. Is it better to do the project alone or in a couple?
# 7. Compare all 3 models - which has the biggest adjusted R2?
