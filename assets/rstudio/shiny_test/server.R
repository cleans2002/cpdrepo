function(input, output, session) {
  
  output$urlText <- renderText({
    as.character(input$my_url)
  })
  
  observe({
    # Run whenever reset button is pressed
    input$reset
    
    # Send an update to my_url, resetting its value
    updateUrlInput(session, "BMIoutput", value = "21.5")
  })
}