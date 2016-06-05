package abv.sys.flash;

import abv.factory.IComm;
import abv.bus.*;
import abv.anim.Juggler;
import abv.io.AD;
import abv.cpu.Timer;

import flash.display.*;
import flash.events.*;
import flash.geom.Matrix;
import flash.Lib;

using abv.sys.ST;

@:dce
class SM extends Sprite implements IComm {

	var width_:Float 	= CC.WIDTH;
	var height_:Float 	= CC.HEIGHT;
// unique id
	public var id(get, never):Int;
	function get_id() return MS.getID(name);
//
	public var msg(default,null) = new MsgProp();
		
	var last:Float;
	var sp:Sprite;
	
	public function new(name:String)
	{
		super();

		if(!MS.add(this,name)) throw name + ": no ID";
		this.name = name;
		
		addEventListener (Event.ADDED_TO_STAGE, addedToStage);
		Lib.current.addChild (this);
 	}// new()

	function addedToStage(e:Event) 
	{
		stage.align = StageAlign.TOP_LEFT;
		stage.scaleMode = StageScaleMode.NO_SCALE;

		addEventListener(Event.ENTER_FRAME, onEnterFrame);
		stage.addEventListener(Event.RESIZE, _onResize);

		onCreate();
	}// addedToStage()
	
	function onEnterFrame(e:Event)
	{	 
		Timer.update();
		Juggler.update();
		AD.update();
		update();
	}

	public function update(){ }
	
	function dispatch(md:MD){ }
	
	public inline function call(md:MD)
	{ 
		if(!MS.has(md.from.id))return;
		var m = md.msg & msg.accept; 
		
		dispatch(md); 
		if(msg.action.exists(m) &&  (msg.action.get(m) != null))
			MS.call(msg.action.get(m).clone());
	}// exec()
	
	function fill()
	{ 
/*		var m = new Matrix();
		m.createGradientBox(width_, height_, Math.PI/2,0,0);
		graphics.beginGradientFill(GradientType.LINEAR,[0xAAAAAA, 0xEEEEEE],[1, 1],[0x00, 0xCC],m);
		graphics.drawRect(0, 0, width_, height_); */
	}// fill()

	inline function onCreate() 
	{  
		last = Timer.stamp();
		create();  
	}// onCreate() 
	
	function create() { }
	
	inline function _onResize(e:Event){ onResize(); }

	inline function onResize()
	{ 
//		screenW = Math.ceil(Lib.current.stage.stageWidth / dpi);
//		screenH = Math.ceil(Lib.current.stage.stageHeight / dpi);
		setSize();
		resize();
		fill();

		AD.resize();
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

	inline function onDestroy() { destroy(); };
	function destroy() { };

	public dynamic function on2D(){ trace("fallback to 2D");}

	function setSize()
	{
		width_ = stage.stageWidth; 
		height_ = stage.stageHeight;  
	}// setSize()
	
}// abv.sys.flash.SM

