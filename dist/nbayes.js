// nbayes | Jannis R | v2.0.2 | https://github.com/derhuerst/nbayes





(function(f){if(typeof exports==="object"&&typeof module!=="undefined"){module.exports=f()}else if(typeof define==="function"&&define.amd){define([],f)}else{var g;if(typeof window!=="undefined"){g=window}else if(typeof global!=="undefined"){g=global}else if(typeof self!=="undefined"){g=self}else{g=this}g.nbayes = f()}})(function(){var define,module,exports;return (function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
/*
 * `BagOfWords` can be used to count how often a specific word occurs.
 */
module.exports = {



	// Initialize the instance.
	init: function () {
		this._i = {};
		this.total = 0;

		return this;
	},



	// Set the counter for `item` to `n`.
	set: function (item, n) {
		if (item === '') return this;

		this._i[item] = n;

		return this;
	},

	// Return the counter for `item`.
	get: function (item) {
		return this._i[item] || 0;
	},

	// Add `n` to the counter for `item`.
	increase: function (item, n) {
		if (item === '') return this;

		if (!this._i[item])
			this._i[item] = n;
		else
			this._i[item] += n;
		this.total += n;

		return this;
	},



	// Add the value of each counter in another `bagOfWords` to this instance.
	addBagOfWords: function (bagOfWords) {
		var i;

		for (i in bagOfWords._i) {
			if (!bagOfWords._i.hasOwnProperty(i)) continue;
			this.increase(i, bagOfWords.get(i));
		}

		return this;
	},

	// Increase the counter for each word in `words` by `1`.
	addWords: function (words) {
		var i, length;
		for (i = 0, length = words.length; i < length; i++) {
			this.increase(words[i], 1);
		}

		return this;
	}



};

},{}],2:[function(require,module,exports){
Vocabulary =	require('./Vocabulary.js')
BagOfWords =	require('./BagOfWords.js')





/*
 * `NaiveBayesClassifier` keeps track of how often a specific word occured. It then computes a probability for a word, given every class.
 */
module.exports = {

	// 'one one' -> 'foo'
	// 'one two' -> 'bar'
	// 'two two' -> 'bar'

	// classes
	//     'foo'
	//         words: BagOfWords
	//             'one': 2
	//             total: 2
	//         documents: 1
	//     'bar'
	//         words: BagOfWords
	//             'one': 1
	//             'two': 3
	//             total: 4
	//         documents: 2
	// documents: 3
	// vocabulary: Vocabulary
	//     'one': true
	//     'two': true
	//     size: 2

	// Initialize the instance.
	init: function () {
		this.classes = {};
		this.documents = 0;
		this.vocabulary = Object.create(Vocabulary).init();

		return this;
	},



	// Add the document `d` to the class `c`.
	learn: function (c, d) {
		var bagOfWords = this._bagOfWords(d);
		var i;

		if (!this.classes[c]) {
			this.classes[c] = {
				words: bagOfWords,
				documents: 1
			};
		} else {
			this.classes[c].words.addBagOfWords(bagOfWords);
			this.classes[c].documents++;
		}
		this.documents++;
		this.vocabulary.addBagOfWords(bagOfWords)

		return this;
	},

	// For each stored class, return the probability of the document `d`, given the class. Returns an `Array` of `Number`s.
	probabilities: function (d) {
		var b = this._bagOfWords(d);
		var result = {};

		var c;
		for (c in this.classes) {
			result[c] = this._pD(c, b);
		}

		return result;
	},

	// For the document `d`, return the class `c` with the highest probability of "`d` given `c`".
	classify: function (d) {
		var b = this._bagOfWords(d);
		var highest = -Infinity;
		var result = null;

		var c, p;
		for (c in this.classes) {
			p = this._pD(c, b);
			if (p > highest) {
				highest = p;
				result = c;
			}
		}

		return result;
	},



	// Return the probability of the bag of words `b` given the class `c`, also called *likelihood*.
	_pD: function (c, b) {
		// Probability of the class `c`, also called *prior*.
		var result = this.classes[c].documents / this.documents;

		var w, p;
		for (w in b._i) {
			// Probability of the word `w` given the class `c`.
			p = (this.classes[c].words.get(w) + 1) / (this.classes[c].words.total + this.vocabulary.size);
			result *= Math.pow(p, b._i[w]);
		}

		return result;
	},

	// Create a `BagOfWords` from a document `d`.
	_bagOfWords: function (d) {
		var result = Object.create(BagOfWords).init();
		return result.addWords(d.replace(/[^\w\s]/g, ' ').split(/\s+/));
	}



};

},{"./BagOfWords.js":1,"./Vocabulary.js":3}],3:[function(require,module,exports){
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
		var i;

		for (i in bagOfWords._i) {
			if (!bagOfWords._i.hasOwnProperty(i)) continue;
			this.add(i);
		}

		return this;
	}



};

},{}]},{},[2])(2)
});