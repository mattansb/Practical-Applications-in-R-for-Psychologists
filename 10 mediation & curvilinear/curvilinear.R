
parental_iris <- read.csv("parental_iris.csv")
head(parental_iris)

m_lin <- lm(child_satisfaction ~ parental_strictness, parental_iris)
parental_iris$Y_pred_lin <- predict(m_lin)

library(ggplot2)

ggplot(parental_iris, aes(parental_strictness,child_satisfaction)) +
  geom_point()

ggplot(parental_iris, aes(parental_strictness,child_satisfaction)) +
  geom_point() +
  geom_segment(aes(xend = parental_strictness, yend = Y_pred_lin),
               position = position_nudge(0.03), color = "red") +
  geom_line(aes(y = Y_pred_lin), color = "red", size = 1)

# Curvilinear -------------------------------------------------------------

# auto centered!
m_curvi <- lm(child_satisfaction ~ poly(parental_strictness,2), parental_iris)
summary(m_curvi)
anova(m_lin, m_curvi)
performance::compare_performance(m_lin, m_curvi)

# uncentered
m_curvi2 <- lm(child_satisfaction ~ parental_strictness + I(parental_strictness^2), parental_iris)
summary(m_curvi2)

parental_iris$Y_pred_curvlin <- predict(m_curvi2)

ggplot(parental_iris, aes(parental_strictness,child_satisfaction)) +
  geom_point() +
  geom_segment(aes(xend = parental_strictness, yend = Y_pred_curvlin),
               position = position_nudge(-0.03), color = "blue") +
  geom_line(aes(y = Y_pred_curvlin), color = "blue", size = 1)
