/**
 * The nodejs part of abv bundle
 * @module abv
 * build: npm run dist
 */
"use strict";

const $isBrowser = typeof window !== 'undefined' && window;

const Node = require('./lib/Node');
const ATerm = require('./lib/ATerm');
const AM = require('./lib/AM');

const abv = {
	Node: Node,
	ATerm: ATerm,
	AM: AM
};

if ($isBrowser){
	window.abv = abv;
}

module.exports = abv;
