assert =     require 'assert'

bagOfWords = require '../src/BagOfWords.js'





describe 'bagOfWords', () ->



	describe 'has', () ->

		it 'returns `false` in the beginning', () ->
			bag = bagOfWords()
			assert.strictEqual bag.has('foo'), false

		it 'returns `true` after set to `2`', () ->
			bag = bagOfWords()
			bag.set 'foo', 2
			assert.strictEqual bag.has('foo'), true

	describe 'get', () ->

		it 'returns `0` in the beginning', () ->
			bag = bagOfWords()
			assert.strictEqual bag.get('foo'), 0

		it 'returns `2` after set to `2`', () ->
			bag = bagOfWords()
			bag.set 'foo', 2
			assert.strictEqual bag.get('foo'), 2

	describe 'set', () ->

		it 'returns the instance', () ->
			bag = bagOfWords()
			assert.strictEqual bag.set('foo', 2), bag

	describe 'increase', () ->

		it 'returns the instance', () ->
			bag = bagOfWords()
			assert.strictEqual bag.increase('foo', 2), bag

		it 'increases by `1` by default', () ->
			bag = bagOfWords()
			bag.set('foo', 2)
			bag.increase('foo')
			assert.strictEqual bag.get('foo'), 3

		it 'increases by `n`', () ->
			bag = bagOfWords()
			bag.set('foo', 2)
			bag.increase('foo', 3)
			assert.strictEqual bag.get('foo'), 5

		it 'uses `0` for words not set before', () ->
			bag = bagOfWords()
			bag.increase('foo')
			assert.strictEqual bag.get('foo'), 1

	describe 'sum', () ->

		it 'basic test', () ->
			bag = bagOfWords()
			bag.set 'foo', 0
			bag.set 'bar', 1
			bag.set 'baz', 2
			assert.strictEqual bag.sum(), 3

	describe 'words', () ->

		it 'returns defined words', () ->
			bag = bagOfWords()
			bag.set 'foo', 1
			bag.set 'bar', 2
			words = bag.words()
			assert.strictEqual words.length, 2
			assert 'foo' in words
			assert 'bar' in words

		it 'filters out `0`', () ->
			bag = bagOfWords()
			bag.set 'foo', 1
			bag.set 'bar', 0
			bag.set 'baz', 2
			assert not ('bar' in bag.words())



	describe 'addBagOfWords', () ->

		it 'adds a bag of words correctly', () ->
			a = bagOfWords()
			a.set 'foo', 4
			a.set 'bar', 3
			b = bagOfWords()
			b.set 'bar', 2
			b.set 'baz', 1
			a.addBagOfWords b

			assert.strictEqual a.get('foo'), 4
			assert.strictEqual a.get('bar'), 5
			assert.strictEqual a.get('baz'), 1

		it 'returns the instance', () ->
			bag = bagOfWords()
			assert.strictEqual bag.addBagOfWords(bagOfWords()), bag

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
			assert.strictEqual bag.addWords(['baz']), bag
