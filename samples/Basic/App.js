/**
 * console app
 */
"use strict";

const ts = require('abv-ts')('abv:App');
const Node = require('../../lib/Node');
const AM = require('../../lib/AM');
const VTerm = require('../../lib/VTerm');
const Term0D = require('../../lib/Term0D');
const Color = require('../../lib/Color');

//let c = Color.rgba(0x00,0x00,0xFF,0x88);
//ts.debug(c.toString(16),Color.toName(c));

const $fps = 3;
const $m = 10;

class App extends AM
{
	constructor()
	{
		super();
	}
	
	create()
	{
		this.term = new VTerm();

		const root = new Node('root',0,0,790,690,Color.name('white')); // Color.rgba(255, 255, 255, 55)
		const box1 = new Node('box1',10,20,100,80,Color.name('red'));
		root.addChild(box1);
		const box2 = new Node('box2',100,120,100,80,Color.name('green'));
		root.addChild(box2);
		const box3 = new Node('box3',16,25,50,40,Color.name('orange'));
		box1.addChild(box3);
		const box4 = new Node('box4',300,200,100,80,Color.name('blue'));
		root.addChild(box4);
		const box5 = new Node('box5',0,200,10,10,Color.name('gray'));
		root.addChild(box5);
		const box6 = new Node('box6',0,220,10,10,Color.name('gray'));
		root.addChild(box6);
		
		this.addLayer(root);
		
		const root2 = new Node('root2',350,70,190,150,Color.name('cyan'));
		this.addLayer(root2);
	}
	
	update()
	{
		const w = 700;
		const r = Node.get('root');
		const b1 = Node.get('box1');
		if(b1.x < w) b1.x += $m; else b1.x = 0;
		const b4 = Node.get('box4');
		if(b4.y > $m) b4.y -= $m;
		const b5 = Node.get('box5');
		if(b5.x < w) b5.x += 1.5*$m; else b5.x = 0;
		const b6 = Node.get('box6');
		if(b6.x < w) b6.x += $m; else b6.x = 0;
		const r2 = Node.get('root2'); 
		if (r2.w > $m) r2.w -= $m;
		if (r2.h > $m) r2.h -= $m;
		this.render();
	}

}

module.exports = App;
