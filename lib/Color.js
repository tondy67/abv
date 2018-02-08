/**
 * Color
 */
"use strict";

class Color
{
	constructor()
	{
		throw new Error('Static class!');
	}

	static rgba(r,g,b,a) 
	{
		return ((r & 0xFF) << 24) | ((g & 0xFF) << 16) | 
			((b & 0xFF) << 8) | (a & 0xFF);
	}

	static toRgba(c) 
	{
		return [(c >> 24) & 0xFF, (c >> 16) & 0xFF,
			(c >> 8) & 0xFF, c & 0xFF];
	}

	static to2B(c) 
	{
		return [(c >> 16) & 0xFFFF, c & 0xFFFF];
	}	

	static from2B(rg,ba) 
	{
		return ((rg & 0xFFFF) << 16) | (ba & 0xFFFF);
	}

	static toRgbaCss(c) 
	{
		const a = Color.toRgba(c);
		return 'rgba(' + a[0] + ',' + a[1] + ',' + a[2] + 
			',' + (a[3]/255) + ')';
	}

	static toHex(c) 
	{
		const a = Color.toRgba(c);
		return '#' + a[0].toString(16) + a[1].toString(16) + 
			a[2].toString(16);
	}

	static name(n)
	{
		n = n.toLowerCase();
		let r;
		switch(n){
			case 'white'	: r =  0xffffffff;break;
			case 'silver' 	: r =  0xc0c0c0ff;break;
			case 'gray' 	: r =  0x808080ff;break;
			case 'red' 		: r =  0xff0000ff;break;
			case 'maroon' 	: r =  0x800000ff;break;
			case 'yellow' 	: r =  0xffff00ff;break;
			case 'orange' 	: r =  0xFFA500FF;break;
			case 'olive'	: r =  0x808000ff;break;
			case 'lime' 	: r =  0x00ff00ff;break;
			case 'green'	: r =  0x008000ff;break;
			case 'cyan' 	: r =  0x00ffffff;break;
			case 'teal' 	: r =  0x008080ff;break;
			case 'blue' 	: r =  0x0000ffff;break;
			case 'navy' 	: r =  0x000080ff;break;
			case 'fuchsia' 	: r =  0xff00ffff;break;
			case 'purple' 	: r =  0x800080ff;break;
			case 'black'	: r =  0x000000ff;break;
			default: r = 0;
		}
		
		return r;
	}

	static toName(c)
	{
		c = (c >> 8) & 0xFFFFFF; //console.log(c.toString(16));
		let r;
		switch(c){
			case 0xffffff: r = 'white' ;break;
			case 0xc0c0c0: r = 'silver';break;
			case 0x808080: r = 'gray' ;break;
			case 0xff0000: r = 'red' ;break;
			case 0x800000: r = 'maroon';break;
			case 0xffff00: r = 'yellow' ;break;
			case 0xFFA500: r = 'orange' ;break;
			case 0x808000: r = 'olive' ;break;
			case 0x00ff00: r = 'lime' ;break;
			case 0x008000: r = 'green' ;break;
			case 0x00ffff: r = 'cyan' ;break;
			case 0x008080: r = 'teal' ;break;
			case 0x0000ff: r = 'blue' ;break;
			case 0x000080: r = 'navy' ;break;
			case 0xff00ff: r = 'fuchsia' ;break;
			case 0x800080: r = 'purple' ;break;
			case 0x000000: r = 'black' ;break;
			default: r = 'white';
		}
		
		return r;
	}
	
}



module.exports = Color;
