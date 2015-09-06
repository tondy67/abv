package abv.sys.javagui;

import abv.interfaces.IComm;
import abv.bus.*;
import abv.ui.*; 
import abv.lib.anim.*;
import abv.lib.comp.*;
import abv.lib.math.Point;
import abv.lib.style.Style;
import abv.*;
import abv.lib.*;
import abv.io.Terminal2D;
import abv.io.*;
import abv.ui.Gui;
import abv.cpu.Timer;

using abv.lib.CC;
using abv.ds.TP;

class AM extends Object {

	public static var verbose 	= DEBUG;
	public static var exitTime 	= .0;
	public static var silent 	= false;
	public static var logFile	= "";
	public static var colors 	= true;
	public static var sound 	= false;
		
	var last = .0;
	var term:Terminal2D;
	var gui:Gui;
	var fps = CC.UPS;
	public static var trace = haxe.Log.trace; 
	
	public function new(id:String)
	{
		super(id);
		haxe.Log.trace = ST.trace;

		msg = {accept:MD.NONE,action:new Map()};
// customMessage register
		MS.cmCode("cmSound");

		term = new Terminal2D(); 
		
		Screen.addTerminal(term);

		init();
          
//		trace("main loop");
		var tm = new Timer(1/fps);
		tm.run = runme;

 	}// new()

	function runme()
	{ //repaint();
//		term.update(); 
		update();
	}
	public override function update()
	{   
//		last += Timer.stamp() - last;
	}// update()

	override function dispatch(md:MD)
	{
		switch(md.msg) {
			case MD.EXIT: exit();
			case MD.MSG: 
				var cm = md.f[0];
				if(cm ==  MS.cmCode("cmSound")){
					AM.sound = md.f[1] == 1?false:true;
				}
		}
	}// dispatch()
	

//	function resize(w:Int,h:Int){ };
	
	function onResize()
	{ 
		var w = CC.WIDTH; 
		var h = CC.HEIGHT; 
//		resize(w,h); 
		Screen.resize(w,h); 
	}// onResize()

	function init() 
	{
		var w:Float = CC.WIDTH; 
		var h:Float = CC.HEIGHT; 

		gui = new Gui(w,h); 
		Screen.addRoot(gui);
		
		onResize();		

	}// init()
	

	function exit()
	{ trace("exit: "+haxe.Timer.stamp());
		Sys.exit(0);
	}// exit()

/**
 * AbstractMachine properties
 **/
	public static function info()
	{
		var width = CC.WIDTH;
		var height = CC.HEIGHT;
		var dpi = 0;
		var lang = "en";
		var os = CC.OS;
		var home = "";
		var run = "java";

 		var r = {width:width,height:height,dpi:dpi,lang:lang,os:os,home:home,run:run};
		return r;
	}// info()

///
	public static inline function getText(path:String)return FS.getText(path);

	public static inline function playSound(path:String)if(sound) AU.playSound(path);
	public static inline function playMusic(path:String)if(sound) AU.playMusic(path);

}// abv.sys.javagui.AM

