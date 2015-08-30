package abv.sys.flash;

import abv.bus.*;
import abv.*;
import abv.lib.style.*;
import abv.io.*;
import abv.lib.comp.Component;
import abv.lib.math.Rectangle;
import abv.io.Screen;

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

	var shapes:Map<String,Sprite>;
	var sp:Sprite;
	public var monitor:Sprite;
	public var ui:Input;
	var bmd = new Map<String,BitmapData>();
	
	public function new()
	{
		super("Terminal2D");
		ui = new Input(); 
		monitor = new Sprite(); //trace(msg);
		shapes = new Map();
	}// new()

	function tid(e:MouseEvent)
	{ 
		var oid:Null<String> = "";
		try oid = e.target.name catch(d:Dynamic){trace(d);}; 
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
	function onMouseOver(e:MouseEvent){onMsg(tid(e),MD.MOUSE_OVER);}
	function onMouseOut(e:MouseEvent){onMsg(tid(e),MD.MOUSE_OUT);}
	function onMouseMove(e:MouseEvent){
		if(ui.click){
			onMsg(tid(e),MD.MOUSE_MOVE);
		};
	}
	function onMouseWheel(e:MouseEvent){ui.wheel = e.delta;}
	function onMouseUp(e:MouseEvent){ui.click = false;}
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
	
	public override function drawStart()
	{
		var o = ro.o;
		if(shapes.exists(o.id)){
			sp = shapes[o.id];
		}else{
			sp = new Sprite();
			sp.name = o.id; 
			shapes.set(o.id, sp);
			monitor.addChild(sp);
		}; 
		sp.removeChildren();
		sp.graphics.clear();
		sp.visible = o.visible; 
	}// drawStart()

	public override function drawShape()
	{ 
		var radius = .0;
		var border = .0;
		var c = ro.o.color.clr();
		var bd:BitmapData = null;
		var x = ro.x, y = ro.y, w = ro.o.width , h = ro.o.height ;
		var style = ro.o.style;
		var scale = ro.o.scale;
		var tile:Rectangle = null;
		var src = "";
		
		if(style != null){
			if(style.border != null){ 
				radius = style.border.radius;
				border = style.border.width;
				if(border > 0){
					c = style.border.color.clr(); 
					sp.graphics.lineStyle(border,c.rgb ,c.alpha);
				}
			}

			if(style.background != null){
				if(style.background.image.good()){
					if(style.background.position != null)
						tile = new Rectangle(-style.background.position.x,-style.background.position.y,w,h);
					src = style.background.image; 
					if(bmd.exists(src+tile)){
						bd = bmd[src+tile]; 
					}else{ 
						bd = getTile(FS.getTexture(src),tile,scale);
						if(bd != null)bmd.set(src+tile,bd); 
					}
				}
				c = style.background.color.clr(); 
			}
		}
	
		if (c.alpha > 0) { 
			sp.graphics.beginFill(c.rgb ,c.alpha); 
			sp.graphics.drawRoundRect(x, y, w * scale, h * scale, radius);
		}
		if (bd != null) {
			var m:Matrix = new Matrix();
			m.translate(x, y);
			sp.graphics.beginBitmapFill(bd,m,false); 
			sp.graphics.drawRoundRect(x, y, w * scale, h * scale, radius);
		}

		sp.graphics.endFill();
	}// drawShape()

	public override function drawText()
	{ //trace(ro);
		var c = ro.o.color.clr();
		var src = "";
		var size = 14.;
		var style = ro.o.style;
		if(style != null){
			if(style.color.good())c = style.color.clr();
			if(style.font != null){
				if(style.font.src.good())src = style.font.src;
				if(style.font.size != null)size = style.font.size;
			}
		}
//trace(style.font);
		var tf = new TextField();
		var font = FS.getFont(src);
		var ft = new TextFormat(font.fontName, size, c.rgb);
		tf.defaultTextFormat = ft;
		tf.width = ro.o.width;
		tf.height = ro.o.height;
		tf.selectable = tf.mouseEnabled = false;
		tf.multiline = true; 
		tf.wordWrap = true;
//tf.scrollV++;  
		tf.text = ro.o.text;
		tf.x = ro.x + 1;
		tf.y = ro.y + 1;
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
		for(el in l){ 
			queue.remove(el.id);
			forms.remove(el.id);
			if(shapes.exists(el.id)){
				monitor.removeChild(shapes[el.id]);
				shapes.remove(el.id);
			}
		}
	}// clear()
	

	public override function drawEnd()
	{
	}// drawEnd()

	
	public override function toString() 
	{
        return "Terminal2D";//("+"x: "+x+", y:"+y+", width:"+width+", height:"+height+")";
    }// toString()

}// abv.sys.flash.Terminal2D

