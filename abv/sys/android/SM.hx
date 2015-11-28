package abv.sys.android;

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

import android.app.Activity;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.Window;
import android.view.Display;
import android.graphics.Point as AndroidPoint;
import 	android.content.res.Configuration;

using abv.lib.CC;
using abv.ds.TP;

class SM extends Activity  implements IComm {

	var width_:Float 	= CC.WIDTH;
	var height_:Float 	= CC.HEIGHT;
		
	var last = .0;
	var term:Terminal3D;
	var gui:Gui;
	var fps = CC.UPS;
	public static var trace = haxe.Log.trace; 
// unique id
	public var id(null, null):Int;
//
	public var msg(default,null):MS.MsgProp;

	var updateHandler = new UpdateHandler();
	var view:AppView;
	
	public function new(id:String)
	{
		super();
		haxe.Log.trace = ST.trace;

		this.id = MS.subscribe(this,id);
		msg = {accept:MD.NONE,action:new AMap()};
// customMessage register
		MS.cmCode("cmSound");
	}// new()

    
	public function onUpdate()
	{
		update();
		view.update();
		updateHandler.sleep(this,1000/fps);
	}// onUpdate()
	
	public function update(){}
	
	function dispatch(md:MD)
	{
		switch(md.msg) {
			case MD.MSG: 
				var cm = md.f[0];
				if(cm ==  MS.cmCode("cmSound")){
					AM.sound = md.f[1] == 1?false:true;
				}
		}
	}// dispatch()
	
	public inline function exec(md:MD)
	{ 
		if(!MS.isSender(md))return;
		var m = md.msg & msg.accept; 
		
		dispatch(md); 
		if(msg.action.exists(m) &&  (msg.action[m] != null))
			MS.exec(msg.action[m].clone());
	}// exec()

///
@:overload
	public override function onConfigurationChanged(newConfig:Configuration) 
	{
		super.onConfigurationChanged(newConfig);

		onResize();
	}// onConfigurationChanged()

@:overload
	public override function onCreate(savedInstanceState:Bundle)
	{
		super.onCreate(savedInstanceState);

//        requestWindowFeature(Window.FEATURE_NO_TITLE);

		term = new Terminal3D(); 
 		Screen.addTerminal(term);
 		
		view = new AppView(this, null);
		view.term = term;
		term.view = view;
		setContentView(view);

		setSize();
		create();
		onUpdate();
	}// onCreate()

	function create() 
	{
		gui = new Gui(width_,height_); 
		Screen.addRoot(gui);
		
		onResize();		

	}// create()

	public function onResize()
	{ 
		setSize();
		resize(); 
		Screen.resize(); 
	}// onResize()
	function resize() { };

@:overload
	public override function onStart() 
	{ 
		super.onStart() ;
		start(); 
	};
	function start() { };

@:overload
	public override function onRestart() 
	{ 
		super.onRestart();
		restart(); 
	};
	function restart() { };

@:overload
	public override function onResume() 
	{ 
		super.onResume();
		resume(); 
	};
	function resume() { };

@:overload
	public override function onPause() 
	{ 
		super.onPause();
		pause(); 
	};
	function pause() { };

@:overload
	public override function onStop() 
	{ 
		super.onStop();
		stop(); 
	};
	function stop() { };

@:overload
	public override function onDestroy() 
	{ 
		super.onDestroy();
		destroy(); 
	};
	function destroy() { };

	function setSize()
	{
		var display = getWindowManager().getDefaultDisplay();
		var size = new AndroidPoint();
		display.getSize(size);
		width_ = size.x;
		height_ = size.y; 
	}// setSize()
	
}// abv.sys.android.SM

class UpdateHandler extends Handler {

	var owner:SM = null;
		
@:overload
	public override function handleMessage(msg:Message) {
		if(owner != null){
			owner.onUpdate();
		}
	}

	public function sleep(owner:SM,delay:Float) 
	{
		if(this.owner == null) this.owner = owner;
		removeMessages(0);
		sendMessageDelayed(obtainMessage(0), delay);
	}
	
}// abv.sys.android.AM.UpdateHandler

