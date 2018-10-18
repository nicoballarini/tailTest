# Load packages ----------------------------------------------------------------
library(markdown)

# Load data --------------------------------------------------------------------

# Define UI for application ----------------------------------------------------
ui <- shinyUI(
  navbarPage(
    title = tags$b("Tail-test for performing a comparability assessment of biosimilars"),
    windowTitle = "tailTest",
    id = "mainNav",
    inverse = TRUE,
    fluid = FALSE,
    collapsible = TRUE,
    #theme = "bootstrap.min.css",
    source(file.path("ui", "ui-tab-home.R"),     local = TRUE)$value,
    source(file.path("ui", "ui-tab-dataset.R"),  local = TRUE)$value,
    source(file.path("ui", "ui-tab-simulate.R"), local = TRUE)$value,
    source(file.path("ui", "ui-tab-examples.R"), local = TRUE)$value,
    source(file.path("ui", "ui-tab-about.R"),    local = TRUE)$value
  )
)
