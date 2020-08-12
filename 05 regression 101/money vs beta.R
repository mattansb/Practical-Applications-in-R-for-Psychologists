library(bayestestR)

n <- 500
set.seed(1)
xtra_hours <- sample(distribution("exp", n = 500, rate = 0.25))
n_comps <- sample(distribution("binom", n = 500, size = 3, prob = 0.35))
e <- sample(distribution("normal", n = 100, sd = 0.5))

salary <-
  20000 + 5000 * (
    scale(xtra_hours) + 
      scale(n_comps)/2 + 
      e
  )
  

dat <- data.frame(salary,xtra_hours,n_comps)

fit <- lm(salary ~ n_comps + xtra_hours, data = dat)
parameters::parameters(fit)
effectsize::standardize_parameters(fit)
hist(salary)
hist(xtra_hours)
hist(n_comps)

performance::check_collinearity(fit)

plot(xtra_hours,salary)
plot(n_comps,salary)

library(emmeans)
library(magrittr)
library(ggplot2)
library(patchwork)


p1 <- emmeans(fit, ~xtra_hours, cov.red = list(xtra_hours = function(.x) c(0,unique(.x)))) %>% 
  predict(interval = "prediction") %>% 
  ggplot(aes(xtra_hours, prediction, ymin = lower.PL, ymax = upper.PL)) + 
  geom_ribbon(alpha = 0.2) + 
  geom_line() + 
  NULL

p2 <- emmeans(fit, ~n_comps, cov.red = list(n_comps = unique)) %>% 
  predict(interval = "prediction") %>% 
  ggplot(aes(n_comps, prediction, ymin = lower.PL, ymax = upper.PL)) + 
  geom_ribbon(alpha = 0.2) + 
  geom_line() + 
  NULL

px1 <- (p1 + p2 +
    theme(axis.title.y = element_blank(),
      axis.text.y = element_blank(),
      axis.ticks.y = element_blank()) & 
    coord_cartesian(ylim = range(dat$salary)) &
    scale_x_continuous(expand = c(0,0))) + 
  # plot_layout(widths = c(25,3)) +
  NULL &
  # geom_vline(xintercept = c(0,3), color = "blue", alpha = 0.7) &
  scale_y_continuous("salary", labels = scales::dollar_format(prefix = "", suffix = "₪"))


px2 <- (p1 + p2 +
          theme(axis.title.y = element_blank(),
                axis.text.y = element_blank(),
                axis.ticks.y = element_blank()) & 
          coord_cartesian(ylim = range(dat$salary)) &
          scale_x_continuous(expand = c(0,0))) + 
  plot_layout(widths = c(25,3)) +
  NULL &
  # geom_vline(xintercept = c(0,3), color = "blue", alpha = 0.7) &
  scale_y_continuous("salary", labels = scales::dollar_format(prefix = "", suffix = "₪"))

px1 / (px2 + plot_spacer() + plot_layout(ncol = 3, widths = c(25,3,22)))
