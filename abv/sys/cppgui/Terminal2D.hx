package abv.sys.cppgui;

import abv.bus.*;
import abv.*;
import abv.lib.style.*;
import abv.io.*;
import abv.cpu.Timer;
import abv.io.Screen;
import abv.ui.box.*;
import abv.ui.widget.*;
import abv.lib.math.Rectangle;
import abv.lib.comp.Component;
import abv.ui.Shape;
import abv.ds.AMap;

using abv.lib.CC;
using abv.lib.math.MT;
using abv.ds.TP;
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
	var elms = new AMap<String,Shape>();
	var elm:Shape;
	var shapes:AMap<String,Shape>;
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
	{// TODO: fix  fps & events
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
	
	function onMouseWheel()ui.wheel = 0;
	function onMouseUp(x=0,y=0)ui.click = false;
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
	
	public override function renderList(list:List<Component>)
	{
		var l = new List<Component>();
		var root = list.first().root.id;
		
		for(k in roots.keys()){
			if(k == root){
				for(el in list) l.add(el);
			}else{
				for(el in roots[k]) l.add(el);
			}
		}
		for(ro in l)drawObject(ro);
	}// renderList

	public override function clearScreen(root:String)
	{ 
		GUI.clearScreen(); 
	}// clearScreen()

	public override function drawStart(shape:Shape)
	{
		if(elms.exists(shape.id)){
			elm = elms[shape.id];
		}else{
			elms.set(shape.id,shape);
		}; 
	}// drawStart()

	public override function drawShape(shape:Shape)
	{ 
		GUI.renderQuad(shape); 
	}// drawShape()

	public override function drawImage(shape:Shape)
	{
		GUI.renderImage(shape.image.src,shape.x,shape.y,shape.image.tile,shape.scale); 
	}
	
	public override function drawText(shape:Shape)
	{ 
		if(shape.text.font.src.good())
			GUI.renderText(shape.text.font.src,shape.text.src,shape.x, shape.y, 
			shape.text.color, shape.w.int());
	}// drawText()

	public override function renderScreen()
	{
		GUI.renderScreen();
	}// renderScreen()

	
	public override function toString() 
	{
        return "Terminal2D";
    }// toString()

}// abv.sys.cppgui.Terminal2D
