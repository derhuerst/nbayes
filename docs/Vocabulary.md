# [`Vocabulary`](../src/Vocabulary.js)

`Vocabulary` can be used to track if a specific words has already occured. It just stores a boolean for each word.


## *public* `init()`

Initialize the instance.


## *public* `has( word )`

Return if the stored value for `word` is `true`-ish.


## *public* `add( word )`

Store `true` for `word`.


## *public* `addBagOfWords( bagOfWords )`

[`add`](#add-word-) every word in the [`bagOfWords`](./BagOfWords.md) to this instance.
