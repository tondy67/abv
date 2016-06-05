package abv.sys.android;

import abv.bus.*;
import abv.ui.*; 
import abv.anim.*;
import abv.factory.*;
import abv.math.Point;
import abv.style.Style;
import abv.*;
import abv.io.*;
import abv.cpu.Timer;


import android.app.Activity;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.Window;
import android.view.Display;
import android.graphics.Point as AndroidPoint;
import android.content.res.Configuration;

using abv.sys.ST;
using abv.ds.TP;

class SM extends Activity  implements IComm {

	var width_:Float 	= CC.WIDTH;
	var height_:Float 	= CC.HEIGHT;
		
	var last = .0;
	var fps = CC.UPS;
// unique id
	public var id(get, never):Int;
	function get_id() return MS.getID(name);

	public var name(get,never):String;
	var _name = "";
	function get_name() return _name;
//
	public var msg(default,null) = new MsgProp();

	var updateHandler = new UpdateHandler();
	var view:AppView;
	
	public function new(id:String)
	{
		super();

		if(!MS.add(this,name)) throw name + ": no ID";
		_name = name;
		
//		view = new AppView();
	}// new()

    
	public function onUpdate()
	{
		Timer.update();
		update();
		if(fps > 0)updateHandler.sleep(this,1000/fps);
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
	
	public inline function call(md:MD)
	{ 
		if(!MS.has(md.from.id))return;
		var m = md.msg & msg.accept; 
		
		dispatch(md); 
		if(msg.action.exists(m) &&  (msg.action.get(m) != null))
			MS.call(msg.action.get(m).clone());
	}// call()

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

        requestWindowFeature(Window.FEATURE_NO_TITLE);

//		term = new Terminal(); 
// 		Screen.addTerminal(term);
 		
//		view.term = term;
//		term.view = view;
		setContentView(view);

//		setSize();
//		create();
//		onUpdate();
	}// onCreate()

	function create() 
	{
		onResize();		

	}// create()

	public function onResize()
	{ 
		setSize();
		resize(); 
	}// onResize()
	function resize() { };
	public dynamic function on2D(){ CC.debug("fallback to 2D");}

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

