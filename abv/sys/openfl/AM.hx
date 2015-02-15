package abv.sys.openfl;

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

import openfl.display.*;
import openfl.events.*;
import openfl.geom.Matrix;
import openfl.Lib;
import openfl.system.Capabilities;

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
//	public var mbox(default,null):MBox;	
	public var sign(null,null):Int;
	public var msg(default,null):MsgProp;
		
		
//
	var last:Float;

	var sp:Sprite;

	var term:Terminal2D;
	var screen:Screen;
	var gui:GUI;
	
	public function new()
	{
		super();
		addEventListener (Event.ADDED_TO_STAGE, addedToStage);
		msg = {accept:MD.NONE,action:new Map()};
		sign = MS.subscribe(this);
// customMessage register
		MS.cmCode("cmView");
		MS.cmCode("cmLang");
/*
 * 
var levels:Array<Class<BaseLevelClass>> = [Level1, Level2, Level3]; 
var level = Type.createInstance(levels[0], []); 
 */
/*var a = [1.2,1.2]; 
//var a = ['1','2','3','4']; 
//var a = [new Sprite()];
clear(a); trace(a); */
/*var bm = new Bitmap(abv.ds.FS.getBitmapData("assets/img/0.120.png"));
addChild(bm);
var bm2 = new Bitmap(abv.ds.FS.getBitmapData("assets/img/ok.png"));
addChild(bm2); bm2.x = 105; bm2.y = 105;
*/
		flash.Lib.current.addChild (this);
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
	{  //trace("step");
		last += Timer.stamp() - last;
//		ui.update();
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
				if(cm == MS.cmCode("cmPuzzle")){}
				else if(cm ==  MS.cmCode("cmLang")){}
			
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

	}
	
	function setBackground(w,h)
	{ 
		var m = new Matrix();
		m.createGradientBox(w, h, Math.PI/2,0,0);
		graphics.beginGradientFill(GradientType.LINEAR,[0xAAAAAA, 0xEEEEEE],[1, 1],[0x00, 0xCC],m);
		graphics.drawRect(0, 0, w, h);
	}// setBackground()

	function exit()
	{
		Sys.exit(0);
	}// exit()
/**
 * Abstract Machine Capabilities as map
 **/
	public static function db()
	{
		var width = .0;
		var height = .0;
		var dpi = .0;
		var lang = "";
		var os = "";
		var home = "";
		var run = "cpp";

#if neko
		width = Capabilities.screenResolutionX;
		height = Capabilities.screenResolutionY;
		dpi = Capabilities.screenDPI;
		lang = Capabilities.language.substr(0, 2);
		os = Sys.systemName();
		home = Sys.getEnv("HOME"); 
		run = "neko";
#elseif linux
		width = Capabilities.screenResolutionX;
		height = Capabilities.screenResolutionY;
		dpi = Capabilities.screenDPI;
		lang = Capabilities.language.substr(0, 2);
		os = "Linux";
		home = Sys.getEnv("HOME"); 
#elseif windows
		width = Capabilities.screenResolutionX;
		height = Capabilities.screenResolutionY;
		dpi = Capabilities.screenDPI;
		lang = Capabilities.language.substr(0, 2);
		os = "Windows";
		home = Sys.getEnv("USERPROFILE"); 
#elseif android
		width = Capabilities.screenResolutionX;
		height = Capabilities.screenResolutionY;
		dpi = Capabilities.screenDPI;
		lang = Capabilities.language.substr(0, 2);
		os = "Android";
		home = Sys.getEnv("HOME"); 
#end
 		var r = {width:width,height:height,dpi:dpi,lang:lang,os:os,home:home,run:run};
		return r;
	}// info()

	public static function get()
	{
		var c = db();
		var s = Std.string(c);
		return s;
	}// get()

}// abv.sys.cpp.AM

