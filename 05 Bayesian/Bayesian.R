library(effectsize) # cohens_d and cramers_v
library(correlation) # for correlation

library(BayesFactor) # all the Bayes...
library(bayestestR)
library(see)


# In Bayesian statistics, we look at the posterior P(theta|Data), which is the
# result of the multiplication between the likelihood P(Data|theta)
# and the prior P(theta) (normalized by P(Data)).

pdat <- readRDS("pdat.Rds") |>
  as.data.frame()

head(pdat)

# Comparing the means of two independent groups ------------------------------

# Frequentist t-test
t.test(
  pdat$Depression[pdat$sex == "M"],
  pdat$Depression[pdat$sex == "F"],
  var.equal = TRUE
)

# Bayesian t-test
(model1 <- ttestBF(
  formula = Depression ~ sex,
  data = pdat,
  # rscale sets the prior width for the effect size
  rscale = 0.707
))

# The BayesFactor package returns the Bayes Factor (BF10), also known as a
# Bayesian decision criterion, represent the average suitability of the prior
# model to our data. We can also see it as the updating factor that tells us how
# much we should update our prior belief in H1 over H0 after seeing the data:
#
# Posterior ratio = Bayes Factor10 * Prior ratio
#
#   P(H1|Data)        P(Data|H1))      P(H1)
#   ----------    =   ----------   *   ----
#   P(H0|Data)        P(Data|H0)       P(H0)

pd(model1)
pd(model1) |> plot()
# pd (probability of direction) - Represent the probability that our measurement
# has a direction. In this case, if there is a difference between the two
# distributions, then one of the probabilities that this difference is
# negative/positive will be close to 1.

p_rope(model1, range = c(-1, 1))
rope(model1, range = c(-1, 1), ci = 1) |> plot()
# ROPE (Region Of Practical Equivalence) - help us support H0. Like Equivalence
# Test in NHST, we will define our "practical equivalence" area and after we
# will check how much of the posterior distribution is falling into this area.
# ! Note that you should choose the ROPE range prior to seeing the posterior...

# Like in NHST where we check our CI (Confidence Interval), in Bayesian analysis
# we will check our CI (Credible Interval) In this case, the CI represents the
# range where the posterior probability for the value is (1-α)% There are few
# ways to calculate CI, in this case we will refer to HDI (High Density
# Interval) which let us see the narrowest range which include (1-α)% from the
# posterior
hdi(model1, ci = .85)
hdi(model1, ci = .85) |> plot()

# Or we can use describe_posterior() to have a summary of all these indices
describe_posterior(
  model1,
  ci = 0.85,
  test = c("pd", "rope"),
  rope_range = c(-1, 1),
  rope_ci = 1
)


# Comparing the means of two paired groups --------------
# order of values is crucial! TAKE CARE WHEN USING LONG DATA!

# Frequentist paired t-test
t.test(pdat$Cond_A, pdat$Cond_B, paired = TRUE)

# Bayesian paired t-test
(model2 <- ttestBF(pdat$Cond_A, pdat$Cond_B, paired = TRUE, rscale = 0.707))

describe_posterior(
  model2,
  ci = 0.85,
  test = c("pd", "rope"),
  rope_range = c(-1, 1),
  rope_ci = 1
)

# You can also set the width of the prior with the rscale argument.
# Read more about selecting and reporting this, here:
# http://xeniaschmalz.blogspot.com/2019/09/justifying-bayesian-prior-parameters-in.html
