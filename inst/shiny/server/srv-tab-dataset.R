##########################
# Dataset tab server


# downloadHandler() takes two arguments, both functions.
# The content function is passed a filename as an argument, and
#   it should write out data to that filename.
output$downloadData <- downloadHandler(

  # This function returns a string which tells the client
  # browser what name to use when saving the file.
  filename = function() {
    "tailTest_dataexample.csv"
  },

  # This function should write data to a file given to it by
  # the argument 'file'.
  content = function(file) {
    set.seed(98123)
    data_example = data.frame(
      Group = c(rep("Test", 30), rep("Reference", 30)),
      value = round(c(rnorm(n = 30, mean = 0, sd = .7),
                rnorm(n = 30, mean = 0, sd = 1)), 2))
    # Write to a file specified by the 'file' argument
    write.csv(data_example, file,
              row.names = FALSE)
  }
)


tailTest.env$outputData<-NULL

Dataset <- shiny::reactive({
  if(is.null(input$outputfile)){
    return(data.frame())
  }
  tailTest.env$outputData <- data.frame(do.call("read.csv",
                                               list(input$outputfile$datapath)))
  return(tailTest.env$outputData)
})

output$head_table <- renderTable(head(Dataset()),
                                 caption = "Preview first 6 rows of the dataset",
                                 caption.placement = getOption("xtable.caption.placement", "top"),
                                 caption.width = getOption("xtable.caption.width", NULL))

output$choose_Vars<-shiny::renderUI({
  if(is.null(input$outputfile))
    return()
  if(identical(Dataset(),'')||identical(Dataset(),data.frame()))
    return(NULL)
  tailTest.env$outputData <- Dataset()
  tailTest.env$NUM     <- dim(tailTest.env$outputData)[2] #Num of all variable  ##
  tailTest.env$Class   <- sapply(apply(tailTest.env$outputData,2,unique),length)  ##
  tailTest.env$Colnames <- colnames(tailTest.env$outputData) ##
  out <- column(6,
                  selectInput("group", label="Grouping variable", c("",tailTest.env$Colnames)),
                  selectInput("value", label="Values",            c("",tailTest.env$Colnames)))
  out
})

group_opts <- shiny::eventReactive(input$group, {
  if(is.null(input$outputfile))
    return()
  if(identical(Dataset(),'')||identical(Dataset(),data.frame()))
    return(NULL)
  if(is.null(input$group)){
    return(NULL)
  }
  dat = Dataset()
  unique(dat[input$group])
})

output$choose_groups <- shiny::renderUI({
  if(is.null(input$outputfile))
    return()
  if(identical(Dataset(),'')||identical(Dataset(),data.frame()))
    return(NULL)
  dat = Dataset()
  tailTest.env$outputData <- dat
  tailTest.env$NUM     <- dim(tailTest.env$outputData)[2] #Num of all variable  ##
  tailTest.env$Class   <- sapply(apply(tailTest.env$outputData,2,unique),length)  ##
  tailTest.env$Colnames <- colnames(tailTest.env$outputData) ##
  if(input$group == ""){
    return(NULL)
  }
  out <- column(6,
                selectInput("reference", label="Reference", c("",group_opts())),
                selectInput("test",      label="Test",      c("",group_opts())))
  out
})




## Do the test -----------------------------------------------

c_value <- reactive({
  if (is.na(input$c)) {
    return(NULL)
  } else{
    return(input$c)
  }
})

test_result <- eventReactive(input$submit, {
  dat = Dataset()
  reference = dat[which(dat$Group == input$reference), "value"]
  test = dat[which(dat$Group == input$test), "value"]
  result = testis.tails(Test = test, Reference = reference,
                        q = input$q, alpha = input$alpha, c = c_value())
  result
})

output$test_result <- renderPrint({
  print(test_result())
})

output$test_plot <- renderPlot({
  plot(test_result())
})
