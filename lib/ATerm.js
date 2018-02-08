/**
 * ATerm
 */
"use strict";

const ts = require('abv-ts')('abv:ATerm');

const $m2arr = (mtx) => {
		let r = [];
		for (let row of mtx) r.push($m2a(row));
		r = $m2a(r);
		return r;	
	};
const  $m2a = (arr) => {
		let r = [], len;
		for (let el of arr){
			len = el.length;
			el.unshift(len);
			r = r.concat(el);
		}
		return r;	
	};
const $arr2m = (arr) => {
		let r = $a2m(arr);
		for (let i=0,len=r.length;i<len;i++) r[i] = $a2m(r[i]);
		return r;
	};
const $a2m = (arr) => {
		let r = [], pos = 0, end;
		while(pos < arr.length){
			end = arr[pos] + pos + 1;
			r.push(arr.slice(pos+1,end));
			pos = end;
		}
		return r;
	};

class ATerm
{
//AD.getObjectsUnderPoint	
	constructor()
	{
		this.layers = [];
	}	
	
	toArray()
	{
		return $m2arr(this.layers);
	}
	
	fromArray(arr)
	{
		this.layers = $arr2m(arr);
	}
	render()
	{
		this.clear();
		for (let l of this.layers) this.draw(l);
	}
	
	clear() {}
	
	draw(arr)
	{
		for (let el of arr){// ts.debug(el);
			switch(el[1]){ // .kind
				case 0: 
					this.rect(el[0],el[2],el[3],el[4],el[5],el[6],el[7]); 
					break;
				default: ts.error(29,'kind: ' + el[1]); // Color.toRgba(el.color)
			}
		}
/*		if (el.children.size > 0){
			for (let [name,child] of el.children) if (child) this.draw(child);
		}
*/					
	}
	
	rect(id,x,y,w,h,rg,ba)
	{
		ts.debug('rect',id,x,y,w,h,rg,ba);
	}
	
	addLayer(l)
	{
		this.layers.push(l);
	}
	
	onKeyUp(e) {  }
	
	onKeyDown(e) {  }

	onWheel(e) {  }

	onMouseMove(e) {  }	

	onMouseUp(e) {  }

	onMouseDown(e) {  }

	onClick(e) {  }
	
	dispose(){}
}

module.exports = ATerm;
