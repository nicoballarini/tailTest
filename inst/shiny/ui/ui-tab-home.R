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
    "Establishing comparability of an originator and its biosimilar at the
    structural and functional level, by analyzing so-called quality attributes,
    is an important step in biosimilar development.
    We propose the 'tail-test' to improve the alignment of statistical
    hypothesis testing with scientific judgment by shifting away from the
    often-used comparison of mean values toward a range-based comparison.
    This web-based tool allows to upload a dataset and perform the hypothesis
    test or simulate its operating characteristics"
  ),
  br(),
  br(),
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
    "If you want to explore examples, then ",
    actionLink("toExamples", "go to the Examples tab")
  )
)


