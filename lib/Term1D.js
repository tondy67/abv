/**
 * Term1D
 */
"use strict";

const ts = require('abv-ts')('abv:Term1D');
const ATerm = require('./ATerm');
const Color = require('./Color');

class Term1D extends ATerm
{
	
	constructor()
	{
		super();
		this.doc = window.document;	
		this.elms = new Map();	
		this.addListeners();
	}	
	
	addListeners()
	{  
		window.addEventListener("keydown", this.onKeyDown_.bind(this), false);
		window.addEventListener("keyup", this.onKeyUp_.bind(this), false);
		window.addEventListener("mouseup", this.onMouseUp_.bind(this), false);
		window.addEventListener("mousedown", this.onMouseDown_.bind(this), false);
		window.addEventListener("mousemove", this.onMouseMove_.bind(this), false);
		window.addEventListener("DOMMouseScroll", this.onWheel_.bind(this), false);
		window.onmousewheel = this.doc.onmousewheel = this.onWheel_.bind(this);
	}// addListeners()

	delListeners()
	{   
		window.removeEventListener("keydown", this.onKeyDown_, false);
		window.removeEventListener("keyup", this.onKeyUp_, false);
		window.removeEventListener("mouseup", this.onMouseUp_, false);
		window.removeEventListener("mousedown", this.onMouseDown_, false);
		window.removeEventListener("mousemove", this.onMouseMove_, false);
		window.removeEventListener("DOMMouseScroll", this.onWheel_, false);
		window.onmousewheel = this.doc.onmousewheel = null;
	}// delListeners()
	
	clear() 
	{ 
	}

	shape(id,c)
	{
		let r = this.elms.get(id);
		if (!r){
			r = this.doc.createElement("div");
			r.id = id;
			r.style.backgroundColor = Color.toRgbaCss(c);
			r.style.border = "1px solid #0000FF";
			this.doc.body.appendChild(r);
			this.elms.set(id,r);
		}
		return r;
	}
	
	rect(id,x,y,w,h,rg,ba)
	{
//		ts.debug('rect: ',id,x,y,w,h);
		const c = Color.from2B(rg,ba);
		const el = this.shape(id,c);
		el.style.left = x + "px"; 
		el.style.top = y + "px";
		el.style.width = w + "px"; 
		el.style.height = h + "px";
		el.style.margin = "0px";
		el.style.position = "fixed";
	}
	
	onKeyUp_(e)
	{
		e.preventDefault();
		this.onKeyUp(e);
	}
	
	onKeyDown_(e)
	{	
		e.preventDefault();
		this.onKeyDown(e);
	}

	onMouseMove_(e) 
	{  
		e.preventDefault();
		this.onMouseMove(e);
	}	
// https://adom.as/javascript-mouse-wheel/
	onWheel_(e) 
	{
		let delta = 0;
		if (!e) e = window.event;
		if (e.wheelDelta) {
			delta = e.wheelDelta/120; 
		} else if (e.detail) {
			delta = -e.detail/3;
		}
		if (delta) this.onWheel(delta);
		e.preventDefault();
		e.returnValue = false;
	}

	onMouseUp_(e) 
	{  
		e.preventDefault();
		this.onMouseUp(e);
	}

	onMouseDown_(e) 
	{  
		e.preventDefault();
		this.onMouseDown(e);
	}

	dispose()
	{
		this.delListeners();
	}
}

module.exports = Term1D;
