package abv.sys.flash;

import abv.LG;
import abv.bus.*;
import abv.lib.ui.*; 
import abv.lib.anim.*;
import abv.lib.comp.*;
import abv.lib.box.View;
import abv.lib.math.Point;
import abv.lib.style.Style;
import abv.*;
import abv.lib.*;
import abv.io.Terminal2D;
import abv.io.*;
import abv.lib.Timer;

import flash.display.*;
import flash.events.*;
import flash.geom.Matrix;
import flash.Lib;
import flash.system.Capabilities;

using abv.CR;
using StringTools;

class AM extends Sprite implements IComm {

	public static var verbose:LogLevel 	= DEBUG;
	public static var exitTime 			= .0;
	public static var silent 			= false;
	public static var logFile			= "";
// unique id
	public var id(get, never):String;
	var _id:String = "App";
	function get_id() { return _id; };
//
	public var sign(null,null):Int;
	public var msg(default,null):MsgProp;
		
	var cfg:Dynamic = null;
		
//
	var last:Float;

	var sp:Sprite;

	var term:Terminal2D;
	var screen:Screen;
	var gui:GUI;
	
//	var game:Game;
	
	public function new()
	{
		super();
		addEventListener (Event.ADDED_TO_STAGE, addedToStage);
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
		screen = Screen.me;
		screen.addTerminal(term);
		LG.screen = screen;
		init();
// set listeners
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
		stage.addEventListener(Event.RESIZE, onResize);
	}// addedToStage()
	

	function update()
	{   
		last += Timer.stamp() - last;
	}// update()

	function onEnterFrame(e:Event)
	{
		update();
	}// onEnterFrame()

	public function exec(mdt:MD)
	{ 	//	trace(id+": "+mdt);
		if(!MS.isMsg(mdt,sign))return;
//
		switch(mdt.msg) {
			case MD.EXIT: exit();
			case MD.MSG: 
				var cm = mdt.f[0];
				if(cm ==  MS.cmCode("cmLang")){}
			
		}
	}// exec()


	function onResize(e:Event=null)
	{ 
//		screenW = Math.ceil(Lib.current.stage.stageWidth / dpi);
//		screenH = Math.ceil(Lib.current.stage.stageHeight / dpi);
		var w = stage.stageWidth;
		var h = stage.stageHeight; 
		setBackground(w,h);

		screen.refresh(w,h);

	}// onResize()

	function init() 
	{
		var w = 1024;
		var h = 540;

		gui = new GUI(w,h); 
		screen.addRoot(gui);
		
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
		if(os.startsWith("Linux"))os = "Linux";
		else if(os.startsWith("Windows"))os = "Windows";
		else if(os.startsWith("OSX"))os = "OSX";

 		var r = {width:width,height:height,dpi:dpi,lang:lang,os:os,home:home,run:run};
		return r;
	}// info()

}// abv.sys.flash.AM

