
# https://easystats.github.io/parameters/articles/efa_cfa.html
library(parameters) # for n_factors, check_factorstructure, model_parameters
library(psych) # for fa and omega


# Select only the 25 first columns corresponding to the items
data <- na.omit(psychTools::bfi[, 1:25])

head(data)


## Is the data suitable for FA?
round(cor(data), 2)
check_factorstructure(data)




# How many factors? -------------------------------------------------------



# Scree plot - where is the elbow?
PCA <- prcomp(data) # run PCA with `prcomp`
screeplot(PCA, npcs = length(PCA$sdev), type = "lines") 



# other methods:

ns <- n_factors(data, algorithm = "pa", rotation = "oblimin")
# This function calls many methods, e.g., nFactors::nScree... Read the doc!
data.frame(ns) # look for Kaiser criterion of Scree - seems to suggest 6


# However...
# We know how many factors we want here: This IS the Big-FIVE after all...





# Factor Analysis (FA) ----------------------------------------------------


## Run FA
efa <- fa(data, nfactors = 5, 
          rotate = "oblimin",
          fm = "minres") # minimum residual method (default)
efa <- fa(data, nfactors = 5, 
          rotate = "oblimin",
          fm = "pa") # principal factor solution
# or rotate = "varimax"

efa

model_parameters(efa, sort = TRUE, threshold = 0.55)
# These give the pattern matrix



## Visualize
biplot(efa, choose = c(1,2), pch = ".") # set `choose = NULL` for all
# We see here that PA2 is aligned with "N" cols, and that PA3 is aligned 
# with "C" cols - same as we saw in the table above.





# We can now use the factor scores just as we would any variable:
data_scores <- efa$scores
colnames(data_scores) <- c("N","E","C","A","O") # name the factors
head(data_scores)




# Reliability -------------------------------------------------------------

# Accepts the same arguments as `fa()`
efa_rel <- omega(data, nfactors = 5, fm = "pa", rotate = "oblimin", 
                 plot = FALSE)
efa_rel$omega.group
# This give omega (look at omega total), which is similar to alpha, but doesn't
# assume equal weights (which we just estimated!).
# https://doi.org/10.1037/met0000144






# Even More ---------------------------------------------------------------

# We really could have conducted a confirmatory factor analysis (CFA) instead of
# an exploratory factor analysis (EFA), as we were using a validated tool (the
# big-5-inventory), and we should know here which items correspond to which
# factors. We will learn how to conduct CFA next semester in the SEM module.
#
# There are also other methods of dimension reduction, such as variable
# clustering, that will be taught in the Machine Learning module.








# Exercise ----------------------------------------------------------------

# Kaiser criterion of Scree suggests that the best number of factors is not 5,
# but 6. Conduct an EFA for 6 factors (big6?).
# - Which items are associated with which factor? What do you make of the
#   factors?
# - Compare different cutoffs for the big6 - what would you do?
# - Compare the EFA on 5 factors and the EFA on 6 factors. You can use `anova()`
#   to compare the models: `d.chiSq` is the test statistic with `d.df` degrees
#   of freedom. `PR` is the p-value.
# Note: Chi-squared corresponds to the variance unaccounted for in the selected
# factors. And the difference (`d.chiSq`) is the additional accounted variance
# by the EFA with more factors. If the results is significant, this means that
# the model with MORE factors significantly accounted for more variance!

