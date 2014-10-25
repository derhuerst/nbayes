var NaiveBayesClassifier;

NaiveBayesClassifier = (function() {
  function NaiveBayesClassifier(tokenize) {
    this.vocabulary = {};
    this.vocabularySize = 0;
    this.expressions = {};
    this.expressionsSize = 0;
    this.tokens = {};
    if (tokenize) {
      this.tokenize = tokenize;
    }
  }

  NaiveBayesClassifier.prototype.learn = function(category, expression) {
    var categoryTokens, frequency, token, _base, _base1, _ref;
    if ((_base = this.expressions)[category] == null) {
      _base[category] = {
        learned: {},
        count: 0
      };
    }
    this.expressions[category].learned[expression] = true;
    this.expressions[category].count++;
    this.expressionsSize++;
    if ((_base1 = this.tokens)[category] == null) {
      _base1[category] = {
        frequency: {},
        count: 0
      };
    }
    categoryTokens = this.tokens[category];
    _ref = this.tokenFrequency(expression);
    for (token in _ref) {
      frequency = _ref[token];
      if (!this.vocabulary[token]) {
        this.vocabulary[token] = true;
        this.vocabularySize++;
      }
      if (!categoryTokens.frequency[token]) {
        categoryTokens.frequency[token] = 0;
      }
      categoryTokens.frequency[token] += frequency;
      categoryTokens.count += frequency;
    }
    return this;
  };

  NaiveBayesClassifier.prototype.categories = function(expression) {
    var category, categoryProbability, categoryTokens, data, frequency, frequencyTable, result, token, tokenProbability, _i, _len, _ref;
    result = {};
    frequencyTable = this.tokenFrequency(expression);
    _ref = this.expressions;
    for (category in _ref) {
      data = _ref[category];
      categoryProbability = data.count / this.expressionsSize;
      categoryTokens = this.tokens[category];
      for (frequency = _i = 0, _len = frequencyTable.length; _i < _len; frequency = ++_i) {
        token = frequencyTable[frequency];
        tokenProbability = (categoryTokens.frequency[token] + 1) / (categoryTokens.count + this.vocabularySize);
        categoryProbability += frequency * tokenProbability;
      }
      result[category] = categoryProbability;
    }
    return result;
  };

  NaiveBayesClassifier.prototype.categorize = function(expression) {
    var category, highest, result, value, _ref;
    highest = -Infinity;
    result = null;
    _ref = this.categories(expression);
    for (category in _ref) {
      value = _ref[category];
      if (value > highest) {
        highest = value;
        result = category;
      }
    }
    return result;
  };

  NaiveBayesClassifier.prototype.tokenize = function(expression) {
    return expression.replace(/[^\w\s]/g, ' ').split(/\s+/);
  };

  NaiveBayesClassifier.prototype.tokenFrequency = function(expression) {
    var result, token, _i, _len, _ref;
    result = {};
    _ref = this.tokenize(expression);
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      token = _ref[_i];
      if (!result[token]) {
        result[token] = 0;
      }
      result[token]++;
    }
    return result;
  };

  return NaiveBayesClassifier;

})();

module.exports = NaiveBayesClassifier;
