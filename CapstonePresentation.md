Capstone Presentation
========================================================
author: Shawn
date: October 21, 2018
autosize: true

Synopsis
========================================================

The shiny application will attempt to predict a users next word as they type by comparing the current word against a prebuilt Corpus list of unigrams, bigrams, and trigrams. It will show the last found in each of the NGrams.

We will provide the user with the most used word. This is inline with how current cell phones work today.

The algorithm will take the last one, two, or three words in the text being typed and predict each of the unigram, bigram, and trigram strings. It will then return a result for each.

Algorithm
========================================================

The algorithm uses pre-processed NGrams of length 1 through 3 from a large Corpus using the Weka library.

The reason we chose to pre-process the data was that the Corpus is static, and creating the NGram tokens on the fly would created long delays in user response times.

In order to present the most frequent words, we show the **last word** result from our unigram, bigram, and trigram Corpus.

    Ex Text: "new york citi " (take note of the space as the algorithm predicts upcoming NGrams based on spaces)
    Unigram: "said" 
    Bigram : "council"
    Trigram: "marathon"

App Details
========================================================

Instructions:

1. There is a text field for the user to type a word or a set of words.
2. The application will then show up to 3 sets of predictive words that the user may type next.
3. If the app comes across a word or set of words not contained in the Corpus, it will not show any predictions ("NA").

Limitations/Considerations:

1. Spelling errors will not be checked as this would require dictionary lookups and other services. Just like a real phone, anything can be typed.
2. Since word stemming was used, the root part of words and their plurals will be displayed (i.e. Citi versus city and cities). The tradeoff is a more accurate prediction, but with a higher likelihood of mis-spelling.
3. In the original cleanup of the corpus I did not remove quotes or other random characters. A refinement would be to remove them via tm_map or regexp manipulations.

Future Enhancements
=========================================================

1. One possible idea for future enhancements is to add a users messages to the corpus, and use it to train the algorithm. This would enable the NGrams to represent the unique style and expressions of its user. However, due to project resource limitations those capabilities were not developed here.
