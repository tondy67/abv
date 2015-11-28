package abv.sys.engine;

import abv.interfaces.IComm;
import abv.bus.*;
import abv.ui.*; 
import abv.lib.anim.*;
import abv.lib.comp.*;
import abv.lib.math.Point;
import abv.lib.style.Style;
import abv.*;
import abv.lib.*;
import abv.io.Terminal3D;
import abv.io.*;
import abv.ui.Gui;
import abv.cpu.Timer;
import abv.ds.AMap;

using abv.lib.CC;
using abv.ds.TP;

class SM extends Object {

	var width_:Float 	= CC.WIDTH;
	var height_:Float 	= CC.HEIGHT;
	public static var trace = haxe.Log.trace; 
		
	var last = .0;
	public var term:Terminal3D;
	var gui:Gui;
	var fps = CC.UPS;

	public function new(id:String)
	{
		super(id);
#if !flash 	haxe.Log.trace = ST.trace; #end

		msg = {accept:MD.EXIT,action:new AMap()};
// customMessage register
		MS.cmCode("cmSound");
		
 		onCreate();
	}// new()

	public function onUpdate()
	{
		update();
	}// onUpdate()
	
	override function dispatch(md:MD)
	{
		switch(md.msg) {
			case MD.MSG: 
				var cm = md.f[0];
				if(cm ==  MS.cmCode("cmSound")){
					AM.sound = md.f[1] == 1?false:true;
				}
		}
	}// dispatch()
	
	inline function onCreate() 
	{
		setSize();

		term = new Terminal3D(); 
		Screen.addTerminal(term);
 		Screen.addTerminal(term);

		gui = new Gui(width_,height_); 
		Screen.addRoot(gui);
		create();
		onResize();		

	}// onCreate()
	function create() { };

	public inline function onResize()
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

	public function setSize()
	{
		width_ = AM.WIDTH;
		height_ = AM.HEIGHT; 
	}// setSize()
	
}// abv.sys.engine.SM

