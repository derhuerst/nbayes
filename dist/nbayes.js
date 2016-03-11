(function(f){if(typeof exports==="object"&&typeof module!=="undefined"){module.exports=f()}else if(typeof define==="function"&&define.amd){define([],f)}else{var g;if(typeof window!=="undefined"){g=window}else if(typeof global!=="undefined"){g=global}else if(typeof self!=="undefined"){g=self}else{g=this}g.nbayes = f()}})(function(){var define,module,exports;return (function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
'use strict'

// `createDoc` is used to count how often a specific word occurs.
const createDoc = function () {
	let words = Object.create(null)
	let sum = 0

	return {

		has: (word) => (word in words),
		get: (word) => (word in words ? words[word] : 0),
		set: function (word, count) {
			sum += count - this.get(word)
			words[word] = count
			return this
		},
		add: function (word) { return this.increase(word, 1)},

		increase: function (word, delta) {
			if (arguments.length < 2) delta = 1
			if (!(word in words)) words[word] = 0
			words[word] += delta
			sum += delta
			return this
		},

		sum: () => sum,
		words: () => Object.keys(words).filter((k) => words[k] !== 0),


		addBagOfWords: function (doc) {
			for (let word of doc.words()) {
				this.increase(word, doc.get(word))
			}
			return this
		},

		addWords: function (words) {
			for (let word of words) {
				this.increase(word, 1)
			}
			return this
		}

	}
}



const stringToDoc = (s) => createDoc().addWords(s
	.replace(/[^\w\s]/g, ' ')
	.split(/\s+/)
	.filter((word) => word.length > 0)
	.map((word) => word.toLowerCase())
)



// `NaiveBayesClassifier` keeps track of how often a specific word occured by class.
// For a given document, it then computes the probability of each class.
const nbayes = function () {

	// document 'foo foo', class 'A'
	// document 'foo bar', class 'B'
	// document 'bar bar', class 'B'

	let wordsByClass = {}
	// A: createDoc(foo: 2)
	// B: createDoc(foo: 1, bar: 3)
	let words = createDoc() // vocabulary of all words
	let docsByClass = {} // A: 1, B: 2
	let docs = 0 // list of all docs, 3

	return {

		// Tags words of a document as being of a class.
		learn: function (_class, wordsInDoc) {
			if (!(_class in wordsByClass)) wordsByClass[_class] = createDoc()
			wordsByClass[_class].addBagOfWords(wordsInDoc)
			words.addBagOfWords(wordsInDoc)

			if (!(_class in docsByClass)) docsByClass[_class] = 0
			docsByClass[_class]++
			docs++

			return this
		},



		// Computes the probability of a class out of all classes, also called *prior*.
		prior: (_class) => (docsByClass[_class] / docs),

		// Computes the probability of a `doc`, given a class, also called *likelihood*.
		likelihood: function (_class, doc) {
			let result = 1
			for (let word of doc.words()) {

				// Probability of the word given the class.
				let pOfWord = (
					wordsByClass[_class].get(word) // # of occurences of `word` in all documents of class `class`
					+ 1 // Laplace smooting
				) / (
					wordsByClass[_class].sum() // # of occurences of all words in all documents if class `class`
					+ words.words().length  // # of different words in all documents of all classes
				)
				// A word may occur more than once in the document.
				result *= Math.pow(pOfWord, doc.get(word))

			}
			return result
		},



		// For each stored class, returns the probability of the words of a doc, given the class.
		// Returns an array of numbers.
		probabilities: function (wordsInDoc) {
			let result = {}
			for (let _class in wordsByClass) {
				result[_class] = this.prior(_class) * this.likelihood(_class, wordsInDoc)
			}
			return result
		},

		// For the words of a document, returns the class with the highest probability.
		classify: function (wordsInDoc) {
			let highest = -Infinity, result = null

			for (let _class in wordsByClass) {
				let probability = this.prior(_class) * this.likelihood(_class, wordsInDoc)
				if (probability > highest) {
					highest = probability
					result = _class
				}
			}

			return result
		}

	}
}



Object.assign(nbayes, {createDoc, stringToDoc})
module.exports = nbayes

},{}]},{},[1])(1)
});