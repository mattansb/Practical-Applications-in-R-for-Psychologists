
library(pwr)
library(effectsize)

pdat <- readRDS("pdat.Rds")

head(pdat)

# The `pwr` package has some functions for all the basic sig-tests. In all of
# the `pwr.*.test()` function you need to leave one of the arguments blank, and
# `pwr` will find THAT parameter for you.
#
# Note that in most of the post-hoc examples the power is awful. oh well...


# t test ------------------------------------------------------------------
# For the difference of two means.

## Ad-hoc power analysis:
pwr.t.test(d = 0.2, sig.level = .05, power = .8) # what n?
pwr.t.test(n = 15, sig.level = .05, power = .8) # what d?
# Or use `pwr.t2n.test()` for unequal group size.


## Post-hoc power analysis:
cohens_d(pdat$Depression[pdat$Group == "a"],
         pdat$Depression[pdat$Group == "b"])

pwr.t.test(d = -0.04, n = 23, sig.level = .05) # what power?
# Or use `pwr.t2n.test()` for unequal group size.




# Correlation -------------------------------------------------------------
# Spearman or Pearson

## Ad-hoc power analysis:
pwr.r.test(r = 0.1, sig.level = .05, power = .8) # what n?
pwr.r.test(n = 30, sig.level = .05, power = .8) # what r?

## Post-hoc power analysis:
cor.test(pdat$Depression, pdat$Joy)

pwr.r.test(r = 0.04, n = 46, sig.level = .05) # what power?




# Proportion --------------------------------------------------------------


## Ad-hoc power analysis:
pwr.p.test(h = ES.h(0.3, 0.5), sig.level = .05, power = .8) # what n?
pwr.p.test(n = 30, sig.level = .05, power = .8) # what p?
# convert h to p... somehow?


## Post-hoc power analysis:
mean(pdat$sex == "F")
pwr.p.test(h = ES.h(0.565, 0.5), n = 46, sig.level = .05) # what power?






# Or use:
# pwr.2p.test: two-sample proportion test
# pwr.2p2n.test: two-sample proportion test (unequal sample sizes)





# Chi-squared test --------------------------------------------------------
# For association (but also possible for goodness of fit)


## Ad-hoc power analysis:
# (w is phi)
pwr.chisq.test(w = 0.2, df = 1, sig.level = .05, power = .8) # what n?
pwr.chisq.test(N = 20, df = 1, sig.level = .05, power = .8) # what phi?


## Post-hoc power analysis:
cont_table <- table(pdat$sex, pdat$Group)
phi(cont_table, correct = FALSE)

pwr.chisq.test(w = 0.09, N = 46, df = 1, sig.level = .05) # what power?





# F tests -----------------------------------------------------------------
# general test for any F statistic (or t^2 statistic...)


## Ad-hoc power analysis:
# f2 is Cohen's f squared
pwr.f2.test(f2 = 0.2, u = 1, sig.level = .05, power = .8) # what n (via v = df2)
pwr.f2.test(v = 35, u = 1, sig.level = .05, power = .8) # what f2?


## Post-hoc power analysis:
# 1. hierarchical regression
# In the next few lessons we will learn how to fit linear model.
pdat <- na.omit(pdat)
fit0 <- lm(Depression ~ sex, data = pdat)
fit1 <- lm(Depression ~ sex + Anxiety + Joy, data = pdat)
anova(fit0, fit1)
F_to_f(6.63, 2, 41)
pwr.f2.test(f2 = 0.57^2, v = 42, u = 2, sig.level = .05) # what power?

# 2. single coefficient regression
summary(fit1)
t_to_f(0.603, 41) # for Joy
pwr.f2.test(f2 = 0.09^2, v = 41, u = 1, sig.level = .05) # what power?




# MORE POWER --------------------------------------------------------------

# Simple analytical solutions are usually not available for more complex designs
# and tests, and instead power analysis is based on simulations: you specify
# what you expect your data will look like, what tests you're going to conduct,
# and calculate power based on simulated data. You can simulate data on your
# own, but there are some useful packages that can help you out:
# - `simr` for (G)LMMs.
# - `Superpower` for Factorial designs (within, between, or mixed).
# - `simsem` (https://simsem.org/) for SEMs.

