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
    #get the word count
    strcnt <- str_count(text, pattern="\\S+")
    nxt <- 0
    #check if there is a space at the end as the user is looking to type the next word and will want a prediction
    if(str_sub(text,-1) == " "){
      nxt <- 1
    }
    
    #lookup word list in corpus data
    if(strcnt > 0){
      
      #check for space indicating user wants the next word otherwise return the current word being typed
      unitext <- word(text, -1)
      #will always return one word
      one <- grep(paste0("^",unitext),unigram$String, value=TRUE, perl=TRUE, useBytes=TRUE)
      
      if(strcnt >= 3){
        
        #check for space indicating user wants the next word prediction, otherwise return the current word pair being typed
        bitext <- word(text, -2, strcnt)
        two <- grep(paste0("^",bitext), bigram$String, value=TRUE, perl=TRUE, useBytes=TRUE)
        #capture the last word of the next prediction
        two <- word(two, -1)
        
        #look ahead for the new 3rd word
        tritext <- word(text, -3, strcnt)
        three <- grep(paste0("^",tritext), trigram$String, value=TRUE, perl=TRUE, useBytes=TRUE)
        #capture the last word of the next prediction
        three <- word(three, -1)
        
      } else if(strcnt == 2){
        
        #check for space indicating user wants the next word prediction, otherwise return the current word pair being typed
        bitext <- word(text, -2, strcnt)
        two <- grep(paste0("^",bitext),bigram$String, value=TRUE, perl=TRUE, useBytes=TRUE)
        #result has 2 words but we want to show either the first or second depending on what the user has typed
        two <- word(two, -1)
        
        three <- grep(paste0("^",text), trigram$String, value=TRUE, perl=TRUE, useBytes=TRUE)
        #result has 3 words but we want to show either the first or second depending on what the user has typed
        three <- word(three, -(strcnt-nxt))
        
      } else {
        
        two <- grep(paste0("^",text), bigram$String, value=TRUE, perl=TRUE, useBytes=TRUE)
        #result has 2 words but we want to show either the first or second depending on what the user has typed
        two <- word(two, -(2-nxt))
        
        three <- grep(paste0("^",text), trigram$String, value=TRUE, perl=TRUE, useBytes=TRUE)
        #result has 3 words but we want to show either the first or second depending on what the user has typed
        three <- word(three, -(3-nxt))
      }
      
      #choose the highest frequency encountered word set match from unigram, bigram, and trigram data
      lookup <- data.frame(c(one[1], two[1], three[1]), stringsAsFactors = FALSE)
    }
  }
  
  output$predictedWord1 <- renderText(wordPrediction()[1,])
  output$predictedWord2 <- renderText(wordPrediction()[2,])
  output$predictedWord3 <- renderText(wordPrediction()[3,])
})
