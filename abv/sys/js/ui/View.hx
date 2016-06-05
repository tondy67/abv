package abv.sys.js.ui;
/**
 * View
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
import js.html.CanvasRenderingContext2D;
import js.html.MouseEvent;
import js.html.KeyboardEvent;

using abv.sys.ST;
using abv.ds.TP;

@:dce
class View extends CView{

	var elms:Map<String,DOMElement>;
	var elm:DOMElement;
	var doc:Document;
	var body: DOMElement;   
    var layers: Array<CanvasRenderingContext2D> = [];
    var ctx: CanvasRenderingContext2D;
    var canvas:CanvasElement = null;
//
	public function new(id:String)
	{
		super(id);

		elms = new Map();
        doc = Browser.document;
        body = doc.getElementById("body");
        
 		setLayer(layer);
		addListeners(); 
		onResize(); 
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
		if((AD.roots[layer] != null) &&
			(AD.roots[layer].context == 1)){
			context = 1;
			return;
		}
		context = 2;
		if(layers[layer] != null){
			ctx = layers[layer];
			return;
		}
		canvas = cast(doc.createElement("Canvas"),CanvasElement);
		var style = canvas.style;
		body.appendChild(canvas);
		ctx = layers[layer] = canvas.getContext2d();
		canvas.width = CC.WIDTH;    
		canvas.height = CC.HEIGHT; 
		canvas.style.top = "0px";
		canvas.style.left = "0px";
		canvas.style.margin = "0px";
		canvas.style.position = "fixed";
	}// setLayer()
	
	inline function clear(s:CanvasRenderingContext2D)
	{ 
		if(s != null){
			s.clearRect(0,0,CC.WIDTH,CC.HEIGHT);
		}
	}// clear()
	
	public override function clearLayer(id=-1)
	{ 
		if(context == 2){
			for(i in 0...layers.length){
				if((id == -1)||(id == i)){
					if(layers[i] == null)continue;
					clear(layers[i]); 
				}
			}
		}
/*		var grd = layers.createLinearGradient(150.000, 0.000, 150.000, 300.000);
		grd.addColorStop(0.125, 'rgba(170, 170, 170, 1.000)');
		grd.addColorStop(0.994, 'rgba(238, 238, 238, 1.000)');
		layers.copyStyle = grd;
		layers.copyRect(0,0,w,h); */
	}// clearLayer()

	
	public override function setShape(id:Int)
	{
		shape = id;

		if(context != 1)return;
		
		var ix = -1;
		var obj = cast(MS.getComm(id),Component);
		var name = obj.name;
		var pname = obj.parent.name;
		
		if(elms.exists(name)){
			elm = elms[name];
		}else{ 
			if(obj.kind == BUTTON){
				elm = doc.createElement("Button"); 
				elm.addEventListener("click", onClick_, false);
			}else if(obj.kind == HBOX){
				elm = doc.createElement("Div");
				elm.className = "hbox"; 
			}else if(obj.kind == VBOX){
				elm = doc.createElement("Div");
				elm.className = "vbox"; 
			}else if(obj.kind == FBOX){
				elm = doc.createElement("Div");
				elm.className = "fbox"; 
			}else if(obj.style.name == ".dialog"){
				elm = doc.createElement("Div");
				elm.className = "dialog";  
			}else if(obj.style.name == ".text"){
				elm = doc.createElement("Div");
				elm.className = "text"; 
			}else{ 
				elm = doc.createElement("Div");
				ix = name.indexOf("_");
				elm.className = ix == -1?"text":name.substr(0,ix);
			}
	
			elm.id = name; 
			elms.set(elm.id, elm); 	
			if(obj.parent == obj.root){
				body.appendChild(elm); 
			}else if(elms.exists(pname)){ 
				elms[pname].appendChild(elm); 
			}
		};
		 
		elm.style.visibility = "visible"; 
/*		if(shape.style.starts(".")){
			name = shape.style.replace(".","");
			var ix = name.indexOf("#");
			if(ix != -1)name = name.substr(0,ix);
			elm.className = name; 
		} */
 	}// setShape()

	function moveElement(x:Float,y:Float)
	{
			elm.style.left = x + "px"; 
			elm.style.top = y + "px";
			elm.style.margin = "0px";
			elm.style.position = "fixed";
	}// moveElement()
	
	public override function drawCircle()
	{ 
  		if(context == 1) return; 
		var r = cursor.w/2;
		var cx = cursor.x + r;
		var cy = cursor.y + r;

		ctx.strokeStyle = stroke.color.toCssRgba();
		ctx.lineWidth = stroke.width ;
		ctx.beginPath();
		ctx.arc(cx, cy, r, 0, 2 * Math.PI, false);
		ctx.closePath();
		ctx.stroke();

		ctx.fillStyle = fill.color.toCssRgba(); 
		ctx.fill();

		ctx.strokeStyle = "rgba(0,0,0,0)";
		ctx.fillStyle 	= "rgba(0,0,0,0)";
	}// drawCircle()
	
	public override function drawRect()
	{ 
  		if(context == 1){ 
			moveElement(cursor.x,cursor.y);
		}else{
//			if(stroke.width > 0){
				var x = cursor.x;
				var y = cursor.y;
				var w = cursor.w;
				var h = cursor.h;
				var r = stroke.radius;
				var scale = 1;
				ctx.strokeStyle = stroke.color.toCssRgba();
				ctx.lineWidth = stroke.width ;
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
//			}
//			if(fill.color.alpha > 0){
				ctx.fillStyle = fill.color.toCssRgba(); 
				ctx.fill();
//			}
			ctx.strokeStyle = "rgba(0,0,0,0)";
			ctx.fillStyle 	= "rgba(0,0,0,0)";
		}

	}// drawRect()

	public override function drawImage()
	{ 
 		if(context == 1){  
			moveElement(cursor.x,cursor.y);
		}else{
			var img = FS.getTexture(fill.image); 
			var scale = 1;
			if(img != null){ //trace(fill.tile);
				if(fill.tile == null)ctx.drawImage(img,cursor.x,cursor.y);
				else ctx.drawImage(img,fill.tile.x,fill.tile.y,cursor.w,cursor.h, 
					cursor.x,cursor.y,cursor.w*scale,cursor.h*scale);
			}
		}

	}// drawImage()
	
	public override function drawText(s:String,font:Font)
	{ 
		if(context == 1){  
			elm.innerHTML = s.nl2br();
		}else{		
			var name = "DefaultFont";

			ctx.fillStyle = stroke.color.toCssRgba();
			ctx.font = font.size + "pt " + name; 
			fillText(s,cursor.x+2,cursor.y+20,cursor.w,font.size+2);
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

	public override function dispose()
	{
		delListeners();
		if(canvas != null)body.removeChild(canvas);
		super.dispose();
	}
}// abv.sys.js.ui.View
