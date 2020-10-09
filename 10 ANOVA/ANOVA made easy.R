

# We've already seen how to deal with categorical predictors, and categorical
# moderators. When all of our predictors are categorical and we model all of the
# possible interactions, our regression model is equivalent to an ANOVA.
#
# Although ANOVA is just a type of regression model, researchers working with
# factorial data often prefer to build a single ANOVA model with all the
# interactions (instead of building a series of models and comparing them
# hierarchically). Although R has a built-in function for conducting ANOVAs -
# `aov()` - you should NOT USE IT as it will not give you the results you want!
# Instead you should use the `afex` package.
# (Read more about why this matters so much here:
# https://easystats.github.io/effectsize/articles/anovaES.html)


library(afex) # for ANOVA
library(emmeans) # for follow up analysis
library(effectsize) # for effect sizes

# This lesson is a shortened version of a full ANOVA course (RIP), which you can
# find here:
# https://github.com/mattansb/Analysis-of-Factorial-Designs-foR-Psychologists
# I highly recommend this for anyone working with factorial designs, or who need
# to perform complex contrasts analyses, and the like.



# A Between Subjects Design -----------------------------------------------


Phobia <- readRDS("Phobia.rds")
head(Phobia)



## 1. Build a model
m_aov <- aov_ez(id = "ID", dv = "BehavioralAvoidance", data = Phobia,
                between = c("Condition", "Phobia"),
                anova_table = list(es = "pes")) # (pes = partial eta square)

# We get all effects, their sig and effect size (partial eta square)
m_aov

# We can use functions from `effectsize` to get confidence intervals for various
# effect sizes:
eta_squared(m_aov, partial = TRUE)
?eta_squared # see more types



## 2. Explore the model
afex_plot(m_aov, ~ Condition, ~ Phobia)



# We only have a significant main effect for Phobia. Let's conduct a contrast on
# the main effect:
# Step 1. Get estimated means:
(em_Phobia <- emmeans(m_aov, ~ Phobia))

# Step 2. Estimate the contrast:
contrast(em_Phobia, method = "consec")

?`emmc-functions` # see for different types of built-in contrast weights.
# But we can also build custom contrast weights!


w <- data.frame(
  Mild_vs_Other = c(-2,1,1)/2,
  Moderate_vs_Severe = c(0,-1,1)
)

contrast(em_Phobia, method = w)









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

# Repeated measures are really just one way of saying that there are multiple
# levels in our data. Although rm-ANOVA can deal with simple cases like the ones
# presented here, for more complex data structures (more nesting, more than one
# random effects factor, modeling of a continuous predictor, etc.) HLM/LMM are
# required (which you can learn next semester).
# see `vignette("afex_mixed_example", package = "afex")` for an example of how
# to run HLM/LMM ANOVAs.


## 2. Explore the model
afex_plot(fit_mfs, ~Time, ~Family_status)


# We had a significant interaction, so we can:

# A. Look as simple effects:
joint_tests(fit_mfs, by = "Time")


# B. Look at simple effects contrasts:
(em_int <- emmeans(fit_mfs, ~ Family_status + Time))
contrast(em_int, method = "pairwise", by = "Time")


# C. Look at interaction contrasts (diffs of diffs):
contrast(em_int, interaction = list(Family_status = "pairwise",
                                    Time = "pairwise"))



# More --------------------------------------------------------------------

# This lesson is a shortened version of a full ANOVA course (RIP), which you can
# find here:
# https://github.com/mattansb/Analysis-of-Factorial-Designs-foR-Psychologists
#
# This course covered:
# - ANCOVA
# - Simple effect / contrast effect sizes
# - Bayesian ANOVA
# - More custom contrasts and interaction contrasts
# - HLM for factorial designs
#
# If any of these topics is useful to you, feel free to use these materials and
# schedule a meeting during my office hours to discuss how you might learn more
# about these methods.





# Exercise ----------------------------------------------------------------

# Go back to the phobia example:
# A. Add `Gender` as a predictor (3-way ANOVA).
# B. What is the effect size of the Gender:Phobia interaction?
# C. Explore the new model in any way you see fit (at least one plot + one
#   contrast)


