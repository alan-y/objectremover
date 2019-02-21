#' object_remove
#' @description Removes objects from the global environment according to a pattern for easy use as an RStudio addin
#'
#' @export
#' @examples
#' if (interactive()) {
#'   object_remove()
#' }
object_remove <- function() {
    ui <- miniUI::miniPage(
        miniUI::gadgetTitleBar("Object Remover"),
        miniUI::miniContentPanel(
            # Define layout, inputs, outputs
            shiny::radioButtons("pattern", "Remove Objects",
                                c("Starting With" = "starting with",
                                  "Ending With" = "ending with",
                                  "According to Regex Pattern" = "according to the regex pattern")),

            shiny::textInput("txt", "Text Pattern", ""),

            shiny::checkboxGroupInput("checkGroup",
                                      label = shiny::strong("Object Types"),
                                      choices = list("Data Frame" = 1L,
                                                     "Function" = 2L,
                                                     "Other" = 3L),
                                      selected = 1L:3L),

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

        reactiveObj <- shiny::reactive({
            obj_txt <- ls(pattern = reactivePattern(), envir = globalenv())
            obj <- lapply(.GlobalEnv, class)[obj_txt]

            if (!1L %in% input$checkGroup) {
                obj <- obj[!grepl("data\\.frame", obj)]
            }

            if (!2L %in% input$checkGroup) {
                obj <- obj[!grepl("function", obj)]
            }

            if (!3L %in% input$checkGroup) {
                obj <- obj[grepl("function|data\\.frame", obj)]
            }

            names(obj)
        })

        output$objects <- shiny::renderPrint({
            reactiveObj()
        })

        # When the Done button is clicked, return a value
        shiny::observeEvent(input$done, {
            rm(list = reactiveObj(), envir = globalenv())
            shiny::stopApp(message(
                "Removed objects (",
                paste(c("Data Frame", "Function", "Other")[as.integer(input$checkGroup)],
                      collapse = ", "),
                ") ", input$pattern, " '", input$txt, "'")
            )
        })

        shiny::observeEvent(input$cancel, {
            shiny::stopApp(message("No objects removed"))
        })
    }

    shiny::runGadget(ui, server)
}
