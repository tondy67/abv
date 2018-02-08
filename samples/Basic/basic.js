/**
 * console app
 */
"use strict";

const ts = require('abv-ts')('abv:Basic');
const Node = require('../../lib/Node');
const AM = require('../../lib/AM');
const VTerm = require('../../lib/VTerm');
const Term0D = require('../../lib/Term0D');
const Color = require('../../lib/Color');
const App = require('./App');

//let c = Color.rgba(0x00,0x00,0xFF,0x88);
//ts.debug(c.toString(16),Color.toName(c));

const $fps = 3;
const $m = 10;


const app = new App();
//app.run($fps);

const tty = new AM();
tty.term = new Term0D();
//ts.debug(app.term.layers);
tty.update = () => {
		app.update();
	//	tty.term.layers = app.term.layers;
		tty.term.fromArray(app.term.toArray());
		tty.render(); 
	}

tty.run($fps);

tty.term.onKeyPress = (key) => {
	if(key.name === 'up'){
		Node.get('box2').y -= $m;
	}else if(key.name === 'down'){
		Node.get('box2').y += $m;
	}else if(key.name === 'left'){
		Node.get('box2').x -= $m;
	}else if(key.name === 'right'){
		Node.get('box2').x += $m;
	}else if(key.name === 'm'){
		Node.get('box5').addChild(Node.get('box3'));
//		ts.debug(Node.get('box3'));
	}else{
		ts.debug(key.name);
	}
};
/*
const readline = require('readline');
readline.emitKeypressEvents(process.stdin);
process.stdin.setRawMode(true);
process.stdin.on('keypress', (str, key) => {
	if(key.ctrl && key.name === 'c'){
		process.exit();
	}else if(key.name === 'space'){
		tty.stop();
		process.exit();
	}else if(key.name === 'up'){
		Node.get('box2').y -= $m;
	}else if(key.name === 'down'){
		Node.get('box2').y += $m;
	}else if(key.name === 'left'){
		Node.get('box2').x -= $m;
	}else if(key.name === 'right'){
		Node.get('box2').x += $m;
	}else if(key.name === 'z'){
		app.onKeyDown(key);
	}else{
		console.log(key);
	}
}); 
*/