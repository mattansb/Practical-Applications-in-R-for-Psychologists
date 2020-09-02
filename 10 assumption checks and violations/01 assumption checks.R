library(effects)      # for residual regression plots
library(performance)  # for check_*
library(ggResidpanel) # for resid_panel


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
# type of model THIS way with THESE predictors to begin with.




# Assumptions of the Model ------------------------------------------------

# These assumptions are related to the *fit* of your model. But before these,
# there is one assumption that cannot be checked - that you are fitting the
# right KIND of model!
# Are you fitting a linear model to binary data? Are you fitting an ordinal
# regression to a scale outcome? This will necessarily be a bad fit...


# 1. "Linearity" ----------------------------------------------------------

# This states that predictors are linearly related to the outcome. But we can
# also have non-linear predictors - we've seen polynomial predictors. More
# generally, this assumption states that our model is correctly specified: no
# missing interactions, or complex relationships not modeled.

# We can do this visually, using *partial regression plots*:
plot(Effect("OSF", mod, residuals = TRUE))

plot(Effect("in_couple", mod, residuals = TRUE))

plot(Effect(c("in_couple","OSF"), mod, residuals = TRUE))

# etc...



# >>> What to do if violated? <<<
# Fix your model? (Warning: this is post-hoc model fitting...)





# 2. (Low) Collinearity ---------------------------------------------------

# Collinearity states that some predictors are related to each other. Why is
# collinearity bad? Two main reasons:
# 1. It reduces power (by increasing SEs).
# 2. It makes interpretation of results harder.

# To measure collinearity we will compute the VIF:
check_collinearity(mod)

# NOTE: when the model includes interactions, centering will prevent spurious
# results (inflated VIFs).



# >>> What to do if violated? <<<
# - Remove a term, OR
# - Combine the collinear terms
# But this might reduce the explanatory power of your model...







# Assumptions of the Significance tests -----------------------------------

# Generally speaking, these assumptions are what allows us to convert Z, t, F,
# and Chi values into probabilities. So any violation of these assumptions
# reduces the validity of our sig-tests. (However, not of the model as a whole!)
#
# Whereas the previous model-assumptions are the same for ALL TYPES OF MODELS,
# assumptions relating to sig-testing are slightly different for different types
# of models - sig-testing in linear models have different assumptions than
# logistic models, than Poisson models, than mixed models, than SEM... etc.
#
# One assumption that all models have in common it that the prediction errors /
# residuals are independence of one another. When this assumption is violated it
# is sometimes called "autocorrelation". This assumption is hard to test, and it
# is usually easier to use knowledge about the data - for example, if we have a
# repeated measures design, or a nested design, then there is some dependency
# between the observations and we would therefor want to account for this by
# using a mixed model (see HLM/LMM next semester), or something of the sort.


# Here I will be looking at assumption of linear models, as these are more
# common and are easier to test...



# 1. Normality (of residuals) ---------------------------------------------

# The true normality assumption is about the normality of the residuals!


# Shapiro-Wilk test for the normality (of THE RESIDUALS!!!)
check_normality(mod)


# but...
# https://notstatschat.rbind.io/2019/02/09/what-have-i-got-against-the-shapiro-wilk-test/

# So you should really LOOK at the residuals:
resid_panel(mod, plots = c("hist", "qq"), qqbands = TRUE)
parameters::describe_distribution(residuals(mod)) # Skewness & Kurtosis

# There are other plot options - these are the one I recommend.
?resid_panel




# >>> What to do if violated? <<<
# This means that we shouldn't have used a Gaussian likelihood function (the
# normal distribution) in our model - so we can:
# 1. Try using a better one... A skewed or heavy tailed likelihood function, or
#   a completely different model family. Or...
# 2. Switch to non-parametric tests!






# 2. Homoscedasticity (of residuals) --------------------------------------


check_heteroscedasticity(mod)

# Let's take a look.
resid_panel(mod,
            plots = c("resid", "ls", "yvp"),
            smoother = TRUE)
# How do we want there to look?

# We can also compare the residuals to each predictor
resid_xpanel(mod, smoother = TRUE)
# How do we want there to look?


# looks like the same outliers from before :(




# >>> What to do if violated? <<<
# 1. Re-fit the model with a heteroscedasticity consistent estimators (See
#   the `sandwich` package).
# 2. Switch to non-parametric tests!










# Exercise ----------------------------------------------------------------

# Fit the model: Report ~ Test + in_couple
# 1. Test 3 of the assumptions and interpret the results.
# 2. Conduct a bootstrap or permutation analysis. How does this affect the
#   results?
