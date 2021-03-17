
library(effectsize)

pdat <- readRDS("pdat.Rds")
head(pdat)

# Here are the most common non-parametric tests. They are all based on
# rank-transforming the data in some way (similar to Spearman's correlation).
# For example:
x <- c(1.45, 2.01, 0.47, 0.79)
rank(x) # or
ranktransform(x) # more options


# However, note that the tests themselves are parametric, it is the underlying
# models that are not. Read more here:
# https://lindeloev.github.io/tests-as-linear/



# Compare two samples -----------------------------------------------------

# These are the rank-versions of the t-test.
# Their effect size is the rank biserial correlation. You can read more about it
# and the other rank based effect sizes here:
# https://easystats.github.io/effectsize/articles/simple_htests.html#rank-based-tests-1


## Mann-Whitney U Test --------------
# (compare two independent samples)
wilcox.test(pdat$Depression[pdat$Group == "a"],
            pdat$Depression[pdat$Group == "b"])

rank_biserial(pdat$Depression[pdat$Group == "a"],
              pdat$Depression[pdat$Group == "b"])




## Wilcoxon Signed-rank Test --------
# (compare two dependent samples)
wilcox.test(pdat$Cond_A, pdat$Cond_B, paired = TRUE)

rank_biserial(pdat$Cond_A, pdat$Cond_B, paired = TRUE)






# Compare more than 2 samples ---------------------------------------------

# These are the rank-versions of the one-way anove.

## Kruskal-Wallis Test --------------
# (compare k independent samples)
kruskal.test(Depression ~ Group, data = pdat)

rank_epsilon_squared(Depression ~ Group, data = pdat)




## Friedman Test --------------------
# (compare k dependent samples)

m <- as.matrix(pdat[c("Cond_A", "Cond_B", "Cond_C")])
m # row per subject, column per condition

friedman.test(m)

kendalls_w(m)
