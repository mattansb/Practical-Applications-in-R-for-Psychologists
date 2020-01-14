library(BayesFactor)
library(bayestestR)

school_asses <- read.csv("school_asses.csv")

# Test the interacting effect of `sex` and `partic` -----------------------
# on `teacher_asses` using both frequentist and Bayesian testing (use generalTestBF()).

mod1F <- lm(teacher_asses ~ sex + partic, data = school_asses)
mod2F <- lm(teacher_asses ~ sex * partic, data = school_asses)

modsB <- generalTestBF(teacher_asses ~ sex * partic, data = school_asses)


# 1. Interpret the Bayesian results.
#    - which is the best model?
head(modsB)
# The intercept only model!

#    - Compare the main effects model to the model with the interaction
#      using both frequentist and Bayesian testing.
anova(mod1F, mod2F)

modsB[4]/modsB[3]

# 2. How / Do the Bayesian and frequentist results differ?
#    Are you convinced there is or isn't an interaction?

# Answer: classical test is not informative; Bayes factor supports the null (no interaction),
# but very weakly  BF01=2.

# 3. On average:
bayesfactor_inclusion(modsB, match_models = TRUE)
#    - which term is most supported? (partic - but even it has evidence agasint it!)
#    - which term is least supported? (the interaction - but only weakly)
