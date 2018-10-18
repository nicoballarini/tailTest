##########################
# Examples tab UI

tabPanel(
  title = "Examples",
  id    = "examplesTab",
  value = "examplesTab",
  name  = "examplesTab",
  class = "fade in",
  icon  = icon("line-chart"),

  # h1("Hasse Diagramms"),
  h1("Examples of tail tests"),
  shiny::wellPanel(
    h2("1. Select an example"),
    fluidRow(column(8,
                    selectInput("e_example", label = "",
                                choices = c("Example of comparable products",
                                            "Example of no comparable products")))),
    shiny::fluidRow(column(12, actionButton("e_submit", "Calculate!")))
    ),
  shiny::wellPanel(
    h2("Results"),
    fluidRow(column(12,verbatimTextOutput("e_test_result"))),
    fluidRow(column(12,plotOutput("e_test_plot")))
  )
)

