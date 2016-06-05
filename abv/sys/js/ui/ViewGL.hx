package abv.sys.js.ui;
/**
 * ViewGL
 **/
import abv.bus.*;
import abv.*;
import abv.style.*;
import abv.io.*;
import abv.ui.*;
import abv.math.*;
import abv.factory.Component;
//
import js.Lib;
import js.Browser;
import js.html.HtmlElement;
import js.html.CanvasElement;
import js.html.DivElement; 
import js.html.Document;
import js.html.DOMElement;
import js.html.webgl.GL;
import js.html.MouseEvent;
import js.html.KeyboardEvent;

using abv.sys.ST;

@:dce
class ViewGL extends CView{

	var doc:Document;
	var body: DOMElement;   
    var layers: Array<GL> = [];
    var ctx: GL;
    var canvas:CanvasElement = null;
//
	public function new(id:String)
	{
		super(id);

        doc = Browser.document;
        body = doc.getElementById("body");
       
		canvas = cast(doc.createElement("Canvas"),CanvasElement);
		body.appendChild(canvas);
		canvas.width = CC.WIDTH;    
		canvas.height = CC.HEIGHT; 
		canvas.style.top = "0px";
		canvas.style.left = "0px";
		canvas.style.margin = "0px";
		canvas.style.position = "fixed";

 		ctx = canvas.getContextWebGL();  
		if(ctx == null){
			ST.error(ST.getText(21),"WebGL");
			ready = false;  
		}else{
			ctx.clearColor(0.0, 1.0, 0.0, 1.0); 
			ctx.enable(GL.DEPTH_TEST);
		}
//ready = false; 
 	}// new()

	function addListeners()
	{  
		Browser.window.addEventListener("keydown", onKeyDown_, false);
		Browser.window.addEventListener("keyup", onKeyUp_, false);
		Browser.window.addEventListener("mouseup", onMouseUp_, false);
		Browser.window.addEventListener("mousedown", onMouseDown_, false);
	}// addListeners()

	function delListeners()
	{   
		Browser.window.removeEventListener("keydown", onKeyDown_, false);
		Browser.window.removeEventListener("keyup", onKeyUp_, false);
		Browser.window.removeEventListener("mouseup", onMouseUp_, false);
		Browser.window.removeEventListener("mousedown", onMouseDown_, false);
	}// delListeners()
	
	function onMouseMove_(e:MouseEvent)
	{ 
		var l = AD.getObjectsUnderPoint(e.clientX,e.clientY); //trace(l);
		if(l.length > 0){ 
			var t = l.first(); 
			if(ui.click){
				onMsg(t,MD.MOUSE_MOVE);
				return;
			}
		}
	}// onMouseMove_()
	
	function onMouseWheel_(e:MouseEvent)ui.wheel = 0;
	function onMouseUp_(e:MouseEvent)ui.click = false;
	function onMouseDown_(e:MouseEvent)
	{ //trace("mouse down");
		var oid = -1;
		var a = AD.getObjectsUnderPoint(e.clientX,e.clientY);
 
		for(it in a){  
			if(MS.accept(it,MD.MOUSE_DOWN)){ 
				oid = it;  
				break;
			}
		}
//
		ui.click = true; 
		ui.start.set(e.clientX,e.clientY);  
		ui.move.copy(ui.start);

		if(oid > 0) onMsg(oid,MD.CLICK); 
	}// onMouseDown_
	
	function onClick_(e:MouseEvent)
	{ //trace(e.target);
		var oid:String  = cast(e.target,DOMElement).id; 
trace(oid);
		if(oid.good())onMsg(MS.getID(oid),MD.CLICK); 
	}// onClick_
	
	function onKeyUp_(e:KeyboardEvent)
	{
		e.preventDefault();
		ui.keys[e.keyCode] = false;
		MS.call(new MD(this,"",MD.KEY_UP,[e.keyCode]));
	}// onKeyUp_()
	
	function onKeyDown_(e:KeyboardEvent)
	{
		e.preventDefault();
		ui.keys[e.keyCode] = true;
		MS.call(new MD(this,"",MD.KEY_DOWN,[e.keyCode]));
	}// onKeyDown_()
	
	public override function setLayer(id:Int)
	{
		layer = id; 
	}// setLayer()
	
	public override function clearLayer(id=-1)
	{ 
	}// clearLayer()

	
	public override function setShape(id:Int)
	{
		shape = id;
 	}// setShape()

	public override function drawRect()
	{ 
 
	}// drawRect()

	public override function drawImage()
	{ 
 	}// drawImage()
	
	public override function drawText(s:String,font:Font)
	{ 
	}// drawText()

	public override function dispose()
	{
		delListeners();
		if(canvas != null)body.removeChild(canvas);
		super.dispose();
	}
}// abv.sys.js.ui.ViewGL
