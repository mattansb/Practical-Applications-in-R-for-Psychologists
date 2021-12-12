

# We've already seen how to deal with categorical predictors, and categorical
# moderators in a regression model. When all of our predictors are categorical
# and we model all of the possible interactions, our regression model is
# equivalent to an ANOVA.
#
# Although ANOVA is just a type of regression model, researchers working with
# factorial data often present their models as a single ANOVA with all the
# interactions (instead of building a series of models and comparing them
# hierarchically).
#
# Although R has a built-in function for conducting ANOVAs - `aov()` - you
# should NOT USE IT as it will not give you the results you want!
#
#
#
#
#
# To be clear:
#
#           .-"""-.
#          / _   _ \
#          ](_' `_)[
#          `-. N ,-'
#         8==|   |==8
#            `---'
#
#  >>>> DO NOT USE `aov()`! <<<<
#
#
#
#
# Instead, we will use the `afex` package, which gives the desired and expected
# ANOVA results.
# (If you wish to learn more - check out:
# https://shouldbewriting.netlify.app/posts/2021-05-25-everything-about-anova





library(afex) # for ANOVA
library(emmeans) # for follow up analysis
library(effectsize) # for effect sizes
library(ggeffects) # for plotting




# A Between Subjects Design -----------------------------------------------


Phobia <- readRDS("Phobia.rds")
head(Phobia)



## 1. Build a model ----
m_aov <- aov_ez(id = "ID", dv = "BehavioralAvoidance",
                between = c("Condition", "Phobia"),
                data = Phobia,
                anova_table = list(es = "pes")) # pes = partial eta squared

# We get all effects, their sig and effect size (partial eta square)
m_aov




# We can use functions from `effectsize` to get confidence intervals for various
# effect sizes:
eta_squared(m_aov, partial = TRUE)
?eta_squared # see more types



## 2. Explore the model ----
ggemmeans(m_aov, c("Condition", "Phobia")) |>
  plot(add.data = TRUE, connect.lines = TRUE)
# see also:
# afex_plot(m_aov, ~ Condition, ~ Phobia)


#







# Repeated Measures Design ------------------------------------------------


## Wide vs long data
# For repeated measures ANOVAs we need to prepare our data in two ways:
# 1. If we have many observations per subject / condition, we must aggregate
#   the data to a single value per subject / condition. This can be done with:
#    - `dplyr`'s `summarise()`
#    - `prepdat`'s `prep()`
#    - etc...
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
mindful_work_stress_long <- mindful_work_stress |>
  pivot_longer(cols = c(T1,T2),
               names_to = "Time",
               values_to = "work_stress")

head(mindful_work_stress_long)




## 1. Build a model ----
fit_mfs <- aov_ez("id", "work_stress",
                  between = "Family_status",
                  within = "Time",
                  data = mindful_work_stress_long,
                  anova_table = list(es = "pes"))
fit_mfs

eta_squared(fit_mfs, partial = TRUE)

# Repeated measures are really just one way of saying that there are multiple
# levels in our data. Although rm-ANOVA can deal with simple cases like the ones
# presented here, for more complex data structures (more nesting, more than one
# random effects factor, modeling of a continuous predictor, etc.) HLM/LMM are
# required (which you can learn next semester).
# see `vignette("afex_mixed_example", package = "afex")` for an example of how
# to run HLM/LMM ANOVAs.





## 2. Explore the model ----
ggemmeans(fit_mfs, c("Time", "Family_status")) |>
  plot(add.data = TRUE, connect.lines = TRUE)



# Contrast analysis...






# More --------------------------------------------------------------------

# This lesson is a shortened version of a full ANOVA course (RIP), which you can
# find here:
# https://github.com/mattansb/Analysis-of-Factorial-Designs-foR-Psychologists
#
# This course covered:
# - ANCOVA
# - Simple effect / contrast effect sizes
# - HLM for factorial designs
#
# If any of these topics is useful to you, feel free to use these materials and
# schedule a meeting during my office hours to discuss how you might learn more
# about these methods.



