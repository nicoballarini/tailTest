##########################
# Home tab server

# change to results tab when clicking on link
observeEvent(input$toDataset,
             updateTabsetPanel(session, "mainNav", "datasetTab")
)
observeEvent(input$toSimulate,
             updateTabsetPanel(session, "mainNav", "simulateTab")
)
observeEvent(input$toExamples,
             updateTabsetPanel(session, "mainNav", "examplesTab")
)
