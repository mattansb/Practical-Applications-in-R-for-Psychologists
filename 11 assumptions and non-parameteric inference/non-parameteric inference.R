library(permuco)    # for permutation tests
library(parameters) # for model_bootstrap

exp_grades <- read.csv("Exp_Psych_Grades.csv")
head(exp_grades)

# "regular" model
mod <- lm(Report ~ DOI + OSF + in_couple, data = exp_grades)
summary(mod)

# Permutation tests -------------------------------------------------------

modp <- lmperm(Report ~ DOI + OSF + in_couple, data = exp_grades)
summary(modp) # why so many p-values??


# Bootstrap estimation ----------------------------------------------------

parameters_bootstrap(mod)
# how do the permutation results and the bootstrap results differ?


# For more complex models more complex methods are required for
# bootstrapping (e.g., `boot::boot()`) and premutation tests...
