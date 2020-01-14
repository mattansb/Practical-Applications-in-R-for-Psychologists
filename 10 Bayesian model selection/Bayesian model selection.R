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
# result is non-significant, as non-significant as can be!
# But does this mean our results support H0?

## Bayesian testing:
mod1B <- lmBF(teacher_asses ~ HW + class_attention, data = school_asses)
mod2B <- lmBF(teacher_asses ~ HW + class_attention + SES, data = school_asses)

c(mod1B,mod2B) # both models look good. Now what?

# compare models by dividing BFs:
mod2B / mod1B
# ALWAYS remember - BFs are comparative! Who are you comparing to?

# Inclusion BFs -----------------------------------------------------------

# We can also produce a BF for each term using Bayesian model averaging:
fit_all <- lm(teacher_asses ~ HW + class_attention + SES + partic, data = school_asses)
summary(fit_all)

# generalTestBF() makes BF for all combinations of effects in the model:
fit_allB <- generalTestBF(teacher_asses ~ HW + class_attention + SES + partic, data = school_asses)
fit_allB
head(fit_allB) # best models


fit_allB[8] # select model BF
fit_allB[9:10] / fit_allB[8] # new BFs
# etc...

plot(fit_allB)
plot(bayesfactor_models(fit_allB))

# which terms are most supported?
# which terms are least supported?

bayesfactor_inclusion(fit_allB, match_models = TRUE)
# read more about Bayesian model averaging:
# https://easystats.github.io/bayestestR/articles/bayes_factors.html#inclusion-bayes-factors-via-bayesian-model-averaging


# Exercise ----------------------------------------------------------------

# Test the interacting effect of `sex` and `partic` on `teacher_asses`
# using both frequentist and Bayesian testing (use generalTestBF()).
# 1. Interpret the Bayesian results.
#    - which is the best model?
#    - Compare the main effects model to the model with the interaction
#      using both frequentist and Bayesian testing.
# 2. How / Do the Bayesian and frequentist results differ?
#    Are you convinced there is or isn't an interaction?
# 3. On average:
#    - which term is most supported?
#    - which term is least supported?
