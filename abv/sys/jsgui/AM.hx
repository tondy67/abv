package abv.sys.jsgui;

import abv.bus.*;
import abv.ui.Gui; 
import abv.lib.anim.*;
import abv.lib.comp.*;
import abv.lib.math.Point;
import abv.AM;
import abv.lib.style.Style;
import abv.*;
import abv.lib.*;
import abv.io.Terminal2D;
import abv.io.*;
import abv.cpu.Timer;
import abv.ST;
import abv.ds.AMap;

import js.Lib;
import js.html.Event;
import js.html.Screen in JsScreen;
import js.Browser;
import js.html.Element;
import js.html.CanvasElement;

using abv.ds.TP;
using abv.lib.CC;

class AM extends Object {

	public static var verbose 	= DEBUG;
	public static var exitTime 	= .0;
	public static var silent 	= false;
	public static var logFile	= "";
	public static var colors 	= true;
	public static var sound 	= false;

	var last:Float;
	var term:Terminal2D;
	var gui:Gui;
	var fps = CC.UPS;
	public static var trace = haxe.Log.trace; 
	
	public function new(id:String)
	{
		super(id);
		haxe.Log.trace = ST.trace;

		msg = {accept:MD.NONE,action:new AMap()};
// customMessage register
		MS.cmCode("cmSound");

		last = Timer.stamp();

		term = new Terminal2D(); 
		
		Screen.addTerminal(term);
		//LG.screen = screen;

		init();

		var tm = new Timer( fps );
		tm.run = update;
	}// new()

	override function update()
	{  //trace("update");
		last += Timer.stamp() - last;
	}// update()

	override function dispatch(md:MD)
	{ 	//	trace(id+": "+md);
		if(!MS.isSender(md))return;
//
		switch(md.msg) {
			case MD.EXIT: exit();
			case MD.MSG: 
				var cm = md.f[0];
				if(cm ==  MS.cmCode("cmLang")){}
			
		}
	}// dispatch()

	function resize(w:Int,h:Int)
	{
		// override me
	}// resize()
	

	function onResize()
	{ 
		var w = CC.WIDTH; 
		var h = CC.HEIGHT; 
		resize(w,h);
		Screen.resize(w,h); 

	}// onResize()

	function init() 
	{
		var w:Float = CC.WIDTH; 
		var h:Float = CC.HEIGHT; 

		gui = new Gui(w,h); 
		gui.context = CC.CTX_1D;
		Screen.addRoot(gui);
		
		
		onResize();		

	}
	
	function exit()
	{
		Browser.window.close();
	}// exit()

/**
 * AbstractMachine properties
 **/
	public static function info()
	{
		var width = Browser.window.innerWidth;
		var height = Browser.window.innerHeight;
		var dpi = Browser.window.devicePixelRatio;
		var lang = Browser.navigator.language.substr(0, 2); 
		var os = CC.OS;  
		var home = "";
		var run = "js";

 		var r = {width:width,height:height,dpi:dpi,lang:lang,os:os,home:home,run:run};
		return r;
	}// info()

///
	public static inline function getText(path:String)return FS.getText(path);

	public static inline function playSound(path:String)if(sound) AU.playSound(path);
	public static inline function playMusic(path:String)if(sound) AU.playMusic(path);

}// abv.sys.jsgui.AM
