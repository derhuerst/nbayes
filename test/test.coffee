assert =			require 'assert'
fs =				require 'fs'
path =				require('path')
NBayes =			require '../'





describe 'naive bayes classifier', () ->



	it 'categorizes correctly for `positive` and `negative` categories', (done) ->
		classifier = new NBayes()

		# teach it positive phrases
		classifier.learn 'positive', 'amazing, awesome movie!! Yeah!! Oh boy.'
		classifier.learn 'positive', 'Sweet, this is incredibly, amazing, perfect, great!!'

		# teach it a negative phrase
		classifier.learn 'negative', 'terrible, shitty thing. Damn. Sucks!!'

		# teach it a neutral phrase
		classifier.learn 'nautral', 'I dont really know what to make of this.'

		# now test it to see that it correctly categorizes a new document
		assert.equal classifier.categorize('awesome, cool, amazing!! Yay.'), 'positive'
		done()



	it 'categorizes correctly for `chinese` and `japanese` categories', (done) ->
		classifier = new NBayes()

		# teach it how to identify the `chinese` category
		classifier.learn 'chinese', 'Chinese Beijing Chinese'
		classifier.learn 'chinese', 'Chinese Chinese Shanghai'
		classifier.learn 'chinese', 'Chinese Macao'

		# teach it how to identify the `japanese` category
		classifier.learn 'japanese', 'Tokyo Japan Chinese'

		# make sure it learned the `chinese` category correctly
		chineseFrequencies = classifier.tokens.chinese.frequency
		assert.equal chineseFrequencies.Chinese, 5
		assert.equal chineseFrequencies.Beijing, 1
		assert.equal chineseFrequencies.Shanghai, 1
		assert.equal chineseFrequencies.Macao, 1

		# make sure it learned the `japanese` category correctly
		japaneseFrequencies = classifier.tokens.japanese.frequency
		assert.equal japaneseFrequencies.Tokyo, 1
		assert.equal japaneseFrequencies.Japan, 1
		assert.equal japaneseFrequencies.Chinese, 1

		# now test it to see that it correctly categorizes a new document
		assert.equal classifier.categorize('Chinese Chinese Chinese Tokyo Japan'), 'chinese'
		done()