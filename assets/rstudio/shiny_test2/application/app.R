library(shiny)

firstUI <- function(id) { uiOutput(NS(id, "first")) }

firstServer <- function(input, output, session, a, b) {
    a_v <- as.numeric(isolate(a()))
    b_v <- as.numeric(isolate(b()))
    t_v <- b_v/(a_v*a_v)
    
    output$first <- renderUI({
        textInput(session$ns("text"), h4("BMI"), paste0(t_v))
    })
}

removeFirstUI <- function(id) {
    removeUI(selector = paste0('#', NS(id, "first")))
}

addRmBtnUI <- function(id) {
    ns <- NS(id)
    
    tags$div(
        actionButton(inputId = ns('insertParamBtn'), label = "Add"),
        actionButton(ns('removeParamBtn'), label = "Remove"),
        hr(),
        tags$div(id = ns('placeholder'))
    )
}

addRmBtnServer <- function(input, output, session, moduleToReplicate,...) {
    ns = session$ns
    
    params <- reactiveValues(btn = 0)
    
    observeEvent(input$insertParamBtn, {
        params$btn <- params$btn + 1
        
        callModule(moduleToReplicate$server, id = params$btn, ...)
        insertUI(
            selector = paste0('#', ns('placeholder')),
            ui = moduleToReplicate$ui(ns(params$btn))
        )
    })
    
    observeEvent(input$removeParamBtn, {
        moduleToReplicate$remover(ns(params$btn))
        params$btn <- params$btn - 1
    })
}

ui <- fluidPage(
    addRmBtnUI("addRm"),
    textInput("a", label = "tall(m)", value = 1.76, width = '150px'),
    textInput("b", label = "weight(kg)", value = 76, width = '150px'))

server <- function(input, output, session) {
    
    
    a <- reactive({ input$a })
    b <- reactive({ input$b })
    callModule(
        addRmBtnServer, 
        id = "addRm",
        moduleToReplicate = list(
            ui = firstUI,
            server = firstServer,
            remover = removeFirstUI
        ), 
        a = a,
        b = b
    )
}

shinyApp(ui = ui, server = server)