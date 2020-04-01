# Intro -------------------------------------------------------------------

3 + 4 # execute a line with Ctrl + Enter

# Assign a value to a variable with   <-
# (will appear as an object in the environment)
a <- 3

# You can "print" the contents of an object by calling it:
a

# You can use the object just as you would its contents:
a + 4

b <- 4
a + b
a * b
a <- 8


c <- a + b
c <- a * b
c <- b - a
c <- B - A # Your first ERROR. Why?

c <- a + b
(c <- a + b)

# Operators ---------------------------------------------------------------

#   +   addition
#   -   subtraction
#   *   multiplication
#   /   division
#   ^   power
#   %%  modulo. The remainder after division. E.g., 5 %% 2  is  1
#   %/% integer division. E.g., 5 %/% 2  is  2

# Order of operations

a + b / 2
a + (b / 2)
(a + b) / 2


# Math functions
#   sqrt(x)     square root
#   abs(x)      absolute value
#   exp(x)      exponent
#   log(x)      natural logaritm
#   log10(x)
#   ceiling(x)  round upwards
#   floor(x)    round downwards
#   round(x)    round to the nearest integer
#   trunc(x)    get rid of decimal digits

# Get help on a function
?exp





# Other types of variables ------------------------------------------------

# character
Group1 <- "control"
Group2 <- "experimental"
Group1 / a




# logical
x <- a > b
y <- b > a
z <- a == 7
z <- a != 7
z <- a = 7
z <- a <- 7

is.logical(a)
is.logical("TRUE")
is.logical(TRUE)
is.numeric(a)
is.character(a)








# Vectors -----------------------------------------------------------------
# a vector is a "chain" of values
# You can "chain" values together with the `c` function

math.grades <- c(93, 30, 84, 88, 100, 67)
english.grades <- c(100, 45, 90, 77, 88, 90)





# Some function work on the whole vector
is.numeric(math.grades)
length(math.grades)
mean(math.grades)
sd(math.grades)
max(math.grades)
range(math.grades)
median(math.grades)
hist(math.grades)


# some accept more than 1 ARGUMENT - in this case: two numeric vectors
cor(math.grades, english.grades)
plot(math.grades, english.grades)


# What will these make?
pass.english <- english.grades >= 56
pass.english
sum(pass.english)
mean(pass.english)
TRUE + 4



hebrew.grades <- c(100, NA, 99, 100, 80, 75)
is.na(hebrew.grades)
mean(hebrew.grades)
mean(hebrew.grades, na.rm = TRUE)
# You can directly name the arguments,
mean(x = hebrew.grades, na.rm = TRUE)
# But don't have to if they're in order
# (use ? to see the arguments a function takes)
mean(hebrew.grades, 0, TRUE)
# If you name the arguments, they can be in any order
mean(na.rm = TRUE, x = hebrew.grades)
mean(na.rm = TRUE, hebrew.grades)


# Statistical distributions
rnorm(1)
rnorm(10)

x <- rnorm(1000)
hist(x)

x <- rnorm(1000, mean = 100, sd = 15)
hist(x)

x <- runif(1000)
hist(x)

x <- rexp(1000)
hist(x)


qnorm(.05) # input is probability
pnorm(-1.96) # input is random variable value
qt(.95,df = 12)


# Working with vectors ----------------------------------------------------

## Creating vectors
# Manually
v1 <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)

# a sequence
v2 <- 1:10
v3 <- seq(from = 1, to = 10, by = 1)
v4 <- seq(from = 1, to = 10, length = 10)
seq(from = 1, to = 10, length = 4)
seq_along(v4)
seq_len(length.out = 123)

# repeat a value
v5 <- rep(0, 1000)
v5
v6 <- rep(c(1, 2, 5), each = 10)
v7 <- rep(c(1, 2, 5), times = 10)

# combind
c(v6, v7) # same as
c(rep(c(1, 2, 5), each = 10), rep(c(1, 2, 5), times = 10))




## Math operations on vectors
v8 <- v1 * 5
v9 <- v6 + v7
c(1, 2, 3, 4) + c(1, 2)




## sample
v10 <- sample(v9, 100, replace = TRUE)
v10

set.seed(1)
v10 <- sample(v9, 100, replace = TRUE)



## Extract and replace
# by index
v9[1]
v9[20:30]
i <- c(1, 3, 4)
v9[i]
v9[c(1, 3, 4)] # same



v9[1]
v9[1] <- 100
v9[c(2, 4, 6)] <- -99
v9


head(v9, 3)
tail(v9, 3)
head(v9,-3)
tail(v9,-3)

v10 <- c(v9, 5)
v16 <- c(v1, v8)

# with a logical vector
v9[v9 > 6]
mean(v9[v9 > 6])


which(math.grades > 80 & math.grades <= 90)




## naming vector elements
names(math.grades) <- 1:4
names(english.grades) <- c("noa", "tzipi", "avi", "shira")
names(english.grades)
english.grades["shira"]
english.grades[4]
english.grades[9 %% 5]

french.grades <- c("nirit" = 90,
                   "yoav" = 100,
                   "mattan" = 56)
mean(french.grades)
french.grades["yossi"] + 2




# Factors -----------------------------------------------------------------

# A factor is a vector of categories.
# Unlike a character vector, factors usually represent "levels".

sex <- sample(c("F", "M"), size = 10, replace = TRUE)
x <- factor(sex)
# x[4] <- "G"
factor(sex, levels = c("M", "F")) # who cares about the order?
factor(sex, levels = c("m", "f")) # be carful...
factor(sex, levels = c("M"))

# change the labels
factor(sex, labels = c("Female", "Male"))
factor(sex, levels = c("M", "F"), labels = c("Male", "Female"))





















# Lists -------------------------------------------------------------------

# What if you wanted to mix some types?
list1 <- c(100, "gugu", FALSE, "TRUE", 255)
str(list1)

# Use `list`!
list1 <- list(100, "gugu", FALSE, "TRUE", 255)
str(list1)

# each "value" in a list is an element.

# We can name elements
list2 <- list("Name" = "Beer-Sheva",
              "Population" = 200000,
              "is_negev" = TRUE)

# We can now extract elements by their name:
list2$Name
list2[["Name"]]
list2[[1]]
list2["Name"]



list2[["Population"]] + 5
list2["Population"] + 5
list2[1] # whats the difference???
list2[c("Name","Population")]

# list with sub list (etc...)
list3 <- list("a" = 4,
              "b" = 2,
              "c" = list(1, 3, 5, T, "T"))
str(list3)


list3[1]*3
list3[[1]]*3

list3[[3]][5]
list3[["c"]][[5]]

list3[["b"]] <- list3[["b"]] + 2

# what will this do?
tail(head(c(2,3,4)[2:3][1:2][1][1])) # (don't ever do this)



# R projects --------------------------------------------------------------

# RStudio only...




# Exercise ----------------------------------------------------------------

# 1. What does this do?
# TIP: try and break it down to its componants.
set.seed(4)
x <- sample(seq(1, 8, length.out = 25), 10000, replace = TRUE) %% 7



# 2. create a new object that counts how many times does x equal 2.75.




# 3. What is the 102nd value of x?



# 4. create a new object of type list with the following elemtns:
#    a. your name
#    b. how many cousins you have
#    c. the names of the people to the left and right of you (as a vector).
