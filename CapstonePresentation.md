Capstone Presentation
========================================================
author: Shawn
date: October 9, 2018
autosize: true

Synopsis
========================================================

The attached shiny application will attempt to predict a users next word or series of words as they type them. 

We will attempt to provide the user with 3 predictive word options when possible. This is inline with how current cell phones work today.

Algorithm
========================================================

The algorithm used in the shiny app is quite basic, but uses pre-processed string data using the Weka library. We create tokenized NGrams of length 1 through 4 from the Corpus. 

The reason we chose to pre-process the data was that the Corpus is static, and creating the NGram tokens on the fly would created long delays in user response times.

One possible idea for future enhancements is to add a users messages to the corpus, and use it to train the algorithm. This would enable the NGrams to represent the unique style and expressions of its user. However, due to project resource limitations those capabilities were not developed here.

App Details
========================================================

Instructions:

1. There is a text field for the user to type a word or a set of words.
2. The application will then show up to 3 sets of predictive words that the user may type next.
3. If the app comes across a word or set of words not contained in the Corpus, it will not show any predictions.

Limitations:

1. There is no text filtering in the app. Spelling errors will not be checked as this would require dictionary lookups and other services. Just like a real phone, anything can be typed.
2. Since word stemming was used, the root part of words and their plurals will be displayed (i.e. Citi versus city and cities). The tradeoff is a more accurate prediction, but with a higher likelihood of mis-spelling.
