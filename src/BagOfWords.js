module.exports = {



	init: function () {
		this._i = {};
		this.total = 0;

		return this;
	},



	set: function (item, n) {
		if (item === '') return this;

		this._i[item] = n;

		return this;
	},

	get: function (item) {
		return this._i[item] || 0;
	},

	increase: function (item, n) {
		if (item === '') return this;

		if (!this._i[item])
			this._i[item] = n;
		else
			this._i[item] += n;
		this.total += n;

		return this;
	},



	addBagOfWords: function (bagOfWords) {
		var i;

		for (i in bagOfWords._i) {
			if (!bagOfWords._i.hasOwnProperty(i)) continue;
			this.increase(i, bagOfWords.get(i));
		}

		return this;
	},

	addWords: function (words) {
		var i, length;
		for (i = 0, length = words.length; i < length; i++) {
			this.increase(words[i], 1);
		}

		return this;
	},



};
