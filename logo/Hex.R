library(hexSticker)
library(tidyverse)

# Hex ---------------------------------------------------------------------

p_r <- ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) + 
  geom_point(size = 2, alpha = 0.6, shape = 16) + 
  geom_smooth(method = "lm", se = FALSE) + 
  scale_color_brewer(type = "qual", palette = 6) + 
  theme_void() + 
  theme_transparent() + 
  theme(legend.position = "none") + 
  NULL

sticker(p_r, package="Practical Applications in R for Psych",
        filename = "Hex.png",
        s_x = 1, s_y = 0.9, s_width = 1.6, s_height = 1.2,
        p_color = "white", p_size = 8,
        h_color = "grey", h_fill = "orange",
        spotlight = TRUE, l_y = 1.2)
