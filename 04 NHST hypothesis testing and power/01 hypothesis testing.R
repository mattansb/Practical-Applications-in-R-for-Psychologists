library(tidyverse)
library(effectsize) # cohens_d and cramers_v
library(correlation) # for correlation
library(TOSTER) # for equivalence testing
library(parameters)

# This exercise will demo how to conduct the "classic" statistical hypothesis
# tests, along with their accompanying confidence intervals and standardized
# effect sizes. Moreover, we will demo how to conduct equivalence tests, which
# is a very popular and useful method. It is important to note that each of
# these so-called "tests" are actually a (simple) statistical model.

# When speaking of NHST (Null Hypothesis Significance Testing), we are checking
# p(Data|H0).

# Remember: we are only capable of rejecting H0 (when pvalue is < 5%) When using
# NHST - we *CAN'T* accept H0!!!

# t-test ------------------------------------------------------------------

pdat <- readRDS("pdat.Rds")

head(pdat)
# "Group" represents whether participants take psychiatric medication:
# a = not at all; b = yes, in the past; c = yes, currently

## between ----

pdat_des <- pdat |>
  group_by(Group) |>
  summarise(
    dep_mee = median(Depression),
    dep_mean = mean(Depression),
    dep_sd = sd(Depression)
  ) |>
  ungroup()

#range(pdat$Depression)

ggplot(pdat, aes(x = Group, y = Depression)) +
  geom_point(
    mapping = aes(color = Group),
    size = 2,
    position = position_jitter(0.1)
  ) +
  geom_boxplot(mapping = aes(color = Group), fill = NA, size = 1) +
  theme_light() +
  theme(legend.position = "none")

ggplot(pdat, aes(x = Depression, color = Group)) +
  geom_density(size = 1) +
  geom_vline(
    data = pdat_des,
    aes(xintercept = dep_mean, color = Group),
    linetype = "dashed",
    size = 1
  ) +
  geom_text(
    data = pdat_des,
    aes(x = dep_mean, y = 0.65, label = round(dep_mean, 3), color = Group),
    angle = 90,
    vjust = 1,
    size = 4.5
  ) +
  scale_color_manual(
    values = c(a = "deeppink3", b = "darkslategrey", c = "transparent")
  ) +
  theme_light()


t.test(
  pdat$Depression[pdat$Group == "a"],
  pdat$Depression[pdat$Group == "b"],
  var.equal = TRUE
)

# The null hypothesis can be changed by setting `mu = ...`
# Note, the default is `var.equal = FALSE` which gives a Welch test.

# reminder: welch's t-test also known as unequal variances t-test is used when
# you want to test whether the means of two population are equal. This test is
# generally applied when the there is a difference between the variations of two
# populations and also when their sample sizes are unequal.

# How to know if you can or cannot assume equal variance? You can use:
?var.test

# The difference between two means expressed in standard deviation units:
cohens_d(pdat$Depression[pdat$Group == "a"], pdat$Depression[pdat$Group == "b"])
hedges_g(pdat$Depression[pdat$Group == "a"], pdat$Depression[pdat$Group == "b"])
# Hedges' g is a measure of effect size that corrects Cohen's d for small sample
# sizes.

# Now let's use TOST with t-tests
model_between <- t_TOST(
  pdat$Depression[pdat$Group == "a"],
  pdat$Depression[pdat$Group == "b"],
  var.equal = TRUE,

  eqb = .15,
  smd_ci = "t"
)
model_between

# plot(model_between, type = "cd") # (Hedges' g is a measure of effect size)

## within / paired ----

# order of values is crucial! TAKE CARE WHEN USING LONG DATA!

t.test(pdat$Cond_A, pdat$Cond_B, paired = TRUE)
t.test(pdat$Cond_B, pdat$Cond_A, paired = TRUE)

cohens_d(pdat$Cond_A, pdat$Cond_B)

(model_within <- t_TOST(
  x = pdat$Cond_A,
  y = pdat$Cond_B,
  eqb = .5,
  smd_ci = "t",
  paired = TRUE
))

#plot(model_within, type = "cd")

# Correlation -------------------------------------------------------------

## single correlation
cor(pdat$Cond_A, pdat$Cond_B)
# pearson correlation = cov(x,y)/(sigma_x*sigma_y)

# Pearson
cor.test(pdat$Cond_A, pdat$Cond_B)


## Spearman correlation ----
cor.test(pdat$Depression, pdat$Joy, method = "spearman")

correlation(
  pdat,
  select = c("Depression", "Anxiety", "Joy"),
  method = "spearman"
)


## Many at once ----
corrs_A <- correlation(
  pdat[pdat$Group == "a", ],
  select = c("Depression", "Anxiety", "Joy")
)
corrs_A # Look at the function docs for Bayesian correlations.
summary(corrs_A) # output as a nice matrix


corrs_B <- correlation(
  pdat[pdat$Group == "b", ],
  select = c("Depression", "Anxiety", "Joy")
)
corrs_B # Look at the function docs for Bayesian correlations.
summary(corrs_B, redundant = TRUE) # output as a nice matrix


# For partial correlations (mit'am helki)
# correlation(pdat, select = c("Depression", "Anxiety", "Joy"), partial = TRUE)

# correlation() also supports group_by()!
pdat |>
  group_by(Group) |>
  correlation(select = c("Depression", "Anxiety", "Joy"))


# Proportion test ---------------------------------------------------------
# testing the null that the proportions (probabilities of success) in several
# groups are the same, or that they equal certain given values.

prop.test(sum(pdat$sex == "F"), nrow(pdat), p = 0.5)
?prop.test
# What's the effect size?

# Chi-squared test --------------------------------------------------------

cont_table <- table(pdat$sex, pdat$Group)
cont_table

proportions(cont_table) # % from total
proportions(cont_table, margin = 1) # % from rows
proportions(cont_table, margin = 2) # % from columns


# chisq.test function performs chi-squared contingency table tests and
# goodness-of-fit tests the first one is in use for checking whether there is a
# relationship between two categorical variables the second on is in use to
# check whether a given categorical variable distributes in an expected way

chisq.test(cont_table, correct = FALSE)


cramers_v(cont_table)


## Goodness of fit ----
group_table <- table(pdat$Group)
group_table
chisq.test(group_table, p = c(0.2, 0.4, 0.4))

fei(group_table, p = c(0.2, 0.4, 0.4))
