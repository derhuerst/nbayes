assert =			require 'assert'





NaiveBayesClassifier =	require '../src/NaiveBayesClassifier.js'
naiveBayesClassifier = () ->
	instance = Object.create NaiveBayesClassifier
	return instance.init()

Vocabulary =		require '../src/Vocabulary.js'
vocabulary = () ->
	instance = Object.create Vocabulary
	return instance.init()

bagOfWords =		require '../src/BagOfWords.js'





describe 'NaiveBayesClassifier', () ->



	describe 'init', () ->

		it 'sets `classes` to an empty object', () ->
			classifier = naiveBayesClassifier()
			assert.deepEqual {}, classifier.classes

		it 'sets `documents` to `0`', () ->
			classifier = naiveBayesClassifier()
			assert.strictEqual 0, classifier.documents

		it 'sets `vocabulary` to a new `Vocabulary` instance', () ->
			classifier = naiveBayesClassifier()
			vocabulary = vocabulary()
			assert.deepEqual vocabulary, classifier.vocabulary

		it 'returns the instance', () ->
			classifier = naiveBayesClassifier()
			assert.strictEqual classifier, classifier.init()



	describe '_bagOfWords', () ->

		it 'returns a correct bag of words', () ->
			classifier = naiveBayesClassifier()
			bag = classifier._bagOfWords ' foo  bar\t foo '

			assert.strictEqual 2, bag.get 'foo'
			assert.strictEqual 1, bag.get 'bar'



	describe 'learn', () ->

		it 'creates and updates `classes[class]` correctly', () ->
			classifier = naiveBayesClassifier()
			classifier.learn 'baz', ' foo bar\t foo '
			bag = classifier._bagOfWords ' foo  bar\t foo '

			assert.ok classifier.classes.baz
			assert.deepEqual bag, classifier.classes.baz.words
			assert.strictEqual 1, classifier.classes.baz.documents

			classifier.learn 'baz', ' foo bar\t foo '
			bag.addBagOfWords classifier._bagOfWords ' foo  bar\t foo '

			assert.deepEqual bag, classifier.classes.baz.words
			assert.strictEqual 2, classifier.classes.baz.documents

		it 'increases `documents` correctly', () ->
			classifier = naiveBayesClassifier()
			expected = classifier.documents

			classifier.learn 'baz', 'foo'
			assert.strictEqual expected + 1, classifier.documents

			classifier.learn 'baz', 'bar'
			assert.strictEqual expected + 2, classifier.documents

		it 'adds words to `vocabulary` correctly', () ->
			classifier = naiveBayesClassifier()

			classifier.learn 'baz', 'one! two!!'
			assert.strictEqual true, classifier.vocabulary._w.one
			assert.strictEqual true, classifier.vocabulary._w.two
			assert.strictEqual 2, classifier.vocabulary.size

			classifier.learn 'baz', 'three?'
			assert.strictEqual true, classifier.vocabulary._w.one
			assert.strictEqual true, classifier.vocabulary._w.two
			assert.strictEqual true, classifier.vocabulary._w.three
			assert.strictEqual 3, classifier.vocabulary.size

		it 'returns the instance', () ->
			classifier = naiveBayesClassifier()
			assert.strictEqual classifier, classifier.learn 'a', 'b'



	describe '_pD', () ->

		it 'calculates the probability of a bag of words given a class correctly', () ->
			# example from https://www.youtube.com/watch?v=pc36aYTP44o
			classifier = naiveBayesClassifier()
			classifier.learn 'c', 'chinese beijing chinese'
			classifier.learn 'c', 'chinese chinese shanghai'
			classifier.learn 'c', 'chinese macao'
			classifier.learn 'j', 'tokyo japan chinese'
			bag = classifier._bagOfWords 'chinese chinese chinese tokyo japan'

			expected = (0.00030121377997263).toFixed 8
			actual = (classifier._pD 'c', bag).toFixed 8
			assert.strictEqual expected, actual

			expected = (0.000135480702467442).toFixed 8
			actual = (classifier._pD 'j', bag).toFixed 8
			assert.strictEqual expected, actual



	describe 'probabilities', () ->

		it 'calculates the probabilies of a document for every class correctly', () ->
			# example from https://www.youtube.com/watch?v=pc36aYTP44o
			classifier = naiveBayesClassifier()
			classifier.learn 'chinese', 'chinese beijing chinese'
			classifier.learn 'chinese', 'chinese chinese shanghai'
			classifier.learn 'chinese', 'chinese macao'
			classifier.learn 'japanese', 'tokyo japan chinese'
			probabilities = classifier.probabilities 'chinese chinese chinese tokyo japan'
			bag = classifier._bagOfWords 'chinese chinese chinese tokyo japan'

			expected = (classifier._pD 'chinese', bag).toFixed 8
			actual = (probabilities.chinese).toFixed 8
			assert.strictEqual expected, actual

			expected = (classifier._pD 'japanese', bag).toFixed 8
			actual = (probabilities.japanese).toFixed 8
			assert.strictEqual expected, actual



	describe 'classify', () ->

		it 'classifies a sample document correctly', () ->
			classifier = naiveBayesClassifier()
			classifier.learn 'positive', 'amazing, awesome movie!! Yeah!! Oh boy.'
			classifier.learn 'positive', 'Sweet, this is incredibly, amazing, perfect, great!!'
			classifier.learn 'negative', 'terrible, shitty thing. Damn. Sucks!!'
			classifier.learn 'nautral', 'I dont really know what to make of this.'

			expected = classifier.classify 'awesome, cool, amazing!! Yay.'
			assert.equal 'positive', expected

		it 'classifies another sample document correctly', () ->
			classifier = naiveBayesClassifier()
			classifier.learn 'chinese', 'chinese beijing chinese'
			classifier.learn 'chinese', 'chinese chinese shanghai'
			classifier.learn 'chinese', 'chinese macao'
			classifier.learn 'japanese', 'tokyo japan chinese'

			expected = classifier.classify 'chinese chinese chinese tokyo japan'
			assert.equal 'chinese', expected
