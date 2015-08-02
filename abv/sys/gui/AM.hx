package abv.sys.gui;

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
import abv.cpu.Timer;
import abv.sys.ST;

using abv.lib.CR;
using abv.lib.TP;

class AM extends Object{

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
					if(cfg.appName != null)trace(cfg.appName);
				}
			}
		}
		msg = {accept:MD.EXIT,action:new Map()};
// customMessage register
		MS.cmCode("cmView");
		MS.cmCode("cmLang");

		last = Timer.stamp();

		term = new Terminal2D(); 
		
		Screen.addTerminal(term);
		//LG.screen = Screen;

		init();

		while( true ){
			update();
			Sys.sleep(1/fps);
		}		
	}// new()

	override function update()
	{  //trace("step");
		last += Timer.stamp() - last;
	}// update()

	function resize(w:Int,h:Int){ };
	

	function onResize()
	{ 
		var w = cfg.appWidth;
		var h = cfg.appHeight;
		resize(w,h);
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

	}
	
	function exit()
	{
		Sys.exit(0);
	}// exit()

/**
 * AbstractMachine properties
 **/
	public static function info()
	{
		var lang = "",os = "",home = "",run = "cpp";
// TODO: get width...
		var width = 0, height = 0, dpi = 0;
		
		try lang = Sys.getEnv("LANG") catch(m:Dynamic){} 
		try os = Sys.systemName() catch(m:Dynamic){} 
		try home = Sys.getEnv("HOME") catch(m:Dynamic){}  

#if neko 
		run = "neko";
#elseif windows
		try home = Sys.getEnv("USERPROFILE") catch(m:Dynamic){}  
#end
		if(lang.good())lang = lang.substr(0,2);
		if(os.starts("Linux"))os = "Linux";
		else if(os.starts("Windows"))os = "Windows";
		else if(os.starts("OSX"))os = "OSX";

 		var r = {width:width,height:height,dpi:dpi,lang:lang,os:os,home:home,run:run};
		return r;
	}// info()

}// abv.sys.gui.AM
