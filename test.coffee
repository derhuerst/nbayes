{naiveBayesClassifier, bagOfWords, wordsFromDoc} = require './index.js'

data =
	topics: Object.freeze Object.assign [
		['chinese',  'chinese beijing chinese' ]
		['chinese',  'chinese chinese shanghai']
		['chinese',  'chinese macao'           ]
		['japanese', 'tokyo japan chinese'     ]
	], {query: 'chinese chinese chinese tokyo japan', expected: 'chinese'}

	sentiment: Object.freeze Object.assign [
		['happy',   'amazing, awesome movie!! Yeah!! Oh boy.'            ]
		['happy',   'Sweet, this is incredibly amazing, perfect, great!!']
		['angry',   'terrible, shitty thing. Damn. This Sucks!!'         ]
		['neutral', 'I dont really know what to make of this.'           ]
	], {query: 'awesome, cool, amazing!! Yay.', expected: 'happy'}



exports.bagOfWords =

	has: (t) ->
		bag = bagOfWords()
		t.strictEqual bag.has('foo'), false
		bag.set 'foo', 2
		t.strictEqual bag.has('foo'), true
		t.done()

	get: (t) ->
		bag = bagOfWords()
		t.strictEqual bag.get('foo'), 0
		bag.set 'foo', 2
		t.strictEqual bag.get('foo'), 2
		t.done()

	set: (t) ->
		bag = bagOfWords()
		t.strictEqual bag.set('foo', 2), bag
		t.done()

	increase:

		'returns the instance': (t) ->
			bag = bagOfWords()
			t.strictEqual bag.increase('foo', 2), bag
			t.done()

		'increases by `1` by default': (t) ->
			bag = bagOfWords()
			bag.set 'foo', 2
			bag.increase 'foo'
			t.strictEqual bag.get('foo'), 3
			bag.increase 'bar'
			t.strictEqual bag.get('bar'), 1
			t.done()

		'increases by `n`': (t) ->
			bag = bagOfWords()
			bag.set 'foo', 2
			bag.increase 'foo', 3
			t.strictEqual bag.get('foo'), 5
			bag.increase 'bar', 4
			t.strictEqual bag.get('bar'), 4
			t.done()

	sum: (t) ->
		bag = bagOfWords()
		bag.set 'foo', 0
		bag.set 'bar', 1
		bag.set 'baz', 2
		t.strictEqual bag.sum(), 3
		t.done()

	words:

		'returns defined words': (t) ->
			bag = bagOfWords()
			bag.set 'foo', 1
			bag.set 'bar', 2

			words = bag.words()
			t.strictEqual words.length, 2
			t.ok 'foo' in words
			t.ok 'bar' in words

			t.done()

		'filters out `0`': (t) ->
			bag = bagOfWords()
			bag.set 'foo', 1
			bag.set 'bar', 0
			bag.set 'baz', 2
			t.ok not ('bar' in bag.words())
			t.done()

	addBagOfWords: (t) ->
		a = bagOfWords()
		a.set 'foo', 4
		a.set 'bar', 3
		b = bagOfWords()
		b.set 'bar', 2
		b.set 'baz', 1

		t.strictEqual a.addBagOfWords(b), a
		t.strictEqual a.get('foo'), 4
		t.strictEqual a.get('bar'), 5
		t.strictEqual a.get('baz'), 1

		t.done()

	addWords: (t) ->
		bag = bagOfWords()
		bag.set 'foo', 2
		bag.set 'bar', 1

		t.strictEqual bag.addWords(['bar', 'baz']), bag
		t.strictEqual 2, bag.get 'foo'
		t.strictEqual 2, bag.get 'bar'
		t.strictEqual 1, bag.get 'baz'

		t.done()



exports.wordsFromDoc = (t) ->
	words = wordsFromDoc ' foo  bar\t foo '
	t.strictEqual words.get('foo'),     2
	t.strictEqual words.get('bar'),     1
	t.strictEqual words.words().length, 2
	t.done()



exports.naiveBayesClassifier =

	learn: (t) ->
		t.strictEqual (typeof naiveBayesClassifier().learn), 'function'
		t.done()

	prior: (t) ->
		nbc = naiveBayesClassifier()
		nbc.learn entry[0], wordsFromDoc(entry[1]) for entry in data.sentiment
		t.strictEqual nbc.prior('happy'), 2/4
		t.strictEqual nbc.prior('angry'), 1/4
		t.done()

	likelihood: (t) ->
		nbc = naiveBayesClassifier()
		nbc.learn 'A', wordsFromDoc 'foo bar'
		nbc.learn 'B', wordsFromDoc 'bar baz bar'
		nbc.learn 'A', wordsFromDoc 'baz'
		# -> A: {foo: 1, bar: 1, baz: 1}, B: {bar: 2, baz: 1}

		t.strictEqual nbc.likelihood('A', wordsFromDoc('foo')), 1/3
		t.strictEqual nbc.likelihood('B', wordsFromDoc('bar')), 3/6
		t.strictEqual nbc.likelihood('A', wordsFromDoc('foo bar')), 1/9
		t.strictEqual nbc.likelihood('B', wordsFromDoc('foo bar')), 1/12
		t.done()

	probabilities: (t) ->
		nbc = naiveBayesClassifier()
		nbc.learn entry[0], wordsFromDoc(entry[1]) for entry in data.topics
		probs = nbc.probabilities wordsFromDoc data.topics.query

		t.strictEqual Object.keys(probs).length, 2 # two classes
		t.strictEqual probs.chinese.toFixed(4),  (.0003).toFixed 4
		t.strictEqual probs.japanese.toFixed(4), (.0001).toFixed 4
		t.done()

	classify: (t) ->
		for set in data
			nbc = naiveBayesClassifier()
			nbc.learn entry[0], wordsFromDoc(entry[1]) for entry in data.sentiment
			result = nbc.classify wordsFromDoc data.sentiment.query
			t.strictEqual result, data.sentiment.expected
		t.done()
