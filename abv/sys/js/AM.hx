package abv.sys.js;

import abv.lib.LG;
import abv.bus.*;
import abv.ui.*; 
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
import haxe.Timer;
import abv.sys.ST;

import js.Lib;
import js.html.Event;
import js.html.Screen in JsScreen;
import js.Browser;
import js.html.Element;
import js.html.CanvasElement;

using abv.lib.TP;
using abv.lib.CR;

class AM extends Object {

	public static var verbose 	= CR.DEBUG;
	public static var exitTime 	= .0;
	public static var silent 	= false;
	public static var logFile	= "";
	public static var colors 	= true;
	var cfg:Dynamic = null;
//
	var last:Float;

	var term:Terminal2D;
	
	var gui:Gui;
	
	var fps = 32;
	public static var trace = haxe.Log.trace; 
	
	public function new(configFile="")
	{
		haxe.Log.trace = ST.trace;
		super(id);
		if(configFile.good()){
			var s = FS.getText(configFile); 
			if(s.good()){
				cfg = s.json(); 
				if(cfg != null){
					if(cfg.app != null)trace(cfg.app);
				}
			}
		}
		msg = {accept:MD.NONE,action:new Map()};
// customMessage register
		MS.cmCode("cmView");
		MS.cmCode("cmLang");

		last = Timer.stamp();

		term = new Terminal2D(); 
//		addChild(term.monitor);
		term.init();
		
		Screen.addTerminal(term);
		//LG.screen = screen;

		init();
//		update();
		var tm = new Timer( fps );
		tm.run = update;
	}// new()

	override function update()
	{  //trace("step");
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
	}// exec()

	function resize(w:Int,h:Int)
	{
		// override me
	}// resize()
	

	function onResize()
	{ 
		var w:Int = cfg.appWidth; 
		var h:Int = cfg.appHeight; 
		resize(w,h);
		Screen.resize(w,h); 

	}// onResize()

	public static inline function getText(path:String)
	{
		return FS.getText(path);
	}// getText()
	
	function init() 
	{
		var w:Int = cfg.appWidth; 
		var h:Int = cfg.appHeight; 

		gui = new Gui(w,h); 
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
		var os = Browser.navigator.platform;  
		if(os.starts("Linux"))os = "Linux";
		else if(os.starts("Windows"))os = "Windows";
		else if(os.starts("OSX"))os = "OSX";
		var home = "";
		var run = "js";

 		var r = {width:width,height:height,dpi:dpi,lang:lang,os:os,home:home,run:run};
		return r;
	}// info()

}// abv.sys.js.AM
