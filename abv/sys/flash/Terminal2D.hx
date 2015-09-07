package abv.sys.flash;

import abv.bus.*;
import abv.*;
import abv.lib.style.*;
import abv.io.*;
import abv.lib.comp.Component;
import abv.lib.math.Rectangle;
import abv.io.Screen;
import abv.ui.Shape;
import abv.ds.AMap;

import flash.display.Sprite;
import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.text.*;
import flash.events.*;

using abv.lib.CC;
using abv.lib.math.MT;
using abv.lib.style.Color;

@:dce
class Terminal2D extends Terminal{

	var shapes = new AMap<String,Sprite>();
	var sp:Sprite;
	public var monitor = new Sprite();
	public var ui:Input;
	var bmd = new AMap<String,BitmapData>();
	
	public function new()
	{
		super("Terminal2D");
		ui = new Input(); 
	}// new()

	function tid(e:MouseEvent)
	{ 
		var oid:Null<String> = "";
		try oid = e.target.name catch(d:Dynamic) trace(d); 
		return oid;
	}// tid()
	
	override function getObjectsUnderPoint(x:Float,y:Float)
	{
		var r = new List<String>();
		var p = new flash.geom.Point(x,y);
		var l = monitor.getObjectsUnderPoint(p);
		l.reverse(); 
		for(o in l){ 
			r.add(o.name); 
		} 
		return r;
	}// getObjectsUnderPoint()
	
	function onMsg(oid:String,cmd:Int)
	{ 
		if(oid.good())MS.exec(new MD(sign,oid,cmd,[monitor.mouseX,monitor.mouseY],"",[ui.delta]));
//LG.log(to+":"+MS.msgName(cmd));
	}// onMsg()	
	function onMouseOver(e:MouseEvent)onMsg(tid(e),MD.MOUSE_OVER);
	function onMouseOut(e:MouseEvent)onMsg(tid(e),MD.MOUSE_OUT);
	function onMouseMove(e:MouseEvent){
		if(ui.click){
			onMsg(tid(e),MD.MOUSE_MOVE);
		};
	}
	function onMouseWheel(e:MouseEvent)ui.wheel = e.delta;
	function onMouseUp(e:MouseEvent)ui.click = false;
	function onMouseDown(e:MouseEvent)
	{ 
		var oid = "";
		var a = getObjectsUnderPoint(monitor.mouseX,monitor.mouseY);
 
		for(o in a){  
			if(MS.accept(o,MD.MOUSE_DOWN)){ 
				oid = o; //trace(oid);
				break;
			}
		}
///
		ui.click = true; 
		ui.start.set(monitor.mouseX,monitor.mouseY); 
		ui.move.copy(ui.start);
//
		onMsg(oid,MD.CLICK);
	}// onMouseDown
	
	function onClick(e:MouseEvent)
	{ 
	}// onClick
	
	function onKeyUp(e:KeyboardEvent)
	{
		ui.keys[e.keyCode] = false;
		MS.exec(new MD(sign,"",MD.KEY_UP,[e.keyCode]));
	}// onKeyUp()

	function onKeyDown(e:KeyboardEvent)
	{ 
		ui.keys[e.keyCode] = true; 
		MS.exec(new MD(sign,"",MD.KEY_DOWN,[e.keyCode]));
	}// onKeyDown()
	
	public function init()
	{ 
//		monitor.stage.addEventListener(MouseEvent.CLICK, onClick);
		monitor.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		monitor.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		monitor.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		monitor.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		monitor.stage.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		monitor.stage.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		monitor.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);   
		monitor.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
	}// init()
	
	public override function drawStart(shape:Shape)
	{
		if(shapes.exists(shape.id)){
			sp = shapes[shape.id];
		}else{
			sp = new Sprite();
			sp.name = shape.id; 
			shapes.set(shape.id, sp);
			monitor.addChild(sp);
		}; 
		sp.removeChildren();
		sp.graphics.clear();
		sp.visible = shape.visible; 
	}// drawStart()

	public override function drawShape(shape:Shape)
	{ 
		var fColor = shape.color.clr();
		var bColor = shape.border.color.clr();

		if(bColor.alpha > 0)sp.graphics.lineStyle(shape.border.width,bColor.rgb ,bColor.alpha);
		
		if(fColor.alpha > 0) { 
			sp.graphics.beginFill(fColor.rgb ,fColor.alpha); 
			sp.graphics.drawRoundRect(shape.x, shape.y, 
				shape.w * shape.scale, shape.h * shape.scale, 
				shape.border.radius);
		}
	}// drawShape()

	public override function drawImage(shape:Shape)
	{
		var bd:BitmapData = null;
		var src = shape.image.src;
		var tile = shape.image.tile;
		var id = src+tile;
		if(bmd.exists(id)){
			bd = bmd[id]; 
		}else{ 
			bd = getTile(FS.getTexture(src),tile,shape.scale);
			if(bd != null)bmd.set(id,bd); 
		}
		if(bd != null){
			var m:Matrix = new Matrix();
			m.translate(shape.x, shape.y);
			sp.graphics.beginBitmapFill(bd,m,false); 
			sp.graphics.drawRoundRect(shape.x, shape.y, 
				shape.w * shape.scale, shape.h * shape.scale, 
				shape.border.radius);
		}
	}// drawImage()

	public override function drawText(shape:Shape)
	{ 
		var c = shape.text.color.clr();
		var tf = new TextField();
		var font = FS.getFont(shape.text.font);
		var ft = new TextFormat(font.fontName, shape.text.size, c.rgb);
		tf.defaultTextFormat = ft;
		tf.width = shape.w;
		tf.height = shape.h;
		tf.selectable = tf.mouseEnabled = false;
		tf.multiline = true; 
		tf.wordWrap = true;
//tf.scrollV++;  
		tf.text = shape.text.src;
		tf.x = shape.x + 1;
		tf.y = shape.y + 1;
		sp.addChild(tf);	
	}// drawText()

	function getTile(bm:BitmapData,rect:Rectangle,scale = 1.)
	{ 
		var sbm:BitmapData = null; 
		if(bm == null) return sbm; 
		if(rect == null){
			rect = new Rectangle(0,0,bm.width,bm.height);
		}
		var bd = new BitmapData(MT.closestPow2(rect.w.int()), MT.closestPow2(rect.h.int()), true, 0);
		var pos = new flash.geom.Point();
		var r = new flash.geom.Rectangle(rect.x,rect.y,rect.w,rect.h);
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

	public override function clear(l:List<Component>)
	{ 
		super.clear(l);
		for(el in l){ 
			if(shapes.exists(el.id)){
				monitor.removeChild(shapes[el.id]);
				shapes.remove(el.id);
			}
		}
	}// clear()
	

	public override function drawEnd()
	{
		sp.graphics.endFill();
	}// drawEnd()

	
	public override function toString() 
	{
        return "Terminal2D";//("+"x: "+x+", y:"+y+", width:"+width+", height:"+height+")";
    }// toString()

}// abv.sys.flash.Terminal2D

