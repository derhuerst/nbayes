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
