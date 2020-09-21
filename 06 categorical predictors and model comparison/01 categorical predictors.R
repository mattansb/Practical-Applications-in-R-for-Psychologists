
library(dplyr)
library(parameters)


anxiety_adhd <- read.csv("anxiety_adhd.csv") %>%
  mutate(ID = factor(ID),
         treat_group = factor(treat_group),
         sex = factor(sex))

glimpse(anxiety_adhd)

# see the levels of a factor
levels(anxiety_adhd$treat_group)


# Unfortunately, regressions (and other models) cannot "deal" with categorical
# predictors; Instead, they require all the predictors to be numerical. The way
# to deal with this is to code categorical variables as a series of numerical
# variables that together encode all the information in the categorical
# variable. These are usually called "dummy variables", as each one alone only
# tells part of the story.
# Let's see how we do this in R.


# 1) Model Fitting --------------------------------------------------------


# Adding dummy variables (manually) ---------------------------------------

# Option 1: The SPSS way - make the dummy vars by hand...

## >>>>>>>>>>>>>> ##
## DO NOT DO THIS ##
## <<<<<<<<<<<<<< ##


anxiety_adhd <- anxiety_adhd %>%
  mutate(d_placebo = ifelse(treat_group == "placebo", 1, 0),
         d_treat   = ifelse(treat_group == "treat",   1, 0))


fit_dummy <- lm(anxiety ~ d_placebo + d_treat,
                data = anxiety_adhd)

model_parameters(fit_dummy)
# what do these parameters mean?




# Adding dummy variables (automagically) ----------------------------------

# Option 2: let R do all the hard work... Just put the factor in the formula!

fit_factor <- lm(anxiety ~ treat_group, data = anxiety_adhd)
model_parameters(fit_factor)
model_parameters(fit_dummy)



# How does R determine what and how to code?
# 1. If the var is a character it is first converted into a factor (level
#   order is alphabetical).
# 2. By default, dummy (treatment) coding is used, with the FIRST level
#   as the base group.

# see the coding scheme:
contrasts(anxiety_adhd$treat_group)




# Change contrast scheme --------------------------------------------------

## 1. change base group in dummy coding
anxiety_adhd$treat_group <- relevel(anxiety_adhd$treat_group, ref = "placebo")
contrasts(anxiety_adhd$treat_group)

fit_factor2 <- lm(anxiety ~ treat_group, data = anxiety_adhd)
model_parameters(fit_factor2)

# Or change the first level of the factor by re-leveling the factor...
# (`forcats` is a good package for working with factors)




## 2. change to effects coding:
# Another popular coding scheme is the effects coding, where the average of all
# the groups is the "base group". Unfortunately, it makes parameter
# interpretation quite hard...
contrasts(anxiety_adhd$treat_group) <- contr.sum
contrasts(anxiety_adhd$treat_group)

fit_factor3 <- lm(anxiety ~ treat_group, data = anxiety_adhd)
model_parameters(fit_factor3) # what do there mean???



?contr.treatment # even more types...






# 2) Model exploration (inference) ----------------------------------------

# Looking at the parameters from the last two models, it is hard to see what the
# difference between "no treat" and "treat" groups is... And even if we could
# fish it out, is it significant?
model_parameters(fit_factor2)
model_parameters(fit_factor3)

# If we were working in SPSS, we would re-fit the model with different dummy
# coding to get all the pair-wise differences.
#
# But we are in R! And we have smart packages that can do wonders!


library(emmeans)
# `emmeans` is one of the best packages in R - for ANY follow-up analysis!!
emmeans(fit_factor2, ~ treat_group)
emmeans(fit_factor3, ~ treat_group)
# Note that both returned the exact same results - the coding scheme has no
# influence here!

## Plot
library(ggeffects)
plot(ggemmeans(fit_factor2, "treat_group"), add.data = TRUE)



# This is the time to note that in R, model ~fitting~ and ~hypothesis testing~
# are not as closely knit as they are in SPSS. Whereas in SPSS we can fit
# several models with different dummy coding or variable centering, in R we work
# in 2 stages:
# 1) fit a model
# 2) Ask the model questions - test contrasts / effects of interest, get
#   predictions...
#
# This 2-part method makes life A LOT EASIER once models become more and more
# complex...


# All pair-wise comparisons.
emmeans(fit_factor2, ~ treat_group) %>%
  contrast(method = "pairwise") %>%
  summary(infer = TRUE)
# Note the automatic p-value adjustment





