set.seed(98123)
data_example = data.frame(
  Group = c(rep("Test", 30), rep("Reference", 30)),
  value = c(rnorm(n = 30, mean = 0, sd = .7),
            rnorm(n = 30, mean = 0, sd = 1)))
data_example = dput(data_example)
devtools::use_data(data_example, overwrite = TRUE)
WriteXLS::WriteXLS(data_example, ExcelFileName = "inst/extdata/data_example.xls")
write.csv(data_example, file = "inst/extdata/data_example.csv")
