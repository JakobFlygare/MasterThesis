## load the nimble library and set seed
install.packages("nimble")
library(nimble)
set.seed(1)

## define the model
stateSpaceCode <- nimbleCode({
  a ~ dunif(-0.9999, 0.9999)
  b ~ dnorm(0, sd = 1000)
  sigPN ~ dunif(1e-04, 1)
  sigOE ~ dunif(1e-04, 1)
  x[1] ~ dnorm(b/(1 - a), sd = sigPN/sqrt((1-a*a)))
  y[1] ~ dt(mu = x[1], sigma = sigOE, df = 5)
  for (i in 2:t) {
    x[i] ~ dnorm(a * x[i - 1] + b, sd = sigPN)
    y[i] ~ dt(mu = x[i], sigma = sigOE, df = 5)
  }
})

## define data, constants, and initial values  
data <- list(
  y = c(0.213, 1.025, 0.314, 0.521, 0.895, 1.74, 0.078, 0.474, 0.656, 0.802)
)
constants <- list(
  t = 10
)
inits <- list(
  a = 0,
  b = .5,
  sigPN = .1,
  sigOE = .05
)

## build the model
stateSpaceModel <- nimbleModel(stateSpaceCode,
                               data = data,
                               constants = constants,
                               inits = inits,
                               check = FALSE)


## build bootstrap filter and compile model and filter
bootstrapFilter <- buildBootstrapFilter(stateSpaceModel, nodes = 'x')
compiledList <- compileNimble(stateSpaceModel, bootstrapFilter)

compiledList$bootstrapFilter$run(10000)
