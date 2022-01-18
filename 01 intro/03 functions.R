

# Functions ---------------------------------------------------------------


# Functions are also R objects, just like any other!
sqrt

# So their values (function) can be assigned into new object
shoe <- sqrt
shoe(9)
shoe(81)
shoe(shoe(81))


blahblah <- is.logical
blahblah(FALSE)
blahblah("a")


# We can also make new function!




# sum of two dice (from: "Hands-on programming with R")
two_dice <- function() {
  die <- 1:6
  dice <- sample(die, 2, replace = TRUE)
  sum(dice)  # the function will return the last command by default
}

two_dice
two_dice()


# sum of n dice
n_dice <- function(n) {
  die <- 1:6
  dice <- sample(die, n, replace = TRUE)
  sum(dice)
}

n_dice(5)



# default values:
n_dice <- function(n = 2) {
  die <- 1:6
  dice <- sample(die, n, replace = TRUE)
  sum(dice)
}

n_dice()
n_dice(50)










# a new measure of distribution symmetry: mean/median.
symmetry <- function(x) {
  return(mean(x) / median(x))
}

a <- c(1, 2, 3, 4, 5, 6, 7, 7, 7, 9, 9, 9, 9, 9)
symmetry(a)


# many inputs:
symmetry <- function(x, top = "mean") {
  if (top == "mean") {
    return(mean(x) / median(x))
  } else if (top == "median") {
    return(median(x) / mean(x))
  } else {
    stop("top can only be 'mean' or 'median'")
  }
}

symmetry(a)
symmetry(a, top = "mean")
symmetry(a, top = "median")
symmetry(a, top = "mode")


