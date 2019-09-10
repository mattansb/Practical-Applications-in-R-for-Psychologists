library(tidyverse)

anxiety_adhd <- read.csv("anxiety_adhd.csv")
head(anxiety_adhd)
unique(anxiety_adhd$treat_group) # why is this a factor?


# Adding dummy variables (manually) ---------------------------------------

anxiety_adhd <- anxiety_adhd %>%
  mutate(d_placebo = ifelse(treat_group == "placebo", 1, 0),
         d_treat   = ifelse(treat_group == "treat",   1, 0))

fit_dummy <- lm(anxiety ~ d_placebo + d_treat,
                data = anxiety_adhd)
summary(fit_dummy)

# Adding dummy variables (automagically) ----------------------------------

fit_factor <- lm(anxiety ~ treat_group,
                 data = anxiety_adhd)
summary(fit_factor)

# How are these determined?
# 1. If the var is a character it is first converted into a factor (level
#    alphabetically).
# 2. By default, a treatment vs base coding is used, with the fist level
#    is the base group.

# see the dummy vars:
contrasts(anxiety_adhd$treat_group)
model.matrix(fit_factor)


# Change contrast scheme --------------------------------------------------

## 1. change base group
contr.treatment(n = 3, base = 2)
contrasts(anxiety_adhd$treat_group) <- contr.treatment(n = 3, base = 2)
contrasts(anxiety_adhd$treat_group)
summary(lm(anxiety ~ treat_group, data = anxiety_adhd))

# Or change fist level of the factor by re-leveling the factor...

## 2. change to a different scheme:
contrasts(anxiety_adhd$treat_group) <- contr.sum
summary(lm(anxiety ~ treat_group, data = anxiety_adhd))

?contr.treatment # even more types...

# Or... make your own (google it / ?contrasts).


## 3. Does the coding even matter?

library(emmeans)
treamt_means <- emmeans(fit_factor, ~ treat_group)
treamt_means
emmip(treamt_means, ~treat_group, CIs = TRUE)
confint(treamt_means)
contrast(treamt_means, "pairwise") %>% summary(infer = TRUE)

# Testing (omnibus test) --------------------------------------------------

anova(fit_factor)

car::Anova(fit_factor, type = 3)

# what do these actually test? And why is it important to understand?
# Well see next time what happens...

# Testing (hierarchical) --------------------------------------------------

fit1 <- lm(anxiety ~ sex, data = anxiety_adhd)
fit2 <- lm(anxiety ~ sex + ADHD_symptoms, data = anxiety_adhd)
fit3 <- lm(anxiety ~ sex + ADHD_symptoms + treat_group, data = anxiety_adhd)

anova(fit1, fit2, fit3)
performance::compare_performance(fit1, fit2, fit3)

# For step-wise regression, see `drop1`, `add1` and `MASS::stepAIC`

# Exercise ----------------------------------------------------------------

#' 1. import the "Exp_Psych_Grades.csv" dataset
#'    - Group     - the group number
#'    - in_couple - work was done in pairs or singles
#'    - TA        - (anonimized) metargelet
#'    - DOI       - part of the grade
#'    - OSF       - part of the grade
#'    - Report    - final grade on the paper
#'    - Test      - final grade on the test (averaged across the pair)
#' 2. Recode the `TA` factor so that C is first.
#' 3. Predict the final Report grade from the TA
#' 4. Is there a difference between the TAs?
#'    Who gave the highest grades?
#'    Who gave the lowest?
#'    Is the difference between them significant? (try using emmeans for this ^)
#' 5. Fit a second model, predicting final Report grade from the TA, in_couple & DOI.
#' 6. Is this model better than the first? What is the R^2 change?


