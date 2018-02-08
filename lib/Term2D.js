/**
 * Term2D
 */
"use strict";

const ts = require('abv-ts')('abv:Term2D');
const Term1D = require('./Term1D');
const Color = require('./Color');

class Term2D extends Term1D
{
	
	constructor()
	{
		super();
		const id = 'canvas';
		const canvas = document.createElement(id);
		canvas.id = id;
		canvas.style.left = "0px"; 
		canvas.style.top = "0px";
		canvas.width = 1024; 
		canvas.height = 624;
		canvas.style.margin 	= "0px";
		canvas.style.position 	= "fixed";
		document.body.appendChild(canvas);
		this.init(canvas);
	}
		
	init(canvas)
	{
		this.ctx = canvas.getContext("2d");
	}
	
	clear() 
	{ 
		this.ctx.clearRect(0, 0, this.ctx.canvas.width, this.ctx.canvas.height);
	}

	rect(id,x,y,w,h,rg,ba)
	{
//		ts.debug('rect: ',id,x,y,w,h);
		const c = Color.from2B(rg,ba);
		this.ctx.beginPath();
		this.ctx.rect(x, y, w, h);
		this.ctx.strokeStyle = 'blue';//clr[o.c+1];
		this.ctx.fillStyle = Color.toRgbaCss(c); //ts.debug(c,Color.toRgbaCss(c));
		this.ctx.fill();
		this.ctx.stroke();
	}

}

module.exports = Term2D;
