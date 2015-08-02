package abv.sys.js;

import abv.bus.*;
import abv.*;
import abv.lib.LG;
import abv.lib.style.*;
import abv.io.*;
import abv.cpu.Timer;
import abv.io.Screen;
import abv.ui.box.*;
import abv.ui.widget.*;
import abv.lib.math.Rectangle;
//
import js.Lib;
import js.html.*;
import js.Browser;
import js.html.HtmlElement;
import js.html.CanvasElement;
import js.html.DivElement; 
import js.html.Document;

using abv.lib.CR;
using abv.lib.math.MT;
using abv.lib.TP;
using abv.lib.style.Color;

//
@:dce
class Terminal2D extends Terminal{

	var elms = new Map<String,DOMElement>();
	var elm:DOMElement;
	var shapes:Map<String,DoData>;
	var doc:Document;
	var body: DOMElement;   
    var ctx: CanvasRenderingContext2D;
//
	var ui:Input;
	
	public function new()
	{
		super("Terminal2D");
		ui = new Input(); 
//
        doc = Browser.document;
/*
var st = doc.createStyleHtmlElement();
st.type = "text/css"; 
doc.head.appendChild(st); 
cast(st.sheet,js.html.CSSStyleSheet).addRule("@font-face", "font-family:'DefaultFont';src: url('../../assets/fonts/regular.ttf')  format('truetype');");
*/
        body = doc.getElementById("body");
        var canvas = cast(doc.createElement("Canvas"),CanvasElement);
		var style = canvas.style;
        body.appendChild(canvas);
		ctx = canvas.getContext2d();
        canvas.width = 1024;    
		canvas.height = 600;
//trace("new");
		Browser.window.addEventListener("keydown", onKeyDown, false);
		Browser.window.addEventListener("keyup", onKeyUp, false);
		canvas.addEventListener("mouseup", onMouseUp, false);
		canvas.addEventListener("mousedown", onMouseDown, false);
	}// new()

	function onMsg(oid:String,cmd:Int)
	{ 
		if(oid.good())MS.exec(new MD(sign,oid,cmd,[],"",[ui.delta]));
//LG.log(to+":"+MS.msgName(cmd));
	}// onMsg()	
	function onMouseMove(e:MouseEvent)
	{ 
		var l = getObjectsUnderPoint(e.clientX,e.clientY);
		if(l.length > 0){ 
			var t = l.first(); 
			if(ui.click){
				onMsg(t,MD.MOUSE_MOVE);
				return;
			}
		}
	}// onMouseMove()
	
	function onMouseWheel(e:MouseEvent){ui.wheel = 0;}
	function onMouseUp(e:MouseEvent){ui.click = false;}
	function onMouseDown(e:MouseEvent)
	{ 
		var oid = "";
		var a = getObjectsUnderPoint(e.clientX,e.clientY);
//LG.log(a+""); 
		for(o in a){  
			if(MS.accept(o,MD.MOUSE_DOWN)){ 
				oid = o; LG.log(oid);
				break;
			}
		}
//
		ui.click = true; 
		ui.start.set(e.clientX,e.clientY);  
		ui.move.copy(ui.start);
//
		if(oid.good())onMsg(oid,MD.CLICK); 
	}// onMouseDown
	
	function onClick(e:MouseEvent)
	{ trace(e.target);
		var oid:String  = cast(e.target,DOMElement).id; 
trace(oid);
		if(oid.good())onMsg(oid,MD.CLICK); 
LG.log(oid);
	}// onClick
	
	function onKeyUp(e:KeyboardEvent)
	{
		e.preventDefault();
		ui.keys[e.keyCode] = false;
		MS.exec(new MD(sign,"",MD.KEY_UP,[e.keyCode]));
	}// onKeyUp()
	
	function onKeyDown(e:KeyboardEvent)
	{
		e.preventDefault();
		ui.keys[e.keyCode] = true;
		MS.exec(new MD(sign,"",MD.KEY_DOWN,[e.keyCode]));
	}// onKeyDown()
	
	public function init()
	{ 
	}// init()
	
	public override function drawClear()
	{
		var w = 1024, h = 600;
		ctx.clearRect(0,0,w,h);
/*		var grd = ctx.createLinearGradient(150.000, 0.000, 150.000, 300.000);
		grd.addColorStop(0.125, 'rgba(170, 170, 170, 1.000)');
		grd.addColorStop(0.994, 'rgba(238, 238, 238, 1.000)');
		ctx.fillStyle = grd;
		ctx.fillRect(0,0,w,h); */
	}// drawClear()

	public override function drawStart()
	{
		var style = ro.o.style;
		if(ro.ctx != Ctx1D)return;
		var kind = switch(Type.typeof(ro.o)){
			case TClass(HBox):"hbox";
			case TClass(VBox):"vbox";
			case TClass(Button):"button";
			case TClass(Text):"text";
			case TClass(Image):"image";
			default:"";
		}

		if(elms.exists(ro.o.id)){
			elm = elms[ro.o.id];
		}else{
			if(kind == "button"){
				elm = doc.createElement("Button");
				elm.addEventListener("click", onClick, false);
			}else if(kind == "hbox"){
				elm = doc.createElement("Div");
				elm.className = "hbox"; 
			}else if(kind == "vbox"){
				elm = doc.createElement("Div");
				elm.className = "vbox"; 
			}else if(style.name == ".dialog"){
				elm = doc.createElement("Div");
				elm.className = "dialog";  
			}else if(style.name == ".text"){
				elm = doc.createElement("Div");
				elm.className = "text"; 
			}else{ trace(ro.o);
				elm = doc.createElement("Div");
				elm.className = "text"; 
			}
		
			elm.id = ro.o.id;
			elms.set(elm.id, elm);
			if(ro.o.parent == ro.o.root)body.appendChild(elm);
			else if(elms.exists(ro.o.parent.id))elms[ro.o.parent.id].appendChild(elm);
		}; 
		if(ro.o.visible){
			if(elm.style.visibility != "visible"){
				elm.style.visibility = "visible"; 
				if(style.name.starts(".")){
					var name = style.name.replace(".","");
					var ix = name.indexOf("#");
					if(ix != -1)name = name.substr(0,ix);
					elm.className = name;
				}
			}
		}else{
			elm.style.visibility = "hidden"; 
		}
 	}// drawStart()

	public override function drawShape()
	{ 
		var r = .0;
		var border = .0;
		var c = ro.o.color;
		var src = "";
		var x = ro.x, y = ro.y, w = ro.o.width, h = ro.o.height;
		var scale = ro.o.scale;
		var tile:Rectangle = null;
		var style = ro.o.style;

		if(ro.ctx == Ctx2D){
			if(style != null){
				if(style.background == null){}
				else if(style.background.image.good()){
					src = style.background.image;
					if(style.background.position != null)
						tile = new Rectangle(-style.background.position.x,-style.background.position.y,w,h);
				}else c = style.background.color;
				
				if(style.border != null){
					r = style.border.radius;
					border = style.border.width;
					if(border > 0){
						ctx.strokeStyle = style.border.color.srgba();
						ctx.lineWidth = border;
					}
				}
			}
			ctx.fillStyle = c.srgba(); 
//			drawRoundRect(x, y, w, h, r, src);
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
			ctx.fill();
			if(src.good()){
				var img = FS.getTexture(src); //trace(img.w);
				if(img != null){
					if(tile == null)ctx.drawImage(img,x,y);
					else ctx.drawImage(img,tile.x,tile.y,w,h, x,y,w*scale,h*scale);
					//trace(tile+":"+w+":"+scale);
				}
			}
		}
	}// drawShape()

	public override function drawText()
	{ //trace(ro);
		var style = ro.o.style;
		if(ro.ctx == Ctx1D){
			elm.innerHTML = ro.o.text;
		}else{		
			var c = ro.o.color;
			var name = "status-bar";
			var size = 14.;
			if(style != null){
				if(style.color.good())c = style.color;
				if(style.font != null){
					if(style.font.name.good())name = style.font.name;
					if(style.font.size != null)size = style.font.size;
				}
			}
			ctx.fillStyle = c.srgba();
			ctx.font = size + "pt " + name; 
			ctx.fillText(ro.o.text,ro.x+2,ro.y+20);
		}
	}// drawText()

	public override function drawEnd()
	{
	}// drawEnd()

	
	public override function toString() 
	{
        return "Terminal2D";
    }// toString()

}// abv.sys.js.Terminal2D
