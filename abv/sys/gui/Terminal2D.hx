package abv.sys.gui;

import abv.bus.*;
import abv.*;
import abv.lib.style.*;
//import abv.ds.FS;
import abv.io.*;
import abv.cpu.Timer;
//import abv.AM;
import abv.io.Screen;
import abv.ui.box.*;
import abv.ui.widget.*;
import abv.lib.math.Rectangle;

using abv.lib.CC;
using abv.lib.math.MT;
using abv.lib.TP;
using abv.lib.style.Color;

//
@:dce
class Terminal2D extends Terminal{

	var textures:Array<Int> = [];
	var mX = 0;
	var sdl:GUI;
	var reverse = false;
	var play = false;
	var plays = false;
	var quit = false;
///
	var elms = new Map<String,DoData>();
	var elm:DoData;
	var shapes:Map<String,DoData>;
//
	var ui:Input;
	var hovered = "";

	
	public function new()
	{
		super("Terminal2D");
		ui = new Input(); 
///
		GUI.init(CC.NAME, CC.WIDTH, CC.HEIGHT);
//trace(GUI.getLog());
		GUI.onMouseWheel = onMouseWheel;
		GUI.onMouseUp = onMouseUp;
		GUI.onMouseDown = onMouseDown;
		GUI.onMouseMove = onMouseMove;
		GUI.onClick = onClick;
		GUI.onKeyUp = onKeyUp;
		GUI.onKeyDown = onKeyDown;

	}// new()

	public override function update()
	{
		GUI.update();
	}// update()
	
	function print(s="")
	{
		if(s != "")Sys.println(s);
	}
	
	function onMsg(oid:String,cmd:Int)
	{ 
		if(oid.good())MS.exec(new MD(sign,oid,cmd,[],"",[ui.delta]));
//LG.log(to+":"+MS.msgName(cmd));
	}// onMsg()	
	function onMouseMove(x=0,y=0)
	{ 
		var l = getObjectsUnderPoint(x,y);
		if(l.length > 0){ 
			var t = l.first(); 
			if(ui.click){
				onMsg(t,MD.MOUSE_MOVE);
			}else if(MS.accept(t,MD.MOUSE_OVER)){
//				if(hovered != t)onMsg(hovered,MD.MOUSE_OUT);
				hovered = t;
//				onMsg(hovered,MD.MOUSE_OVER); 
			}else if(hovered.good()){
//				onMsg(hovered,MD.MOUSE_OUT); 
				hovered = "";
			}
		}
	}// onMouseMove()
	
	function onMouseWheel(){ui.wheel = 0;}
	function onMouseUp(x=0,y=0){ui.click = false;}
	function onMouseDown(x=0,y=0)
	{ 
		var oid = "";
		var a = getObjectsUnderPoint(x,y);

		for(o in a){  
			if(MS.accept(o,MD.MOUSE_DOWN)){ 
				oid = o; //trace(oid);
				break;
			}
		}
//
		ui.click = true; 
//		ui.start.set(e.clientX,e.clientY);  
		ui.move.copy(ui.start);
//
		if(oid.good()){ trace(oid);
			onMsg(oid,MD.CLICK); 
		}
	}// onMouseDown
	
	function onClick()
	{ 
		var oid:String  = "";//cast(e.toElement,Element).id;
		if(oid.good())onMsg(oid,MD.CLICK); 
//LG.log(oid);
	}// onClick
	
	function onKeyUp(key:Int)
	{
		ui.keys[key] = false;
		MS.exec(new MD(sign,"",MD.KEY_UP,[key])); 
	}// onKeyUp()
	
	function onKeyDown(key:Int)
	{ 
		ui.keys[key] = true;
		MS.exec(new MD(sign,"",MD.KEY_DOWN,[key]));
	}// onKeyDown()
	
	public override function drawClear()
	{ 
		var w = 1024, h = 600;
		GUI.clearScreen(); 
	}// drawClear()

	public override function drawStart()
	{
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
			elms.set(ro.o.id,ro);
		}; 
	}// drawStart()

	public override function drawShape()
	{ 
		var radius = 0;
		var border = 0;
		var c = ro.o.color;
		var bColor = .0;
		var src = "";
		var x = ro.x.int(), y = ro.y.int(), w = ro.o.width.int(), h = ro.o.height.int();
		var scale = ro.o.scale;
		var tile:Rectangle = null;
		var style = ro.o.style;
		
		if(style != null){
			if(style.background != null){
				if(style.background.image.good()){
					src = style.background.image;
					if(style.background.position != null)
						tile = new Rectangle(-style.background.position.x,-style.background.position.y,w,h);
				}
				c = style.background.color; 
			}
			
			if(style.border != null){
				radius = style.border.radius.int();
				border = style.border.width.int();
				bColor = style.border.color;
			}
		}
//if(ro.o.id == "food_0")trace(c+":"+border);
		if((c > 0)||(border > 0))GUI.renderQuad(new Rectangle(x,y,w*scale,h*scale),c,border, bColor); 
		if(src.good()) GUI.renderImage(src,x,y,tile,scale); 
	}// drawShape()

	public override function drawText()
	{ //trace(ro);
		var color = ro.o.color;
		var wrap = ro.o.width.int(); 
		var font = "";
		var style = ro.o.style;

		if(style != null){
			if(style.color.good())color = style.color;
			if(style.font != null)font = style.font.src; 
			if(font.good())GUI.renderText(font,ro.o.text,ro.x, ro.y, color, wrap);
		}
		
	}// drawText()

	public override function renderScreen()
	{
		GUI.renderScreen();
	}// renderScreen()

	
	public override function toString() 
	{
        return "Terminal2D";
    }// toString()

}// abv.sys.gui.Terminal2D
