library(tidyverse)

library(parameters)
library(marginaleffects)

anxiety_adhd <- read.csv("anxiety_adhd.csv") |>
  mutate(
    ID = factor(ID),
    treat_group = factor(treat_group),
    sex = factor(sex)
  )

glimpse(anxiety_adhd)

# see the levels of a factor
levels(anxiety_adhd$treat_group)


# Unfortunately, regressions (and other models) cannot "deal" with categorical
# predictors; Instead, they require all the predictors to be numerical. The way
# to deal with this is to code categorical variables as a series of numerical
# variables that together encode all the information in the categorical
# variable. These are usually called "dummy variables", as each one alone only
# tells part of the story.
#
# Let's see how we do this in R.

# (1) Model Fitting -------------------------------------------------------

## Adding dummy variables (manually) ---------------------------------------

# Option 1: The SPSS way - make the dummy vars by hand...

##>>>>>>>>>>>>>>>>>>>>>>>>>>##
##      ______________      ##
##    /.--------------.\    ##
##   //                \\   ##
##  //                  \\  ##
## || .-..----. .-. .--. || ##
## ||( ( '-..-'|.-.||.-.||| ##
## || \ \  ||  || ||||_|||| ##
## ||._) ) ||  \'-'/||-' || ##
##  \\'-'  `'   `-' `'  //  ##
##   \\                //   ##
##    \\______________//    ##
##     '--------------'     ##
##                          ##
##      DO NOT DO THIS      ##
##                          ##
##<<<<<<<<<<<<<<<<<<<<<<<<<<##

anxiety_adhd <- anxiety_adhd |>
  mutate(
    d_placebo = ifelse(treat_group == "placebo", 1, 0),
    d_treat = ifelse(treat_group == "treat", 1, 0)
  )


fit_dummy <- lm(anxiety ~ d_placebo + d_treat, data = anxiety_adhd)

model_parameters(fit_dummy)
# what do these parameters mean?

## Adding dummy variables (automatically) ----------------------------------
# Option 2: let R do all the hard work... Just put the factor in the formula!

fit_factor <- lm(anxiety ~ treat_group, data = anxiety_adhd)
compare_parameters(fit_factor, fit_dummy)


# How does R determine what and how to dummy-code?
# - If `X` is a factor, treatment coding is used
#   with the FIRST level as the base group.
# - If `X` is a character vector, it is first converted into a factor
#   (level order is alphabetical).
levels(anxiety_adhd$treat_group)


# see the coding scheme:
contrasts(anxiety_adhd$treat_group)


## Change contrast scheme --------------------------------------------------

## 1. change base group in dummy coding
anxiety_adhd$treat_group <- relevel(anxiety_adhd$treat_group, ref = "placebo")
contrasts(anxiety_adhd$treat_group)

fit_factor2 <- lm(anxiety ~ treat_group, data = anxiety_adhd)
model_parameters(fit_factor2)

# Or change the first level of the factor by re-leveling the factor...
# (`forcats` is a good package for working with factors)

## 2. change to effects coding:
# Another popular coding scheme is the effects coding, where the "base group" is
# the AVERAGE of all the groups (so the first contrast is the difference between
# the mean of group 1 and the total mean, etc). Unfortunately, it makes
# parameter interpretation quite hard...
# using mainly you have an interaction of two categorical variables
# then main effects will refer to the "true" main effects  rather what are called simple effects (dummy coding)
contrasts(anxiety_adhd$treat_group) <- contr.sum
contrasts(anxiety_adhd$treat_group)

fit_factor3 <- lm(anxiety ~ treat_group, data = anxiety_adhd)
model_parameters(fit_factor3) # what do there mean???

# the intercept represents the total mean and each coefficient represent the difference between
# the total mean and the mean of the group coded '1'

?contr.treatment # even more types...
?datawizard::contr.deviation
help.search("^contr\\.")


# (2) Model exploration (inference) ---------------------------------------

# Looking at the parameters from the last two models, it is hard to see what the
# difference between "no treat" and "treat" groups is... And even if we could
# fish it out, is it significant?
model_parameters(fit_factor2)
model_parameters(fit_factor3)

# If we were working in SPSS, we would re-fit the model with different dummy
# coding to get all the pair-wise differences.
#
# But we are in R! And we have smart packages that can do wonders!

avg_predictions(fit_factor2, variables = "treat_group")
avg_predictions(fit_factor3, variables = "treat_group")
# Note that both returned the exact same results - the coding scheme has no
# influence here!

# mean(anxiety_adhd$anxiety[anxiety_adhd$treat_group=="placabo"])
# mean(anxiety_adhd$anxiety[anxiety_adhd$treat_group=="no treat"])
# mean(anxiety_adhd$anxiety[anxiety_adhd$treat_group=="treat"])

# All pair-wise comparisons.
avg_comparisons(fit_factor2, variables = list("treat_group" = "pairwise"))
# Note p-value is NOT adjusted here!
# (We will see more complex contrasts when we learn about ANOVAs.)

# This is the time to note that in R, model ~fitting~ and ~hypothesis testing~
# are not as closely knit as they are in other programs where you might have to
# re-fit the model several times to answer different questions.
# In R we work in 2 steps:
# 1) fit a model
# 2) Ask the model questions - test contrasts / effects of interest, get
#    predictions... <- models as prediction machines!
#
# This 2-part method makes life A LOT EASIER once models become more and more
# complex...

## Plot
plot_predictions(fit_factor2, condition = "treat_group") +
  geom_boxplot(
    data = anxiety_adhd,
    aes(x = treat_group, y = anxiety),
    color = "grey40",
    fill = NA
  )
