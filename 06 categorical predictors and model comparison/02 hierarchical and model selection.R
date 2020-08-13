
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



# 2) Compare them:
c(fit1B,fit2B,fit3B) # Third model looks the best, but is it?

# compare models by dividing them:
fit3B / fit2B
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
fit_allB[c(3,6,7)] / fit_allB[2] # new BFs
# etc...


plot(bayesfactor_models(fit_allB))




# We can also use Bayesian model averaging (BMA) to test terms specifically, not
# just by comparing 2 specific models:
bayesfactor_inclusion(fit_allB, match_models = TRUE)
# which terms are most supported?
# which terms are least supported?





# read more about Bayesian model averaging:
# https://easystats.github.io/bayestestR/articles/bayes_factors.html

# For more Bayesian modeling, check out brms, rstanarm or BAS.


# Exercise ----------------------------------------------------------------

# 1. import the "Exp_Psych_Grades.csv" dataset
#   - Group     - the group number
#   - in_couple - work was done in pairs or singles
#   - TA        - (anonimized) "Metargelet"
#   - DOI       - part of the grade
#   - OSF       - part of the grade
#   - Report    - final grade on the paper
#   - Test      - final grade on the test (averaged across the pair)
# 2. Predict `Report` grade from `Test` grade.
# 3. Re-level the `TA` factor so that C is first.
# 4. Predict the final Report grade from the `Test` and `TA`.
# 5. Is there a difference between the TAs? (compare the two models)
# 6. Explore the model:
#   - Who gave the highest grades?
#   - Who gave the lowest?
#   - Is the difference between them significant?
# 5. Fit a second model, predicting `Report` grade from the `TA`, `Test` and
#    `in_couple`. Is it better to do the project alone or in a couple?
# 6. Compare all 3 models - which has the biggest adjusted R2?
