# Dataset tab UI ---------------------------------------------------------------

tabPanel(
  title = "Dataset",
  id    = "datasetTab",
  value = "datasetTab",
  name  = "datasetTab",
  class = "fade in",
  icon  = icon("file-excel-o"),

  h1("Analyze dataset using the tail test"),
  wellPanel(
    h2("1. Upload your data"),
    fluidRow(column(5,fileInput("outputfile",label="Select data file in csv")),
    # h5("Preview first 6 rows of the dataset"),
            fluidRow(column(6,tableOutput("head_table")))),
    fluidRow(column(12, "Note: The data should have an observation per row and two columns, one indicating the group (test or reference) and the other one indicating the response value\n")),
    fluidRow(column(3, downloadButton('downloadData', 'Download an example dataset')))),
  wellPanel(
    h2("2. Choose the corresponding variables"),
    fluidRow(column(12,
                           uiOutput("choose_Vars"),
                           uiOutput("choose_groups"))
    )),
  wellPanel(
    h2("3. Choose test options"),
    fluidRow(column(3, numericInput("q", label = "q", value = .1, min = 0, max = .5, step = 0.05)),
                    column(3, numericInput("alpha", label = "significance level (alpha)", value = .05, min = 0, max = 1, step = 0.005)),
                    column(3, numericInput("c", label = "equivalence margin (c)", value = NULL))),
    fluidRow(column(9, "Note: Leave blank the value of c to use Tsong's null hypothesis (please see the paper for details).")),
    fluidRow(column(12, actionButton("submit", "Calculate!")))
    ),
  wellPanel(
    conditionalPanel(
      condition = "input.submit > 0",
      h2("Results"),
      fluidRow(column(12,verbatimTextOutput("test_result"))),
      fluidRow(column(12,plotOutput("test_plot")))
    )
  )
)
