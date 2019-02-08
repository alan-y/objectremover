#' object_remove
#' @description Removes objects from the global environment according to a pattern for easy use as an RStudio addin
object_remove <- function() {

    ui <- miniUI::miniPage(
        miniUI::gadgetTitleBar("Clean Workspace"),
        miniUI::miniContentPanel(
            # Define layout, inputs, outputs
            shiny::radioButtons("pattern", "Remove Objects",
                         c("Starting With" = "starting with",
                           "Ending With" = "ending with",
                           "According to Regex Pattern" = "according to the regex pattern")),

            shiny::textInput("txt", "Text Pattern", "z"),

            shiny::strong("Objects to be removed"),
            shiny::verbatimTextOutput("objects")
        )
    )

    server <- function(input, output, session) {
        # Define reactive expressions, outputs, etc.
        reactivePattern <- shiny::reactive({
            if (input$pattern == "starting with") {
                paste0("^\\Q", input$txt, "\\E")
            } else if (input$pattern == "ending with") {
                paste0("\\Q", input$txt, "\\E$")
            } else {
                input$txt
            }

        })

        output$objects <- shiny::renderPrint({
            ls(pattern = reactivePattern(), envir = globalenv())
        })

        # When the Done button is clicked, return a value
        shiny::observeEvent(input$done, {
            rm(list = ls(pattern = reactivePattern(), envir = globalenv()),
               envir = globalenv())
            shiny::stopApp(message("Removed objects ", input$pattern, " '", input$txt, "'"))
        })

        shiny::observeEvent(input$cancel, {
            shiny::stopApp(message("No objects removed"))
        })
    }

    shiny::runGadget(ui, server)
}
