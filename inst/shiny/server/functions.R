#' given observations for Test and Reference,
#' the function calculates the test statistic with the tail-test
#'
#' @param Test vector of observations from Test
#' @param Reference vector of observations from Reference
#' @param q which quantil should be used (e.g., q = 0.05). Default to 0.10
#' @param alpha significance level. Default to 0.05
#' @param c equivalence margin. Default corresponds to the FDA's null hypothesis
#'
#' @examples
#' library(tailTest)
#' data(data_example)
#' head(data_example)
#' reference = data_example[which(data_example$Group == "Reference"), "value"]
#' test = data_example[which(data_example$Group == "Test"), "value"]
#' testis.tails(Test = test, Reference = reference,
#'              q = 0.1, alpha = 0.05, c = 20)
#' @importFrom stats dnorm optimize pnorm qnorm quantile rchisq rnorm sd
#' @importFrom graphics abline curve polygon par
#' @export
testis.tails <- function(Test, Reference, q = 0.1, alpha = 0.05, c = NULL) {
  # Check arguments
  if(q < 0 | q > 0.5) stop("q must be between 0 and 0.5")
  if(alpha < 0 | alpha > 0.5) stop("alpha must be between 0 and 1")
  if(is.null(c)) {
    c = (2 * q - pnorm(qnorm(q), mean = 1.5, sd = 1) - (1 - pnorm(qnorm(1 - q), mean = 1.5, sd = 1)))
    message(sprintf("As no value of the equivalence margin c was given, the value %.6s is used corresponding to Tsong's null hypothesis (please see the paper for details).", c))
  }
  # Step 1: estimate mean values and standard deviations
  mT <- mean(Test)
  mR <- mean(Reference)
  sT <- sd(Test)
  sR <- sd(Reference)

  # Step 2: calculate quantiles of Reference
  quan1 <- qnorm(    q, mean = mR, sd = sR)
  quan2 <- qnorm(1 - q, mean = mR, sd = sR)

  # Step 3: calculate C_l, C_u
  C_l <-     pnorm(quan1, mean = mT, sd = sT)
  C_u <- 1 - pnorm(quan2, mean = mT, sd = sT)

  # Step 4: calculate test statistic w
  teststat <- 2 * q - C_l - C_u

  # Simulate critical value
  n <- length(Test)
  m <- length(Reference)
  critical_value <- critical(m, n, q, alpha, c)

  testdec <- (teststat > unname(critical_value))
  out = list(nT = n,
             nR = m,
             mT = mT,
             mR = mR,
             sT = sT,
             sR = sR,
             q  = q,
             c  = c,
             alpha = alpha,
             statistic = teststat,
             critical_value = critical_value,
             decision = testdec)
  class(out) = "testTail"
  return(out)
}

critical <- function(m, n, q, alpha, c) {
  nsim = 10000
  # first find which mean difference of T and R correspond to this value of c
  # assume a variance of 1 for T and R
  mean_finder <- function(x, q, c) {
    res <- (2 * q - pnorm(qnorm(q), mean = x, sd = 1) - (1 - pnorm(qnorm(1 - q), mean = x, sd = 1)) - c)^2
    return(res)
  }
  meanT <- optimize(mean_finder, interval = c(-10, 0), q = q, c = c)$minimum

  # generate mean values and standard deviations and
  # calculate test decision as in testis.tails()
  mT <- rnorm(nsim, mean = meanT, sd = 1 / sqrt(n))
  mR <- rnorm(nsim, mean =     0, sd = 1 / sqrt(m))
  sT <- sqrt(rchisq(nsim, df = n - 1)/(n - 1))
  sR <- sqrt(rchisq(nsim, df = m - 1)/(m - 1))

  quan1 <- qnorm(    q, mean = mR, sd = sR)
  quan2 <- qnorm(1 - q, mean = mR, sd = sR)

  C_l <-     pnorm(quan1, mean = mT, sd = sT)
  C_u <- 1 - pnorm(quan2, mean = mT, sd = sT)

  teststat <- 2 * q - C_l - C_u

  critic <- quantile(teststat, 1 - alpha)
  return(critic)
}

#' Generic plot function for testTail objects
#'
#' @param x An object resulting from \link{testis.tails}
#' @param ... options to pass to the generic plot function.
#'
#' @examples
#' library(tailTest)
#' data(data_example)
#' head(data_example)
#' reference = data_example[which(data_example$Group == "Reference"), "value"]
#' test = data_example[which(data_example$Group == "Test"), "value"]
#' result    = testis.tails(Test = test, Reference = reference,
#'                          q = 0.1, alpha = 0.05, c = 20)
#' plot(result)
#'
#' @export
plot.testTail <- function(x, ...){
  old.par = par(no.readonly = TRUE) # Capture graphics options to restore after we change them
  q  <- x$q
  mT <- x$mT
  mR <- x$mR
  sT <- x$sT
  sR <- x$sR
  quan1 <- qnorm(q,     mean = mR, sd = sR)
  quan2 <- qnorm(1 - q, mean = mR, sd = sR)

  xmin = min(mR - 3.5*sR, mT - 3.5 * sT)
  xmax = max(mR + 3.5*sR, mT + 3.5 * sT)

  xseq <- seq(xmin, xmax, length = 1000)
  resd1 <- dnorm(xseq, mean = mT, sd = sT)
  resd2 <- dnorm(xseq, mean = mR, sd = sR)

  par(mfrow = c(1,2))

  #left panel
  curve(dnorm(x, mean = mR, sd = sR),
        xlim = c(xmin, xmax),
        main = "Reference",
        ylab = "Density",
        ylim = c(0, max(c(resd1, resd2)) + 0.01))
  abline(v = quan1, lty = 2)
  abline(v = quan2, lty = 2)

  #right panel
  curve(dnorm(x, mean = mT, sd = sT),
        xlim = c(xmin, xmax),
        main = "Test", ylab = "Density",
        ylim = c(0, max(c(resd1, resd2)) + 0.01))
  abline(v = quan1, lty = 2)
  abline(v = quan2, lty = 2)
  polygon(c(xseq[xseq < quan1], quan1),  c(resd1[xseq < quan1], 0), col = "red")
  polygon(c(xseq[xseq > quan2], quan2),  c(resd1[xseq > quan2], 0), col = "blue")
  par(old.par) # Restore graphic options to the state they were before.
}


#' Generic print function for testTail objects
#'
#' @param x An object resulting from \link{testis.tails}
#' @param ... options to pass to the generic print function.
#'
#' @export
print.testTail <- function(x, ...){

  Reject = "Reject the null hypothesis. Comparability can be claimed."
  NoReject = "Do not reject the null hypothesis. Comparaility cannot be claimed."

  r1 = sprintf("\n Tail test for Reference vs. Test with q=%s, alpha=%s and equivalence margin c=%.6s\n", x$q, x$alpha, x$c)
  r2 = paste0("\n", paste0(sprintf(" %-10s %10s %10s %10s ", "", "Mean", "Std.dev", "N")))
  r3 = paste0("\n", paste0(sprintf(" %-10s %10s %10s %10s ", "Reference", round(x$mR, 2), round(x$sR, 2), x$nR)))
  r4 = paste0("\n", paste0(sprintf(" %-10s %10s %10s %10s ", "Test",      round(x$mT, 2), round(x$sT, 2), x$nT)))
  r5 = sprintf("\n\n Statistic: %.2f   Critical value: %.2f \n Decision: %s \n\n",
               x$statistic, x$critical_value,
               ifelse(x$decision == TRUE, Reject, NoReject))

  textout = paste0(r1,r2,r3,r4,r5)
  cat(textout)
  invisible(textout)
}

#' Launch a GUI (shiny app) for performing the Tail test
#'
#' @export
tailTest_gui <- function(){
  appDir <- system.file("shiny", package = "tailTest")
  shiny::runApp(appDir, display.mode = "normal");
}

#' An example simulated dataset to use in examples
#'
#' @name data_example
#' @docType data
#' @examples
#' # Code used to generate data_example
#' set.seed(98123)
#' data_example = data.frame(
#'   Group = c(rep("Test", 30), rep("Reference", 30)),
#'   value = c(rnorm(n = 30, mean = 0, sd = .7),
#'             rnorm(n = 30, mean = 0, sd = 1)))
#' @keywords data
NULL

