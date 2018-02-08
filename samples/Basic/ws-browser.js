/**
 * The browser part of abv-agent bundle
 * build: npm run dist
 */
"use strict";
// localStorage.ts.debug = 'abv:*';

(() => {
const abv = window.abv;
ts.debug('ttt');
//const clr = ['black','rgba(0, 0, 255, 0.2)','blue','rgba(0, 255,0,  0.2)','green','orange'];

const canvas = document.createElement("canvas");
canvas.style.left = "0px"; 
canvas.style.top = "0px";
canvas.width = 1024; 
canvas.height = 624;
canvas.style.margin 	= "0px";
canvas.style.position 	= "fixed";
document.body.appendChild(canvas);
const ctx = canvas.getContext("2d");
const win = window;
	win.ctx = ctx;
const Node = abv.Node;
const Term2D = abv.Term2D;
const VTerm = abv.VTerm;
const Color = abv.Color;
const AM = abv.AM;

const out = (msg) => {
//	let m = msg.f.substr(0,5)+'>'+msg.t.substr(0,5)+': ';// + ts.ab2str(msg.b);
	const a = Array.from(new Uint16Array(msg.b));
	tty.update(a);
//  	print(m);
};

const agent = new abv.Agent(location.origin,WebSocket);
agent.log = ts.debug.bind(ts);
agent.out = out;

const $fps = 30;
const $m = 1;

const tty = new AM();
tty.term = new Term2D(win);
//ts.debug(app.term.layers);
tty.update = (arr) => {
//		app.update();
	//	tty.term.layers = app.term.layers;
		tty.term.fromArray(arr);
		tty.render(); 
	}

})();
