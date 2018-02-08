/**
 * AM
 */
"use strict";

const ts = require('abv-ts')('abv:AM');
const ATerm = require('./ATerm');

let $timer = null;

class AM
{
	
	constructor()
	{
		this.term = null;
		this.create();
	}	
	
	create()
	{
//		this.addTerm(new ATerm());
	}
	
	update()
	{
		this.render();
	}

	output(v) {}
	intput(v) {}
	
	render()
	{
		this.term.render();
		this.output();
	}
	
	addLayer(l)
	{
		this.term.addLayer(l);
	}
	
	run(fps=30)
	{
		if ($timer != null) return;
		if (fps > 0) $timer = setInterval(this.update.bind(this),1000/fps);
		else this.update(this);
	}
	stop()
	{
		clearInterval($timer);
	}
	
	exit(code){ }
		
}

module.exports = AM;
