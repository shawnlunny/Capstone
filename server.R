suppressPackageStartupMessages(c(
  library(shinythemes),
  library(shiny),
  library(tm),
  library(stringr),
  library(markdown)
  ))

#functions from milestone app

#get the preprocesses corpus data to trim down app runtime
unigram <- readRDS(file="unigram.RData")
unigram$String <- as.character(unigram[,"String"])
bigram <- readRDS(file="bigram.RData")
bigram$String <- as.character(bigram[,"String"])
trigram <- readRDS(file="trigram.RData")
trigram$String <- as.character(trigram[,"String"])
#quadrigram <- readRDS(file="quadrigram.RData")

unigram$String <- as.character(unigram[,"String"])
bigram$String <- as.character(bigram[,"String"])
trigram$String <- as.character(trigram[,"String"])


shinyServer(function(input, output) {
  
  wordPrediction <- reactive({
      text <- input$text
      wordPrediction <- nextWordPrediction(text)
    })
  
  nextWordPrediction <- function(text){
    
    #lookup word list in corpus data
    if(text != ""){
      one <- grep(paste0("^",text),unigram$String, value=TRUE)
      two <- grep(paste0("^",text),bigram$String, value=TRUE)
      three <- grep(paste0("^",text),trigram$String, value=TRUE)
      #choose the first word set match from unigram,bigram, and trigram
      lookup <- data.frame(c(one[1], two[1], three[1]), stringsAsFactors = FALSE)
    }
  }
  
  output$predictedWord1 <- renderText(wordPrediction()[1,])
  output$predictedWord2 <- renderText(wordPrediction()[2,])
  output$predictedWord3 <- renderText(wordPrediction()[3,])
})
