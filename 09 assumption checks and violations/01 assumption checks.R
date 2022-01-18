
library(ggeffects)    # for partial residual plots
library(performance)  # for check_*
library(see)


exp_grades <- read.csv("Exp_Psych_Grades.csv")
exp_grades$in_couple <- factor(exp_grades$in_couple)

head(exp_grades)




mod <- lm(Report ~ DOI + OSF + in_couple, data = exp_grades)


# When we talk about assumption checks, these are often 2 types of assumptions
# that get mixed together:
# - Conditional model assumptions (is our regression equation even good?)
# - Distributional model assumptions (can we trust the significant tests?)
# (Read more here: https://shouldbewriting.netlify.com/posts/2018-08-30-linear-regression-assumptions/)
#
#
# These checks are only meant to validate our pre-existing assumptions about our
# data and our model - optimally, we wouldn't be surprised by the results of
# these checks. For example, if we have an orthogonal design, we already know
# that collinearity is low or non existent; if we have reaction time data, we
# already know our data is not homoscedastic, etc. In other words, we shouldn't
# be using these checks to determine whether it's "okay" to use some model, but
# rather to validate what we already know about the model. Models should ideally
# be selected based on prior knowledge about our data and on our hypotheses -
# not in a trial-and-error fashion.
#
#
#
# If you approach these checks without an a-priori belief about the check's
# result, you should take a step back and consider why you decided to fit THIS
# type of model THIS way with THESE predictors to THESE data to begin with.








# 0. The Bare Minimum ------------------------------------------------------


# For *parameteric* models (we'll talk about non-parametric models in a bit),
# the bare minimal check is to see if your model is good is to examine how well
# it *fits* the overall (marginal) distribution of your data.
#
# Often times this check will fail because our predictors are not good enough,
# or that we are fitting the wrong KIND of model; e.g., a linear model to binary
# data, an ordinal regression to a scale outcome? These will necessarily have a
# bad fit to our target data...


bayesplot::pp_check(mod) # For non Bayesian models, requires {performance}

# In this case it seems like the answer is "not great":
# 1. The data is bi-modal, while our model does not capture this in the data: it
#   expects more grades ~60 than we actually have.
# 2. Our model expects some NEGATIVE grades (though not a lot).


# >>> What to do if violated? <<<
# Perhaps the conditional model (our regression equation) is not good enough?
# Or maybe our distributional model isn't of the right kind (See GLM lesson)...
# We need to probe a bit more to see what's up...






# Assumptions of the conditional model ------------------------------------

# These assumptions are related to the specification of conditional model - is
# our regression equation well specified?





## 1. "Linearity" ---------------------------------------------------------

# This states that predictors are linearly related to the outcome. But we can
# also have non-linear predictors (e.g., polynomial predictors, etc...). More
# generally, this assumption states that our model is correctly specified: there
# are no interactions or any other complex relationship that is missing from our
# model.

# We can do this visually, using *partial residual plots*:

ggemmeans(mod, "DOI [all]") |>
  plot(jitter = 0, residuals = TRUE, residuals.line = TRUE)

ggemmeans(mod, "in_couple") |>
  plot(jitter = 0.1, residuals = TRUE, residuals.line = TRUE)

ggemmeans(mod, c("OSF","in_couple")) |>
  plot(jitter = 0, residuals = TRUE, residuals.line = TRUE)
# etc...



# >>> What to do if violated? <<<
# Fix your model? (Warning: this is post-hoc model fitting...)





## 2. (Low) Collinearity --------------------------------------------------

# Collinearity states that some predictors are (strongly) related to each other.
# Why is collinearity bad?
# 1. It makes interpretation of results harder.
# 2. It reduces power (by increasing SEs).

# To measure collinearity we will compute the VIF:
check_collinearity(mod)

# NOTE: when the model includes interactions, centering will prevent spurious
# results (falsely inflated VIFs).



# >>> What to do if violated? <<<
# Option 1: worry -
# - Remove a term, OR
# - Combine the collinear terms
# But this might reduce the explanatory power of your model...
#
# Option 2: don't worry.
# ... but be very cautions about interpreting your model's parameters.

















# Assumptions of the distributional model ---------------------------------

# There are assumptions of the distribution (normal, binoamil, Poisson...) of
# our model.
#
# Generally speaking, it is these assumptions are what allows us to talk about
# probabilities; that is, they allows us to convert Z, t, F, and Chi-square
# values into p-values (which are probabilities), and to estimate confidence
# intervals.
#
# Thus, any violation of these assumptions reduces the validity of our
# inference.
#
#
# Each distribution comes with it's own set of assumptions (linear models have
# different assumptions than logistic models, than Poisson models, than mixed
# models, than SEM, etc).
#
# Here I will be focusing on the assumption of linear models.


# But first...

## 0. Independence of errors -----------------------------------------------


# One assumption that ALL regression models (not just linear regression) have in
# common it that the prediction errors / residuals are independence of one
# another. When this assumption is violated it is sometimes called
# "autocorrelation".
#
# This assumption is hard to test, and it is usually easier to use knowledge
# about the data and study design - for example, if we have a repeated measures
# design, then there is some dependency between the observations; if we have
# time-series data, then there is some temporal correlation between time points.



# >>> What to do if violated? <<<
# We need to account for the dependence by using a mixed model (see HLM/LMM next
# semester), rmANOVA, or something of the sort.




## 1. Homoscedasticity (of residuals) -------------------------------------


het <- check_heteroscedasticity(mod)


# Let's take a look.
plot(het)
# How do we want this to look?





# >>> What to do if violated? <<<
# 1. Re-fit the model with a heteroscedasticity consistent estimators (See
#    the `sandwich` package).
# 2. Switch to non-parametric tests.



# *. There are other, more advanced (Bayesian) models.
#    Ask me about them (if you dare).




## 2. Normality (of residuals) --------------------------------------------

# The true normality assumption is about the normality of the residuals!


# Shapiro-Wilk test for the normality (of THE RESIDUALS!!!)
norm <- check_normality(mod)

# but...
# https://notstatschat.rbind.io/2019/02/09/what-have-i-got-against-the-shapiro-wilk-test/

# So you should really LOOK at the residuals:
plot(norm, type = "qq") # see ?qqplotr::stat_qq_band for conf-bands

# # Can *also* check skewness & kurtosis
# e <- residuals(mod)
# datawizard::skewness(e) |> summary(test = TRUE)
# datawizard::kurtosis(e) |> summary(test = TRUE)




# >>> What to do if violated? <<<
# This might suggest that we shouldn't have used a Gaussian (normal)
# distribution in our model - so we can:
# 1. Try using a better one... A skewed or heavy tailed likelihood function, or
#    a completely different model family. Or...
# 2. Switch to non-parametric tests.











## For ANOVAs -------------------------------------------------------------


# The previous tests allow for assumptions checks for linear regression. For
# ANOVAs (and specifically for mixed ANOVAs), there are slightly different
# assumptions that need to be tested. You can see how to do this, here:
# https://github.com/mattansb/Analysis-of-Factorial-Designs-foR-Psychologists/tree/master/06%20assumption%20check%20and%20non-parametric%20tests





## For GLMs ---------------------------------------------------------------


# As noted above, each distribution has a slightly different set of assumptions
# See also:
# https://easystats.github.io/performance/reference/index.html#check-model-assumptions-or-data-properties
# and ?check_model()


### For logistic regression ---------

?binned_residuals()

?check_overdispersion()


### For Poisson regression ---------

?check_overdispersion()

?check_zeroinflation()




# Exercise ----------------------------------------------------------------

# Fit the model: Report ~ Test + in_couple
# 1. Test 3 of the assumptions and interpret the results.
# 2. Conduct a bootstrap or permutation analysis. How does this affect the
#   results?
