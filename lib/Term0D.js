/**
 * Term0D
 */
"use strict";

const ts = require('abv-ts')('abv:Term0D');
const ATerm = require('./ATerm');
const Color = require('./Color');

const readline = require('readline');

const $lup = '┌';
const $rup = '┐';
const $ldn = '└';
const $rdn = '┘';
const $h = '─';
const $v = '│';
const $p = '.';
// const Bold  	= "\x1b[1m"; 
const $pos = (x,y) => { return '\x1b['+y+';'+x+'H'; };

const $ul = (w) => {
	let r = '';
//	for (let i=0;i<w-2;i++) r += $h;
//	return $lup + r + $rup;
	for (let i=0;i<w-2;i++) r += $p;
	return w > 1 ? $p + r + $p : $p;
};

const $dl = (w) => {
	let r = '';
//	for (let i=0;i<w-2;i++) r += $h;
//	return $ldn + r + $rdn;
	for (let i=0;i<w-2;i++) r += $p;
	return $p + r + $p;
};

const $ml = (w) => {
	let r = '';
//	for (let i=0;i<w-2;i++) r += ' ';
//	return $v + r + $v;
	for (let i=0;i<w-2;i++) r += ' ';
	return $p + r + $p;
};

const $rst = () => { return '\x1b[2J'; };

class Term0D extends ATerm
{
	
	constructor(owner)
	{
		super(owner);		

	readline.emitKeypressEvents(process.stdin);
	process.stdin.setRawMode(true);
		process.stdin.on('keypress', (str, key) => {
			if(key.ctrl && key.name === 'c'){
				process.exit();
			}else if(key.name === 'space'){
		//		tty.stop();
				process.exit();
			}else{
				this.onKeyPress(key);
			}
		}); 

	}	
	
	clear(){ ts.println($rst()); }
		
	rect(id,x,y,w,h,rg,ba)
	{//ts.debug(id);
		const c = Color.from2B(rg,ba);
		const m = 10;
		x = Math.round(x/m);
		y = Math.round(y/m) + 1;
		w = Math.round(w/m);
		if (w < 1) w = 1;
		h = Math.round(h/m);
		if (h < 1) h = 1;
//	ts.debug('rect; ',id,x,y,w,h,Color.toName(c)); return;
		ts.println(ts.clr2c(Color.toName(c),true) + $pos(x,y) + $ul(w));
		if(h>2)for (let i=1;i<h-2;i++) ts.println($pos(x,y+i) + $ml(w));
		if(h>1)ts.println($pos(x,y+h-2) + $dl(w));
		ts.println(ts.clr2c());
//		s += $h;
//throw new Error(id);	
//ts.debug(c,Color.toRgbaCss(c));	
	}

}

module.exports = Term0D;
