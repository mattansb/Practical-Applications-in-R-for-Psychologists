# Intro -------------------------------------------------------------------

3 + 4 # execute a line with Ctrl + Enter

a <- 3
a
a + 4

b <- 4
a + b
a * b


c <- a + b
c <- a * b
c <- b - a
c <- B - A

(a <- 5)

# Operators ---------------------------------------------------------------
?`+`
#   + addition
#   - subtraction
#   * multiplication
#   / division
#   ^ power
#   %% modulo. The remainder after division. E.g., 5 %% 2 = 1
#   %/% integer division. E.g., 5 %/% 2 = 2

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





# Other types of variables ------------------------------------------------

# character
Group1 <- "control"
Group2 <- "experimental"
Group1 / a


# logical
x <- a > b
y <- b > a
z <- a == 7
z <- a = 7

is.logical(a)
is.numeric(a)
is.character(a)

# Functions??? ------------------------------------------------------------

blah <- exp
blah(1)


# Vectors -----------------------------------------------------------------
# a vector is a "chain" of values
# You can "chain" values together with `c`

math.grades <- c(93, 30, 84, 88, 100, 67)
english.grades <- c(100, 45, 90, 77, 88, 90)
is.numeric(math.grades)

length(math.grades)

mean(math.grades)
sd(math.grades)
max(math.grades)
range(math.grades)
mean(math.grades)
median(math.grades)
cor(math.grades, english.grades)
hist(math.grades)
plot(math.grades,english.grades)


pass.english <- english.grades >= 56 # what will this make?


hebrew.grades <- c(100, NA, 99, 100, 80, 75)
is.na(hebrew.grades)
mean(hebrew.grades)
mean(hebrew.grades, na.rm = TRUE)
mean(x = hebrew.grades, na.rm = TRUE)
mean(na.rm = TRUE, x = hebrew.grades)


# Creating vectors
v1 <- c(1,2,3,4,5,6,7,8,9,10)
v2 <- 1:10
v3 <- seq(from = 1, to = 10, by = 1)
v4 <- seq(from = 1, to = 10, length = 10)

v5 <- rep(0, 1000)
v6 <- rep(c(1, 2, 5), each = 10)
v7 <- rep(c(1, 2, 5), times = 10)

# operations
v8 <- v1 * 5
v9 <- v6 + v7

# sample
v10 <- sample(v9, 100, replace = TRUE)

set.seed(1)
v10 <- sample(v9, 100, replace = TRUE)

# Extract and replace
v9[1]
v9[20:30]
v9[v9 > 6]
mean(v9[v9 > 6])

v9[1] <- 100
v9[c(2,4,6)] <- -99
v9

head(v9, 3)
tail(v9, 3)
head(v9, -3)
tail(v9, -3)

v10 <- c(v9, 5)
v16 <- c(v1, v8)

which(math.grades > 80 & math.grades <= 90)
str(math.grades)

# naming vector elements
names(math.grades) <- 1:6
names(english.grades) <- c("yossi", "danny", "avi", "moshe", "david", "eli")
english.grades["avi"]
english.grades[3]
english.grades[7 %% 4]

french.grades <- c("yossi" = 90,
                   "danny" = 100,
                   "avi" = 56)

# Factors -----------------------------------------------------------------

sex <- sample(c("F","M"), size = 10, replace = TRUE)
factor(sex)
factor(sex, levels = c("M","F")) # who cares about the order?
factor(sex, levels = c("M","f")) # be carful...
factor(sex, levels = c("M"))
factor(sex, labels = c("Female","Male"))

# Lists -------------------------------------------------------------------

# mix
list1 <- list(100,"gugu",FALSE,"TRUE",255)
str(list1)

# name elements
list2 <- list("Name" = "Beer-Sheva", "Population" = 200000, "is_negev" = TRUE)
list2$Name
list2[["Name"]]
list2[[1]]
list2[1] # whats the difference???
list2[c("Name","Population")]

# list with sub list
list3 <- list("a" = 4, "b" = 2, "c" = list(1,3,5,T,"T"))
str(list3)


list3[1]*3
list3[[1]]*3

list3[[3]][5]
list3[["c"]][5]

# R projects --------------------------------------------------------------

# RStudio only...

# Exercise ----------------------------------------------------------------

# 1. What does this do?
set.seed(4)
x <- sample(seq(1,8,length.out = 25),10000,replace = TRUE) %% 7

# 2. create a new object that counts how many times does x equal 2.75.

# 3. What is the 102nd value of x?

# 4. create a new object of type list with the following elemtns:
#    a. your name
#    b. how many cousins you have
#    c. the names of the people to the left and right of you (as a vector).
