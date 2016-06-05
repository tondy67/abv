package abv.sys.cpp.ui;

import abv.bus.*;
import abv.*;
import abv.style.*;
import abv.io.*;
import abv.cpu.Timer;
import abv.ui.*;
import abv.math.*;
import abv.factory.Component;

using abv.sys.ST;
using abv.math.MT;
using abv.ds.TP;
using abv.style.Color;

//
@:dce
class View extends CView{

	var textures:Array<Int> = [];
	var mX = 0;
	var sdl:SD;
	var reverse = false;
	var play = false;
	var plays = false;
	var quit = false;
///
//
	public function new(id:String)
	{
		super(id);
//trace(SD.getLog());
		SD.onMouseWheel_ = onMouseWheel_;
		SD.onMouseUp_ = onMouseUp_;
		SD.onMouseDown_ = onMouseDown_;
		SD.onMouseMove_ = onMouseMove_;
		SD.onClick_ = onClick_;
		SD.onKeyUp_ = onKeyUp_;
		SD.onKeyDown_ = onKeyDown_;
	}// new()

	function print(s="")
	{
		if(s != "")Sys.println(s);
	}
	
	function onMouseMove_(x:Int,y:Int)
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
			}else if(hovered.good()){
//				onMsg(hovered,MD.MOUSE_OUT); 
//				hovered = "";
			}
		}
	}// onMouseMove_()
	
	function onMouseWheel_()ui.wheel = 0;
	function onMouseUp_(x=0,y=0)ui.click = false;
	function onMouseDown_(x=0,y=0)
	{ 
		var oid = -1;
		var a = AD.getObjectsUnderPoint(x,y);

		for(it in a){  
			if(MS.accept(it,MD.MOUSE_DOWN)){ 
				oid = it;  
				break;
			}
		}
//
		ui.click = true; 
//		ui.start.set(e.clientX,e.clientY);  
		ui.move.copy(ui.start);

		if(oid > 0) onMsg(oid,MD.CLICK); 
	}// onMouseDown_
	
	function onClick_()
	{ 
		var oid = -1;//cast(e.toElement,Element).id;
		if(oid != -1)onMsg(oid,MD.CLICK); 
//LG.log(oid);
	}// onClick_
	
	function onKeyUp_(key:Int)
	{
		ui.keys[key] = false;
		MS.call(new MD(this,"",MD.KEY_UP,[key])); 
	}// onKeyUp_()
	
	function onKeyDown_(key:Int)
	{ 
		ui.keys[key] = true;
		MS.call(new MD(this,"",MD.KEY_DOWN,[key]));
	}// onKeyDown_()
	
	public override function setLayer(id:Int)
	{ 
		layer = id; 
		SD.setLayer(id);
	}// setLayer()

	public override function drawRect()
	{ 
		SD.renderQuad(cursor,stroke,fill); 
	}// drawRect()

	public override function drawImage()
	{
		var scale = 1;
		SD.renderImage(fill.image,cursor.x,cursor.y,fill.tile,scale); 
	}
	
	public override function drawText(s:String,font:Font)
	{ 
		if(font.src.good())
			SD.renderText(font.src,s,cursor.x, cursor.y, 
			stroke.color, cursor.w.i());
	}// drawText()

	public override function clearLayer(id=-1)
	{
		SD.clearLayer(id);
	}// clear()

	public override function render()
	{
		SD.render();
	}// render()

}// abv.sys.cpp.ui.View
