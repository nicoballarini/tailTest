tailTest.env<-new.env()

server <- shinyServer(function(input, output, session) {
  options(stringsAsFactors = F)
  # # include logic for each tab
  source(file.path("server", "srv-tab-home.R"),    local = TRUE)$value
  source(file.path("server", "srv-tab-dataset.R"), local = TRUE)$value
  source(file.path("server", "srv-tab-simulate.R"),   local = TRUE)$value
  source(file.path("server", "srv-tab-examples.R"),local = TRUE)$value
  source(file.path("server", "functions.R"),local = TRUE)$value

})


