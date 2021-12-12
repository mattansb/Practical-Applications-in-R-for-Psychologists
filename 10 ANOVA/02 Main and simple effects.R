
library(afex)
library(emmeans)
library(ggeffects)


Phobia <- readRDS("Phobia.rds")
head(Phobia)


# 1. Fit the model --------------------------------------------------------


m_aov <- aov_ez(id = "ID", dv = "BehavioralAvoidance",
                between = c("Condition", "Phobia"),
                data = Phobia,
                anova_table = list(es = "pes")) # pes = partial eta squared

# We get all effects, their sig and effect size (partial eta square)
m_aov








# 2. Model Exploration ----------------------------------------------------



# Effect sizes with CIs...
# Make a plot...
# (see 01 ANOVA made easy.R)






## A. Main Effect Analysis (Phobia) ========
# We are looking at a main effect in a 2-way design, so this means we are
# averaging over the levels sex and coffee.


# Only the main effect for Phobia was significant. Let's conduct a contrast on
# the main effect.
ggemmeans(m_aov, "Phobia") |>
  plot(add.data = TRUE, connect.lines = TRUE)





### Step 1. Get estimated means ----
(em_Phobia <- emmeans(m_aov, ~ Phobia))
# Note the footnote!






### Step 2. Estimate the contrasts ----
contrast(em_Phobia, method = "consec") # consecutive differences


?`emmc-functions` # see for different types of built-in contrast weights.


# But we can also build custom contrast weights!
w <- data.frame(
  "Mild vs Other2" = c(-2, 1, 1) / 2, # make sure each "side" sums to 1!
  "Mild vs Other" = c(-2, 1, 1),
  "Moderate vs Severe" = c(0, -1, 1)
)


contrast(em_Phobia, method = w)













## B. Simple Effect Analysis (Phobia by Condition) ========


# A "simple" effect, is the effect of some variable, conditional on some other
# variable.

ggemmeans(m_aov, c("Phobia", "Condition")) |>
  plot(add.data = TRUE, connect.lines = TRUE, facet = TRUE)




# We can "split" our model *by* some variable to see the effects conditional on
# its levels. For example, we can look at each Condition to see test if there
# are differences between the levels of Phobia within each condition:
joint_tests(m_aov, by = "Condition")




# We can then conduct a contrast analysis for each simple effect...


### Step 1. Get estimated means ----
 (em_Phobia_by_Condition <- emmeans(m_aov, ~ Phobia + Condition))




### Step 2. Estimate the contrasts (conditionally) ----
contrast(em_Phobia_by_Condition, method = "consec", by = "Condition")
contrast(em_Phobia_by_Condition, method = w, by = "Condition")





# Exercise ----------------------------------------------------------------

# A. Add `Gender` as a predictor in the Phobia*Condition ANOVA (making it a
#    3-way between-Ss ANOVA)
# B. What is the effect size of the Gender:Phobia interaction?
# C. Explore the 2-way interaction between Condition:Phobia:
#    - Plots
#    - Simple effects
#    - Simple effect contrasts (use custom contrasts)
#    Interpret your results along the way...








