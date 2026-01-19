library(afex)
library(effectsize)
library(emmeans)
library(ggbeeswarm)


Phobia <- readRDS("data/Phobia.rds")
head(Phobia)


# 1. Fit the model --------------------------------------------------------

m_aov <- aov_ez(
  id = "ID",
  dv = "BehavioralAvoidance",
  between = c("Condition", "Gender"),
  data = Phobia,
  anova_table = list(es = "pes")
  # pes = partial eta squared
)

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

# Only the main effect for Condition was significant. Let's conduct a contrast
# on the main effect.
afex_plot(m_aov, ~Condition)


### Step 1. Get marginal means ----
# We can do this with {marginaleffects}:
marginaleffects::avg_predictions(m_aov, variables = "Condition")
# But for factorial designs, it's often easier to use {emmeans}:
(em_Condition <- emmeans(m_aov, ~Condition))
# Note the footnote!

### Step 2. Estimate the contrasts ----
contrast(em_Condition, method = "pairwise")

?emmeans::pairwise.emmc # see for different types of built-in contrast weights.

levels(Phobia$Condition)
# But we can also build custom contrast weights!
contrast(
  em_Condition,
  method = list(
    "Implosion vs Other2" = c(-1, 2, -1) / 2, # make sure each "side" sums to 1!
    "Implosion vs Other" = c(-1, 2, -1),
    "Desens vs CBT" = c(-1, 0, 1)
  )
)

# If you set your contrast weights to sum to 1 and -1 on each side of the
# contrast, the resulting contrast estimate should equal the difference between
# the means (if your contrast weights sum to 2 and -2, then it should equal
# twice the mean difference, etc.) Sometimes it appears to work just fine, but
# sometimes it doesn't! And if you throw in a nonorthogonal comparison, things
# get even more mysterious!

## B. Simple Effect Analysis (Condition by Gender) ========

# A "simple" effect, is the effect of some variable, conditional on some other
# variable.
afex_plot(m_aov, ~Condition, ~Gender)
afex_plot(m_aov, ~Condition, panel = ~Gender)


# We can "split" our model *by* some variable to see the effects conditional on
# its levels. For example, we can look at each Condition to see test if there
# are differences between the levels of Gender within each condition:
joint_tests(m_aov, by = "Gender")
F_to_eta2(
  # For approximate partial eta squared calculation
  f = c(0.755, 0.976),
  df = 2,
  df_error = 48,
  ci = 0.9,
  alternative = "two.sided"
)

# We can then conduct a contrast analysis for each simple effect...

### Step 1. Get estimated means ----
(em_Condition_by_Gender <- emmeans(m_aov, ~ Condition + Gender))


### Step 2. Estimate the contrasts (conditionally) ----

(c_simpeff <- contrast(
  em_Condition_by_Gender,
  method = "pairwise",
  by = "Gender"
))

# Note that we have an mvt correction for each of the 2 contrasts.
# We can have any other type of correction:
# bonf = dividing the desired overall significance level by the number of tests
# being conducted, and then using this adjusted significance level for each
# individual test
update(c_simpeff, adjust = "holm")
# Or even have the corrections done on all 6 contrasts:
update(c_simpeff, adjust = "holm", by = NULL) # by = NULL removes partitioning


# Same, but with custom contrasts:
contrast(
  em_Condition_by_Gender,
  method = list(
    "Implosion vs Other2" = c(-1, 2, -1) / 2, # make sure each "side" sums to 1!
    "Implosion vs Other" = c(-1, 2, -1),
    "Desens vs CBT" = c(-1, 0, 1)
  ),
  by = "Gender"
)
