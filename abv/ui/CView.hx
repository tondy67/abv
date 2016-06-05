package abv.ui;

import abv.factory.*;
import abv.bus.*;
import abv.io.*;
import abv.style.*;
import abv.math.*;
import abv.factory.IView;

using abv.sys.ST;
using abv.style.Color;

@:dce
class CView extends Object implements IView{

	public var ready(default,null) = true;
	public var ui = new Input(); 
	public var width(default, null):Float;
	public var height(default, null):Float;
	var context = 2;
	var hovered = "";

	public var monitor(default,null) = 0;
	public var layer(default,null) = 0;
	public var shape(default,null):Int;
	public var stroke(default,null) = new Stroke();
	public var fill(default,null) = new Fill();
	public var cursor(default,null) = new Rect();

	public inline function new(id:String)
	{
		super(id);
		msg.accept = MD.ALL;
	}// new()
	
	public function init() { return false;}
	
	inline function onMsg(to:Int,cmd:Int)
	{ 
		if(to > 0)MS.call(new MD(this,MS.getName(to),cmd,[],"",[ui.delta]));
	}// onMsg()	

	public dynamic function onMouseMove(x:Float,y:Float) mouseMove(x,y);
	inline function mouseMove(x:Float,y:Float)
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
	}// mouseMove()
	
	public dynamic function onMouseWheel(delta = 0) mouseWheel(delta);
	inline function mouseWheel(delta:Int)ui.wheel = delta;

	public dynamic function onMouseUp(x:Float,y:Float) mouseUp(x,y);
	inline function mouseUp(x:Float,y:Float)ui.click = false;

	public dynamic function onMouseDown(x:Float,y:Float) mouseDown(x,y);
	inline function mouseDown(x:Float,y:Float)
	{ 
		var to = -1;
		var a = AD.getObjectsUnderPoint(x,y);

		for(it in a){  
			if(MS.accept(it,MD.MOUSE_DOWN)){ 
				to = it;  
				break;
			}
		}
//
		ui.click = true; 
//		ui.start.set(e.clientX,e.clientY);  
		ui.move.copy(ui.start);
//
		if(to > 0) onMsg(to,MD.CLICK); 
	}// mouseDown
	
	public dynamic function onClick(x:Float,y:Float) mouseClick(x,y);
	inline function mouseClick(x:Float,y:Float)
	{ 
		var to = -1; 
		if(to != -1)onMsg(to,MD.CLICK); 
	}// mouseClick
	
	public dynamic function onKeyDown(key:Int) keyDown(key);
	inline function keyDown(key:Int)
	{ 
		ui.keys[key] = true; 
		MS.call(new MD(this,"",MD.KEY_DOWN,[key]));  
	}// onKeyDown_()
	
	public dynamic function onKeyUp(key:Int) keyUp(key);
	inline function keyUp(key:Int)
	{
		ui.keys[key] = false;
		MS.call(new MD(this,"",MD.KEY_UP,[key]));
	}// onKeyUp_()

	public function setMonitor(id:Int)
	{ 
		monitor = id;
	}// setMonitor()

	public function setLayer(id:Int)
	{
		layer = id;
	}// setLayer()

	public function clearLayer(id=-1){ }

	public function setShape(id:Int)
	{ 
		shape = id;
	}// setShape()
		
	public function strokeStyle(color:Color = 0, width = .0, radius=.0) 
	{ 
		stroke.color = color;
		stroke.width = width;
		stroke.radius = radius;
	}// strokeStyle()

	public function fillStyle(color:Color = 0, image="",tile:Rect=null) 
	{ 
		fill.color 	= color;
		fill.image 	= image;
		fill.tile 	= tile;
	}// fillStyle()

	public function moveTo(x:Float, y:Float, w = .0, h =.0)
	{
		cursor.set(x, y, w, h);
	}// moveTo()

	public function curveTo(x:Float, y:Float){ }

// Creates a cubic Bézier curve
	public function bezierTo(x:Float, y:Float){ }

	public function lineTo(x:Float, y:Float)
	{ 
		cursor.x = x;
		cursor.y = y;
	}

	public function drawCircle(){ } 

	public function drawEllipse(){ }

	public function drawPolygon(path:Array<Point>){ }

	public function drawRect(){ }

	public function drawImage(){ }
	
	public function drawText(s:String,font:Font){ }

	public function render(){ }
	
	public function onResize()
	{
		width = AM.WIDTH; height = AM.HEIGHT;
	}// resize()

	public override function toString() 
	{
        return '($name: $width x $height)';
    }// toString()

}// abv.ui.CView

