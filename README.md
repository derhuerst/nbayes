# *nbayes*

**A Naive Bayes Classifier written in CoffeeScript.** *nbayes* takes a document (piece of text), and tells you what category that document belongs to.


##What can I use this for?

You can use *nbayes* for categorizing any text content into any arbitrary set of **categories**. For example:

- is an email **spam**, or **not spam** ?
- is a news article about **technology**, **politics**, or **sports** ?
- is a piece of text expressing **positive** emotions, or **negative** emotions?


## Installing

```
npm install nbayes
```


## Getting Started

```coffeescript
NBayes = require 'nbayes'

classifier = new NBayes()

# teach it positive phrases
classifier.learn 'positive', 'amazing, awesome movie!! Yeah!! Oh boy.'
classifier.learn 'positive', 'Sweet, this is incredibly, amazing, perfect, great!!'

# teach it a negative phrase
classifier.learn 'negative', 'terrible, shitty thing. Damn. Sucks!!'

# now ask it to categorize a document it has never seen before
classifier.categorize 'awesome, cool, amazing!! Yay.'
# gives you a hash of numbers indicating the similarity to each category
```


## Documentation

coming soon!