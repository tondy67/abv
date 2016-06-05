package abv.sys.android.ui;

import abv.bus.*;
import abv.*;
import abv.style.*;
import abv.io.*;
import abv.factory.Component;
import abv.math.*;
import abv.ui.*;


using abv.sys.ST;
using abv.math.MT;
using abv.style.Color;

@:dce
class View extends CView {

@:allow(abv.sys.android.SM)
	var ctx:AppView = null;
	
	public function new(id:String)
	{
		super(id);
	}// new()

@:allow(abv.sys.android.AppView)
	function onMouseMove_(x=.0,y=.0)
	{ 
		var l = AD.getObjectsUnderPoint(x,y); 
		if(l.length > 0){ 
			var t = l.first(); 
			if(ui.click){
				onMsg(t,MD.MOUSE_MOVE);
			}else if(MS.accept(t,MD.MOUSE_OVER)){
//				if(hovered != t)onMsg(hovered,MD.MOUSE_OUT);
//				hovered = t;
//				onMsg(hovered,MD.MOUSE_OVER); 
			}else {
//				onMsg(hovered,MD.MOUSE_OUT); 
//				hovered = "";
			}
		}
	}// onMouseMove_()
	
@:allow(abv.sys.android.AppView)
	function onMouseUp_(x=.0,y=.0)ui.click = false;

@:allow(abv.sys.android.AppView)
	function onMouseDown_(x=.0,y=.0)
	{ 
		var oid = -1;
		var a = AD.getObjectsUnderPoint(x,y); 

		for(o in a){  
			if(MS.accept(o,MD.MOUSE_DOWN)){ 
				oid = o; //trace(oid);
				break;
			}
		}
//
		ui.click = true; 
//		ui.start.set(e.clientX,e.clientY);  
		ui.move.copy(ui.start);
//
		if(oid > 0){ //trace(oid);
			onMsg(oid,MD.CLICK); 
		}
	}// onMouseDown_
	
@:allow(abv.sys.android.AppView)
	function onClick_()
	{ 
		var oid  = -1;//cast(e.toElement,Element).id;
		if(oid > 0)onMsg(oid,MD.CLICK); 
//LG.log(oid);
	}// onClick_
	
	public override function render()
	{
/*		var l = new List<Component>();
		var root = list.first().root.id;
		
		for(k in roots.keys()){
			if(k == root){
				for(el in list) l.add(el);
			}else{
				for(el in roots[k]) l.add(el);
			}
		}
		for(ro in l)drawObject(ro); */
	}// renderList

	public override function clearLayer(id=-1)
	{
		if(ctx != null) ctx.clear();
	}// clearScreen()

	public override function drawLine()
	{
	}// lineTo()

	public override function drawCircle()
	{
	}// drawCircle()

	public override function drawEllipse()
	{
	}// drawEllipse()

	public override function drawPolygon( path:Array<Point>)
	{
	}// drawPolygon()

	public override function drawRect()
	{ 
		if(ctx != null) ctx.redraw();
	}// drawRect()

	public override function drawImage()
	{
		if(ctx != null) ctx.redraw();
	}
	
	public override function drawText(s:String,font:Font)
	{ 
		if(ctx != null) ctx.redraw();
	}// drawText()

/*	function getTile(bm:BitmapData,rect:Rect,scale = 1.)
	{ 
		var sbm:BitmapData = null; 
		if(bm == null) return sbm; 
		if(rect == null){
			rect = new Rect(0,0,bm.width,bm.height);
		}
		var bd = new BitmapData(MT.closestPow2(rect.w.int()), MT.closestPow2(rect.h.int()), true, 0);
		var pos = new flash.geom.Point();
		var r = new flash.geom.Rect(rect.x,rect.y,rect.w,rect.h);
		bd.copyPixels(bm, r, pos, null, null, true);
		
		if(scale == 1){
			sbm = bd;
		}else{
			var m = new flash.geom.Matrix();
			m.scale(scale, scale);
			var w = (bd.width * scale).int(), h = (bd.height * scale).int();
			sbm = new BitmapData(w, h, true, 0x000000);
			sbm.draw(bd, m, null, null, null, true);
		}		
		return sbm;
	}// getTile()
*/
}// abv.sys.android.ui.View

