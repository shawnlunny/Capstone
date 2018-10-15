suppressPackageStartupMessages(c(
  library(shinythemes),
  library(shiny),
  library(tm),
  library(stringr),
  library(markdown)
  ))

shinyUI(
  navbarPage("Data Science Capstone Project",
    theme = shinytheme("united"),
    tabPanel("NGrams Word Prediction",
      textInput("text", label = h3("Enter your message:"), value = ""),
      h4("The next 3 word sets predicted are:"),
      textOutput("predictedWord1"),
      br(),
      textOutput("predictedWord2"),
      br(),
      textOutput("predictedWord3")
    )
  )
)