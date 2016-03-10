assert =			require 'assert'





Vocabulary =		require '../src/Vocabulary.js'
vocabulary = () ->
	instance = Object.create Vocabulary
	return instance.init()

bagOfWords =		require '../src/BagOfWords.js'





describe 'Vocabulary', () ->



	describe 'init', () ->

		it 'sets `_w` to an empty object', () ->
			voc = vocabulary()
			assert.deepEqual voc._w, {}

		it 'sets `size` to `0`', () ->
			voc = vocabulary()
			assert.equal voc.size, 0

		it 'returns the instance', () ->
			voc = vocabulary()
			assert.equal voc, voc.init()



	describe 'has', () ->

		it 'returns `false` for a non-existing word', () ->
			voc = vocabulary()
			assert.strictEqual false, voc.has 'foo'

		it 'returns `true` for an existing word', () ->
			voc = vocabulary()
			voc._w.foo = true
			assert.strictEqual true, voc.has 'foo'



	describe 'add', () ->

		it 'adds a word correctly', () ->
			voc = vocabulary()
			voc.add 'foo'
			assert.strictEqual true, voc._w.foo

		it 'increases `size` for a non-existing word by `1`', () ->
			voc = vocabulary()
			voc.add 'foo'

			before = voc.size
			voc.add 'bar'
			after = voc.size

			assert.strictEqual before + 1, after

		it 'doesn\'t increase `size` for an existing word', () ->
			voc = vocabulary()
			voc.add 'foo'

			before = voc.size
			voc.add 'foo'
			after = voc.size

			assert.strictEqual before, after

		it 'returns the instance', () ->
			voc = vocabulary()
			assert.equal voc, voc.add 'foo'



	describe 'addBagOfWords', () ->

		it 'adds a bag of words correctly', () ->
			voc = vocabulary()
			voc.add 'foo'
			voc.add 'bar'
			bag = bagOfWords()
			bag.set 'bar', 2
			bag.set 'baz', 1
			voc.addBagOfWords bag

			assert.strictEqual true, voc.has 'foo'
			assert.strictEqual true, voc.has 'bar'
			assert.strictEqual true, voc.has 'baz'

		it 'returns the instance', () ->
			voc = vocabulary()
			bag = bagOfWords()
			assert.equal voc, voc.addBagOfWords bag
