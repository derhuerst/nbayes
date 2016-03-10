assert =                require 'assert'
type =                  require 'is'

NaiveBayesClassifier =	require '../src/NaiveBayesClassifier.js'
bagOfWords =            require '../src/BagOfWords.js'

naiveBayesClassifier = () ->
	instance = Object.create NaiveBayesClassifier
	return instance.init()

isVocabulary = (b) ->
	return type.fn(b.has) \
	   and type.fn(b.add) \
	   and type.fn(b.addBagOfWords)

isBagOfWords = (b) ->
	return type.fn(b.has) \
	   and type.fn(b.get) \
	   and type.fn(b.set) \
	   and type.fn(b.increase) \
	   and type.fn(b.sum) \
	   and type.fn(b.words) \
	   and type.fn(b.addBagOfWords) \
	   and type.fn(b.addWords)

data = Object.freeze [
	{class: 'chinese',  document: 'chinese beijing chinese'}
	{class: 'chinese',  document: 'chinese chinese shanghai'}
	{class: 'chinese',  document: 'chinese macao'}
	{class: 'japanese', document: 'tokyo japan chinese'}
]






describe 'NaiveBayesClassifier', () ->



	describe '_bagOfWords', () ->

		it 'returns a correct bag of words', () ->
			classifier = naiveBayesClassifier()
			bag = classifier._bagOfWords ' foo  bar\t foo '

			assert.strictEqual bag.get('foo'), 2
			assert.strictEqual bag.get('bar'), 1



	describe 'learn', () ->

		it 'creates and updates `classes[class]` correctly', () ->
			classifier = naiveBayesClassifier()
			classifier.learn 'baz', ' foo bar\t foo '

			assert classifier.classes.baz
			assert isBagOfWords classifier.classes.baz.words
			assert.strictEqual classifier.classes.baz.documents, 1

			classifier.learn 'baz', ' foo bar\t foo '

			assert isBagOfWords classifier.classes.baz.words
			assert.strictEqual classifier.classes.baz.documents, 2

		it 'increases `documents` correctly', () ->
			classifier = naiveBayesClassifier()
			expected = classifier.documents

			classifier.learn 'baz', 'foo'
			assert.strictEqual classifier.documents, expected + 1

			classifier.learn 'baz', 'bar'
			assert.strictEqual classifier.documents, expected + 2

		it 'adds words to `vocabulary` correctly', () ->
			classifier = naiveBayesClassifier()

			classifier.learn 'baz', 'one! two!!'
			assert.strictEqual classifier.vocabulary.has('one'), true
			assert.strictEqual classifier.vocabulary.has('two'), true
			assert.strictEqual classifier.vocabulary.words().length, 2

			classifier.learn 'baz', 'three?'
			assert.strictEqual classifier.vocabulary.has('one'), true
			assert.strictEqual classifier.vocabulary.has('two'), true
			assert.strictEqual classifier.vocabulary.has('three'), true
			assert.strictEqual classifier.vocabulary.words().length, 3

		it 'returns the instance', () ->
			classifier = naiveBayesClassifier()
			assert.strictEqual classifier, classifier.learn 'a', 'b'



	describe '_pD', () ->

		it 'calculates the probability of a bag of words given a class correctly', () ->
			# example from https://www.youtube.com/watch?v=pc36aYTP44o
			classifier = naiveBayesClassifier()
			classifier.learn d.class, d.document for d in data
			bag = classifier._bagOfWords 'chinese chinese chinese tokyo japan'

			expected = (0.00030121377997263).toFixed 8
			actual = (classifier._pD 'chinese', bag).toFixed 8
			assert.strictEqual actual, expected

			expected = (0.000135480702467442).toFixed 8
			actual = (classifier._pD 'japanese', bag).toFixed 8
			assert.strictEqual actual, expected



	describe 'probabilities', () ->

		it 'calculates the probabilies of a document for every class correctly', () ->
			# example from https://www.youtube.com/watch?v=pc36aYTP44o
			classifier = naiveBayesClassifier()
			classifier.learn d.class, d.document for d in data
			probabilities = classifier.probabilities 'chinese chinese chinese tokyo japan'
			bag = classifier._bagOfWords 'chinese chinese chinese tokyo japan'

			expected = (classifier._pD 'chinese', bag).toFixed 8
			actual = (probabilities.chinese).toFixed 8
			assert.strictEqual actual, expected

			expected = (classifier._pD 'japanese', bag).toFixed 8
			actual = (probabilities.japanese).toFixed 8
			assert.strictEqual actual, expected



	describe 'classify', () ->

		it 'classifies a sample document correctly', () ->
			classifier = naiveBayesClassifier()
			classifier.learn 'positive', 'amazing, awesome movie!! Yeah!! Oh boy.'
			classifier.learn 'positive', 'Sweet, this is incredibly, amazing, perfect, great!!'
			classifier.learn 'negative', 'terrible, shitty thing. Damn. Sucks!!'
			classifier.learn 'nautral', 'I dont really know what to make of this.'

			expected = classifier.classify 'awesome, cool, amazing!! Yay.'
			assert.equal expected, 'positive'

		it 'classifies another sample document correctly', () ->
			classifier = naiveBayesClassifier()
			classifier.learn d.class, d.document for d in data

			expected = classifier.classify 'chinese chinese chinese tokyo japan'
			assert.equal expected, 'chinese'
