
# A mediation model seeks to explain the *mechanism* that underlies a
# relationship between a two variables, by including a third hypothetical
# variable, known as *the mediator*. Rather than a direct causal relationship
# between the independent variable and the dependent variable, a mediation model
# proposes that the independent variable influences the mediator variable, which
# in turn influences the dependent variable. Thus, the mediator variable serves
# to clarify the nature of the relationship between the independent and
# dependent variables.
#
# Note, however, that a mediation analysis is NOT enough to properly demonstrate
# causation - like correlation, mediation too does not suffice to infer a fully
# causal relationship.
# Suggested reading: http://www.the100.ci/2019/10/03/indirect-effect-ex-machina/



parental_iris <- read.csv("parental_iris.csv")

head(parental_iris)




# Manual Mediation --------------------------------------------------------

# We want to see if there is a suppression mediation pattern associating the
# number of sweets a child is given and the degree to which a child is satisfied
# with their relationship with their parents (to be clear: this is bogus data).

# Looking at a correlation between the two, it seems to be negative (less candy
# -> more happy?) but not significant.
cor.test(parental_iris$ave_sweets,
         parental_iris$child_satisfaction)


# Let's see if and how this relationship is mediated by parental strictness.
# (Note that here we are skipping Baron and Kenny's four step process. See
# http://dx.doi.org/10.1080/03637750903310360)

# For this we need to build 2 models:
# Model 1. Predict Y from X and M:
m_sat <- lm(child_satisfaction ~ ave_sweets + parental_strictness,
            data = parental_iris)

# Model 2. Predict M from X:
m_strict <- lm(parental_strictness ~ ave_sweets,
               data = parental_iris)


# We can not get the direct, indirect and total effects / paths by extracting
# and multiplying the correct coefficients:
(effects <- c(
  direct = coef(m_sat)["ave_sweets"],
  indirect = coef(m_strict)["ave_sweets"] * coef(m_sat)["parental_strictness"],
  total = coef(m_sat)["ave_sweets"] + coef(m_strict)["ave_sweets"] * coef(m_sat)["parental_strictness"]
))

# We can see that the direct and indirect effects are of opposing signs -
# suggesting a suppression pattern of mediation. But are any of these
# significant?



# Mediation w/ `mediation` ------------------------------------------------


# To conduct a mediation analysis, we will use the... `mediation` package:
library(mediation)
# This is a powerful package, that can deal with complex models to estimate the
# strength of a single mediator's effect. (See bellow for dealing with more than
# a one mediator.)

# we must supply the previous two models, and `mediate()` will do the rest!

med <- mediate(m_strict, m_sat,
               sims = 599, boot = TRUE, boot.ci.type = "bca",
               treat = "ave_sweets",
               mediator = "parental_strictness")
summary(med)
# - ACME - average causal mediation effects (indirect effect)
# - ADE - average direct effects (direct effect)
# - Total Effect
# - Prop. Mediated - The proportion of the ACME / Total effect.
#
# Looks like both direct and indirect effects are significant.
# Note also that the indirect effect explains more than 1,000% of the total
# effect because of the suppression!

# compare to:
effects


plot(med)



## Standardized indirect effect?
# You can simply run both models on standardized data, and then the results of
# `mediate()` (estimates, CIs) will themselves be standardized.




# More --------------------------------------------------------------------

# `mediation` also supports *moderated mediation*, the addition of covariates to
# any of the two models, the mixing of LMs, GLMs, (G)LMMs and more.
#
# However, all of this for models with a single mediator. For more complex
# mediation patterns (two or more parallel / serial mediators, etc), you will
# need to use SEM (`lavaan`, next semester...).





# Exercise ----------------------------------------------------------------

# 1. Fit the reverse moderation models: ave_sweets mediates the effect of
#    parental_strictness on child_satisfaction.
# 2. Is the direct effect significant?
# 3. Is the indirect effect significant?
# 4. How would you interpret these results?
