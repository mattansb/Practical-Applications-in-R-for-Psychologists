
# 1. What does this do? ---------------------------------------------------

set.seed(4)
x <- sample(seq(1,8,length.out = 25),10000,replace = TRUE) %% 7

#' We can break this long function in a function in a function into the
#' following steps:

#' 1. Make a sequence from 1 to 8, of length 25 (the step-size will be
#'    computed internally):
the_sequence <- seq(1,8,length.out = 25)

#' 2. Sample from `the_sequence` 10,000 times, *with* replacment:
the_samples <- sample(the_sequence, 10000, replace = TRUE)

#' 3. Get the "she'erit" of each value in `the_samples` when it is
#'    divided by 7, and save this numceric vector it into `x`:
x <- the_samples %% 7


# 2. create a new object that counts how many times does x equal 2.75 ------

#' there are many ways we can do this:
sum(x == 2.75)
#' or
length(x[x==2.75])
#' or (same as this ^):
i <- x==2.75
z <- x[i]
length(z)
#' anyway... answer is 390


# 3. What is the 102nd value of x? ----------------------------------------
x[102]
#' answer: 3.333333



# 4. create a new object of type list with the following elemtns: ---------
#    a. your name
#    b. how many cousins you have
#    c. the names of the people to the left and right of you (as a vector).

list(name = "Mattan S. Ben-Shachar",
     n_cousins = 18,
     left_and_right = c(left = "Maayan", right = NA))
#' I chose to name the elements, but you don't have to. Also, the last 
#' element could itself be a list in this case:
list(name = "Mattan S. Ben-Shachar",
     n_cousins = 18,
     left_and_right = list(left = "Maayan", right = NA))
