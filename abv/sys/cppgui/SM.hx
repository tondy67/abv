package abv.sys.cppgui;

import abv.bus.*;
import abv.ui.Gui; 
import abv.lib.anim.*;
import abv.lib.comp.*;
import abv.lib.math.Point;
import abv.lib.style.Style;
import abv.*;
import abv.lib.*;
import abv.io.*;
import abv.cpu.Timer;
import abv.ST;
import abv.ds.AMap;

using abv.lib.CC;
using abv.ds.TP;

class SM extends Object{

	var width_:Float 	= CC.WIDTH;
	var height_:Float 	= CC.HEIGHT;
		
	var last:Float;
	var term:Terminal3D;
	var gui:Gui;
	var fps = CC.UPS;
	
	public function new(id:String)
	{
		super(id);
		haxe.Log.trace = ST.trace;

		msg = {accept:MD.EXIT,action:new AMap()};
// customMessage register
		MS.cmCode("cmSound");

		last = Timer.stamp();

		onCreate();

		while( true ){
//			term.update();
			update();
			Sys.sleep(1/fps);
		}		
	}// new()

	override function update()
	{  //trace("step");
		last += Timer.stamp() - last;
	}// step()

	inline function onCreate() 
	{ 
		term = new Terminal3D(); 
		Screen.addTerminal(term);
		//LG.screen = Screen;
		create(); 
		onResize();		
	}// onCreate() 
	
	function create() 
	{
		var w:Float = CC.WIDTH; 
		var h:Float = CC.HEIGHT; 

		gui = new Gui(w,h); 
		gui.context = CTX_1D;
		Screen.addRoot(gui);
	}// create() 
	

	inline function onResize() 
	{ 
		setSize();
		resize(); 
		Screen.resize(); 
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
	

}// abv.sys.cppgui.SM
