source("url-input.R")

fluidPage(
  titlePanel("Custom input example"),
  
  fluidRow(
    column(4, wellPanel(
      urlInput("my_tall", "키 : ", 1),
      urlInput("my_weight", "몸무게: ", 1),
      actionButton("reset", "BMI 계산")
    )),
    column(8, wellPanel(
      urlInput("BMIoutput", "BMI : ", 0)
    ))
  )
)