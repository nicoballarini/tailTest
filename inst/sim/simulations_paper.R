library(tailTest)
library(parallel)
library(ggplot2)
library(dplyr)
mc.cores = 30
# Warning! This program will run in parallel and needs a cluster with 30 cores.
# change mc.cores to the number of available cores, or set it to 1 in a pc
N        = c(5, 10, 25, 100)
nsim     = 1000
q        = 0.05
alpha    = 0.05
c        = -.34

scenarios = data.frame(id      = rep(c(1, 2,   3,    4),   each = 4),
                       mu_R    = rep(c(0, 0,   0,    0),   each = 4),
                       mu_T    = rep(c(0, 0.9, 0,    1.5), each = 4),
                       sigma_R = rep(c(1, 1,   1,    1),   each = 4),
                       sigma_T = rep(c(1, 0.4, 2.15, 1),   each = 4),
                       n       = rep(c(5, 10,  25, 100),   times = 4),
                       power   = NA)
scenarios

# Scenarios
# 1. Distributions of Test and Reference are identical
# (correct decision: comparable; µR = µT = 0 and σT = σR = 1).

# 2. The mean values of Test and Reference are different and the variability
# of Test is much smaller than that of Reference so that the distribution of
# Reference completely covers the distribution of Test
# (correct decision: comparable; µR = 0, µT = 0.9, σR = 1 and σT = 0.4).

# 3. The mean values of Test and Reference are identical, but the variability of Reference
# is smaller than the variability of Test
# (correct decision: not comparable; µR = µT = 0 and σR = 1 and σT = 2.15).

# 4. The variances of Test and Reference are identical, but the distribution of Test is
# shifted so that the situation is under Tsong’s null hypothesis [4]
# (correct decision: not comparable; µR = 0 and µT = 1.5 and σR = σT = 1).


# Possible decisions:
# Reject   = "Reject the null hypothesis. Comparability can be claimed."
# NoReject = "Do not reject the null hypothesis. Comparaility cannot be claimed."
for (i in 1:nrow(scenarios)) {
 n = scenarios[i, "n"]
 mu_R = scenarios[i, "mu_R"]
 mu_T = scenarios[i, "mu_T"]
 sigma_R = scenarios[i, "sigma_R"]
 sigma_T = scenarios[i, "sigma_T"]
 res = unlist(mclapply(X = 1:nsim, FUN = function(x){
    X_R = rnorm(n, mean = mu_R, sd = sigma_R)
    X_T = rnorm(n, mean = mu_T, sd = sigma_T)
    # Perform Test
    res = tailTest::testis.tails(Test = X_T, Reference = X_R,
                                 q = q, alpha = alpha, c = c)
    res$decision
  }, mc.cores = mc.cores))
 scenarios[i, "power"] = mean(res)
}

scenarios

# Save results
root = rprojroot::find_package_root_file()
fileOut = paste0(root, "/inst/sim/simulations_paper.RDS")
saveRDS(object = scenarios, file = fileOut)
scenarios = readRDS(file = fileOut)

# Produce the plot with the results (Figure 4 in the manuscript)
scenarios %>%
  filter(id != 4) %>%
ggplot() +
  geom_line(aes(x = id, y = power)) +
  geom_point(aes(x = id, y = power)) +
  facet_wrap(~ n, nrow = 2, ncol = 2, labeller = label_both) +
  labs(x = "Scenario", y = "Rate of comparability claims") +
  scale_x_continuous(breaks = 1:3)+
  scale_y_continuous(breaks = seq(0, 1, 0.2)) +
  theme_minimal() +
  theme(panel.border = element_rect(fill=NA),
        axis.ticks = element_line(),
        panel.grid.minor.x = element_blank())


plotOut = paste0(root, "/inst/sim/simulations_paper.pdf")
ggsave(filename = plotOut, width = 7.51, height = 5.59)


# Produce the plot with the results (Figure 4 in the manuscript)
scenarios %>%
  rename(Scenario = id) %>%
  ggplot() +
  geom_line(aes(x = n, y = power)) +
  geom_point(aes(x = n, y = power)) +
  facet_wrap(~ Scenario, nrow = 2, ncol = 2, labeller = label_both) +
  labs(x = "N", y = "Rate of comparability claims") +
  scale_x_continuous(breaks = N)+
  scale_y_continuous(breaks = seq(0, 1, 0.2)) +
  theme_minimal() +
  theme(panel.border = element_rect(fill=NA),
        axis.ticks = element_line(),
        panel.grid.minor.x = element_blank())

plotOut = paste0(root, "/inst/sim/simulations_paper_2.pdf")
ggsave(filename = plotOut, width = 7.51, height = 5.59)
