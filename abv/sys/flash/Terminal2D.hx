package abv.sys.flash;

import abv.bus.*;
import abv.*;
import abv.lib.style.*;
import abv.io.*;
import abv.lib.comp.Component;
import abv.lib.math.Rect;
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

	var panels:AMap<Int,Sprite>; 
	var shapes:AMap<Int,Sprite>;
	var sp:Sprite;
	public var monitor:Sprite;

	public function new(id:String)
	{
		super(id);
	}// new()

	public override function init()
	{ 
		panels = new AMap<Int,Sprite>(); 
		shapes = new AMap<Int,Sprite>();
		monitor = new Sprite();
	}// init()
	
	public function initListeners()
	{ 
//		monitor.stage.addEventListener(MouseEvent.CLICK, onClick_);
		monitor.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp_);
		monitor.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown_);
		monitor.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove_);
		monitor.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel_);
		monitor.stage.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver_);
		monitor.stage.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut_);
		monitor.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown_);   
		monitor.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp_); 
	}// initListeners()
	
	function tid(e:MouseEvent)
	{ 
		var r = -1;
		var oid:Null<String> = "";
		try oid = e.target.name catch(d:Dynamic) trace(d); 
		if(oid.good()) r = MS.getID(oid);
		return r;
	}// tid()
	
	override function getObjectsUnderPoint(x:Float,y:Float)
	{
		var r = new List<Int>();
		var p = new flash.geom.Point(x,y);
		var l = monitor.getObjectsUnderPoint(p);
		l.reverse(); 
		for(o in l){ 
			r.add(MS.getID(o.name)); 
		} 
		return r;
	}// getObjectsUnderPoint()
	
	function onMouseOver_(e:MouseEvent)onMsg(tid(e),MD.MOUSE_OVER);
	function onMouseOut_(e:MouseEvent)onMsg(tid(e),MD.MOUSE_OUT);
	function onMouseMove_(e:MouseEvent){
		if(ui.click){
			onMsg(tid(e),MD.MOUSE_MOVE);
		};
	}
	function onMouseWheel_(e:MouseEvent) super.onMouseWheel(e.delta);
	function onMouseUp_(e:MouseEvent) super.onMouseUp(monitor.mouseX.i(),monitor.mouseY.i());
	function onMouseDown_(e:MouseEvent)
	{ 
		var oid = -1;
		var a = getObjectsUnderPoint(monitor.mouseX,monitor.mouseY);

		for(it in a){  
			if(MS.accept(it,MD.MOUSE_DOWN)){ 
				oid = it; //trace(oid);
				break;
			}
		}
///
		ui.click = true; 
		ui.start.set(monitor.mouseX,monitor.mouseY); 
		ui.move.copy(ui.start);
//
		onMsg(oid,MD.CLICK);
	}// onMouseDown_
	
	function onClick_(e:MouseEvent) super.onClick(monitor.mouseX.i(),monitor.mouseY.i());
	
	function onKeyDown_(e:KeyboardEvent) super.onKeyDown(e.keyCode);
 	
	function onKeyUp_(e:KeyboardEvent) super.onKeyUp(e.keyCode);
 
	public override function clearScreen(root:Int)
	{
		if(!panels.exists(root)){ //trace(root);
			panels.set(root,new Sprite());
			panels.get(root).name = MS.getName(root);
			monitor.addChild(panels.get(root));
		};  
		clearList(roots[root]);
	}// clearScreen()

	public override function drawStart()
	{ 
		var root = shape.root;
		if(shapes.exists(shape.id)){
			sp = shapes.get(shape.id);
		}else{
			sp = new Sprite();
			sp.name = MS.getName(shape.id); 
			shapes.set(shape.id, sp);
			panels.get(root).addChild(sp);
		}; 
		sp.removeChildren();
		sp.graphics.clear();
		sp.visible = shape.visible; 
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
		var fColor = shape.color;
		var bColor = shape.border.color;

		if(bColor.alpha > 0)sp.graphics.lineStyle(shape.border.width,bColor.rgb ,bColor.alpha);
		
		if(fColor.alpha > 0) { 
			sp.graphics.beginFill(fColor.rgb ,fColor.alpha); 
			sp.graphics.drawRoundRect(shape.x, shape.y, 
				shape.w * shape.scale, shape.h * shape.scale, 
				shape.border.radius);
		}
	}// drawRect()

	public override function drawImage()
	{
		var bd = FS.getImage(shape.image.src,shape.image.tile,shape.scale);
		
		if(bd != null){
			var m:Matrix = new Matrix();
			m.translate(shape.x, shape.y);
			sp.graphics.beginBitmapFill(bd,m,false); 
			sp.graphics.drawRoundRect(shape.x, shape.y, 
				shape.w * shape.scale, shape.h * shape.scale, 
				shape.border.radius);
		}
	}// drawImage()

	public override function drawText()
	{ 
		var c = shape.text.color;
		var tf = new TextField();
		var font = FS.getFont(shape.text.font.src);
		var ft = new TextFormat(font.fontName, shape.text.font.size, c.rgb);
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


	public override function clearList(list:List<Component>)
	{ 
		if(list.isEmpty())return; 
		var root = list.first().root.id; 
		panels.get(root).removeChildren();
		for(el in list) shapes.remove(el.id);
		super.clearList(list); 
	}// clearList()
	

	public override function drawEnd()
	{
		sp.graphics.endFill();
	}// drawEnd()

	
	public override function toString() 
	{
        return "Terminal2D";//("+"x: "+x+", y:"+y+", width:"+width+", height:"+height+")";
    }// toString()

}// abv.sys.flash.Terminal2D

