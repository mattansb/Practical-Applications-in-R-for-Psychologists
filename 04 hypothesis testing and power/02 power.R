
# "Power corrupts. Absolute power corrupts absolutely."
#
# Generally speaking, power indicates how likely we are to detect an effect of a
# given size, given a sample of a given size. There are two common types of
# power analyses:
# - An a-priori power analysis is used to determine the minimal sample sized
#   required to detect some effect size.
# - A post hoc power analysis is used to asked about observed power - what was
#   the power to detect the observed effect size, given the sample size used in
#   the study.
# However there are more types of power analyses that are gaining popularity,
# such as the "power curve" analysis... There any many guidelines and rules of
# thumb for conducting power analysis, and but for the very trivial statistical
# tests, things get complicated fast.
#
# Suggesting reading - "Five Common Power Fallacies" by Richard D. Morey.


library(pwr)
library(effectsize) # since power is always a function of effect size

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
pwr.t.test(d = 0.2, sig.level = .05, power = .8, type = "two.sample") # what n (per group)?
pwr.t.test(n = 15, sig.level = .05, power = .8, type = "two.sample") # what d?
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
pwr.p.test(n = 30, sig.level = .05, power = .8) # what h?
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
phi(cont_table, correct = FALSE) # Phi is equivalent to Cohen's w

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
cohens_f2(fit0, model2 = fit1)
pwr.f2.test(f2 = 0.32, v = 42, u = 2, sig.level = .05) # what power?

# 2. single coefficient regression
summary(fit1)
t_to_f2(3.567, 41) # for Joy
pwr.f2.test(f2 = 0.31, v = 41, u = 1, sig.level = .05) # what power?









# Power Curve Analysis ----------------------------------------------------

# This is a basic example for an independent samples t-test - the idea of a
# power curve is to show how power, sample size, and effect size are related.

p_data <- expand.grid(
  d = seq(0, 1.2, length.out = 20),
  n = seq(2, 150, length.out = 50)
)

p_data$power <- pwr.t.test(
  n = p_data$n, d = p_data$d,
  sig.level = .05, type = "two.sample"
)$power # get only the power values

library(ggplot2)

ggplot(p_data, aes(n, d, fill = power)) +
  geom_raster() +
  geom_contour(aes(z = power, linetype = factor(stat(level))),
               breaks = c(0.5, 0.8, 0.9, 0.99),
               color = "black", size = 1) +
  scale_fill_distiller("Power", type = "seq", palette = 3, direction = 1) +
  scale_linetype_discrete("Power", guide = guide_legend(reverse = TRUE)) +
  theme_minimal() +
  labs(x = "Sample Size [per group]",
       y = "Cohen's d",
       title = "Power Curve Analysis",
       subtitle = "for an independent samples t-test")

# We can see that smaller effect sizes can more reliably be detected with larger
# sample sizes, and that for each sample size there is some effect size for
# which there is 80% power (or any other threshold).


# (Note the often power is shown on the y axis, and different lines represent
# the different effect sizes).
ggplot(p_data, aes(n, power, color = d, group = d)) +
  geom_line(size = 1) +
  scale_color_distiller("Cohen's d", type = "seq", palette = 1, direction = 1) +
  theme_minimal() +
  labs(x = "Sample Size [per group]",
       y = "Power",
       title = "Power Curve Analysis",
       subtitle = "for an independent samples t-test")
# (Or with the effect size on x, and lines for samples size - try it yourself!)




# MORE POWER --------------------------------------------------------------

# Simple analytical solutions are usually not available for more complex designs
# and tests, and instead power analysis is based on simulations: you specify
# what you expect your data will look like, what tests you're going to conduct,
# and calculate power based on simulated data. You can simulate data on your
# own, but there are some useful packages that can help you out, for example:
# - `simr` for (G)LMMs.
# - `Superpower` for Factorial designs (within, between, or mixed).
# - `simsem` (https://simsem.org/) for SEMs.
# - `simstudy` - a general purpose package for data simulation.



