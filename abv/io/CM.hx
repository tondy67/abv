package abv.io;
/**
 * CommonMachine 
 **/
import abv.bus.*;
import abv.*;
import abv.io.*;
import abv.factory.Object;
import abv.cpu.Timer;
import abv.io.*;
#if gui
import abv.anim.Juggler;
import abv.ui.Gui; 
#end

using abv.sys.ST;
using abv.ds.TP;

class CM extends Object{

	var width_:Float 	= CC.WIDTH;
	var height_:Float 	= CC.HEIGHT;
		
	var last = Timer.stamp();
	var fps = CC.UPS;
	var quit = false;
	public var ui = new Input(); 
	var hovered = "";
	
	public inline function new(id:String)
	{
		super(id);

		msg.accept = MD.EXIT;
// customMessage register
//		MS.cmCode("cmSound");

		onCreate();
		onStart();

		if(fps > 0){

#if (flash || engine)

#elseif js
			untyped setInterval(update_,1000/fps);
//#elseif java
//			var tm = new abv.sys.java.JavaTimer(1000/fps); 
//			tm.run = function(){update_();}
#else
			while( !quit ){
				update_();
				Sys.sleep(1/fps);
			}	
#end	
		}

	}// new()

	public inline function update_()
	{
		var r:Array<Int> = [];
		Timer.update();
#if gui
 #if (cpp || neko)
 		abv.sys.cpp.SD.update();
 #end 
		Juggler.update();
		r = AD.update();
#end 

		update();
		return r;
	}// update_()

	public dynamic function on2D(){ CC.debug("fallback to 2D");}
/*

	inline function onMsg(to:Int,cmd:Int)
	{ 
		if(to > 0)MS.exec(new MD(this,MS.getName(to),cmd,[],"",[ui.delta]));
	}// onMsg()	

	public dynamic function onMouseMove(x:Int,y:Int) mouseMove(x,y);
	inline function mouseMove(x:Int,y:Int)
	{ 
		var l = AD.getObjectsUnderPoint(x,y);
		if(l.length > 0){ 
			var t = l.first(); 
			if(ui.click){
				onMsg(t,MD.MOUSE_MOVE);
			}else if(MS.accept(t,MD.MOUSE_OVER)){
//				if(hovered != t)onMsg(hovered,MD.MOUSE_OUT);
//				hovered = t;
//				onMsg(hovered,MD.MOUSE_OVER); 
			}else if(hovered.good()){
//				onMsg(hovered,MD.MOUSE_OUT); 
//				hovered = "";
			}
		}
	}// mouseMove()
	
	public dynamic function onMouseWheel(delta = 0) mouseWheel(delta);
	inline function mouseWheel(delta = 0)ui.wheel = delta;

	public dynamic function onMouseUp(x:Int,y:Int) mouseUp(x,y);
	inline function mouseUp(x = 0,y = 0)ui.click = false;

	public dynamic function onMouseDown(x:Int,y:Int) mouseDown(x,y);
	inline function mouseDown(x = 0,y = 0)
	{ 
		var to = -1;
		var a = AD.getObjectsUnderPoint(x,y);

		for(it in a){  
			if(MS.accept(it,MD.MOUSE_DOWN)){ 
				to = it;  
				break;
			}
		}

		ui.click = true; 
//		ui.start.set(e.clientX,e.clientY);  
		ui.move.copy(ui.start);
//
		if(to > 0) onMsg(to,MD.CLICK); 
	}// mouseDown
	
	public dynamic function onClick(x:Int,y:Int) mouseClick(x,y);
	inline function mouseClick(x:Int,y:Int)
	{ 
		var to = -1; 
		if(to != -1)onMsg(to,MD.CLICK); 
	}// mouseClick
	
	public dynamic function onKeyDown(key:Int) keyDown(key);
	inline function keyDown(key:Int)
	{ 
		ui.keys[key] = true; 
		MS.exec(new MD(this,"",MD.KEY_DOWN,[key]));  
	}// onKeyDown_()
	
	public dynamic function onKeyUp(key:Int) keyUp(key);
	inline function keyUp(key:Int)
	{
		ui.keys[key] = false;
		MS.exec(new MD(this,"",MD.KEY_UP,[key]));
	}// onKeyUp_()
*/
	inline function onCreate() 
	{ 
#if gui
 #if (cpp || neko)
		abv.sys.cpp.SD.init(CC.NAME, CC.WIDTH, CC.HEIGHT);
 #end 
#end 
		create(); 
	}// onCreate() 
	
	function create(){ }
	

	inline function onResize() 
	{ 
		setSize();
		resize(); 
#if gui
		AD.resize(); 
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
	

}// abv.io.CM
