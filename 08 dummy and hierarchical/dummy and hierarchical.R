
library(dplyr)

anxiety_adhd <- read.csv("anxiety_adhd.csv")
head(anxiety_adhd)

unique(anxiety_adhd$treat_group) # why is this a factor?




# Adding dummy variables (manually) ---------------------------------------


## ------------- ##
## DON'T DO THIS ##
## ------------- ##


anxiety_adhd <- anxiety_adhd %>%
  mutate(d_placebo = ifelse(treat_group == "placebo", 1, 0),
         d_treat   = ifelse(treat_group == "treat",   1, 0))

fit_dummy <- lm(anxiety ~ d_placebo + d_treat,
                data = anxiety_adhd)
summary(fit_dummy)





# Adding dummy variables (automagically) ----------------------------------



fit_factor <- lm(anxiety ~ treat_group, data = anxiety_adhd)
summary(fit_factor)
summary(fit_dummy)


# How are these determined?
# 1. If the var is a character it is first converted into a factor (level
#    order is alphabetical).
# 2. By default, dummy (treatment) coding is used, with the fist level
#    as the base group.

# see the coding:
contrasts(anxiety_adhd$treat_group)
model.matrix(~ treat_group, data = anxiety_adhd)
model.matrix(fit_factor)




# Change contrast scheme --------------------------------------------------

## 1. change base group in dummy coding
contrasts(anxiety_adhd$treat_group) <- contr.treatment(n = 3, base = 2)
contrasts(anxiety_adhd$treat_group)

fit_factor2 <- lm(anxiety ~ treat_group, data = anxiety_adhd)
summary(fit_factor2)

# Or change fist level of the factor by re-leveling the factor...
# (`forcats` is a good package for tidying factors)




## 2. change to effects coding:
contrasts(anxiety_adhd$treat_group) <- contr.sum
contrasts(anxiety_adhd$treat_group)

fit_factor3 <- lm(anxiety ~ treat_group, data = anxiety_adhd)
summary(fit_factor3) # what do there mean?



?contr.treatment # even more types...



# Or... make your own (google it / ?contrasts).





## 3. Does the coding even matter for describing the data? (no)

library(emmeans)
# `emmeans` is one of the best packages in R - for ANY follow-up analysis!!

emmeans(fit_factor, ~ treat_group)
emmeans(fit_factor2, ~ treat_group)
emmeans(fit_factor3, ~ treat_group)


# It is important to note that in R, model fitting and hypothesis testing
# are not as closely knit as they are in SPSS.
# For example, if we have 3 group, and we wanted to test all pairwise
# differences in SPSS, we would re-fit the model with different dummy
# coding.
# In R would would (1) fit a model, (2) test the contrasts of interest.
# (As we will see, this is also true for simple slope analysis...)

# All pair wise comparisons.
emmeans(fit_factor, ~ treat_group) %>%
  contrast("pairwise") %>%
  summary(infer = TRUE)
# More on this next semester (ANOVA)






# Testing (hierarchical) --------------------------------------------------



fit1 <- lm(anxiety ~ sex, data = anxiety_adhd)
fit2 <- lm(anxiety ~ sex + ADHD_symptoms, data = anxiety_adhd)
fit3 <- lm(anxiety ~ sex + ADHD_symptoms + treat_group, data = anxiety_adhd)

anova(fit1, fit2, fit3)
performance::compare_performance(fit1, fit2, fit3)

# For forward/backward step-wise regression, see `drop1`, `add1`.
# You might also be interested in `stepAIC` from the `MASS` package.




# Exercise ----------------------------------------------------------------

#' 1. import the "Exp_Psych_Grades.csv" dataset
#'    - Group     - the group number
#'    - in_couple - work was done in pairs or singles
#'    - TA        - (anonimized) metargelet
#'    - DOI       - part of the grade
#'    - OSF       - part of the grade
#'    - Report    - final grade on the paper
#'    - Test      - final grade on the test (averaged across the pair)
#' 2. Re-level the `TA` factor so that C is first.
#' 3. Predict the final Report grade from the TA
#' 4. Is there a difference between the TAs?
#'    Who gave the highest grades?
#'    Who gave the lowest?
#'    Is the difference between them significant? (try using `emmeans`
#'    for this)
#' 5. Fit a second model, predicting final Report grade from the `TA`,
#'    `in_couple` & `DOI`.
#' 6. Is this model better than the first? What is the R^2 change?


