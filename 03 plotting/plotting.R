
library(dplyr)

df_NPAS <- readRDS("NPAS-data_clean.Rds")
glimpse(df_NPAS)

# Use `across` to compute sum / mean scores
df_NPAS_with_score <- df_NPAS %>%
  mutate(
    Nerdy = rowMeans(across(Q1:Q26)) # better for missing data
  ) %>%
  select(-(Q1:Q26))

head(df_NPAS_with_score)



# *** ggplot2 *** ---------------------------------------------------------

library(ggplot2)

# There are 2 main ideas to understand when using `ggplot`:
#    1. Plots are built ("drawn"), layer by layer.
#    2. Data (variables) are mapped to visual features of the plot.
#       Like saying "on the x axis we have 'age'", or "color represents
#       'gender'".
# This course will not expant much on using `ggplot`, as its use changes
# dramatically between users, but let's look at some basics.


# Basic steps - think:
# 1. What data do we want to plot? (which variables)
# 2. What do we want to plot? (a scatter plot? A bar plot? error bars?)
# 3. How do variables map onto the plot
#    (thinking about axes, separate plots / groups, colors)...

# Draw a histogram of "Nerdy"
ggplot(df_NPAS_with_score, mapping = aes(x = Nerdy)) +
  geom_histogram()

# draw points, with [x,y] coordinates from `Nerdy` and `Knowlage`:
ggplot(df_NPAS_with_score, aes(x = Nerdy, y = Knowlage)) +
  geom_point()

# same, but different genders are colored differently:
ggplot(df_NPAS_with_score, aes(x = Nerdy, y = Knowlage, color = gender)) +
  geom_point()

ggplot(df_NPAS_with_score, aes(x = Nerdy, y = Knowlage, color = factor(gender))) +
  geom_point() +
  geom_smooth()

ggplot(df_NPAS_with_score, aes(x = Nerdy, y = Knowlage, color = factor(gender))) +
  geom_point() +
  geom_smooth(method = "lm")

ggplot(df_NPAS_with_score, aes(x = ASD, y = Nerdy, color = urban)) +
  geom_boxplot()

ggplot(df_NPAS_with_score, aes(x = ASD, y = Nerdy, color = urban)) +
  geom_boxplot() +
  facet_grid( ~ married)

ggplot(df_NPAS_with_score, aes(x = ASD, y = Nerdy, color = urban)) +
  geom_point() +
  facet_grid(gender ~ married) + 
  labs(x = "ASD Level", y = "Nerdyness", color = "City Size")

# and many many more...
# https://ggplot2-book.org/
#
# ggplot is a powerful tool - with many other packages interfacing or
# expanding it.
#
# Learn how to better visualize your data:
# https://serialmentor.com/dataviz/visualizing-amounts.html






# Take 5 minutes, look at the data - think what you'd like to plot.





# Exercise ----------------------------------------------------------------

# Using ggplot, try and (visually) answer the following question:
# 1. What is the relationship between sexual orientation (`orientation`)
#    and nerdiness (`Nerdy2`).
# 2. Does it vary by ASD? education? Both?