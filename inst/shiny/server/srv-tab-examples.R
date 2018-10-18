##########################
# Examples tab server

# Examples -------------------------------------------------------------------
## Drop-down selection box for which data set --------------------------------
data_nocomp = reactive({
  set.seed(64566)
  data_example = data.frame(
    Group = c(rep("Test", 30), rep("Reference", 30)),
    value = c(rnorm(n = 30, mean = 0, sd = 1),
              rnorm(n = 30, mean = 0, sd = 1)))
  data_example
})

data_comp = reactive({
  set.seed(64566)
  data_example = data.frame(
    Group = c(rep("Test", 30), rep("Reference", 30)),
    value = c(rnorm(n = 30, mean = 0, sd = 4),
              rnorm(n = 30, mean = 0, sd = 1)))
  data_example
})

## Do the test -----------------------------------------------
e_test_result <- eventReactive(input$e_submit, {
  if (input$e_example == "Example of comparable products") {
    dat = data_nocomp()
  } else {
    dat = data_comp()
  }
  reference = dat[which(dat$Group == "Reference"), "value"]
  test      = dat[which(dat$Group == "Test"), "value"]
  result = testis.tails(Test = test, Reference = reference,
                        q = .1, alpha = .05)
})

output$e_test_result <- renderPrint({
  print(e_test_result())
})

output$e_test_plot <- renderPlot({
  plot(e_test_result())
})
