.onAttach <- function(...) {
    if (!interactive()) return()
    tip <- "Please run tailTest_gui() for interactive shiny app. See help(package = 'tailTest') for more details."

    packageStartupMessage(paste(strwrap(tip), collapse = "\n"))
}
