package abv.sys.flash;

import abv.interfaces.IComm;
import abv.bus.*;
import abv.ui.*; 
import abv.lib.anim.*;
import abv.lib.comp.*;
import abv.lib.math.Point;
import abv.lib.style.Style;
import abv.*;
import abv.lib.*;
import abv.io.Terminal3D;
import abv.io.*;
import abv.cpu.Timer;
import abv.ui.Gui;
import abv.ds.AMap;
import abv.lib.Enums;

import flash.display.*;
import flash.events.*;
import flash.geom.Matrix;
import flash.Lib;

using abv.lib.CC;
using abv.ds.TP;

class SM extends Sprite implements IComm {

	var width_:Float 	= CC.WIDTH;
	var height_:Float 	= CC.HEIGHT;
// unique id
	public var id(get, never):Int;
	var _id = -1;
	function get_id() return _id;
//
	public var sign(null,null):Int;
	public var msg(default,null):MS.MsgProp;
		
	var last:Float;
	var sp:Sprite;
	var term:Terminal3D;
	var gui:Gui;
	
	public function new(id:String)
	{
		super();
		addEventListener (Event.ADDED_TO_STAGE, addedToStage);

		_id = MS.subscribe(this,id);
		msg = {accept:MD.NONE,action:new AMap()};
// customMessage register
		MS.cmCode("cmSound");
		
		Lib.current.addChild (this);
 	}// new()

	function addedToStage(e:Event) 
	{
		stage.align = StageAlign.TOP_LEFT;
		stage.scaleMode = StageScaleMode.NO_SCALE;

		addEventListener(Event.ENTER_FRAME, onEnterFrame);
		stage.addEventListener(Event.RESIZE, _onResize);

		onCreate();
	}// addedToStage()
	
	inline function update_()
	{   
		Timer.update();
		update();
	}// update_()
	
	public function update()
	{   
		last += Timer.stamp() - last;
	}// update()

	function onEnterFrame(e:Event){	update_(); }

	function dispatch(md:MD)
	{
		switch(md.msg) {
			case MD.MSG: 
				var cm = md.f[0];
				if(cm ==  MS.cmCode("cmSound")){
					AM.sound = md.f[1] == 1?false:true;
				}
		}
	}
	
	public inline function exec(md:MD)
	{ 
		if(!MS.isSender(md))return;
		var m = md.msg & msg.accept; 
		
		dispatch(md); 
		if(msg.action.exists(m) &&  (msg.action.get(m) != null))
			MS.exec(msg.action.get(m).clone());
	}// exec()
	
	function setBackground()
	{ 
		var m = new Matrix();
		m.createGradientBox(width_, height_, Math.PI/2,0,0);
		graphics.beginGradientFill(GradientType.LINEAR,[0xAAAAAA, 0xEEEEEE],[1, 1],[0x00, 0xCC],m);
		graphics.drawRect(0, 0, width_, height_);
	}// setBackground()

	inline function onCreate() 
	{ 
		last = Timer.stamp();

		term = new Terminal3D(); 
		addChild(term.monitor);
		Screen.addTerminal(term); 
		term.initListeners(); 
		
		setSize();
		create(); 
		onResize();		
	}// onCreate() 
	
	function create() 
	{
		//LG.screen = screen;
		gui = new Gui(width_,height_); 
		gui.context = CTX_1D;
		Screen.addRoot(gui);
	}// create()

	inline function _onResize(e:Event){ onResize(); }

	inline function onResize()
	{ 
//		screenW = Math.ceil(Lib.current.stage.stageWidth / dpi);
//		screenH = Math.ceil(Lib.current.stage.stageHeight / dpi);
		setSize();
		resize();
		setBackground();

		Screen.resize();
	}// onResize()

	function resize() { };

	inline function onStart() { start(); };
	function start() { };

	inline function onRestart() { restart(); };
	function restart() { };

	inline function onResume() { resume(); };
	function resume() { };

	inline function onPause() { pause(); };
	function pause() { };

	inline function onStop() { stop(); };
	function stop() { };

	inline function onDestroy() { destroy(); };
	function destroy() { };

	function setSize()
	{
		width_ = stage.stageWidth; 
		height_ = stage.stageHeight;  
	}// setSize()
	
}// abv.sys.flash.AM

