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


shinyServer(function(input, output) {
  
  wordPrediction <- reactive({
      text <- input$text
      wordPrediction <- nextWordPrediction(text)
    })
  
  nextWordPrediction <- function(text){
    #this will pose an issue on which word to check in which corpus (possibly bad logic here)
    words <- data.frame(strsplit(text, "\\s+"), stringsAsFactors = FALSE)
    
    
    #find the last word the user has typed
    last <- words[nrow(words),]
    
    #lookup word list in corpus data
    one <- unigram[last,"String"]
    two <- bigram[last,"String"]
    three <- trigram[last,"String"]
    
    #TODO: add some grep like logic to the subset
    
    #wordList <- subset(unigram, String==words, select = String)
    #wordList <- subset(biigram, String==words, select = String)
    wordList <- subset(trigram, String==words, select = String)
    
  }
  
  output$predictedWord1 <- renderText(wordPrediction()[1,])
  output$predictedWord2 <- renderText(wordPrediction()[1,])
  output$predictedWord3 <- renderText(wordPrediction()[1,])
})
