package abv;
/**
 * AbstractMachine entry class App
 * haxelib run dox --title Title -o docs -i cpp.xml
 **/
import abv.math.*;
import abv.ds.*;
import abv.cpu.Timer;
import abv.style.*;
import abv.io.*;
import abv.Enums;
#if gui
import abv.ui.Gui;
#end 
using abv.sys.ST;
using abv.ds.TP;

#if flash
	typedef SM = abv.sys.flash.SM;
#elseif android
	typedef SM = abv.sys.android.SM;
#elseif js
	typedef SM = abv.io.CM;
#elseif (cpp || neko || java)
	typedef SM = abv.io.CM;
#end

class AM extends SM {

	public static var me(default,null):AM = null;
	
	public static var delayExit = .0;
	public static var logFile	= "";
	public static var sound 	= false; 
	public static var WIDTH		= .0;
	public static var HEIGHT	= .0;
	public static var ORIENTATION(get,never):Bool;
	static var _ORIENTATION = false;
	static function get_ORIENTATION(){ return WIDTH >= HEIGHT ? true : false;} 
#if !(flash || js)
	var args = Sys.args();
#end 	

	public inline function new(id:String)
	{
#if android
		super(id);
#else
		if(me == null) me = this;
		else throw ST.getText(5);
		super(id); 
#end 
	}// new()
	
	override function setSize()
	{
		super.setSize();
		WIDTH = width_;
		HEIGHT = height_;
	}// setSize()

// AbstractMachine properties
 	public static function info()
	{

		var lang = "",os = ST.OS,home = "",run = "cpp";
// TODO: cpp get width...
		var width = .0, height = .0, dpi = .0;
#if cpp		
		try lang = Sys.getEnv("LANG") catch(m:Dynamic){} 
		try home = Sys.getEnv("HOME") catch(m:Dynamic){}
	#if neko 
			run = "neko";
	#elseif windows
			try home = Sys.getEnv("USERPROFILE") catch(m:Dynamic){}  
	#end
#elseif flash 
		width = flash.system.Capabilities.screenResolutionX;
		height = flash.system.Capabilities.screenResolutionY;
		dpi = flash.system.Capabilities.screenDPI;
		lang = flash.system.Capabilities.language.substr(0, 2);
		run = "flash";
#elseif (js && gui)
		width = js.Browser.window.innerWidth;
		height = js.Browser.window.innerHeight;
		dpi = js.Browser.window.devicePixelRatio;
		lang = js.Browser.navigator.language.substr(0, 2); 
		run = "js";
#end

		if(lang.good())lang = lang.substr(0,2);

 		var r = {width:width,height:height,dpi:dpi,lang:lang,os:os,home:home,run:run};
		return r;
	}// info()
///	
}// abv.AM
