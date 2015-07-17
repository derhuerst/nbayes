# [`NaiveBayesClassifier`](../src/NaiveBayesClassifier.js)

`NaiveBayesClassifier` keeps track of how often a specific word occured. It then computes a probability for a word, given every class.


## *public* `init()`

Initialize the instance.


## *public* `learn( c, d )`

Add the document `d` to the class `c`.


## *public* `probabilities( d )`

For each stored class, return the probability of the document `d`, given the class. Returns an `Array` of `Number`s.


## *public* `classify( d )`

For the document `d`, return the class `c` with the highest probability of "`d` given `c`".


## *private* `_pD( c, d )`

Return the probability of the [bag of words](./BagOfWords.md) `b` given the class `c`, also called *likelihood*.


## *private* `_bagOfWords( d )`

Create a [`BagOfWords`](./BagOfWords.md) from a document `d`.
