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
import abv.io.Terminal3D;
import abv.io.*;
import abv.cpu.Timer;
import abv.ST;
import abv.ds.AMap;
import abv.lib.Enums;

import js.Lib;
import js.html.Event;
import js.html.Screen in JsScreen;
import js.Browser;
import js.html.Element;
import js.html.CanvasElement;

using abv.ds.TP;
using abv.lib.CC;

class SM extends Object {

	var width_:Float 	= CC.WIDTH;
	var height_:Float 	= CC.HEIGHT;

	var last:Float;
	var term:Terminal3D;
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


		onCreate();

		var tm = new Timer( fps );
		tm.run = update;
	}// new()

	override function update()
	{  
		last += Timer.stamp() - last;
	}// update()

	override function dispatch(md:MD)
	{ 	//	trace(id+": "+md);
		if(!MS.isSender(md))return;
//
		switch(md.msg) {
			case MD.MSG: 
				var cm = md.f[0];
				if(cm ==  MS.cmCode("cmLang")){}
			
		}
	}// dispatch()

	inline function onCreate() 
	{
		last = Timer.stamp();

		term = new Terminal3D(); 
		Screen.addTerminal(term);

		setSize();
		gui = new Gui(width_,height_); 
		gui.context = CTX_1D;
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
	
}// abv.sys.jsgui.SM
