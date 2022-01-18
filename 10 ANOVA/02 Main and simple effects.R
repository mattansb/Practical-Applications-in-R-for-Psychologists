
library(afex)
library(emmeans)
library(ggeffects)


Phobia <- readRDS("Phobia.rds")
head(Phobia)


# 1. Fit the model --------------------------------------------------------


m_aov <- aov_ez(id = "ID", dv = "BehavioralAvoidance",
                between = c("Condition", "Gender"),
                data = Phobia,
                anova_table = list(es = "pes")) # pes = partial eta squared

# We get all effects, their sig and effect size (partial eta square)
m_aov








# 2. Model Exploration ----------------------------------------------------



# Effect sizes with CIs...
# Make a plot...
# (see 01 ANOVA made easy.R)



# === NOTE ===
# The model we used here is an ANOVA - but what follows is applicable to any
# type of multiple regression with categorical predictors.





## A. Main Effect Analysis (Condition) ========
# We are looking at a main effect in a 2-way design, so this means we are
# averaging over the levels Gender.


# Only the main effect for Condition was significant. Let's conduct a contrast on
# the main effect.
ggemmeans(m_aov, "Condition") |>
  plot(add.data = TRUE, connect.lines = TRUE)





### Step 1. Get estimated means ----
(em_Condition <- emmeans(m_aov, ~ Condition))
# Note the footnote!






### Step 2. Estimate the contrasts ----
contrast(em_Condition, method = "pairwise")


?`emmc-functions` # see for different types of built-in contrast weights.


# But we can also build custom contrast weights!
w <- data.frame(
  "Implosion vs Other2" = c(-1, 2, -1) / 2, # make sure each "side" sums to 1!
  "Implosion vs Other" = c(-1, 2, -1),
  "Desens vs CBT" = c(-1, 0, 1)
)
w

contrast(em_Condition, method = w)













## B. Simple Effect Analysis (Condition by Gender) ========


# A "simple" effect, is the effect of some variable, conditional on some other
# variable.

ggemmeans(m_aov, c("Condition", "Gender")) |>
  plot(add.data = TRUE, connect.lines = TRUE, facet = TRUE)




# We can "split" our model *by* some variable to see the effects conditional on
# its levels. For example, we can look at each Condition to see test if there
# are differences between the levels of Gender within each condition:
joint_tests(m_aov, by = "Gender")




# We can then conduct a contrast analysis for each simple effect...


### Step 1. Get estimated means ----
(em_Condition_by_Gender <- emmeans(m_aov, ~ Condition + Gender))




### Step 2. Estimate the contrasts (conditionally) ----

(c_simpeff <- contrast(em_Condition_by_Gender, method = "pairwise", by = "Gender"))

# Note that we have an mvt correction for each of the 2 contrasts.
# We can have any other type of correction:
update(c_simpeff, adjust = "bonf")
update(c_simpeff, adjust = "fdr")
# Or even have the corrections done on all 6 contrasts:
update(c_simpeff, adjust = "bonf", by = NULL) # by = NULL removes partitioning


# Same, but with custom contrasts:
contrast(em_Condition_by_Gender, method = w, by = "Gender")









# Exercise ----------------------------------------------------------------

# A. Add `Phobia` as a predictor in the Condition*Gender ANOVA (making it a
#    3-way between-subjects ANOVA)
# B. What is the effect size of the Gender:Phobia interaction?
# C. Explore the 2-way interaction between Condition:Phobia:
#    - Plots
#    - Simple effects
#    - Simple effect contrasts (use custom contrasts)
#    Interpret your results along the way...








