package abv.sys.gui;

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
import abv.sys.gui.GUI;
import abv.bus.MD;
import abv.lib.math.Rectangle;

using abv.CR;
using abv.lib.math.MT;
using abv.lib.TP;
using abv.lib.Color;

//
@:dce
class Terminal2D extends Terminal{

	var textures:Array<Int> = [];
	static var SCREEN_WIDTH = 1024;
	static var SCREEN_HEIGHT = 540;
	var mX = 0;
	var sdl:GUI;
	var reverse = false;
	var font = 0;
	var music = 0;
	var sound = 0;
	var play = false;
	var plays = false;
	var quit = false;
///
	var elms = new Map<String,DoData>();
	var elm:DoData;
	var shapes:Map<String,DoData>;
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
///
		GUI.init(SCREEN_WIDTH,SCREEN_HEIGHT);
//trace(GUI.getLog());
		GUI.onMouseWheel = onMouseWheel;
		GUI.onMouseUp = onMouseUp;
		GUI.onMouseDown = onMouseDown;
		GUI.onMouseMove = onMouseMove;
		GUI.onClick = onClick;
		GUI.onKeyUp = onKeyUp;
		GUI.onKeyDown = onKeyDown;

	}// new()

	override function update(){GUI.update();}
	
	function playm()
	{
		if(play){
			GUI.playMusic(music,0);
			play = false;
		}
		
	}//
	
	function playms()
	{
		if(plays){
			GUI.playSound(sound);
			plays = false;
		}
		
	}//
	
	function print(s="")
	{
		if(s != "")Sys.println(s);
	}
	
	function onMsg(oid:String,cmd:Int)
	{ 
		if(oid.good())MS.exec(new MD(id,oid,cmd,sign,[],"",[ui.delta]));
//LG.log(to+":"+MS.msgName(cmd));
	}// onMsg()	
	function onMouseMove(x=0,y=0)
	{ 
		var l = getObjectsUnderPoint(x,y);
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
	
	function onMouseWheel(){ui.wheel = 0;}
	function onMouseUp(){ui.click = false;}
	function onMouseDown(x=0,y=0)
	{ 
		var oid = "";
		var a = getObjectsUnderPoint(x,y);
//LG.log(a+""); 
		for(o in a){  
			if(MS.accept(o,MD.MOUSE_DOWN)){ 
				oid = o; LG.log(oid);
				break;
			}
		}
//
		ui.click = true; 
//		ui.start.set(e.clientX,e.clientY);  
		ui.move.copy(ui.start);
//
		if(oid.good()){
			onMsg(oid,MD.CLICK); 
			trace(oid);
		}
	}// onMouseDown
	
	function onClick()
	{ 
		var oid:String  = "";//cast(e.toElement,Element).id;
		if(oid.good())onMsg(oid,MD.CLICK); 
LG.log(oid);
	}// onClick
	
	function onKeyUp(key:Int)
	{
		ui.keys[key] = false;
		MS.exec(new MD(id,"",MD.KEY_UP,sign,[key]));
	}// onKeyUp()
	
	function onKeyDown(key:Int)
	{ 
		ui.keys[key] = true;
		MS.exec(new MD(id,"",MD.KEY_DOWN,sign,[key]));
	}// onKeyDown()
	
	public function init()
	{ 
	}// init()
	
	public override function drawClear()
	{ 
		var w = 1024, h = 600;
		GUI.clearScreen(); 
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
			elms.set(ro.o.id,ro);
		}; 
/*
 		if(ro.o.visible){
			if(elm.style.visibility != "visible"){
				elm.style.visibility = "visible"; 
				if(ro.style.name.starts(".")){
					var name = ro.style.name.replace(".","");
					var ix = name.indexOf("#");
					if(ix != -1)name = name.substr(0,ix);
				}
			} 
		}else{
			elm.style.visibility = "hidden"; 
		}
*/
 	}// drawStart()

	public override function drawRect()
	{ 
		var r = .0;
		var c = .0;
		var bColor = .0;
			if(ro.style == null){
				c = ro.o.color;
			}else{
				if(ro.style.background.color.good())c = ro.style.background.color;
				if(ro.style.border != null){
					if(ro.style.border.radius.good())r = ro.style.border.radius;
					if(ro.style.border.color.good())bColor = ro.style.border.color;
				}
			}

			drawRoundRect(ro.x, ro.y, ro.o.width, ro.o.height, c, r,bColor );
	}// drawRect()

	function drawRoundRect(x:Float,y:Float, width: Float,height:Float, color:Float,radius:Float , borderColor:Float)
	{ 
		var x = int(x), y = int(y);
		var w = int(width), h = int(height);
		var r = GUI.renderQuad(x,y,w,h,color,1, borderColor); 
		if(r == 0)trace(GUI.getLog());
	}// drawRoundRect()
	
	public override function drawText()
	{ //trace(ro);
		var color = .0;

		if(ro.style == null)color = ro.o.color;
		else if(ro.style.color.good())color = ro.style.color;
#if neko 
		var wrap = 0;
#else
		var wrap = Std.int(ro.o.width);
#end
		GUI.renderText(1,ro.o.text,ro.x, ro.y, color, wrap);
	}// drawText()

	public override function renderScreen()
	{
		GUI.renderScreen();
	}// renderScreen()

	function int(f:Float)return Std.int(f);
	
	public override function toString() 
	{
        return "Terminal2D";
    }// toString()

}// abv.sys.gui.Terminal2D
