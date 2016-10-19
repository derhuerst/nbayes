'use strict'

const test = require('tape')

const createClassifier = require('.')
const {createDoc, stringToDoc} = createClassifier



const topics = [
	['chinese',  'chinese beijing chinese'],
	['chinese',  'chinese chinese shanghai'],
	['chinese',  'chinese macao'],
	['japanese', 'tokyo japan chinese']
]
topics.query = 'chinese chinese chinese tokyo japan',
topics.expected = 'chinese'

const sentiment = [
	['happy',   'amazing, awesome movie!! Yeah!! Oh boy.'],
	['happy',   'Sweet, this is incredibly amazing, perfect, great!!'],
	['angry',   'terrible, shitty thing. Damn. This Sucks!!'],
	['neutral', 'I dont really know what to make of this.']
]
sentiment.query = 'awesome, cool, amazing!! Yay.',
sentiment.expected = 'happy'



test('doc.has', (t) => {
	t.plan(2)
	const d = createDoc()

	t.strictEqual(d.has('foo'), false)
	d.set('foo', 2)
	t.strictEqual(d.has('foo'), true)
})

test('doc.get', (t) => {
	t.plan(2)
	const d = createDoc()

	t.strictEqual(d.get('foo'), 0)
	d.set('foo', 2)
	t.strictEqual(d.get('foo'), 2)
})

test('doc.set', (t) => {
	t.plan(1)
	const d = createDoc()

	t.strictEqual(d.set('foo'), d)
})

test('doc.increase', (t) => {
	t.plan(5)
	const d1 = createDoc()
	const d2 = createDoc()

	t.strictEqual(d1.increase('foo'), d1)
	t.strictEqual(d1.increase('foo', 2), d1)

	d2.increase('foo')
	t.strictEqual(d2.get('foo'), 1)
	d2.increase('foo', 2)
	t.strictEqual(d2.get('foo'), 3)
	d2.increase('foo', 5)
	t.strictEqual(d2.get('foo'), 8)
})

test('doc.sum', (t) => {
	t.plan(1)
	const d = createDoc()
	d.set('foo', 1)
	d.set('bar', 3)
	d.set('baz', 2)

	t.strictEqual(d.sum(), 6)
})

test('doc.words', (t) => {
	t.plan(4)
	const d = createDoc()
	d.set('foo', 1)
	d.set('bar', 0)
	d.set('baz', 3)
	const w = d.words()

	t.strictEqual(w.length, 2)
	t.ok(w.includes('foo'))
	t.notOk(w.includes('bar'))
	t.ok(w.includes('baz'))
})

test('doc.addBagOfWords', (t) => {
	t.plan(4)
	const a = createDoc()
	a.set('foo', 4)
	a.set('bar', 3)
	const b = createDoc()
	b.set('bar', 2)
	b.set('baz', 1)

	t.strictEqual(a.addBagOfWords(b), a)
	t.strictEqual(a.get('foo'), 4)
	t.strictEqual(a.get('bar'), 5)
	t.strictEqual(a.get('baz'), 1)
})

test('doc.addWords', (t) => {
	t.plan(4)
	const d = createDoc()
	d.set('foo', 2)
	d.set('bar', 1)

	t.strictEqual(d.addWords(['bar', 'baz', 'bar']), d)
	t.strictEqual(d.get('foo'), 2)
	t.strictEqual(d.get('bar'), 3)
	t.strictEqual(d.get('baz'), 1)
})



test('stringToDoc', (t) => {
	t.plan(3)
	const d = stringToDoc(' foo bar\t foo')

	t.strictEqual(d.get('foo'), 2)
	t.strictEqual(d.get('bar'), 1)
	t.strictEqual(d.words().length, 2)
})



test('classifier.types', (t) => {
	t.plan(4)
	const c = createClassifier()

	t.strictEqual(typeof c.learn, 'function')
	t.strictEqual(typeof c.prior, 'function')
	t.strictEqual(typeof c.likelihood, 'function')
	t.strictEqual(typeof c.probabilities, 'function')
})

test('classifier.prior', (t) => {
	t.plan(2)
	const c = createClassifier()
	for (let entry of sentiment)
		c.learn(entry[0], stringToDoc(entry[1]))

	t.strictEqual(c.prior('happy'), 2/4)
	t.strictEqual(c.prior('angry'), 1/4)
})

test('classifier.likelihood', (t) => {
	t.plan(4)
	const c = createClassifier()
	c.learn('A', stringToDoc('foo bar'))
	c.learn('B', stringToDoc('bar baz bar'))
	c.learn('A', stringToDoc('baz'))
	// A: {foo: 1, bar: 1, baz: 1}, B: {bar: 2, baz: 1}

	t.strictEqual(c.likelihood('A', stringToDoc('foo')),     1/ 3)
	t.strictEqual(c.likelihood('B', stringToDoc('bar')),     3/ 6)
	t.strictEqual(c.likelihood('A', stringToDoc('foo bar')), 1/ 9)
	t.strictEqual(c.likelihood('B', stringToDoc('foo bar')), 1/12)
})

test('classifier.probabilities', (t) => {
	t.plan(3)
	const c = createClassifier()
	for (let entry of topics)
		c.learn(entry[0], stringToDoc(entry[1]))
	const probs = c.probabilities(stringToDoc(topics.query))

	t.strictEqual(Object.keys(probs).length, 2) // 2 classes
	t.strictEqual(probs.chinese.toFixed(4),  (.0003).toFixed(4))
	t.strictEqual(probs.japanese.toFixed(4), (.0001).toFixed(4))
})

test('classifier.topics', (t) => {
	t.plan(1)
	const c = createClassifier()
	for (let entry of topics)
		c.learn(entry[0], stringToDoc(entry[1]))

	t.strictEqual(c.classify(stringToDoc(topics.query)), topics.expected)
})

test('classifier.sentiment', (t) => {
	t.plan(1)
	const c = createClassifier()
	for (let entry of sentiment)
		c.learn(entry[0], stringToDoc(entry[1]))

	t.strictEqual(c.classify(stringToDoc(sentiment.query)), sentiment.expected)
})
