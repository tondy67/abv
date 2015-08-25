package abv.sys.gui;

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
import abv.sys.ST;

using abv.lib.CC;
using abv.lib.TP;

class AM extends Object{

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
		haxe.Log.trace = ST.trace;
		super(id);
		msg = {accept:MD.EXIT,action:new Map()};
// customMessage register
		MS.cmCode("cmSound");

		last = Timer.stamp();

		term = new Terminal2D(); 
		
		Screen.addTerminal(term);
		//LG.screen = Screen;

		init();

		while( true ){
			term.update();
			update();
			Sys.sleep(1/fps);
		}		
	}// new()

	override function update()
	{  //trace("step");
		last += Timer.stamp() - last;
		term.update();
	}// update()

	function resize(w:Int,h:Int){ };
	

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

///
	public static inline function getText(path:String)return FS.getText(path);

	public static inline function playSound(path:String)if(sound) AU.playSound(path);
	public static inline function playMusic(path:String)if(sound) AU.playMusic(path);

}// abv.sys.gui.AM
