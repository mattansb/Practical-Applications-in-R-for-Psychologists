

# if, else if, else -------------------------------------------------------

# if/else:
#
# if (condition) {
#   do something
# } else if (another condition) {
#   do something else
# } else {
#   find something else to do
# }

# e.g.,

salary <- runif(1, min = 1000, max = 20000)

if (salary < 5000) {
  worker <- "poor"
} else if (salary > 15000) {
  worker <- "rich"
} else {
  worker <- "so so"
}

list(salary, worker)







# note: if..else is a control flow function. Takes only one logical value.
salary <- runif(3, min = 1000, max = 20000)
if (salary < 5000) {
  worker <- "poor"
} else if (salary > 15000) {
  worker <- "rich"
} else {
  worker <- "so so"
}

list(salary, worker)







# to use with a vector: use `ifelse()` (taking a vector as input).
worker <- ifelse(salary < 5000, "poor",
                 ifelse(salary > 15000, "rich",
                        "so so"))
list(salary,worker)













# Loops -------------------------------------------------------------------


# what does this code do?
test <- numeric(length = 100)

for (i in seq_along(test)) {
  
  test[i] <- i ^ 2
  
}
test




# what does this code do?
num <- rnorm(100)
min_num <- 1000


for (i in seq_along(num)) {
  if (num[i] < min_num) {
    min_num <- num[i]
  }
}
min_num




## pre-allocate vectors.
system.time({
  b <- NA
  for (i in 1:1e5) {
    b[i] <- rnorm(1)
  }
})


system.time({
  b <- numeric(1e5)
  for (i in 1:1e3) {
    b[i] <- rnorm(1)
  }
})


## vectorizing
system.time({
  a <- numeric(1e5)
  for (i in 1:1e5) {
    a[i] <- rnorm(1)
  }
})


system.time({
  a <- rnorm(1e5)
})


# For most cases, you probably can do without loops...
# see apply-family / the `purrr` pkg (not covered in this course)











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
n_dice(5)










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


