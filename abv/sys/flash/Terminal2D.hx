package abv.sys.flash;

import abv.bus.*;
import abv.*;
import abv.lib.style.Style;
import abv.lib.style.IStyle;
import abv.lib.Color;
import abv.ds.FS;
import abv.io.*;
import abv.AM;
import abv.lib.comp.Component;

import flash.display.Sprite;
import flash.text.*;
import flash.events.*;

using abv.CR;
using abv.lib.math.MT;
using abv.lib.Color;

@:dce
class Terminal2D extends Terminal{

	var shapes:Map<String,Sprite>;
	var sp:Sprite;
	public var monitor:Sprite;
	public var ui:Input;

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
		try oid = e.target.name catch(d:Dynamic){LG.log(d);}; 
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
		if(oid.good())MS.exec(new MD(id,oid,cmd,sign,[monitor.mouseX,monitor.mouseY],"",[ui.delta]));
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
				oid = o; LG.log(oid);
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
		MS.exec(new MD(id,"",MD.KEY_UP,sign,[e.keyCode]));
	}// onKeyUp()

	function onKeyDown(e:KeyboardEvent)
	{ 
		ui.keys[e.keyCode] = true;
		MS.exec(new MD(id,"",MD.KEY_DOWN,sign,[e.keyCode]));
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

	public override function drawRect()
	{ 
		var r = .0;
		var c = ro.o.color.clr();

		if(ro.style != null){
			if(ro.style.border != null){
				if(ro.style.border.radius.good())r = ro.style.border.radius;
				if(ro.style.border.color.good()){
					c = ro.style.border.color.clr(); 
					sp.graphics.lineStyle(1,c.rgb ,c.alpha);
				}
			}
			if(ro.style.background.color.good())c = ro.style.background.color.clr(); 
		}
		sp.graphics.beginFill(c.rgb ,c.alpha); 

		if(r == 0)sp.graphics.drawRect(ro.x, ro.y, ro.o.width, ro.o.height);
		else sp.graphics.drawRoundRect(ro.x, ro.y, ro.o.width, ro.o.height, r);

		sp.graphics.endFill();
	}// drawRect()

	public override function drawText()
	{ //trace(ro);
		var c = ro.o.color.clr();
		if((ro.style != null)&&(ro.style.color.good()))c = ro.style.color.clr(); 
		var tf = new TextField();
		var font = FS.getFont ("assets/fonts/regular.ttf"); //trace(font.fontName);
		var ft = new TextFormat(font.fontName, 14, c.rgb);
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

	public override function drawEnd()
	{
	}// drawEnd()

	
	public override function toString() 
	{
        return "Terminal2D";//("+"x: "+x+", y:"+y+", width:"+width+", height:"+height+")";
    }// toString()

}// abv.sys.flash.Terminal2D

