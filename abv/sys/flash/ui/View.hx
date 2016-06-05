package abv.sys.flash.ui;


import flash.text.*;
import flash.display.*;
import flash.events.*;
import flash.geom.Matrix;
import flash.Lib;

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

	public var ctx(default,null) = new Sprite();
	var sp:Sprite;

	var layers:Array<Sprite> = []; 
	var shapes = new Map<Int,Sprite>(); 
	var ad = new AD();

	public function new(id:String)
	{ 
		super(id);
		ctx.name = id;
		AM.me.addChild(ctx);

		setLayer(layer);
		addListeners(); 
		onResize(); 
	}// new()

	function addListeners()
	{  
		if((ctx == null)||(ctx.stage == null)){
			ST.error(ST.getText(20));
			return;
		}
//		ctx.stage.addEventListener(MouseEvent.CLICK, onClick_);
		ctx.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp_);
		ctx.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown_);
		ctx.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove_);
		ctx.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel_);
		ctx.stage.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver_);
		ctx.stage.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut_);
		ctx.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown_);   
		ctx.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp_); 
	}// addListeners()

	function delListeners()
	{  
		if((ctx == null)||(ctx.stage == null)){
			ST.error(ST.getText(20));
			return;
		}
//		ctx.stage.removeEventListener(MouseEvent.CLICK, onClick_);
		ctx.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp_);
		ctx.stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown_);
		ctx.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove_);
		ctx.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel_);
		ctx.stage.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver_);
		ctx.stage.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut_);
		ctx.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown_);   
		ctx.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp_); 
	}// delListeners()
	
	function tid(e:MouseEvent)
	{ 
		var r = -1;
		var oid:Null<String> = "";
		try oid = e.target.name catch(e:Dynamic) trace(e); 
		if(oid.good()) r = MS.getID(oid);
		return r;
	}// tid()

	function onMouseOver_(e:MouseEvent)onMsg(tid(e),MD.MOUSE_OVER);
	function onMouseOut_(e:MouseEvent)onMsg(tid(e),MD.MOUSE_OUT);
	function onMouseMove_(e:MouseEvent){
		if(ui.click){
			onMsg(tid(e),MD.MOUSE_MOVE);
		};
	}
	function onMouseWheel_(e:MouseEvent) super.onMouseWheel(e.delta);
	function onMouseUp_(e:MouseEvent) super.onMouseUp(ctx.mouseX,ctx.mouseY);
	function onMouseDown_(e:MouseEvent)super.onMouseDown(ctx.mouseX,ctx.mouseY);
	
	function onClick_(e:MouseEvent) super.onClick(ctx.mouseX.i(),ctx.mouseY.i());
	
	function onKeyDown_(e:KeyboardEvent) super.onKeyDown(e.keyCode);
 	
	function onKeyUp_(e:KeyboardEvent) super.onKeyUp(e.keyCode);
 

	public override function setLayer(id:Int)
	{
		layer = id;
		if(layers[id] != null){
			sp = layers[id];
			return;
		}
		sp = new Sprite();
		layers[id] = sp;
		sp.name = id + "";
		ctx.addChild(sp);
		clear(sp);
	}// setLayer()

	inline function clear(s:Sprite)
	{
		if(s != null){
			s.removeChildren();
			s.graphics.clear();
		}
	}// clear()
	
	public override function clearLayer(id=-1)
	{
		for(i in 0...layers.length){
			if((id == -1)||(id == i)){
				if(layers[i] == null)continue;
				clear(layers[i]); 
			}
		}
	}// clearLayer()
	
	public override function setShape(id:Int)
	{ 
		shape = id;
/*
 trace(abv.bus.MS.getName(id));
		if(shapes[id] != null){
			sp = shapes[id];
			clear(sp);
			sp.visible = true; 
			return;
		}
		sp = new Sprite();
		shapes[id] = sp;
		sp.name = id + "";
		layers[layer].addChild(sp);
		clear(sp);
		sp.visible = true;  */
	}// setShape()

	public override function lineTo(x:Float, y:Float)
	{ 
		sp.graphics.lineStyle(stroke.width,stroke.color.rgb ,stroke.color.alpha);
		sp.graphics.moveTo(cursor.x, cursor.y); 
		sp.graphics.lineTo(x, y);
		super.lineTo(x,y);	
	}// drawLine()
	
	public override function drawPolygon(path:Array<Point>)
	{ 
		if (path == null) return;
		var len = path.length;  
		sp.graphics.lineStyle(stroke.width,stroke.color.rgb ,stroke.color.alpha);
		sp.graphics.beginFill(fill.color.rgb ,fill.color.alpha); 
		sp.graphics.moveTo(path[0].x, path[0].y); 
		for(i in 1...len){
			sp.graphics.lineTo(path[i].x, path[i].y);	
		}
		sp.graphics.lineTo(path[0].x, path[0].y);	
		sp.graphics.endFill();
	}// drawPolygon()
	
	public override function drawCircle()
	{ 
		sp.graphics.lineStyle(stroke.width,stroke.color.rgb ,stroke.color.alpha);
		
		sp.graphics.beginFill(fill.color.rgb ,fill.color.alpha); 
		sp.graphics.drawCircle(cursor.x,cursor.y,cursor.w);
//		sp.graphics.endFill();
	}// drawRect()

	public override function drawRect()
	{ 
//trace(x+":"+y+"-"+width+":"+height); trace(stroke);
		sp.graphics.lineStyle(stroke.width,stroke.color.rgb ,stroke.color.alpha);
		
		sp.graphics.beginFill(fill.color.rgb ,fill.color.alpha); 
		sp.graphics.drawRoundRect(cursor.x, cursor.y, cursor.w, cursor.h, stroke.radius);
//		sp.graphics.endFill();
	}// drawRect()

	public override function drawImage()
	{ 
	var scale = 1; //trace(fill.tile);
		var bd = FS.getImage(fill.image,fill.tile,scale);
		
		if(bd != null){
			var m:Matrix = new Matrix();
			m.translate(cursor.x, cursor.y);
			sp.graphics.beginBitmapFill(bd,m,false); 
			sp.graphics.drawRoundRect(cursor.x, cursor.y, 
				cursor.w * scale, cursor.h * scale, 
				stroke.radius);
//			sp.graphics.endFill();
		} 
	}// drawImage()
	
	public override function drawText(s:String,font:Font)
	{ 
		if(font == null){
			ST.error(ST.getText(20));
			return;
		}
		var tf = new TextField();
		var f = FS.getFont(font.src);  
		var ft = new TextFormat(f.fontName, font.size, stroke.color.rgb); 
		tf.defaultTextFormat = ft;
		tf.width = cursor.w;
		tf.height = cursor.h;
		tf.selectable = tf.mouseEnabled = false;
		tf.multiline = true; 
		tf.wordWrap = true;
//tf.scrollV++;  
		tf.text = s;
		tf.x = cursor.x + 1;
		tf.y = cursor.y + 1;
		layers[layer].addChild(tf);	
	}// drawText()

	public override function dispose()
	{
		delListeners();
		AM.me.removeChild(ctx);
		super.dispose();
	}
}// abv.sys.flash.ui.View

