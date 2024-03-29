
library(dplyr)

# We will again be using the NPAS data set.

# Let's clean it up a bit
# (data from https://www.kaggle.com/lucasgreenwell/nerdy-personality-attributes-scale-responses)
df_NPAS <- read.csv("NPAS data.csv") |> 
  tidyr::drop_na(Q1:Q26, gender, age) |> # this is similar to na.omit() but for specific vars
  mutate(
    Nerdy = across(Q1:Q26, .fns = as.numeric) |> rowMeans(na.rm = TRUE),
    gender = factor(gender, levels = c(2, 1, 3), labels = c("woman", "man", "other"))
  ) |>
  select(-(Q1:Q26)) |> 
  filter(age < 100) |> 
  sample_n(200) # get just some of the data


glimpse(df_NPAS)





# *** ggplot2 *** ---------------------------------------------------------

library(ggplot2)

# When using `ggplot` there are two main concepts to understand:
#    1. Plots are built ("drawn") - layer by layer.
#    2. Data (variables) are mapped to visual features of the plot.
#     Like saying "on the x axis we have 'age'", 
#     or "color represents 'gender'".
#
# This course will not expand much on using `ggplot`, as its use changes
# dramatically between users, data type and whole fields, but let's look at some
# of the basics.


# Basic steps - think:
# 1. What variables do want to plot?
# 2. What data do we want to plot? Raw data (individual scores)? Summarized data
#   (group means)?
# 2. What type of plot are we making? (a scatter plot? A bar plot? error bars?)
# 3. How do variables MAP onto the plot - in other words what visual feature
#   represents different variables? Does color change by group? Does location on
#   the X axis change according to age? Etc...


# Example 1 ---------------------------------------------------------------

# The main function is `ggplot()`, and it takes a data frame.
ggplot(df_NPAS)
# This drew nothing, because we did not tell it what to draw or how...



# `aes()` is the mapping function - it lets us MAP variables onto visual
# features. For example, I want the X-axis to represent `age` and th Y-axis to
# represent `Nerdy`.
ggplot(df_NPAS, mapping = aes(x = age, y = Nerdy))
# This still does nothing, because we didn't add any layers - we didn't tell
# ggplot what to draw!



# All the actual "drawing" is specified with the layers - "geoms" and "stats".
# Here we might want to draw the data points.
# So lets add that - literally, with a `+`!
ggplot(df_NPAS, aes(x = age, y = Nerdy)) + 
  geom_point()
# Starting to get somewhere!

# We can also 'map' variables to other aesthetics, such as color:
ggplot(df_NPAS, aes(x = age, y = Nerdy)) + 
  geom_point(aes(color = gender))

# We can also map color on to a continuous variable:
ggplot(df_NPAS, aes(x = age, y = Nerdy)) + 
  geom_point(aes(color = TIPI2))


ggplot(df_NPAS, aes(x = age, y = Nerdy)) + 
  geom_point(aes(color = gender)) + 
  stat_smooth() # add regression line
# "stats" process the raw data and produces new data. In this case - a line and
# error ribbon. All layers have a geom (the drawing) and a stat (how the did is,
# or isn't, processed).


ggplot(df_NPAS, aes(x = age, y = Nerdy)) + 
  geom_point(aes(color = gender)) + 
  stat_smooth(aes(color = gender), method = "lm")



# we can split into subplots using facets:
ggplot(df_NPAS, aes(x = age, y = Nerdy)) + 
  geom_point(aes(color = gender)) + 
  stat_smooth(aes(color = gender), method = "lm") + 
  facet_grid(rows = vars(urban))





# We can "prettify" the plot with themes, change the "scales", and more...
ggplot(df_NPAS, aes(x = age, y = Nerdy)) + 
  geom_point(aes(color = gender), alpha = 0.7, shape = 3) + 
  stat_smooth(aes(color = gender), method = "lm", 
              linewidth = 1.5, fill = "gray") + 
  facet_grid(cols = vars(urban),
             # We can change the facet labels:
             labeller = as_labeller(c("0" = "N/A", "1" = "Rural", "2" = "Suburban", "3" = "Urban"))) + 
  # scale_*() functions can be used to control the appearance of different
  # scales (x, y, color, fill, size...) - things that we've mapped.
  scale_color_manual(values = c(woman = "red4", man = "steelblue4", other = "purple1"),
                     labels = c("Woman", "Man", "Other")) +
  coord_cartesian(ylim = c(0, 5)) + 
  labs(x = "Age [years]", color = "Gender") + 
  theme_light() + 
  theme(legend.position = "bottom")

# Example 2 ---------------------------------------------------------------


# Let's try another example, with the same data, this time with the `Nerdy` and
# `gender` variables:
ggplot(df_NPAS, aes(x = gender, y = Nerdy))



ggplot(df_NPAS, aes(x = gender, y = Nerdy)) + 
  geom_point()

# because the x-variable is categorical, we might get a better understanding of
# the data with a box plot:
ggplot(df_NPAS, aes(x = gender, y = Nerdy)) + 
  stat_boxplot()



ggplot(df_NPAS, aes(x = gender, y = Nerdy)) + 
  stat_boxplot() + 
  stat_ydensity()


# Can't really see the boxes! Order of geoms matters!
ggplot(df_NPAS, aes(x = gender, y = Nerdy)) + 
  stat_ydensity(trim = FALSE) + 
  stat_boxplot(mapping = aes(color = gender), fill = NA)


# Note that both geom_violin and geom_boxplot didn't draw the raw data as is,
# but summarized the data first. In some cases, we might want to summarize the
# data ourselves in some way before plotting (with `group_by() |> summarize()`)





# Example 2 ---------------------------------------------------------------


# What will this do?
ggplot(df_NPAS, mapping = aes(x = Nerdy)) + 
  stat_bin(color = gender)


# Seems like we don't want the color to represent gender, but maybe the filling
# instead? Just MAP onto `fill`.
ggplot(df_NPAS, mapping = aes(x = Nerdy, fill = gender)) + 
  stat_bin()


ggplot(df_NPAS, mapping = aes(x = Nerdy, color = gender)) + 
  stat_bin(mapping = aes(linetype = gender),
           linewidth = 1, fill = "yellow", alpha = 0.4)
# note that `linetype` is in `aes()` - so it varies according to some variable,
# whereas shape, fill, and alpha (the opacity) are not inside `aes()` so there
# are FIXED to a constant.






# and many many more... 
# - The basics: https://ggplot2-book.org/
# - Explore options + cheat sheet here: https://ggplot2.tidyverse.org/
# - How to get the plot you want: https://www.r-graph-gallery.com/index.html
# - Learn how to better visualize your data: https://serialmentor.com/dataviz/visualizing-amounts.html
#
# ggplot is a powerful tool - with many other packages interfacing or expanding
# on it. We will see some of them later on.







# Take 5 minutes, look at the data - think what you'd like to plot.



# Hebrew / Arabic plots ---------------------------------------------------

# ggplot2 for the most part supports right-to-left (RTL) scripts, but not always
# the use of mixed texts. There are some work arounds, and there are those
# working to improve it. E.g.:
# https://gist.github.com/adisarid/b2ab5ec3dd225579bd4ad069ec111d83


# Exporting plots ---------------------------------------------------------

# You "can" export images via the "Export" menu in the "Plots" tab,
# but this save the images in very poor quality.

# for best results: 
library(ragg)                        # 1. load {ragg} before saving
packageVersion("ggplot2") >= "3.3.5" # 2. use the latest ggplot2 version

p <- ggplot(df_NPAS, aes(x = age, y = Nerdy)) + 
  geom_point(aes(color = gender))

# As tiff
ggsave(filename = "p2.tiff", plot = p,
       # - Size -
       units = "mm",
       width = 480,
       height = 300, 
       # - Resolution -
       dpi = 600,
       scaling = 1) # play with this one to get it juuuust right


# As png
ggsave(filename = "p2.png", plot = p,
       # - Size -
       units = "mm",
       width = 480,
       height = 300, 
       # - Resolution -
       dpi = 600,
       scaling = 1) # play with this one to get it juuuust right


# As pdf
ggsave(filename = "p2.pdf", plot = p,
       # - Size -
       units = "mm",
       width = 480,
       height = 300,
       # - Resolution -
       dpi = 600,
       scale = 1) # play with this one to get it juuuust right



# Exercise ----------------------------------------------------------------


# Using ggplot, try and (visually) answer the following question:
# 1. What is the relationship between extraversion (`TIPI1`) and nerdiness
#   (`Nerdy`).
# 2. Does it vary by family size (`familysize`)? Autism diagnosis (`ASD`)? Both?





