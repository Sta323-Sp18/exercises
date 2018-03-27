library(profvis)
library(dplyr)

# Example 1 - lm


# Example 2 - growing a vector


# Example 3 - ggally


# Example 4

## From https://stats.stackexchange.com/questions/266665/gibbs-sampler-examples-in-r

## y ~ N(mu, 1/tau)
##
## f(mu) \propto 1
## f(tau) \propto 1/tau
##
## mu | tau, y_bar ~ N(y_bar, 1/(n tau))
## 
## tau | mu, y_bar ~ Gamma(n/2, 2 / ((n-1)s^2 + n(mu-y_bar)^2))

n = 30
y_bar = 15
s2 = 3

nburn = 100000
niter = 10000

mu = rep(NA, nburn+niter)
tau = rep(NA, nburn+niter)

tau[1] = 1
for(i in 2:(nburn+niter)) {   
  mu[i] = rnorm(n = 1, mean = y_bar, sd = sqrt(1 / (n * tau[i - 1])))    
  tau[i] = rgamma(n = 1, shape = n / 2, scale = 2 / ((n - 1) * s2 + n * (mu[i] - y_bar)^2))
}

mu = mu[-(1:nburn)]
tau = tau[-(1:nburn)]


# Example 6 - Gibbs (bivariate normal)

## Write a Gibbs sampler to draw from the following distribution,
## y ~ N( (0),  ( 1   0.5))
##      ( (0)   (0.5   1 ))

Sigma = matrix(c(1,0.5,0.5,1), 2, 2)

y1 = rep(NA, nburn+niter)
y2 = rep(NA, nburn+niter)

for(i in 1:(nburn+niter)) {   
  y1[i] = rnorm(1, 0, Sigma[1,1])    
  y2[i] = rnorm(
            1, 
            Sigma[2,1] / Sigma[2,2] * y1[i],  
            sqrt( (1-(Sigma[2,1]/sqrt(Sigma[1,1]*Sigma[2,2]))^2 * Sigma[2,2] ) )
          )
}

y1 = y1[-(1:nburn)]
y2 = y2[-(1:nburn)]


# Example 7 - Shiny



# Exercise 1 - t-test

## Setup

m = 1000
n = 50

d = matrix(rnorm(m * n, mean = 10, sd = 3), ncol = m) %>%
  as_data_frame() %>%
  mutate(group = rep(1:2, each = n / 2))

## Improve the performance of the following code:
##
## t = (x_bar1 - x_bar2) / sqrt(var1 / n1 + var2 / n2)

for(i in 1:m) {
  t.test(d[[i]] ~ d$group)$stat
}



