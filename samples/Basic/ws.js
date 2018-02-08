/**
 * Abvos console agent
 * image viewers: feh, eog , display, fim
 */
"use strict";

const fs = require('fs');
const ts = require('abv-ts')('abv:console');
const log = console.log.bind(console);
const abv = require('abv-core');
const WebSocket = require('ws');

const host = 'http://localhost:8080';
const icon = 'favicon-32x32.png';

let rl = null;

const out = (msg) => {
//	let m = msg.f.substr(0,5)+'>'+msg.t.substr(0,5)+': ';// + ts.ab2str(msg.b);
	const a = Array.from(new Uint16Array(msg.b));
	tty.update(a);
};

const send = (a) => {
		agent.send('msg',a,'@0');
	};

const agent = new abv.core.Agent(host,WebSocket); // net.Socket
agent.out = out;
agent.log = ts.debug.bind(ts);


//setTimeout(send, 1000,'aaa');
//setInterval(send, 1000,'aaa');
const Node = require('../../lib/Node');
const AM = require('../../lib/AM');
const VTerm = require('../../lib/VTerm');
const Term0D = require('../../lib/Term0D');
const Color = require('../../lib/Color');

const $fps = 1;
const $m = 10;

const tty = new AM();
tty.term = new Term0D(tty);
//ts.debug(app.term.layers);
tty.update = (arr) => {
		if(arr) tty.term.fromArray(arr);
		else	tty.render(); 
	}
tty.term.onKeyPress = (key) => {
	send(key.name);
}
tty.run($fps);
//setInterval(tty.update,1000/$fps);
//tty.run($fps);
