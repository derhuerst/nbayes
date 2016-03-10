'use strict'

// `bagOfWords` is used to count how often a specific word occurs.
module.exports = function () {
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


		addBagOfWords: function (bagOfWords) {
			for (let word of bagOfWords.words()) {
				this.increase(word, bagOfWords.get(word))
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
