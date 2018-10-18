m = 10
n = 20
q = 0.9
alpha = 0.05

tailTest:::critical(20, 20, .9, .5, -.1)
# tailTest:::critical_vec(20, 20, .9, .5)
# microbenchmark::microbenchmark(tailTest:::critical(20, 20, .9, .5),
#                                tailTest:::critical_vec(20, 20, .9, .5), times = 10)
#
# i=1
# # use the FDA's null hypothesis
# ci = mT = mR = sT = sR =  numeric(nsim)
# for (i in 1:nsim) {
#   # use the FDA's null hypothesis
#   Test <- rnorm(n, mean=1.5, sd=1)
#   Reference <- rnorm(m, mean=0, sd=1)
#
#   # estimate mean values
#   mT[i] <- mean(Test)
#   mR[i] <- mean(Reference)
#   sT[i] <- sd(Test)
#   sR[i] <- sd(Reference)
#
#   quan1 <- qnorm(q, mean=mR[i], sd=sR[i])
#   ci1 <- q-pnorm(quan1, mean=mT[i], sd=sT[i])
#
#   quan2 <- qnorm(1-q, mean=mR[i], sd=sR[i])
#   ci2 <- q-(1-pnorm(quan2, mean=mT[i], sd=sT[i]))
#
#   ci[i] <- ci1+ci2
# }
#
# plot(mT, .mT)
# plot(mR, .mR)
# plot(sT, .sT)
# plot(sR, .sR)
#
#
# # use the FDA's null hypothesis
# nsim = 10000
# .mT <- rnorm(nsim, mean=1.5, sd=1/sqrt(n))
# .mR <- rnorm(nsim, mean=  0, sd=1/sqrt(m))
# .sT <- sqrt(rchisq(nsim, df = n - 1)/(n-1))
# .sR <- sqrt(rchisq(nsim, df = m - 1)/(m-1))
#
# quan1 <- qnorm(q, mean = mR, sd = sR)
# ci1   <- q - pnorm(quan1, mean = mT, sd = sT)
# quan2 <- qnorm(1 - q, mean = mR, sd = sR)
# ci2 <- q - (1 - pnorm(quan2, mean = mT, sd = sT))
# ci <- ci1 + ci2
# critic <- quantile(ci, 1 - alpha)
# return(critic)
