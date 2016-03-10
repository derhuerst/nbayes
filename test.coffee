{naiveBayesClassifier, createDoc, stringToDoc} = require './index.js'

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



exports.createDoc =

	has: (t) ->
		doc = createDoc()
		t.strictEqual doc.has('foo'), false
		doc.set 'foo', 2
		t.strictEqual doc.has('foo'), true
		t.done()

	get: (t) ->
		doc = createDoc()
		t.strictEqual doc.get('foo'), 0
		doc.set 'foo', 2
		t.strictEqual doc.get('foo'), 2
		t.done()

	set: (t) ->
		doc = createDoc()
		t.strictEqual doc.set('foo', 2), doc
		t.done()

	increase:

		'returns the instance': (t) ->
			doc = createDoc()
			t.strictEqual doc.increase('foo', 2), doc
			t.done()

		'increases by `1` by default': (t) ->
			doc = createDoc()
			doc.set 'foo', 2
			doc.increase 'foo'
			t.strictEqual doc.get('foo'), 3
			doc.increase 'bar'
			t.strictEqual doc.get('bar'), 1
			t.done()

		'increases by `n`': (t) ->
			doc = createDoc()
			doc.set 'foo', 2
			doc.increase 'foo', 3
			t.strictEqual doc.get('foo'), 5
			doc.increase 'bar', 4
			t.strictEqual doc.get('bar'), 4
			t.done()

	sum: (t) ->
		doc = createDoc()
		doc.set 'foo', 0
		doc.set 'bar', 1
		doc.set 'baz', 2
		t.strictEqual doc.sum(), 3
		t.done()

	words:

		'returns defined words': (t) ->
			doc = createDoc()
			doc.set 'foo', 1
			doc.set 'bar', 2

			words = doc.words()
			t.strictEqual words.length, 2
			t.ok 'foo' in words
			t.ok 'bar' in words

			t.done()

		'filters out `0`': (t) ->
			doc = createDoc()
			doc.set 'foo', 1
			doc.set 'bar', 0
			doc.set 'baz', 2
			t.ok not ('bar' in doc.words())
			t.done()

	addBagOfWords: (t) ->
		a = createDoc()
		a.set 'foo', 4
		a.set 'bar', 3
		b = createDoc()
		b.set 'bar', 2
		b.set 'baz', 1

		t.strictEqual a.addBagOfWords(b), a
		t.strictEqual a.get('foo'), 4
		t.strictEqual a.get('bar'), 5
		t.strictEqual a.get('baz'), 1

		t.done()

	addWords: (t) ->
		doc = createDoc()
		doc.set 'foo', 2
		doc.set 'bar', 1

		t.strictEqual doc.addWords(['bar', 'baz']), doc
		t.strictEqual 2, doc.get 'foo'
		t.strictEqual 2, doc.get 'bar'
		t.strictEqual 1, doc.get 'baz'

		t.done()



exports.stringToDoc = (t) ->
	words = stringToDoc ' foo  bar\t foo '
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
		nbc.learn entry[0], stringToDoc(entry[1]) for entry in data.sentiment
		t.strictEqual nbc.prior('happy'), 2/4
		t.strictEqual nbc.prior('angry'), 1/4
		t.done()

	likelihood: (t) ->
		nbc = naiveBayesClassifier()
		nbc.learn 'A', stringToDoc 'foo bar'
		nbc.learn 'B', stringToDoc 'bar baz bar'
		nbc.learn 'A', stringToDoc 'baz'
		# -> A: {foo: 1, bar: 1, baz: 1}, B: {bar: 2, baz: 1}

		t.strictEqual nbc.likelihood('A', stringToDoc('foo')), 1/3
		t.strictEqual nbc.likelihood('B', stringToDoc('bar')), 3/6
		t.strictEqual nbc.likelihood('A', stringToDoc('foo bar')), 1/9
		t.strictEqual nbc.likelihood('B', stringToDoc('foo bar')), 1/12
		t.done()

	probabilities: (t) ->
		nbc = naiveBayesClassifier()
		nbc.learn entry[0], stringToDoc(entry[1]) for entry in data.topics
		probs = nbc.probabilities stringToDoc data.topics.query

		t.strictEqual Object.keys(probs).length, 2 # two classes
		t.strictEqual probs.chinese.toFixed(4),  (.0003).toFixed 4
		t.strictEqual probs.japanese.toFixed(4), (.0001).toFixed 4
		t.done()

	classify: (t) ->
		for set in data
			nbc = naiveBayesClassifier()
			nbc.learn entry[0], stringToDoc(entry[1]) for entry in data.sentiment
			result = nbc.classify stringToDoc data.sentiment.query
			t.strictEqual result, data.sentiment.expected
		t.done()
