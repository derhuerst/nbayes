'use strict';

/*
 * `Vocabulary` can be used to track if a specific words has already occured. It just stores a boolean for each word.
 */
module.exports = {



	// Initialize the instance.
	init: function () {
		this._w = {};
		this.size = 0;

		return this;
	},



	// Return if the stored value for `word` is `true`-ish.
	has: function (word) {
		return this._w.hasOwnProperty(word) && !!this._w[word];
	},

	// Store `true` for `word`.
	add: function (word) {
		if (word === '') return this;

		if (!this._w[word]) {
			this._w[word] = true;
			this.size++;
		}

		return this;
	},



	// `add` every word in the `bagOfWords` to this instance.
	addBagOfWords: function (bagOfWords) {
		for (let word of bagOfWords.words()) { this.add(word) }
		return this
	}



};
