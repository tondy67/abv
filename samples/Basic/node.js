/**
 * console app
 */
"use strict";

const ts = require('abv-ts')('abv:Basic');
const VTerm = require('../../lib/VTerm');
const Node = require('../../lib/Node');
const AM = require('../../lib/AM');
const Term1D = require('../../lib/Term1D');
const Term2D = require('../../lib/Term2D');
const Color = require('../../lib/Color');
const Agent = require('abv-core/lib/Agent');

window.ts = ts;

window.abv = {
	Color: Color,
	VTerm: VTerm,
	Node: Node,
	AM: AM,
	Term1D: Term1D,
	Term2D: Term2D,
	Agent: Agent
}
