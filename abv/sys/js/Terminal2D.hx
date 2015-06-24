package abv.sys.js;

import abv.bus.*;
import abv.*;
import abv.lib.style.Style;
import abv.lib.Color;
import abv.ds.FS;
import abv.io.*;
import abv.lib.Timer;
import abv.AM;
import abv.lib.Screen;
import abv.lib.ui.box.*;
import abv.lib.ui.widget.*;

import js.Lib;
import js.html.*;
import js.Browser;
import js.html.HtmlElement;
import js.html.CanvasElement;
import js.html.DivElement; 
import js.html.Document;

using abv.CR;
using abv.lib.math.MT;
using abv.lib.TP;
using abv.lib.Color;

//
@:dce
class Terminal2D extends Terminal{

	var elms = new Map<String,DOMElement>();
	var elm:DOMElement;
	var shapes:Map<String,DoData>;
	var doc:Document;
	var body: DOMElement;   
    var ctx: CanvasRenderingContext2D;
	var xx:Float = 0; 
	var yy:Float = 0;
	var delta = 2;
//
	var ui:Input;
	var speed = 4;
	var hovered = "";
	
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
		if(oid.good())MS.exec(new MD(id,oid,cmd,sign,[],"",[ui.delta]));
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
			}else if(MS.accept(t,MD.MOUSE_OVER)){
				if(hovered != t)onMsg(hovered,MD.MOUSE_OUT);
				hovered = t;
				onMsg(hovered,MD.MOUSE_OVER);
			}else if(hovered.good()){
				onMsg(hovered,MD.MOUSE_OUT);
				hovered = "";
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
		MS.exec(new MD(id,"",MD.KEY_UP,sign,[e.keyCode]));
	}// onKeyUp()
	
	function onKeyDown(e:KeyboardEvent)
	{
		e.preventDefault();
		ui.keys[e.keyCode] = true;
		MS.exec(new MD(id,"",MD.KEY_DOWN,sign,[e.keyCode]));
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
			}else if(ro.style.name == ".dialog"){
				elm = doc.createElement("Div");
				elm.className = "dialog";  
			}else if(ro.style.name == ".text"){
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
				if(ro.style.name.starts(".")){
					var name = ro.style.name.replace(".","");
					var ix = name.indexOf("#");
					if(ix != -1)name = name.substr(0,ix);
					elm.className = name;
				}
			}
		}else{
			elm.style.visibility = "hidden"; 
		}
 	}// drawStart()

	public override function drawRect()
	{ 
		var r = .0;
		var c = .0;
		if(ro.ctx == Ctx2D){
			if(ro.style == null){
				c = ro.o.color;
			}else{
				if(ro.style.background.color.good())c = ro.style.background.color;
				if(ro.style.border != null){
					if(ro.style.border.radius.good())r = ro.style.border.radius;
					if(ro.style.border.color.good()){
						ctx.strokeStyle = ro.style.border.color.srgba();
						ctx.lineWidth = 1;
					}
				}
			}
			ctx.fillStyle = c.srgba(); 
			drawRoundRect(ro.x, ro.y, ro.o.width, ro.o.height, r);
		}
	}// drawRect()

	function drawRoundRect(x:Float,y:Float, width: Float,height:Float,radius:Float=4 )
	{
	  ctx.beginPath();
	  ctx.moveTo(x + radius, y);
	  ctx.lineTo(x + width - radius, y);
	  ctx.quadraticCurveTo(x + width, y, x + width, y + radius);
	  ctx.lineTo(x + width, y + height - radius);
	  ctx.quadraticCurveTo(x + width, y + height, x + width - radius, y + height);
	  ctx.lineTo(x + radius, y + height);
	  ctx.quadraticCurveTo(x, y + height, x, y + height - radius);
	  ctx.lineTo(x, y + radius);
	  ctx.quadraticCurveTo(x, y, x + radius, y);
	  ctx.closePath();
	  ctx.stroke();
	  ctx.fill();
	}// drawRoundRect()
	
	public override function drawText()
	{ //trace(ro);
		if(ro.ctx == Ctx1D){
			elm.innerHTML = ro.o.text;
		}else{		
			var c = .0;
			if(ro.style == null)c = ro.o.color;
			else if(ro.style.color.good())c = ro.style.color;
			ctx.fillStyle = c.srgba();
			ctx.font = "12pt DefaultFont"; // status-bar
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
