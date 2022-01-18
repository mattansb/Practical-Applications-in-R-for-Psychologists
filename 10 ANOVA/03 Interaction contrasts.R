

library(afex) # for ANOVA
library(emmeans) # for follow up analysis
library(ggeffects) # for plotting






# let's look at the coffee_plot.png and get a feel for our data.
#
# What marginal (main) effects and interactions does it look like we have here?
# What conditional (simple) effects does it look like we have here?

coffee_data <- read.csv('coffee.csv')
coffee_data$time <- factor(coffee_data$time, levels = c('morning', 'noon', 'afternoon'))
head(coffee_data)




coffee_fit <- aov_ez('ID', 'alertness', coffee_data,
                     within = c('time', 'coffee'),
                     between = 'sex',
                     anova_table = list(es = "pes"))

coffee_fit
# what's up with the 3-way interaction??


ggemmeans(coffee_fit, c("time", "coffee", "sex")) |>
  plot(connect.lines = TRUE)




# We will be looking at the Coffee-by-Time interaction.



# === NOTE ===
# The model we used here is an ANOVA - but what follows is applicable to any
# type of multiple regression with categorical predictors.




# Explore the **simple effect** for `time` by `coffee` --------------------
# We are looking at a 2-way interaction in a 3-way design, so this means we are
# averaging over the levels sex.


ggemmeans(coffee_fit, c("time", "coffee")) |>
  plot(connect.lines = TRUE, facet = TRUE)



## Test simple effects ========
# We can break down an interaction into simple effects:
# ("by" can be a vector for simple-simple effects, etc...)
joint_tests(coffee_fit, by = "coffee")
# Which rows are we looking at?





## Contrast Analysis ========

### Step 1. Get the means --------
em_time.coffee <- emmeans(coffee_fit, ~ time + coffee)
em_time.coffee





### Step 2. Compare them (conditionally) --------
# We want to look at the simple effects for time, conditionally on values of
# coffee. So we must use "by"!

# Here too we can use both types of methods:
contrast(em_time.coffee, method = "consec", by = "coffee") # note p-value correction
contrast(em_time.coffee, method = "poly", by = "coffee") # note p-value correction



w.time <- data.frame(
  "wakeup vs later" = c(-2, 1, 1) / 2, # make sure each "side" sums to (+/-)1!
  "start vs end of day" = c(-1, 0, 1)
)
w.time # Are these orthogonal contrasts?
cor(w.time)

contrast(em_time.coffee, method = w.time, by = "coffee")






# Follow-Up: Interaction Contrasts ----------------------------------------

# After seeing the conditional contrasts - the contrasts for the effect of time
# within the levels of coffee, we can now ask: do these contrasts DIFFER BETWEEN
# the levels of coffee?


contrast(em_time.coffee, interaction = list(time = "consec", coffee = "pairwise"))

# Here too we can use custom contrasts:
contrast(em_time.coffee, interaction = list(time = w.time, coffee = "pairwise"))


# How do we interpret these?






# These steps can be used for higher-order interactions as well. For example,
# for a 3-way interaction we can:
# - Look at the *simple* 2-way interactions.
#   - Look at the *simple simple* effect.
#     - Conduct a contrast analysis for the *simple simple* effect.
#   - Conduct an interaction contrast for the *simple* 2-way interactions.
# - Conduct an interaction contrast for the 3-way interactions.

# Same for 4-way interactions... etc.



# Exercise ----------------------------------------------------------------


# Explore the sex-by-time interaction using all the steps from above.
# Answer these questions:
# A. Which sex is the most alert in the morning?
# B. What is the difference between noon and the afternoon for males?
# C. Is this difference larger than the same difference for females?
# Interpret your results along the way...
#
#
# *. Confirm (w/ contrasts, simple effects...) that there really is no 3-way
#   interaction in the coffee data.


