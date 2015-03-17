package abv.sys.gui;

import abv.LG;
import abv.bus.*;
import abv.lib.ui.*; 
import abv.lib.anim.*;
import abv.lib.comp.*;
import abv.lib.box.View;
import abv.lib.math.Point;
import abv.AM;
import abv.lib.style.Style;
import abv.*;
import abv.lib.*;
import abv.io.Terminal2D;
import abv.io.*;
import abv.lib.Timer;

using abv.CR;
using StringTools;

class AM implements IComm {

	public static var verbose:LogLevel 	= LOG;
	public static var exitTime 			= .0;
	public static var silent 			= false;
	public static var logFile			= "";
	var cfg:Dynamic = null;
// unique id
	public var id(get, never):String;
	var _id:String = "App";
	function get_id() { return _id; };
//
	public var sign(null,null):Int;
	public var msg(default,null):MsgProp;
//
	var last:Float;

	var term:Terminal2D;
	var screen:Screen;
	var gui:GUI;
	
	var fps = 32;
	
	public function new()
	{
		msg = {accept:MD.NONE,action:new Map()};
		sign = MS.subscribe(this);
// customMessage register
		MS.cmCode("cmView");
		MS.cmCode("cmLang");

		last = Timer.stamp();

		term = new Terminal2D(); 
//		addChild(term.monitor);
		term.init();
		screen = Screen.me;
		screen.addTerminal(term);
		LG.screen = screen;

		init();
/*		update();
		var tm = new Timer( fps );
		tm.run = update;
		while(true){
			tm.update();
			Sys.sleep(.01);
		}
*/
		while( true ){
			update();
			Sys.sleep(1/fps);
		}		
	}// new()

	function update()
	{  //trace("step");
		last += Timer.stamp() - last;
	}// update()

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


	function onResize()
	{ 
//		screenW = Math.ceil(Lib.current.stage.stageWidth / dpi);
//		screenH = Math.ceil(Lib.current.stage.stageHeight / dpi);
//		var w = stage.stageWidth;
//		var h = stage.stageHeight; 
//		setBackground(w,h);

		var w = 1024;
		var h = 580;
		screen.refresh(w,h); 

	}// onResize()

	function init() 
	{
// set listeners
//		addEventListener(Event.ENTER_FRAME, onEnterFrame);
//		stage.addEventListener(Event.RESIZE, onResize);
		var w = 1024;
		var h = 540;

		gui = new GUI(w,h); 
		screen.addRoot(gui);
		
		onResize();		

	}
	
	function setBackground(w,h)
	{ 
/*		var m = new Matrix();
		m.createGradientBox(w, h, Math.PI/2,0,0);
		graphics.beginGradientFill(GradientType.LINEAR,[0xAAAAAA, 0xEEEEEE],[1, 1],[0x00, 0xCC],m);
		graphics.drawRect(0, 0, w, h);
*/
	}// setBackground()

	function exit()
	{
		Sys.exit(0);
	}// exit()

/**
 * AbstractMachine properties
 **/
	public static function info()
	{
		var width = 0;
		var height = 0;
		var dpi = 0;
		var lang = 0;
		var os = "Linux";
		if(os.startsWith("Linux"))os = "Linux";
		else if(os.startsWith("Windows"))os = "Windows";
		else if(os.startsWith("OSX"))os = "OSX";
		var home = "";
		var run = "cpp";

 		var r = {width:width,height:height,dpi:dpi,lang:lang,os:os,home:home,run:run};
		return r;
	}// info()

}// abv.sys.gui.AM
