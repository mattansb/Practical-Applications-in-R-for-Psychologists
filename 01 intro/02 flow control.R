

# Control -----------------------------------------------------------------



## if, else if, else ------------------------------------------------------

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

if (salary < 4000) {
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













## Loops ------------------------------------------------------------------


# what does this code do?
test <- numeric(length = 100)

for (i in c(1, 3, 6, 2)) {
  
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





## More -------------------------------------------------------------------

# See:
?Control


