# nbayes

***nbayes* is a lightweight [Naive Bayes Classifier](https://www.youtube.com/watch?v=DdYSMwEWbd4) written in vanilla JavaScript.** It classifies a document (arbitrary piece of text) among the classes (arbitrary names) it has been trained with before. This is not black magic, but [pure mathematics](https://www.youtube.com/watch?v=DdYSMwEWbd4). As an example, you could use *nbayes* to answer the following questions.

- Is an email **spam**, or **not spam** ?
- Is a news article about **technology**, **politics**, or **sports** ?
- Does a piece of text express **positive** emotions, or **negative** emotions?

*nbayes* offers a simple and straightforward API and embraces [prototypal programming](http://davidwalsh.name/javascript-objects-deconstruction#simpler-object-object), keeping it **below 3kb (minified)**. It is an **[MIT-licensed](LICENSE)** rewrite of [ttezel/bayes](https://github.com/ttezel/bayes) and [thoroughly unit-tested](test/).


## Installing

```
npm install nbayes
```


## Getting Started

```coffeescript
NBayes = require 'nbayes'

classifier = Object.create(NBayes).init()

# teach it positive phrases
classifier.learn 'positive', 'amazing, awesome movie!! Yeah!! Oh boy.'
classifier.learn 'positive', 'Sweet, this is incredibly, amazing, perfect, great!!'

# teach it a negative phrase
classifier.learn 'negative', 'terrible, shitty thing. Damn. Sucks!!'

# now ask it to categorize a document
classifier.classify 'awesome, cool, amazing!! Yay.'
# -> 'positive'

console.log classifier.probabilities 'shitty, terrible thing!'
# -> {
#     'positive': 0.0000016864529762100512,
#     'negative': 0.000016075102880658434
# }
```


## Documentation

coming soon!



## Contributing

If you **have a question**, **found a bug** or want to **propose a feature**, have a look at [the issues page](https://github.com/derhuerst/nbayes/issues).
