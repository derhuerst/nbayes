class NaiveBayesClassifier



	# vocabulary
	# 	'token1': true
	# 	'token2': true
	# vocabularySize: 2

	# expressions
	#	'category1'
	#		learned
	# 			'token1 token2': true
	# 			'token2 token1': true
	#		count: 2
	# expressionsSize: 2

	# tokens
	# 	'category1'
	# 		frequency
	#			'token1': 2
	#			'token2': 2
	# 		count: 4



	constructor: (tokenize) ->
		@vocabulary = {}
		@vocabularySize = 0

		@expressions = {}
		@expressionsSize = 0

		@tokens = {}

		@tokenize = tokenize if tokenize



	learn: (category, expression) ->
		@expressions[category] ?=
			learned: {}
			count: 0
		@expressions[category].learned[expression] = true
		@expressions[category].count++
		@expressionsSize++

		@tokens[category] ?=
			frequency: {}
			count: 0
		categoryTokens = @tokens[category]

		for token, frequency of @tokenFrequency expression
			if not @vocabulary[token]
				@vocabulary[token] = true
				@vocabularySize++

			if not categoryTokens.frequency[token]
				categoryTokens.frequency[token] = 0
			categoryTokens.frequency[token] += frequency
			categoryTokens.count += frequency

		return this



	categories: (expression) ->
		result = {}
		frequencyTable = @tokenFrequency expression

		for category, data of @expressions
			categoryProbability = data.count / @expressionsSize

			categoryTokens = @tokens[category]
			for token, frequency in frequencyTable
				tokenProbability = (categoryTokens.frequency[token] + 1) / (categoryTokens.count + @vocabularySize)
				categoryProbability += frequency * tokenProbability

			result[category] = categoryProbability
		return result


	categorize: (expression) ->
		highest = -Infinity
		result = null
		for category, value of @categories expression
			if value > highest
				highest = value
				result = category
		return result



	tokenize: (expression) ->
		return expression.replace(/[^\w\s]/g, ' ').split /\s+/


	tokenFrequency: (expression) ->
		result = {}
		for token in @tokenize expression
			if not result[token]
				result[token] = 0
			result[token]++
		return result





module.exports = NaiveBayesClassifier