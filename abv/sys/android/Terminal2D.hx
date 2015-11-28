package abv.sys.android;

import abv.bus.*;
import abv.*;
import abv.lib.style.*;
import abv.io.*;
import abv.lib.comp.Component;
import abv.lib.math.Rect;
import abv.io.Screen;
import abv.ui.Shape;
import abv.ds.AMap;

using abv.lib.CC;
using abv.lib.math.MT;
using abv.lib.style.Color;

@:dce
class Terminal2D extends Terminal {

@:allow(abv.sys.android.SM)
	var view:AppView = null;
	
	public function new(id:String)
	{
		super(id);
	}// new()

@:allow(abv.sys.android.AppView)
	function onMouseMove_(x=.0,y=.0)
	{ 
		var l = getObjectsUnderPoint(x,y); 
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
		var a = getObjectsUnderPoint(x,y); 

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
	
	public override function renderList(list:List<Component>)
	{
		var l = new List<Component>();
		var root = list.first().root.id;
		
		for(k in roots.keys()){
			if(k == root){
				for(el in list) l.add(el);
			}else{
				for(el in roots[k]) l.add(el);
			}
		}
		for(ro in l)drawObject(ro);
	}// renderList

	public override function clearScreen(root:Int)
	{
		if(view != null) view.clear();
	}// clearScreen()

	public override function drawStart()
	{
//trace("drawStart");
	}// drawStart()

	public override function drawPoint()
	{
	}// drawPoint()

	public override function drawLine()
	{
	}// drawLine()

	public override function drawTriangle()
	{
	}// drawTriangle()

	public override function drawCircle()
	{
	}// drawCircle()

	public override function drawEllipse()
	{
	}// drawEllipse()

	public override function drawShape()
	{
	}// drawShape()

	public override function drawRect()
	{ 
		if(view != null) view.redraw(shape);
	}// drawRect()

	public override function drawImage()
	{
		if(view != null) view.redraw(shape);
	}
	
	public override function drawText()
	{ 
		if(view != null) view.redraw(shape);
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

	public override function drawEnd()
	{
	}// drawEnd()

	
	public override function toString() 
	{
        return "Terminal2D";//("+"x: "+x+", y:"+y+", width:"+width+", height:"+height+")";
    }// toString()


}// abv.sys.android.Terminal2D

