##########################
# Simulate tab UI

tabPanel(
  title = "Simulate",
  id    = "simulateTab",
  value = "simulateTab",
  name  = "simulateTab",
  class = "fade in",
  icon  = icon("table"),

  h1("Simulate a dataset and perform tail test"),
  shiny::wellPanel(
    h2("1. Specify parameters for simulated dataset"),
    fluidRow(column(9, "For each product (Reference and Test), a list of observations is generated with the inserted parameters assuming independent and identically distributed
                    random variables that follow a normal distribution.")),
    fluidRow(column(4,
                    numericInput("mR",value = 0,
                                label = h5("Mean for Reference product")),
                    numericInput("sR",value = .1,
                                 label = h5("Standard deviation for Reference product")),
                    numericInput("nR",value = 25,
                                 label = h5("Number of samples for Reference product"))),
             column(4,
                    numericInput("mT",value = 0,
                                 label = h5("Mean for Test product")),
                    numericInput("sT",value = .1,
                                 label = h5("Standard deviation for Test product")),
                    numericInput("nT",value = 25,
                                 label = h5("Number of samples for Test product")))),
    fluidRow(column(4,numericInput("seed", value = NULL,
                 label = h5("Seed for random number generation (optional value for reproducibility)"))),
             column(4,numericInput("s_nsim", value = 1000, min = 1, max = 2000,
                                   label = h5("Number of simulated datasets for calculating empirical power*")))),
    fluidRow(column(8, "* Datasets with the given characteristics are simulated and
                    the empirical rejection rate (empirical power) for this scenario is calculated")),
    fluidRow(column(3, downloadButton('s_downloadData', 'Download one generated dataset')))),
  shiny::wellPanel(
    h2("2. Choose test options"),
    shiny::fluidRow(column(3, numericInput("s_q", label = "q", value = .1, min = 0, max = .5, step = 0.05)),
                    column(3, numericInput("s_alpha", label = "alpha", value = .05, min = 0, max = 1, step = 0.005)),
                    column(3, numericInput("s_c", label = "equivalence margin (c)", value = NULL))),
    fluidRow(column(9, "Note: Leave blank the value of c to use Tsong's null hypothesis (please see the paper for details).")),
    shiny::fluidRow(column(12, actionButton("s_submit", "Calculate!")))
  ),
  shiny::wellPanel(
    conditionalPanel(
      condition = "input.s_submit > 0",
      h2("Results"),
      h3("Empirical Power"),
      fluidRow(column(12,verbatimTextOutput("s_sim_result"))),
      h3("Example of single realization"),
      fluidRow(column(12,verbatimTextOutput("s_test_result"))),
      fluidRow(column(12,plotOutput("s_test_plot")))
    )
  )
)


