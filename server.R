suppressPackageStartupMessages(c(
  library(shinythemes),
  library(shiny),
  library(stringr)
  ))

#get the preprocessed corpus data to trim down app runtime
unigram <- readRDS(file="unigram.RData")
unigram$String <- as.character(unigram[,"String"])
bigram <- readRDS(file="bigram.RData")
bigram$String <- as.character(bigram[,"String"])
trigram <- readRDS(file="trigram.RData")
trigram$String <- as.character(trigram[,"String"])

shinyServer(function(input, output) {
  
  wordPrediction <- reactive({
      text <- input$text
      wordPrediction <- nextWordPrediction(text)
    })
  
  nextWordPrediction <- function(text){
    
    #lookup word list in corpus data
    if(text != ""){
      #when using the unigram start searching on the last word in the string looking for one word matches
      if(word(text,-1) != ""){
        one <- grep(paste0("^",word(text,-1)),unigram$String, value=TRUE, perl=TRUE, useBytes=TRUE)
      } else {
        one <- grep(paste0("^",text),unigram$String, value=TRUE, perl=TRUE, useBytes=TRUE)
      }
      
      #after every two words, go back one word and look for the next bigram to continue the string
      if(str_count(text, pattern="\\S+") <= 2 && (word(text,-1) != "")){
        two <- grep(paste0("^",text),bigram$String, value=TRUE, perl=TRUE, useBytes=TRUE)
      } else {
        #only show the user the last word of the bigram, since the first word was already typed in the string
        two <- grep(paste0("^",word(text,-2,2)),bigram$String, value=TRUE, perl=TRUE, useBytes=TRUE)
        two <- word(two,-1)
      }
        
      if(str_count(text, pattern="\\S+") <= 3 && (word(text,-1) != "")){
        three <- grep(paste0("^",text),trigram$String, value=TRUE, perl=TRUE, useBytes=TRUE)
      } else {
        #only show the user the last word of the trigram, since the first 2 words were already typed in the string
        three <- grep(paste0("^",word(text,-3,3)),trigram$String, value=TRUE, perl=TRUE, useBytes=TRUE)
        three <- word(three,-1)
      }
      
      #choose the first (highest frequency) word set match from unigram, bigram, and trigram
      lookup <- data.frame(c(one[1], two[1], three[1]), stringsAsFactors = FALSE)
    }
  }
  
  output$predictedWord1 <- renderText(wordPrediction()[1,])
  output$predictedWord2 <- renderText(wordPrediction()[2,])
  output$predictedWord3 <- renderText(wordPrediction()[3,])
})
