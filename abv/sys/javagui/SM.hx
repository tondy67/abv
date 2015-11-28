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
		
	var last = .0;
	var term:Terminal3D;
	var gui:Gui;
	var fps = CC.UPS;
	
	public function new(id:String)
	{
		super(id);
		haxe.Log.trace = ST.trace;

		msg = {accept:MD.NONE,action:new AMap()};
// customMessage register
		MS.cmCode("cmSound");


		onCreate();
          
//		trace("main loop");
		var tm = new Timer(1/fps);
		tm.run = runme;

 	}// new()
	
	function runme(){ update(); }
	public override function update()
	{   
//		last += Timer.stamp() - last;
	}// update()

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

		gui = new Gui(width_,height_); 
		Screen.addRoot(gui);
		
		create();
		onResize();		

	}// onCreate()
	function create() { };

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
	
}// abv.sys.javagui.SM

