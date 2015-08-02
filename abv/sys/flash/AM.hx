package abv.sys.flash;

import abv.lib.LG;
import abv.bus.*;
import abv.ui.*; 
import abv.lib.anim.*;
import abv.lib.comp.*;
import abv.lib.box.View;
import abv.lib.math.Point;
import abv.lib.style.Style;
import abv.*;
import abv.lib.*;
import abv.io.Terminal2D;
import abv.io.*;
import abv.cpu.Timer;

import flash.display.*;
import flash.events.*;
import flash.geom.Matrix;
import flash.Lib;
import flash.system.Capabilities;

using abv.lib.CR;
using abv.lib.TP;

class AM extends Sprite implements IComm {

	public static var verbose 	= CR.DEBUG;
	public static var exitTime 	= .0;
	public static var silent 	= false;
	public static var logFile	= "";
	public static var colors 	= true;
// unique id
	public var id(get, never):String;
	var _id:String = "AM";
	function get_id() { return _id; };
//
	public var sign(null,null):Int;
	public var msg(default,null):MsgProp;
		
	var cfg:Dynamic = null;
		
//
	var last:Float;

	var sp:Sprite;

	var term:Terminal2D;
	
	var gui:Gui;
	
	public function new(configFile="")
	{
		super();
		addEventListener (Event.ADDED_TO_STAGE, addedToStage);

		if(configFile.good()){
			var s = FS.getText(configFile); 
			if(s.good()){
				cfg = s.json(); 
				if(cfg != null){
					if(cfg.appName != null)trace(cfg.appName);
				}
			}
		}
		msg = {accept:MD.NONE,action:new Map()};
		sign = MS.subscribe(this);
// customMessage register
		MS.cmCode("cmView");
		MS.cmCode("cmLang");
		Lib.current.addChild (this);
 	}// new()

	function addedToStage(e:Event) 
	{
		stage.align = StageAlign.TOP_LEFT;
		stage.scaleMode = StageScaleMode.NO_SCALE;
// init
		last = Timer.stamp();
		

		term = new Terminal2D(); 
		addChild(term.monitor);
		term.init();
		
		Screen.addTerminal(term);
		//LG.screen = screen;
		init();
// set listeners
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
		stage.addEventListener(Event.RESIZE, onResize);
	}// addedToStage()
	

	public function update()
	{   
		last += Timer.stamp() - last;
	}// update()

	function onEnterFrame(e:Event)
	{
		update();
	}// onEnterFrame()

	function dispatch(md:MD)
	{
		switch(md.msg) {
			case MD.EXIT: exit();
			case MD.MSG: 
				var cm = md.f[0];
				if(cm ==  MS.cmCode("cmLang")){}
		}
	}
	
	public inline function exec(md:MD)
	{ 
		if(!MS.isSender(md))return;
		var m = md.msg & msg.accept; 
		
		dispatch(md); 
		if(msg.action.exists(m) &&  (msg.action[m] != null))
			MS.exec(msg.action[m].clone());
	}// exec()
	

	function resize(w:Int,h:Int)
	{
		// override me
	}// resize()
	
	function onResize(e:Event=null)
	{ 
//		screenW = Math.ceil(Lib.current.stage.stageWidth / dpi);
//		screenH = Math.ceil(Lib.current.stage.stageHeight / dpi);
		var w = stage.stageWidth;
		var h = stage.stageHeight; 
		resize(w,h);
		setBackground(w,h);

		Screen.resize(w,h);

	}// onResize()

	public static inline function getText(path:String)
	{
		return FS.getText(path);
	}// getText()
	
	function init() 
	{
		var w:Float = cfg.appWidth; 
		var h:Float = cfg.appHeight; 

		gui = new Gui(w,h); 
		Screen.addRoot(gui);
		
		onResize();		

	}// init()
	
	function setBackground(w,h)
	{ 
		var m = new Matrix();
		m.createGradientBox(w, h, Math.PI/2,0,0);
		graphics.beginGradientFill(GradientType.LINEAR,[0xAAAAAA, 0xEEEEEE],[1, 1],[0x00, 0xCC],m);
		graphics.drawRect(0, 0, w, h);
	}// setBackground()

	function exit()
	{
		flash.system.System.exit(0);
	}// exit()
/**
 * AbstractMachine properties
 **/
	public static function info()
	{
		var width = Capabilities.screenResolutionX;
		var height = Capabilities.screenResolutionY;
		var dpi = Capabilities.screenDPI;
		var lang = Capabilities.language.substr(0, 2);
		var os = "";
		var home = "";
		var run = "flash";

		os = Capabilities.os;
		if(os.starts("Linux"))os = "Linux";
		else if(os.starts("Windows"))os = "Windows";
		else if(os.starts("OSX"))os = "OSX";

 		var r = {width:width,height:height,dpi:dpi,lang:lang,os:os,home:home,run:run};
		return r;
	}// info()

}// abv.sys.flash.AM

