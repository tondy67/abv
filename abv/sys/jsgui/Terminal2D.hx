package abv.sys.jsgui;

import abv.bus.*;
import abv.*;
import abv.lib.style.*;
import abv.io.*;
import abv.cpu.Timer;
import abv.io.Screen;
import abv.ui.box.*;
import abv.ui.widget.*;
import abv.lib.math.Rect;
import abv.lib.comp.Component;
import abv.ui.Shape;
import abv.ds.AMap;
//
import js.Lib;
import js.html.*;
import js.Browser;
import js.html.HtmlElement;
import js.html.CanvasElement;
import js.html.DivElement; 
import js.html.Document;

using abv.lib.CC;
using abv.lib.math.MT;
using abv.ds.TP;
using abv.lib.style.Color;

//
@:dce
class Terminal2D extends Terminal{

	var elms:AMap<String,DOMElement>;
	var elm:DOMElement;
	var doc:Document;
	var body: DOMElement;   
    var ctx: CanvasRenderingContext2D = null;
//
	public function new(id:String)
	{
		super(id);
	}// new()

	public override function init() 
	{ 
		elms = new AMap();
        doc = Browser.document;
        body = doc.getElementById("body");

		if(CC.CONTEXT != CTX_1D){
			var canvas = cast(doc.createElement("Canvas"),CanvasElement);
			var style = canvas.style;
			body.appendChild(canvas);
			ctx = canvas.getContext2d();
			canvas.width = CC.WIDTH;    
			canvas.height = CC.HEIGHT; trace("canvas");
		}
//trace("new");
		Browser.window.addEventListener("keydown", onKeyDown_, false);
		Browser.window.addEventListener("keyup", onKeyUp_, false);
		Browser.window.addEventListener("mouseup", onMouseUp_, false);
		Browser.window.addEventListener("mousedown", onMouseDown_, false);
	}// init() 

	function onMouseMove_(e:MouseEvent)
	{ 
		var l = getObjectsUnderPoint(e.clientX,e.clientY);
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
		var a = getObjectsUnderPoint(e.clientX,e.clientY);
 
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
//
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
		MS.exec(new MD(id,"",MD.KEY_UP,[e.keyCode]));
	}// onKeyUp_()
	
	function onKeyDown_(e:KeyboardEvent)
	{
		e.preventDefault();
		ui.keys[e.keyCode] = true;
		MS.exec(new MD(id,"",MD.KEY_DOWN,[e.keyCode]));
	}// onKeyDown_()
	
	public override function clearScreen(root:Int)
	{
		var w = CC.WIDTH, h = CC.HEIGHT;
		if(CC.CONTEXT == CTX_2D){
			ctx.clearRect(0,0,w,h);
		}
/*		var grd = ctx.createLinearGradient(150.000, 0.000, 150.000, 300.000);
		grd.addColorStop(0.125, 'rgba(170, 170, 170, 1.000)');
		grd.addColorStop(0.994, 'rgba(238, 238, 238, 1.000)');
		ctx.copyStyle = grd;
		ctx.copyRect(0,0,w,h); */
	}// clearScreen()

	public override function drawStart()
	{
		if(shape.context != CTX_1D)return;
		
		var ix = CC.ERR;
		var name = MS.getName(shape.id);
		var pname = MS.getName(shape.parent);
		
		if(elms.exists(name)){
			elm = elms[name];
		}else{
			if(shape.kind == BUTTON){
				elm = doc.createElement("Button");
				elm.addEventListener("click", onClick_, false);
			}else if(shape.kind == HBOX){
				elm = doc.createElement("Div");
				elm.className = "hbox"; 
			}else if(shape.kind == VBOX){
				elm = doc.createElement("Div");
				elm.className = "vbox"; 
			}else if(shape.kind == FBOX){
				elm = doc.createElement("Div");
				elm.className = "fbox"; 
			}else if(shape.style == ".dialog"){
				elm = doc.createElement("Div");
				elm.className = "dialog";  
			}else if(shape.style == ".text"){
				elm = doc.createElement("Div");
				elm.className = "text"; 
			}else{ 
				elm = doc.createElement("Div");
				ix = name.indexOf("_");
				elm.className = ix == CC.ERR?"text":name.substr(0,ix);
			}
		
			elm.id = name;
			elms.set(elm.id, elm); 
			if(shape.parent == shape.root)body.appendChild(elm);
			else if(elms.exists(pname)){ 
				elms[pname].appendChild(elm);
			}
		}; 
		if(shape.visible){ 
			if(elm.style.visibility != "visible"){
				elm.style.visibility = "visible"; 
				if(shape.style.starts(".")){
					var name = shape.style.replace(".","");
					var ix = name.indexOf("#");
					if(ix != CC.ERR)name = name.substr(0,ix);
					elm.className = name; 
				}
			}
		}else{
			elm.style.visibility = "hidden"; 
		}
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
		if(shape.context == CTX_1D){
			var elm = doc.getElementById(MS.getName(shape.id));
			if(elm != null){  
				elm.style.left = shape.x + "px"; 
				elm.style.top = shape.y + "px";
			}
		}else{
			
			if(shape.border.width > 0){
				var x = shape.x;
				var y = shape.y;
				var w = shape.w;
				var h = shape.h;
				var r = shape.border.radius;
				var scale = shape.scale;
				ctx.strokeStyle = shape.border.color.toCssRgba();
				ctx.lineWidth = shape.border.width ;
				ctx.beginPath();
				ctx.moveTo(x + r, y);
				ctx.lineTo(x + w*scale - r, y);
				ctx.quadraticCurveTo(x + w*scale, y, x + w*scale, y + r);
				ctx.lineTo(x + w*scale, y + h*scale - r);
				ctx.quadraticCurveTo(x + w*scale, y + h*scale, x + w*scale - r, y + h*scale);
				ctx.lineTo(x + r, y + h*scale);
				ctx.quadraticCurveTo(x, y + h*scale, x, y + h*scale - r);
				ctx.lineTo(x, y + r);
				ctx.quadraticCurveTo(x, y, x + r, y);
				ctx.closePath();
				ctx.stroke();
			}
			
			if(shape.color.alpha > 0){
				ctx.fillStyle = shape.color.toCssRgba(); 
				ctx.fill();
			}
			ctx.strokeStyle = "rgba(0,0,0,0)";
			ctx.fillStyle 	= "rgba(0,0,0,0)";
		}
	}// drawRect()

	public override function drawImage()
	{
			var img = FS.getTexture(shape.image.src); //trace(img.w);
			if(img != null){
				if(shape.image.tile == null)ctx.drawImage(img,shape.x,shape.y);
				else ctx.drawImage(img,shape.image.tile.x,shape.image.tile.y,shape.w,shape.h, 
					shape.x,shape.y,shape.w*shape.scale,shape.h*shape.scale);
				//trace(tile+":"+w+":"+scale);
			}
	}
	
	public override function drawText()
	{ 
		if(shape.context == CTX_1D){
			elm.innerHTML = shape.text.src.nl2br();
		}else{		
			var name = "DefaultFont";

			ctx.fillStyle = shape.text.color.toCssRgba();
			ctx.font = shape.text.font.size + "pt " + name; 
			var text = shape.text.src; 
			fillText(text,shape.x+2,shape.y+20,shape.w,shape.text.font.size+2);
		}
	}// drawText()

	function fillText(text:String, x:Float, y:Float, maxWidth:Float, lineHeight:Float) 
	{
		var lines = text.split("\n");
		var line = "";
		var words:Array<String>;

		for(i in 0...lines.length) {
			line = "";
			words = lines[i].split(" "); 

			for(n in 0...words.length) {
				var testLine = line + words[n] + " ";
				var metrics = ctx.measureText(testLine);
				var testWidth = metrics.width;

				if (testWidth > maxWidth) {
					ctx.fillText(line, x, y);
					line = words[n] + " ";
					y += lineHeight;
				}else{
					line = testLine;
				}
			}

			ctx.fillText(line, x, y);
			y += lineHeight;
		}
	}// fillText()

	public override function drawEnd()
	{
	}// drawEnd()

	
	public override function toString() 
	{
        return "Terminal2D";
    }// toString()

}// abv.sys.jsgui.Terminal2D
