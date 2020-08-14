

# We've already seen how to deal with categorical predictors, and categorical
# mediators. When all of our predictors are categorical and we model all of the
# possible interactions, our regression model is equivalent to an ANOVA.
#
# Although ANOVA is just a type of regression model, researchers working with
# factorial designs often prefer to build a single ANOVA model with all the
# interactions instead of building a series of models and comparing them. In
# theory this can be done with the `aov()` function but DO NOT DO THIS - this
# function will not give you the results you want! instead we will use the
# `afex` package.

library(afex)
library(emmeans)

# This lesson is a shortened version of a full ANOVA course (RIP), which you can
# find here:
# https://github.com/mattansb/Analysis-of-Factorial-Designs-foR-Psychologists
# I highly recommend this for anyone working with factorial designs, complex
# contrasts analyses, and the like.



# A Between Subjects Design -----------------------------------------------


Phobia <- readRDS("Phobia.rds")
head(Phobia)



## 1. Build a model
m_aov <- aov_ez(id = "ID", dv = "BehavioralAvoidance", data = Phobia,
                between = c("Condition", "Phobia"),
                anova_table = list(es = "pes")) # (pes = partial eta square)

# We get all effects, their sig and effect size (partial eta square)
m_aov
# We have a main effect for Phobia and an Interaction with Condition. Let's
# explore!



## 2. Explore the model
afex_plot(m_aov, ~ Condition, ~ Phobia)

# Simple effects:
joint_tests(m_aov, by = "Condition")

# Contrast for main effect
(em_Phobia <- emmeans(m_aov, ~ Phobia))
contrast(em_Phobia, method = "consec")

# Contrast for simple effects
(em_int <- emmeans(m_aov, ~ Phobia + Condition))
contrast(em_int, method = "pairwise", by = "Condition")


# We can also conduct interaction contrasts... See much much more:
# https://github.com/mattansb/Analysis-of-Factorial-Designs-foR-Psychologists






# Repeated Measures Design ------------------------------------------------


## Wide vs long data
# For repeated measures ANOVAs we need to prepare our data in two ways:
# 1. If we have many observations per subject / condition, we must aggregate
#   the data to a single value per subject / condition. This can be done with:
#    - `dplyr`'s `summarise()`
#    - `prepdat`'s `prep()`
# 2. The data must be in the LONG format.


mindful_work_stress <- readRDS("mindful_work_stress.rds")



# WIDE DATA has:
# 1. A row for each subject,
# 2. Between-subject variables have a column
# 3. Repeated measures are stored across columns, and the within-subject are
#   stored in column names
head(mindful_work_stress)




# LONG DATA (also known as 'tidy data'), has:
# 1. One row per each OBSERVATION,
# 2. A column for each variable (including the subject ID!)
# 3. Repeated measures are stored across rows.
library(tidyr)
mindful_work_stress_long <- mindful_work_stress %>%
  pivot_longer(cols = c(T1,T2),
               names_to = "Time",
               values_to = "work_stress")

head(mindful_work_stress_long)




## 1. Build a model:
fit_mfs <- aov_ez("id", "work_stress", mindful_work_stress_long,
                  between = "Family_status",
                  within = "Time",
                  anova_table = list(es = "pes"))
fit_mfs


# Exercise ----------------------------------------------------------------

# 1. Explore the `fit_mfs` model:
#   A. Plot the model with `afex_plot()`.
#   B. Did the treatment *significantly* affect all groups?
# 2. Go back to the phobia example:
#   A. Add `Gender` as a predictor (3-way ANOVA).
#   B. What is the effect size of the Gender:Phobia interaction?
#   C. Explore the new model in any way you see fit (at least one plot + one
#     contrast)




# This lesson is a shortened version of a full ANOVA course (RIP), which you can
# find here:
# https://github.com/mattansb/Analysis-of-Factorial-Designs-foR-Psychologists
# This course covered:
# - ANCOVA
# - Custom contrasts
# - Interaction contrasts
# - GLMMs for factorial designs
# If any of these topics is useful to you, feel free to use these materials and
# schedule a meeting during my office hours to discuss how you might learn more
# about these methods.

