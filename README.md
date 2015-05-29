# *nbayes*

***nbayes* is a lightweight [Naive Bayes Classifier](https://www.youtube.com/watch?v=DdYSMwEWbd4) written in vanilla JavaScript.** It offers a simple and straightforward API and embraces [prototypal programming](http://davidwalsh.name/javascript-objects-deconstruction#simpler-object-object), keeping it **below 7kb (minified)**. *nbayes* is an **[MIT-licensed](LICENSE)** rewrite of [ttezel/bayes](https://github.com/ttezel/bayes).

A Naive Bayes Classifier classifies a document (a piece of text) among the classes it has been trained with before. **You can use *nbayes* for categorizing any text content** into any arbitrary **set of classes**. For example:

- Is an email **spam**, or **not spam** ?
- Is a news article about **technology**, **politics**, or **sports** ?
- Does a piece of text express **positive** emotions, or **negative** emotions?


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

If you **have a question**, **found a bug** or want to **propose a feature**, have a look at [the issues page](https://github.com/derhuerst/velo/issues).

If you contribute code, pleace respect [the coding style of this project](docs/styleguide.md).
