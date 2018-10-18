# Home tab UI ##################################################################

tabPanel(
  title = "Home",
  id    = "homeTab",
  value = "homeTab",
  name  = "homeTab",
  # class = "fade",
  icon  = icon("home"),
  h1("Welcome"),
  div(
    id = "analyzeNextMsg",
    class = "next-msg",
    "data-step"="1", "data-intro"="text step 1",
    "If you have raw data and want to upload it and do the tail-test, then ",
    actionLink("toDataset", "go to the Dataset tab")
  ),
  div(
    id = "analyzeNextMsg",
    class = "next-msg",
    "If you want to simulate one dataset, then ",
    actionLink("toSimulate", "go to the Simulate tab")
  ),
  div(
    id = "analyzeNextMsg",
    class = "next-msg",
    "If you want to explore some examples, then ",
    actionLink("toExamples", "go to the Examples tab")
  )
)


