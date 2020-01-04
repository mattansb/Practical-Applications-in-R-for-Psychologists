library(performance) # for compare_performance, r2
library(parameters)  # for model_parameters
library(ggplot2)     # for plotting

parental_iris <- read.csv("parental_iris.csv")
head(parental_iris)

m_lin <- lm(child_satisfaction ~ parental_strictness, parental_iris)
parental_iris$Y_pred_lin <- predict(m_lin)

# lets looks at the data:
p <- ggplot(parental_iris, aes(parental_strictness,child_satisfaction)) +
  geom_point()
p

p +
  geom_segment(aes(xend = parental_strictness, yend = Y_pred_lin), color = "red") +
  geom_line(aes(y = Y_pred_lin), color = "red", size = 1)

# Curvilinear -------------------------------------------------------------

# auto centered!
m_curvi <- lm(child_satisfaction ~ poly(parental_strictness,2), parental_iris)
# we can also have X^3 with poly(x,3), etc...

summary(m_curvi)
model_parameters(m_curvi, standardize = "basic")

anova(m_lin, m_curvi)
compare_performance(m_lin, m_curvi)


# lets plot again:
parental_iris$Y_pred_curvlin <- predict(m_curvi)

ggplot(parental_iris, aes(parental_strictness,child_satisfaction)) +
  geom_point() +
  geom_segment(aes(xend = parental_strictness, yend = Y_pred_curvlin), color = "blue") +
  geom_line(aes(y = Y_pred_curvlin), color = "blue", size = 1)
