Vocabulary =	require('./Vocabulary.js')
BagOfWords =	require('./BagOfWords.js')





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

	init: function () {
		this.classes = {};
		this.documents = 0;
		this.vocabulary = Object.create(Vocabulary).init();

		return this;
	},



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

	probabilities: function (d) {
		var b = this._bagOfWords(d);
		var result = {};

		var c;
		for (c in this.classes) {
			result[c] = this._pD(c, b);
		}

		return result;
	},

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



	// Probability of the bag of words `b` given the class `c`, also called *likelihood*.
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

	_bagOfWords: function (d) {
		var result = Object.create(BagOfWords).init();
		return result.addWords(d.replace(/[^\w\s]/g, ' ').split(/\s+/));
	}



};
