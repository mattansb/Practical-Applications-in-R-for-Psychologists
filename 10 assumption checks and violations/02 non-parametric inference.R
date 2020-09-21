library(permuco)    # for permutation tests
library(parameters) # for model_bootstrap


exp_grades <- read.csv("Exp_Psych_Grades.csv")
exp_grades$in_couple <- factor(exp_grades$in_couple)


# "regular" model
mod <- lm(Report ~ DOI + OSF + in_couple, data = exp_grades)
summary(mod)






# Permutation tests -------------------------------------------------------


modp <- lmperm(Report ~ DOI + OSF + in_couple, data = exp_grades)
summary(modp) # why so many p-values??






# Bootstrap estimation ----------------------------------------------------

bootstrap_parameters(mod, iterations = 599) # uses quantile CIs
# how do the permutation results and the bootstrap results differ?


# For more complex models more complex methods are required for permutation
# tests and bootstrapping (e.g., the `boot` package, which allows for
# bootstrapping estimates, e.g., from `emmeans`, and not just the model
# parameters).




