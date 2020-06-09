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

sticker(p_r, package="ARMP - Practical Applications in R",
        filename = "BGUHex.png",
        s_x = 1, s_y = 0.9, s_width = 1.6, s_height = 1.2,
        p_color = "white", p_size = 8,
        h_color = "grey", h_fill = "orange",
        spotlight = TRUE, l_y = 1.2)

# Panel -------------------------------------------------------------------

df <- rbind(data.frame(x = c(0, 0, 1,   0.5,  0, -0.5, -1, -0.5),
                       y = c(-0.4, 1, 1.5, 2.5,  3, 2, 1.5, 1),
                       group = "main"),
            data.frame(x = c(-.7, -0.5,-0.5) - 0.2,
                       y = c(-0.4, 0.5,0.75),
                       group = "left"),
            data.frame(x = -c(-.7, -0.5,-0.6) + 0.2,
                       y = c(-0.4, 0.5,0.75),
                       group = "right"))

ggplot(df, aes(x,y, group = group)) +
  geom_path(color = "white", size = 10) +
  theme(panel.background = element_rect(fill = "orange")) +
  coord_cartesian(xlim = c(-5,5), ylim = c(-0.5, 3.5))


# Hex ---------------------------------------------------------------------
# 
# hex_p <- ggplot(df, aes(x,y, group = group)) +
#   geom_path(color = "white", size = 2) +
#   theme_transparent() +
#   coord_cartesian(xlim = c(-4,4), ylim = c(-0.5, 3.1))
# 
# sticker(hex_p, package="ARMP - Practical Applications in R",
#         filename = "BGUHex.png",
#         s_x = 0.9, s_y = 0.8, s_width = 1.6, s_height = 1.2,
#         p_color = "white", p_size = 8,
#         h_color = "grey", h_fill = "orange",
#         spotlight = TRUE, l_y = 1.2)
