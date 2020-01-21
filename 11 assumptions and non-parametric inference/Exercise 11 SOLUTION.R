
exp_grades <- read.csv("Exp_Psych_Grades.csv")
head(exp_grades)

mod <- lm(Report ~ DOI + OSF + in_couple, data = exp_grades)

# 1. What does `resid_xpanel()` do? ---------------------------------------

library(ggResidpanel)

resid_xpanel(mod)
# It plots the residuals vs. all the predictors.

# It should look like there is no relationship between them -
# any relationship (linear or other) can hint at our model missing
# some variance that can be explained.


# 2. Fit the model: Report ~ Test + in_couple -----------------------------

library(permuco)
library(parameters)

fit2 <- lm(Report ~ Test + in_couple, data = exp_grades)

# Conduct a boostrap / permutation analysis. How does this affect the results?
fit2p <- lmperm(Report ~ Test + in_couple, data = exp_grades)

fit2b <- parameters_bootstrap(fit2, ci_method = "HDI")

summary(fit2)
summary(fit2p)
fit2b

# all methods do not support the effect of `Test` being non-zero.
# The methods differ in the sig of the effect for `in_couple`:
#   - Parameteric and permutation methods give sig result.
#   - Bootstrap give marginal result.


