# nbayes

***nbayes* is a lightweight [Naive Bayes Classifier](https://www.youtube.com/watch?v=DdYSMwEWbd4) written in vanilla JavaScript.** It classifies a document (arbitrary piece of text) among the classes (arbitrarily named categories) it has been trained with before. This is all basic on [simple mathematics](https://www.youtube.com/watch?v=DdYSMwEWbd4). As an example, you could use *nbayes* to answer the following questions.

- Is an email **spam**, or **not spam** ?
- Is a news article about **technology**, **politics**, or **sports** ?
- Does a piece of text express **positive** emotions, or **negative** emotions?

```javascript
const nbayes = require('nbayes')

let classifier = nbayes()
classifier.learn('happy',   nbayes.stringToDoc('amazing, awesome movie!! Yeah!! Oh boy.'))
classifier.learn('happy',   nbayes.stringToDoc('Sweet, this is incredibly amazing, perfect, great!!'))
classifier.learn('angry',   nbayes.stringToDoc('terrible, shitty thing. Damn. This Sucks!!'))
classifier.learn('neutral', nbayes.stringToDoc('I dont really know what to make of this.'))

classifier.classify(nbayes.stringToDoc('awesome, cool, amazing!! Yay.'))
// -> 'happy'
```

*nbayes* offers a simple and straightforward API, keeping it **below 3kb (minified)**. It is a rewrite of [ttezel/bayes](https://github.com/ttezel/bayes) and [thoroughly tested](test.coffee).

[![npm version](https://img.shields.io/npm/v/nbayes.svg)](https://www.npmjs.com/package/nbayes)
[![bower version](https://img.shields.io/bower/v/nbayes.svg)](bower.json)
[![build status](https://img.shields.io/travis/derhuerst/nbayes.svg)](https://travis-ci.org/derhuerst/nbayes)
[![dev dependency status](https://img.shields.io/david/dev/derhuerst/nbayes.svg)](https://david-dm.org/derhuerst/nbayes#info=devDependencies)
![ISC-licensed](https://img.shields.io/github/license/derhuerst/nbayes.svg)


## Installing

```
npm install nbayes
```


# API


### `nbayes.createDoc()`

Creates a representation of a document, which can be used to track words and their frequencies.

#### Example

```js
let d = nbayes.createDoc()
d.set('foo', 2)
d.add('bar')
d.increase('bar', 2)

d.has('FOO') // -> false
d.get('foo') // -> 2
d.get('bar') // -> 3
d.sum() // -> 5
d.words() // -> 2
```

#### Methods

- `has(word)`: If `word` has been `add`ed before.
- `get(word)`: Returns the count of `word`.
- `set(word, count)`: Sets the count of `word`.
- `add(word)`: Shorthand for `increase(word, 1)`.
- `increase(word, d = 1)`: Adds `d` to the count of `word`.
- `sum`: Returns the sum of all word counts.
- `words`: Returns the number of *distinct* word.


### `nbayes.stringToDoc()`

Returns a [document](#nbayescreatedoc) from the string. Special characters will be ignored. Everything will be lowercase.

*Note: It is probably a better idea to use a proper tokenizer/stemmer and to [remove stopwords](https://github.com/fergiemcdowall/stopword) to support non-Latin languages and to get more accurate results.*

```js
nbayes.stringToDoc('awesome, amazing!! Yay.').words()
// -> ['awesome', 'amazing', 'yay']
```


### `nbayes()`

Creates a classifier, which can `learn` and then `classify` documents into classes.

#### Example

```js
let c = nbayes()
c.learn('happy',   nbayes.stringToDoc('amazing, awesome movie!! Yeah!! Oh boy.'))
c.learn('happy',   nbayes.stringToDoc('Sweet, this is incredibly amazing, perfect, great!!'))
c.learn('angry',   nbayes.stringToDoc('terrible, shitty thing. Damn. This Sucks!!'))
c.learn('neutral', nbayes.stringToDoc('I dont really know what to make of this.'))

c.classify(c.stringToDoc('awesome, cool, amazing!! Yay.'))
// -> 'happy'
c.probabilities(c.stringToDoc('awesome, cool, amazing!! Yay.'))
// -> { happy: 0.000001…,
//      angry: 2.384…e-7,
//      neutral: 1.665…e-7 }
```

#### Methods

- `learn(class, doc)`: Tags words of `doc` as being of `class`.
- `probabilities(doc)`: For each stored class, returns the probability of `doc`, given the class.
- `classify(doc)`: For `doc`, returns the class with the highest probability.
- `prior(class)`: Computes the probability of `class` out of all classes.
- `likelihood(class, doc)`: Computes the probability of `doc`, given `class`.



## Contributing

If you **have a question**, **found a bug** or want to **propose a feature**, have a look at [the issues page](https://github.com/derhuerst/nbayes/issues).
