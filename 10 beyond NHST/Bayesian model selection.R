library(BayesFactor)
library(bayestestR)

school_asses <- read.csv("school_asses.csv")
str(school_asses)
head(school_asses)

# Hierarchical testing ----------------------------------------------------

# You would use this method in any situation you would use hierarchical
# testing (model comparison).

## Frequenstist testing:

mod1 <- lm(teacher_asses ~ HW + class_attention, data = school_asses)
mod2 <- lm(teacher_asses ~ HW + class_attention + SES, data = school_asses)

summary(mod1) # look at the F test! What does it mean?

# compare models
anova(mod1,mod2)

## Bayesian testing:
mod1B <- lmBF(teacher_asses ~ HW + class_attention, data = school_asses)
mod2B <- lmBF(teacher_asses ~ HW + class_attention + SES, data = school_asses)

mod1B

# compare models
mod2B / mod1B

# Inclusion BFs -----------------------------------------------------------

# We can also produce a BF for each term using Bayesian model averaging:

fit_all <- lm(teacher_asses ~ HW + class_attention + SES + partic, data = school_asses)
summary(fit_all)

fit_allB <- generalTestBF(teacher_asses ~ HW + class_attention + SES + partic, data = school_asses)
fit_allB
head(fit_allB) # best models

fit_allB[8]
fit_allB[9:10] / fit_allB[8]
# etc...

plot(fit_allB)
plot(bayesfactor_models(fit_allB))

# which terms are most supported?
# which terms are least supported?

bayesfactor_inclusion(fit_allB, match_models = TRUE)
# read more about Bayesian model averaging:
# https://easystats.github.io/bayestestR/articles/bayes_factors.html#inclusion-bayes-factors-via-bayesian-model-averaging


# Exercise ----------------------------------------------------------------

# 1. Test the interacting effect of `sex` and `partic` on `teacher_asses`
#    using both frequentist and Bayesian hierarchical testing.
#    - Interpret the Bayesian results. Are you convinced there is or isn't
#      an interaction?
#    - How / Do the Bayesian and frequentist results differ?
# 2. Given the following formula and data:
data(attitude)
rating ~ complaints + privileges + learning * raises
#    - On average, which term is most supported?
#    - On average, which term is least supported?
#    - which is the best model?
#    - what is the BF when comparing these two models?
#      complaints + privileges / learning * raises
