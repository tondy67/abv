package abv.sys.openfl;

import abv.bus.*;
import abv.*;
import abv.lib.style.Style;
import abv.lib.Color;
import abv.ds.FS;
import abv.io.*;
import abv.AM;

import openfl.display.Sprite;
import openfl.text.*;
import openfl.events.*;

using abv.CR;
using abv.lib.math.MT;
using abv.lib.Color;
//
@:dce
class Terminal2D extends Terminal{

	public var shapes:Map<String,Sprite>;
	var sp:Sprite;
	public var monitor:Sprite;
	var ui:Input;
	var xx = 100; var yy = 100; var speed = 4;

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
		try oid = #if !neko e.target.name #else e.target.toString() #end
		catch(d:Dynamic){LG.log(d);}; 
		if(!oid.good())oid = "";
		return oid;
	}
	function onMsg(oid:String,cmd:Int)
	{ 
		if(oid.good())MS.exec(new MD(id,oid,cmd,sign,[monitor.mouseX,monitor.mouseY],"",[ui.delta]));
//LG.log(to+":"+MS.msgName(cmd));
	}// onMsg()	
	function onMouseOver(e:MouseEvent){onMsg(tid(e),MD.MOVER);}
	function onMouseOut(e:MouseEvent){onMsg(tid(e),MD.MOUT);}
	function onMouseMove(e:MouseEvent){
		if(ui.click){
			onMsg(tid(e),MD.MMOVE);
		};
	}
	function onMouseWheel(e:MouseEvent){ui.wheel = e.delta;}
	function onMouseUp(e:MouseEvent){ui.click = false;}
	function onMouseDown(e:MouseEvent)
	{ 
		var oid = "";
		var p = new flash.geom.Point(monitor.mouseX,monitor.mouseY);
		var l = monitor.getObjectsUnderPoint(p);
		l.reverse(); 
		for(o in l){ //trace(MS.accept(o.name,MD.MDOWN));
			if(MS.check(o.name) && MS.accept(o.name,MD.MDOWN)){ 
				oid += o.name; LG.log(oid);
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
	
	function onKeyUp(e:KeyboardEvent){ui.keys[e.keyCode] = false;}
	function onKeyDown(e:KeyboardEvent){
		ui.keys[e.keyCode] = true;

		if(isKey(KB.SPACE)){LG.log("SPACE");}
		else if(isKey(KB.N1)){LG.log(MS.show());};
		else if(isKey(KB.N2))LG.log("N2");
		
		var a = [KB.UP,KB.DOWN,KB.LEFT,KB.RIGHT];
		for(i in 0...a.length){
			xx = yy = 0;
			if(isKey(a[i])){ 
				switch(i){
					case 0:yy = -speed;
					case 1:yy = speed;
					case 2:xx = -speed;
					case 3:xx = speed;
				}		
				MS.exec(new MD(id,"snake",MD.MOVE,sign,[xx,yy],"",[ui.delta]));
				break;
			}	
		}	
	}
	
	function isKey(k:Int)
	{
		if(ui.keys[k]){
			ui.keys[k] = false;
			return true;
		}else return false;
	}// isKey()
	
	public function init()
	{ //trace(monitor.stage);
//		monitor.stage.addEventListener(MouseEvent.CLICK, onClick);
		monitor.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		monitor.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		monitor.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		monitor.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		monitor.stage.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		monitor.stage.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		monitor.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);   
		monitor.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
	}// initListeners()
	
	public override function drawStart()
	{
		var o = ro.o;
		if (shapes.exists(o.id)) {
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

}// abv.sys.openfl.Terminal2D
