package abv.sys.cppgui;

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
	var elms = new AMap<Int,Shape>();
	var elm:Shape;
	var shapes:AMap<Int,Shape>;
//
	public function new(id:String)
	{
		super(id);
	}// new()

	public override function init() 
	{ 
		GUI.init(CC.NAME, CC.WIDTH, CC.HEIGHT);
//trace(GUI.getLog());
		GUI.onMouseWheel_ = onMouseWheel_;
		GUI.onMouseUp_ = onMouseUp_;
		GUI.onMouseDown_ = onMouseDown_;
		GUI.onMouseMove_ = onMouseMove_;
		GUI.onClick_ = onClick_;
		GUI.onKeyUp_ = onKeyUp_;
		GUI.onKeyDown_ = onKeyDown_;
	}// init() 

	public override function update()
	{// TODO: fix  fps & events
		GUI.update();
	}// update()
	
	function print(s="")
	{
		if(s != "")Sys.println(s);
	}
	
	function onMouseMove_(x:Int,y:Int)
	{ 
		var l = getObjectsUnderPoint(x,y);
		if(l.length > 0){ 
			var t = l.first(); 
			if(ui.click){
				onMsg(t,MD.MOUSE_MOVE);
			}else if(MS.accept(t,MD.MOUSE_OVER)){
//				if(hovered != t)onMsg(hovered,MD.MOUSE_OUT);
//				hovered = t;
//				onMsg(hovered,MD.MOUSE_OVER); 
			}else if(hovered.good()){
//				onMsg(hovered,MD.MOUSE_OUT); 
//				hovered = "";
			}
		}
	}// onMouseMove_()
	
	function onMouseWheel_()ui.wheel = 0;
	function onMouseUp_(x=0,y=0)ui.click = false;
	function onMouseDown_(x=0,y=0)
	{ 
		var oid = -1;
		var a = getObjectsUnderPoint(x,y);

		for(it in a){  
			if(MS.accept(it,MD.MOUSE_DOWN)){ 
				oid = it;  
				break;
			}
		}
//
		ui.click = true; 
//		ui.start.set(e.clientX,e.clientY);  
		ui.move.copy(ui.start);
//
		if(oid > 0) onMsg(oid,MD.CLICK); 
	}// onMouseDown_
	
	function onClick_()
	{ 
		var oid = -1;//cast(e.toElement,Element).id;
		if(oid != -1)onMsg(oid,MD.CLICK); 
//LG.log(oid);
	}// onClick_
	
	function onKeyUp_(key:Int)
	{
		ui.keys[key] = false;
		MS.exec(new MD(id,"",MD.KEY_UP,[key])); 
	}// onKeyUp_()
	
	function onKeyDown_(key:Int)
	{ 
		ui.keys[key] = true;
		MS.exec(new MD(id,"",MD.KEY_DOWN,[key]));
	}// onKeyDown_()
	
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

	public override function clearScreen(root:Int)
	{ 
		GUI.clearScreen(); 
	}// clearScreen()

	public override function drawStart()
	{
		if(elms.exists(shape.id)){
			elm = elms[shape.id];
		}else{
			elms.set(shape.id,shape);
		}; 
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
		GUI.renderQuad(shape); 
	}// drawRect()

	public override function drawImage()
	{
		GUI.renderImage(shape.image.src,shape.x,shape.y,shape.image.tile,shape.scale); 
	}
	
	public override function drawText()
	{ 
		if(shape.text.font.src.good())
			GUI.renderText(shape.text.font.src,shape.text.src,shape.x, shape.y, 
			shape.text.color, shape.w.i());
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
