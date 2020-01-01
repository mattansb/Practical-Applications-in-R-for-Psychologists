library(dplyr)

#' 1. import the "Exp_Psych_Grades.csv" dataset
#'    - Group     - the group number
#'    - in_couple - work was done in pairs or singles
#'    - TA        - (anonimized) metargelet
#'    - DOI       - part of the grade
#'    - OSF       - part of the grade
#'    - Report    - final grade on the paper
#'    - Test      - final grade on the test (averaged across the pair)
exp_grades <- read.csv("Exp_Psych_Grades.csv")

#' 2. Re-level the `TA` factor so that C is first.
exp_grades <- exp_grades %>%
  mutate(TA = factor(TA, levels = c("C","A","B","D")))

#' 3. Predict the final Report grade from the TA
fit <- lm(Report ~ TA,
          data = exp_grades)

#' 4. Is there a difference between the TAs?
anova(fit) # No.

#'    Who gave the highest grades?
#'    Who gave the lowest?
library(emmeans)
emmeans(fit, ~TA)
# Highest - C
# Lowest  - A

#'    Is the difference between them significant? (try using `emmeans` for this)
emmeans(fit, ~TA) %>%
  pairs()
# No.

#' 5. Fit a second model, predicting final Report grade from the `TA`, `in_couple` & `DOI`.
fit2 <- lm(Report ~ TA + in_couple + DOI,
           data = exp_grades)

#' 6. Is this model better than the first? What is the R^2 change?
anova(fit, fit2)
performance::compare_performance(fit, fit2)
# The second model is better, with R2=0.12 (vs R2=0)
