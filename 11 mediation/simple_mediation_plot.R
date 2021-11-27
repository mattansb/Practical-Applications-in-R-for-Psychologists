simple_mediation_plot <- function(a = NA, b = NA, direct = NA,
                                  indirect = NA, total = NA,
                                  X_name = "X", M_name = "M", Y_name = "Y", ...) {

  stopifnot("Please install 'tidySEM'" = require("tidySEM"))

  nodes <- data.frame(name = c("X", "M", "Y"),
                      label = c(X_name, M_name, Y_name),
                      shape = c("rect", "rect", "rect"))

  edges <- data.frame(from = c("X", "M", "X"),
                      to = c("M", "Y", "Y"),
                      label = c(a, b, direct),
                      connect_from = c("top", "right", "right"),
                      connect_to = c("left", "top", "left"),
                      arrow = c("last", "last", "last"),
                      show = c(TRUE, TRUE, TRUE),
                      curvature = c(NA, NA, NA),
                      linetype = c("solid", "solid", "solid"))

  layout <- structure(c(NA, "X", "M", NA, NA, "Y"),
                      .Dim = 2:3,
                      class = c("matrix", "array"))

  if (!is.na(total)) {
    nodes <- rbind(nodes,
                   data.frame(name = c("X_", "Y_"),
                              label = c(X_name, Y_name),
                              shape = c("rect", "rect")))

    edges <- rbind(edges,
                   data.frame(from = "X_", to = "Y_", label = total,
                              connect_from = "right", connect_to = "left",
                              arrow = "last", show = TRUE, curvature = NA, linetype = "solid"))

    layout <- rbind(layout, c("X_", NA, "Y_"))
  }

  if (!is.na(indirect)) {
    nodes$label[2] <- paste0(nodes$label[2], "\n", indirect)
  }

  g <- tidySEM::prepare_graph(
    edges = edges,
    nodes = nodes,
    layout = layout,
    ...
  )
  g$edges <- edges
  g
}
