module.exports = {



	init: function () {
		this._w = {};
		this.size = 0;

		return this;
	},



	has: function (word) {
		return this._w.hasOwnProperty(word) && !!this._w[word];
	},

	add: function (word) {
		if (item === '') return this;

		if (!this._w[word]) {
			this._w[word] = true;
			this.size++;
		}

		return this;
	},



	addBagOfWords: function (bagOfWords) {
		var i;

		for (i in bagOfWords._i) {
			if (!bagOfWords._i.hasOwnProperty(i)) continue;
			this.add(i);
		}

		return this;
	},



};
