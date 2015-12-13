package abv.lib;
/**
 * CommonMachine 
 **/

import abv.bus.*;
import abv.*;
import abv.lib.*;
import abv.lib.comp.Object;
import abv.io.*;
import abv.cpu.Timer;
import abv.ST;
import abv.ds.AMap;
#if gui
import abv.ui.Gui; 
 #if (cpp||neko)
import abv.sys.cppgui.Terminal3D;
 #elseif js 
import abv.sys.jsgui.Terminal3D;
 #end 	
 
#end

using abv.lib.CC;
using abv.ds.TP;

class CM extends Object{

	var width_:Float 	= CC.WIDTH;
	var height_:Float 	= CC.HEIGHT;
		
	var last = Timer.stamp();
	var fps = CC.UPS;
	var quit = false;
	public static var trace = haxe.Log.trace; 
#if gui
	public var term:Terminal3D;
	var gui:Gui;
#end
	
	public inline function new(id:String)
	{
		super(id);
#if !flash 	haxe.Log.trace = ST.trace; #end

		msg = {accept:MD.EXIT,action:new AMap()};
// customMessage register
//		MS.cmCode("cmSound");

		onCreate();
		onStart();

		if(fps > 0){
#if flash
#elseif js
			untyped setInterval(update_,1000/fps);
#elseif java
			var tm = new abv.sys.java.JavaTimer(1000/fps);
			tm.run = update_;
#else
trace(fps);
			while( !quit ){
				update_();
				Sys.sleep(1/fps);
			}	
#end	
		}
	}// new()

	function update_()
	{
		Timer.update();
		update();
	}// update_()

	override function update()
	{  //trace("step");
		last += Timer.stamp() - last;
	}// step()

	inline function onCreate() 
	{ 
#if gui
		term = new Terminal3D(); 
		Screen.addTerminal(term);
#end
		create(); 
	}// onCreate() 
	
	function create() 
	{
	}// create() 
	

	inline function onResize() 
	{ 
		setSize();
		resize(); 
#if gui
		Screen.resize(); 
#end
	}// onResize()
	
	function resize() { };

	inline function onStart() { start(); };
	function start() { };

	inline function onRestart() { restart(); };
	function restart() { };

	inline function onResume() { resume(); };
	function resume() { };

	inline function onPause() { pause(); };
	function pause() { };

	inline function onStop() { stop(); };
	function stop() { };

	inline function onDestroy() { dispose(); };

	function setSize()
	{
		width_ = CC.WIDTH;
		height_ = CC.HEIGHT; 
	}// setSize()
	

}// abv.lib.CM
