assert =			require 'assert'





BagOfWords =		require '../src/BagOfWords.js'
bagOfWords = () ->
	instance = Object.create BagOfWords
	return instance.init()





describe 'BagOfWords', () ->



	describe 'init', () ->

		it 'sets `_i` to an empty object', () ->
			bag = bagOfWords()
			assert.deepEqual bag._i, {}

		it 'sets `total` to `0`', () ->
			bag = bagOfWords()
			assert.strictEqual bag.total, 0

		it 'returns the instance', () ->
			bag = bagOfWords()
			assert.strictEqual bag, bag.init()



	describe 'get', () ->

		it 'returns `0` for a non-existing word', () ->
			bag = bagOfWords()
			assert.strictEqual 0, bag.get 'foo'

		it 'returns the counter of an existing word correctly', () ->
			bag = bagOfWords()
			bag._i.foo = 1
			assert.strictEqual bag._i.foo, bag.get 'foo'



	describe 'set', () ->

		it 'sets the counter of a word correctly', () ->
			bag = bagOfWords()
			bag.set 'foo', 3
			assert.strictEqual 3, bag._i.foo

		it 'returns the instance', () ->
			bag = bagOfWords()
			assert.strictEqual bag, bag.set 'foo', 3



	describe 'increase', () ->

		it 'sets the counter of a non-existing word correctly', () ->
			bag = bagOfWords()

			bag.increase 'foo', 3

			assert.strictEqual 3, bag._i.foo

		it 'increases the counter for a word correctly', () ->
			bag = bagOfWords()
			bag._i.foo = 2
			bag.increase 'foo', 1
			assert.strictEqual 3, bag._i.foo

		it 'returns the instance', () ->
			bag = bagOfWords()
			assert.strictEqual bag, bag.increase 'foo', 3



	describe 'addBagOfWords', () ->

		it 'adds a bag of words correctly', () ->
			bag1 = bagOfWords()
			bag1.set 'foo', 4
			bag1.set 'bar', 3
			bag2 = bagOfWords()
			bag2.set 'bar', 2
			bag2.set 'baz', 1
			bag1.addBagOfWords bag2

			assert.strictEqual 4, bag1.get 'foo'
			assert.strictEqual 5, bag1.get 'bar'
			assert.strictEqual 1, bag1.get 'baz'

		it 'returns the instance', () ->
			bag1 = bagOfWords()
			bag1.set 'foo', 1
			bag2 = bagOfWords()
			bag2.set 'bar', 2

			assert.strictEqual bag1, bag1.addBagOfWords bag2



	describe 'addWords', () ->

		it 'adds words correctly', () ->
			bag = bagOfWords()
			bag.set 'foo', 2
			bag.set 'bar', 1
			bag.addWords ['bar', 'baz']

			assert.strictEqual 2, bag.get 'foo'
			assert.strictEqual 2, bag.get 'bar'
			assert.strictEqual 1, bag.get 'baz'

		it 'returns the instance', () ->
			bag = bagOfWords()
			bag.set 'foo', 2
			bag.set 'bar', 1

			assert.strictEqual bag, bag.addWords ['baz']
