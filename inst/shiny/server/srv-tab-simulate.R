##########################
# Simulate tab server

# Create ---------------------------------------------------------------------
# Initial definitions --------------------------------------------------------


data_sim = reactive({
  if (!is.null(s_seed_value())) set.seed(s_seed_value())
  data_sim = data.frame(
    Group = c(rep("Test", input$nT), rep("Reference", input$nR)),
    value = c(rnorm(n = input$nT, mean = input$mT, sd = input$sT),
              rnorm(n = input$nR, mean = input$mR, sd = input$sR)))
  data_sim
})


output$s_downloadData <- downloadHandler(

  # This function returns a string which tells the client
  # browser what name to use when saving the file.
  filename = function() {
    "tailTest_simulatedData.csv"
  },

  # This function should write data to a file given to it by
  # the argument 'file'.
  content = function(file) {
    # Write to a file specified by the 'file' argument
    write.csv(data_sim(), file,
              row.names = FALSE)
  }
)


## Do the test -----------------------------------------------
s_c_value <- reactive({
  if (is.na(input$s_c)) {
    return(NULL)
  } else{
    return(input$s_c)
  }
})

s_seed_value <- reactive({
  if (is.na(input$seed)) {
    return(NULL)
  } else{
    return(input$seed)
  }
})

s_test_result <- eventReactive(input$s_submit, {
  dat = data_sim()
  reference = dat[which(dat$Group == "Reference"), "value"]
  test      = dat[which(dat$Group == "Test"), "value"]
  result = testis.tails(Test = test, Reference = reference,
                        q = input$s_q, alpha = input$s_alpha, c = s_c_value())
  result
})

output$s_test_result <- renderPrint({
  print(s_test_result())
})

output$s_test_plot <- renderPlot({
  plot(s_test_result())
})
