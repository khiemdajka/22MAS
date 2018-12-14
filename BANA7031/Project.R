### BANA 7031 - Probability Models
### Khiem Pham - M13048732
### Project


# 0. Load data
library(SASxport)
library(pastecs)
library(ggplot2)

Demo <- read.xport("DEMO_H.XPT")
Bmx <- read.xport("BMX_H.XPT")
FullData <- merge.data.frame(Demo, Bmx, by = "SEQN")
FullData$RIAGENDR <- as.factor(FullData$RIAGENDR)
FilterData <- FullData[FullData$RIDAGEYR >= 21, ]
M_Height <- as.vector(FilterData$BMXHT[FilterData$RIAGENDR == 1])
F_Height <- as.vector(FilterData$BMXHT[FilterData$RIAGENDR == 2])
M_Height <- na.omit(M_Height)
F_Height <- na.omit(F_Height)

ggplot(FilterData, aes(x = BMXHT, fill = RIAGENDR)) + geom_density(alpha = .3)

# 1. Hypothesis testing

# 1.1. Wald test
m.n <- length(M_Height)
f.n <- length(F_Height)
m.bar <- mean(M_Height)
f.bar <- mean(F_Height)
m.se <- sd(M_Height)
f.se <- sd(F_Height)
se <- sqrt(m.se^2/m.n + f.se^2/f.n)

w <- (m.bar - f.bar)/se
p.value_w <- 2*pnorm(-abs(w))

# 1.2. Permutation test
B <- 10000
data.vector <- c(M_Height, F_Height)
n <- length(data.vector)
t.obs <- abs(m.bar - f.bar)
perm.matrix <- replicate(B, sample(n))
perm.T <- apply(perm.matrix, 1, function(x) {abs(mean(data.vector[x[1:m.n]]) - mean(data.vector[x[(m.n+1):n]]))})
p.value_p <- mean(perm.T > t.obs)

# 1.3. Wilcoxon Rank-Sum test
wilcox.test(x = M_Height, y = F_Height, conf.int = T)


# 2. Testing with decreased sample size

# 2.1. Sample size = 100
M_Height1 <- sample(M_Height, 100)
F_Height1 <- sample(F_Height, 100)

# 2.1.1. Wald test
m.n1 <- length(M_Height1)
f.n1 <- length(F_Height1)
m.bar1 <- mean(M_Height1)
f.bar1 <- mean(F_Height1)
m.se1 <- sd(M_Height1)
f.se1 <- sd(F_Height1)
se1 <- sqrt(m.se1^2/m.n1 + f.se1^2/f.n1)

w1 <- (m.bar1 - f.bar1)/se1
p.value_w1 <- 2*pnorm(-abs(w1))

# 2.1.2. Permutation test
data.vector1 <- c(M_Height1, F_Height1)
n1 <- length(data.vector1)
t.obs1 <- abs(m.bar1 - f.bar1)
perm.matrix1 <- replicate(B, sample(n1))
perm.T1 <- apply(perm.matrix1, 1, function(x) {abs(mean(data.vector1[x[1:100]]) - mean(data.vector1[x[101:200]]))})
p.value_p1 <- mean(perm.T1 > t.obs1)

# 2.1.3. Wilcoxon Rank-Sum test
wilcox.test(x = M_Height1, y = F_Height1, conf.int = T)

# 2.2. Sample size = 10
M_Height2 <- sample(M_Height, 10)
F_Height2 <- sample(F_Height, 10)

# 2.2.1. Wald test
m.n2 <- length(M_Height2)
f.n2 <- length(F_Height2)
m.bar2 <- mean(M_Height2)
f.bar2 <- mean(F_Height2)
m.se2 <- sd(M_Height2)
f.se2 <- sd(F_Height2)
se2 <- sqrt(m.se2^2/m.n2 + f.se2^2/f.n2)

w2 <- (m.bar2 - f.bar2)/se2
p.value_w2 <- 2*pnorm(-abs(w2))

# 2.2.2. Permutation test
data.vector2 <- c(M_Height2, F_Height2)
n2 <- length(data.vector2)
t.obs2 <- abs(m.bar2 - f.bar2)
perm.matrix2 <- replicate(B, sample(n2))
perm.T2 <- apply(perm.matrix2, 1, function(x) {abs(mean(data.vector2[x[1:10]]) - mean(data.vector1[x[11:20]]))})
p.value_p2 <- mean(perm.T2 > t.obs2)

# 2.2.3. Wilcoxon Rank-Sum test
wilcox.test(x = M_Height2, y = F_Height2, conf.int = T)

# 2.3. Sample size = 5
M_Height3 <- sample(M_Height, 5)
F_Height3 <- sample(F_Height, 5)

# 2.3.1. Wald test
m.n3 <- length(M_Height3)
f.n3 <- length(F_Height3)
m.bar3 <- mean(M_Height3)
f.bar3 <- mean(F_Height3)
m.se3 <- sd(M_Height3)
f.se3 <- sd(F_Height3)
se3 <- sqrt(m.se3^2/m.n3 + f.se3^2/f.n3)

w3 <- (m.bar3 - f.bar3)/se3
p.value_w3 <- 2*pnorm(-abs(w3))

# 2.2.2. Permutation test
data.vector3 <- c(M_Height3, F_Height3)
n3 <- length(data.vector3)
t.obs3 <- abs(m.bar3 - f.bar3)
perm.matrix3 <- replicate(B, sample(n3))
perm.T3 <- apply(perm.matrix3, 1, function(x) {abs(mean(data.vector3[x[1:5]]) - mean(data.vector1[x[6:10]]))})
p.value_p3 <- mean(perm.T3 > t.obs3)

# 2.2.3. Wilcoxon Rank-Sum test
wilcox.test(x = M_Height3, y = F_Height3, conf.int = T)


# 3. Simulate Wald test p-value
p.value_w4 <- rep(NA, B)

for (i in 1:B) {
  M_Height4 <- sample(M_Height, 5)
  F_Height4 <- sample(F_Height, 5)
  m.n4 <- length(M_Height4)
  f.n4 <- length(F_Height4)
  m.bar4 <- mean(M_Height4)
  f.bar4 <- mean(F_Height4)
  m.se4 <- sd(M_Height4)
  f.se4 <- sd(F_Height4)
  se4 <- sqrt(m.se4^2/m.n4 + f.se4^2/f.n4)
  
  w4 <- (m.bar4 - f.bar4)/se4
  p.value_w4[i] <- 2*pnorm(-abs(w4))
}
hist(p.value_w4)
