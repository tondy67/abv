/**
 * Node
 */
"use strict";

const ts = require('abv-ts')('abv:Node');

const $nodes = new Map();
const $names = [];

class Node{
	constructor(id,x=0,y=0,w=0,h=0,c=0)
	{
		if ($nodes.has(id)) throw Error('ID exists: ' + id);
		$names.push(id);
		this.id = id;
		$nodes.set(id,this);
		this._x = x;
		this._y = y;
		this.w = w;
		this.h = h;
		this.color = c;
		this.kind = 0;
		this.children = new Map();
		this.parent = null;
//		this.style = new Style(this);
	}
	
	get x(){return this._x;}
	set x(v)
	{ 
		let d = v - this.x;
		for (let [n,c] of this.children) if (c) c.x += d;
		this._x = v;
	}
	get y(){return this._y;}
	set y(v)
	{ 
		let d = v - this.y;
		for (let [n,c] of this.children) if (c) c.y += d;
		this._y = v;
	}
	
	addChild(child)
	{
		if (!child) return;
		if (this.children.has(child.id)) return;
		if (child.parent) child.parent.delChild(child);
		this.children.set(child.id,child);// ts.debug(child.id);
		child.parent = this;
	}

	delChild(child)
	{
		if (!child) return;
		child.parent = null;
		this.children.delete(child.id);		
	}
	
	static get(id)
	{
		let r = null;
		if ($nodes.has(id)) r = $nodes.get(id);
		return r;
	}
	
	static id(n) 
	{
		return $names.indexOf(n);
	}
}

module.exports = Node;