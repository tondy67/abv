/**
 * VTerm
 */
"use strict";

const ts = require('abv-ts')('abv:VTerm');
const ATerm = require('./ATerm');
const Node = require('./Node');
const Color = require('./Color');

class VTerm extends ATerm
{
	
	constructor()
	{
		super();
		this.roots = [];
	}	
	
	render()
	{
		this.clear();
		this.layers.length = 0;
		let a;
		for (let l of this.roots){
			a = [];
			this.draw(l,a);
			this.layers.push(a);
		}
//ts.debug(this.layers);
	}

	draw(el,arr)
	{
		const c = Color.to2B(el.color);
		switch(el.kind){
			case 0: 
				arr.push([Node.id(el.id),0,el.x,el.y,el.w,el.h,c[0],c[1]]); // el.color
				break;
			default: ts.error(29,'kind: ' + el.kind);
		}
		if (el.children.size > 0){
			for (let [name,child] of el.children) if (child) this.draw(child,arr);
		}
		
	}
	
	addLayer(l)
	{
		this.roots.push(l);
	}
	
}

module.exports = VTerm;
