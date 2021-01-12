
library(car) # for Tyoe 3 ANOVA tables
library(effectsize) # for effect sizes

# For proper ANOVA tables we need:
# 1. All predictors for be centered around 0. For factors, this means using
#   *effects coding*.
# 2. Type 3 sums of squares.
# (Read more about why this matters so much here:
# https://easystats.github.io/effectsize/articles/anovaES.html)
#
# This script demonstrates how to do this without `afex` - giving a much more
# flexible workflow that is relevant to mixed models, glms, etc.




# A Between Subjects Design -----------------------------------------------

Phobia <- readRDS("Phobia.rds")
head(Phobia)

## 1. Effects coding ----
contrasts(Phobia$Phobia) <- contr.sum
contrasts(Phobia$Condition) <- contr.sum

# Fit the model
m_aov <- aov(BehavioralAvoidance ~ Condition * Phobia,
             data = Phobia)

## 2. Type 3 ANOVA ----
# Get the ANOVA table for the results
ANOVA_table <- Anova(m_aov, type = 3)


## Output
ANOVA_table
eta_squared(ANOVA_table)
# Or parameters::model_parameters(ANOVA_table, eta_squared = TRUE)

# Compare to `afex`'s results:
afex::aov_ez(id = "ID", dv = "BehavioralAvoidance", data = Phobia,
             between = c("Condition", "Phobia"),
             anova_table = list(es = "pes")) # (pes = partial eta square)





# A Within (or Mixed) Subjects Design -------------------------------------

library(tidyr)

mindful_work_stress_long <- readRDS("mindful_work_stress.rds") %>%
  pivot_longer(cols = c(T1,T2),
               names_to = "Time",
               values_to = "work_stress")

# MUST be FACTORS!
mindful_work_stress_long$id <- factor(mindful_work_stress_long$id)
mindful_work_stress_long$Time <- factor(mindful_work_stress_long$Time)
mindful_work_stress_long$Family_status <- factor(mindful_work_stress_long$Family_status)




## 1. Effects coding ----
contrasts(mindful_work_stress_long$Time) <- contr.sum
contrasts(mindful_work_stress_long$Family_status) <- contr.sum

# Fit the model
m_aov <- aov(work_stress ~ (Family_status) * (Time) + Error(id/(Time)),
             data = mindful_work_stress_long)




## 2. Type 3 ANOVA ----
# Get the ANOVA table for the results
summary(m_aov)
eta_squared(m_aov)


# Compare to `afex`'s results:
afex::aov_ez("id", "work_stress", mindful_work_stress_long,
             between = "Family_status",
             within = "Time",
             anova_table = list(es = "pes"))





# Even more ---------------------------------------------------------------


# You can use car::Anova() to get ANOVA tables for GLMs too - give it a try!!
# (It is even possible to get ANOVA tables for (generalized) linear mixed
# models!)


