
library(ggeffects)    # for partial residual plots
library(performance)  # for check_*
library(see)


exp_grades <- read.csv("Exp_Psych_Grades.csv")
exp_grades$in_couple <- factor(exp_grades$in_couple)

head(exp_grades)




mod <- lm(Report ~ DOI + OSF + in_couple, data = exp_grades)

summary(mod)


# When we talk about assumption checks, these are often 2 types of assumptions
# that get mixed together:
# - Assumptions of the Model
# - Assumptions of the Significant tests
# (Read more here: https://shouldbewriting.netlify.com/posts/2018-08-30-linear-regression-assumptions/)
#
#
# These checks are only meant to validate our pre-existing assumptions about our
# data and our model - optimally, we shouldn't be surprised by the results of
# these checks. For example, if we have an orthogonal design, we already know
# that collinearity is low or non existent; if we have reaction time data, we
# already know our data is at least somewhat not homoscedastic, etc. In other
# words, we shouldn't be using these checks to determine whether it's "okay" to
# use some model, but rather to validate what we (should) already know about the
# model. Models should ideally be selected based on prior knowledge about our
# data and on our hypotheses - not in a trial-and-error fashion.




# If you approach these checks without an a-priori belief about the check's
# result, you should take a step back and consider why you decided to fit THIS
# type of model THIS way with THESE predictors to THESE data to begin with.








# Assumptions of the Model ------------------------------------------------

# These assumptions are related to the *fit* of your model. But before these...



## 0. The Bare Minimum ------------------------------------------------------


# For parameteric models (we'll talk about non-parametric models in a bit), the
# bare minimal check is to see if your model is good is to examine how well it
# *fits* the overall (marginal) distribution of your data.
#
# Often times this check will fail because our predictors are not good enough,
# or that we are fitting the wrong KIND of model; e.g., a linear model to binary
# data, an ordinal regression to a scale outcome? These will necessarily have a
# bad fit to our target data...

bayesplot::pp_check(mod)
# In this case it seems like the answer is NO:
# 1. The data is bi-modal, while our model does not capture this in the data: it
#   expects more grades ~60 than we actually have.
# 2. Our model expects some NEGATIVE grades (though not a lot).


# >>> What to do if violated? <<<
# Need to think if we are even using the right kind of model...
# See GLM lesson...



## 1. "Linearity" ---------------------------------------------------------

# This states that predictors are linearly related to the outcome. But we can
# also have non-linear predictors (e.g., polynomial predictors, etc...). More
# generally, this assumption states that our model is correctly specified: there
# are no interactions or any other complex relationship that is missing from our
# model.

# We can do this visually, using *partial residual plots*:
ggemmeans(mod, "OSF") |>
  plot(jitter = 0, residuals = TRUE, residuals.line = TRUE)

ggemmeans(mod, "in_couple") |>
  plot(jitter = 0.1, residuals = TRUE, residuals.line = TRUE)

ggemmeans(mod, c("OSF","in_couple")) |>
  plot(jitter = 0, residuals = TRUE, residuals.line = TRUE)
# etc...



# >>> What to do if violated? <<<
# Fix your model? (Warning: this is post-hoc model fitting...)





## 2. (Low) Collinearity --------------------------------------------------

# Collinearity states that some predictors are related to each other. Why is
# collinearity bad? Two main reasons:
# 1. It reduces power (by increasing SEs).
# 2. It makes interpretation of results harder.

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
















# Assumptions of the Significance tests -----------------------------------

# Generally speaking, these assumptions are what allows us to convert Z, t, F,
# and Chi-square values into probabilities (p-values). So any violation of these
# assumptions reduces the validity of our sig-tests.
#
# One assumption that all models have in common it that the prediction errors /
# residuals are independence of one another. When this assumption is violated it
# is sometimes called "autocorrelation". This assumption is hard to test, and it
# is usually easier to use knowledge about the data - for example, if we have a
# repeated measures design, or a nested design, then there is some dependency
# between the observations and we would therefor want to account for this by
# using a mixed model (see HLM/LMM next semester), or something of the sort.



# Besides the assumption of independence (which is the same for ALL TYPES OF
# MODELS), assumptions relating to sig-testing are slightly different for
# different types of models - sig-testing in linear models have different
# assumptions than logistic models, than Poisson models, than mixed models, than
# SEM... etc.
#
# Here I will be looking at assumption of linear models, as these are more
# common and are easier to test...

## 1. Homoscedasticity (of residuals) -------------------------------------


het <- check_heteroscedasticity(mod)


# Let's take a look.
plot(het)
# How do we want this to look?


# looks like the same outliers from before :(




# >>> What to do if violated? <<<
# 1. Re-fit the model with a heteroscedasticity consistent estimators (See
#    the `sandwich` package).
# 2. Switch to non-parametric tests.



# *. There are other, more advanced (Bayesian) models.
#    Ask me about them (if you dare).




## 2. Normality (of residuals) --------------------------------------------

# The true normality assumption is about the normality of the residuals!
# Note that this assumption is palces last because it is least important!


# Shapiro-Wilk test for the normality (of THE RESIDUALS!!!)
norm <- check_normality(mod)

# but...
# https://notstatschat.rbind.io/2019/02/09/what-have-i-got-against-the-shapiro-wilk-test/

# So you should really LOOK at the residuals:
plot(norm, type = "qq")

residuals(mod) |> parameters::describe_distribution() # Skewness & Kurtosis





# >>> What to do if violated? <<<
# This might suggest that we shouldn't have used a Gaussian likelihood function
# (the normal distribution) in our model - so we can:
# 1. Try using a better one... A skewed or heavy tailed likelihood function, or
#    a completely different model family. Or...
# 2. Switch to non-parametric tests.











# For ANOVAs --------------------------------------------------------------


# The previous tests allow for assumptions checks for linear regression. For
# ANOVAs (and specifically for mixed ANOVAs), there are slightly different
# assumptions that need to be tested. You can see how to do this, here:
# https://github.com/mattansb/Analysis-of-Factorial-Designs-foR-Psychologists/tree/master/06%20assumption%20check%20and%20non-parametric%20tests





# For GLMs ----------------------------------------------------------------


# As noted above, assumptions relating to sig-testing are slightly different for
# different types of models. See also:
# https://easystats.github.io/performance/reference/index.html#check-model-assumptions-or-data-properties
# and ?check_model()


## For logistic regression ---------

?binned_residuals()

?check_overdispersion()


## For Poisson regression ---------

?check_overdispersion()

?check_zeroinflation()




# Exercise ----------------------------------------------------------------

# Fit the model: Report ~ Test + in_couple
# 1. Test 3 of the assumptions and interpret the results.
# 2. Conduct a bootstrap or permutation analysis. How does this affect the
#   results?
