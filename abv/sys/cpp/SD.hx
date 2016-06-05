package abv.sys.cpp;
/**
 * SystemDevice
 * look in abv-tools/gui/src for cpp source
 **/
import abv.bus.MD;
import abv.math.Rect;
import abv.style.*;

using abv.sys.ST;
using abv.style.Color;

class SD{

// MAX_EVENTS = abv.h:MAX_EVENTS
	static inline var MAX_EVENTS = 10;
// copy of AbvEvent enum (sdl.h)
	public static inline var EVENT 		= 0;
	public static inline var QUIT 		= 1;
	public static inline var MOUSE_MOVE = 2;
	public static inline var MOUSE_DOWN = 3;
	public static inline var MOUSE_UP 	= 4;
	public static inline var MOUSE_X 	= 5;
	public static inline var MOUSE_Y 	= 6;
	public static inline var KEY_DOWN 	= 7;
	public static inline var KEY_UP 	= 8;
//
	static var ready = false;
//
	static var mX = 0;
	static var sdl:SD;
	static var reverse = false;
	static var music = 0;
	static var sound = 0;
	static var play = false;
	static var plays = false;
	
	public static inline function init(name:String, width:Int, height:Int)
	{
		if( DV.initSdl(name, width, height) )	{
			ready = true;
		}
	}// init()

	static function pollEvent():Array<Int>
	{
#if cpp
		var p = DV.pollEvent(); 
		var r:Array<Int> = [];
		for(i in 0...MAX_EVENTS)r[i] = p[i];
		return r;
#elseif neko
		return DV.pollEvent(); 
#end
	}

	public static inline function update()
	{
		var e:Array<Int>;
		var key = 0;
		while((e = pollEvent())[EVENT] != 0){ 
			if(e[MOUSE_DOWN] == MOUSE_DOWN)onMouseDown_(e[MOUSE_X],e[MOUSE_Y]); 
			else if(e[MOUSE_UP] == MOUSE_UP)onMouseUp_(e[MOUSE_X],e[MOUSE_Y]); 
			onMouseMove_(e[MOUSE_X],e[MOUSE_Y]);
			
			if(e[KEY_DOWN] != 0) onKeyDown_(e[KEY_DOWN]);
			else if(e[KEY_UP] != 0) onKeyUp_(e[KEY_UP]);
			if(e[QUIT] == QUIT) quit();
		} 
	}// update()
	
	public static inline function quit()
	{
		DV.closeSdl();
	}// quit()
	
	public static inline function clearLayer(id=-1)
	{
		DV.clearLayer(id);
	}// clear()

	public static inline function setLayer(id=-1)
	{
		DV.setLayer(id);
	}// setLayer()

	public static inline function render()
	{
		DV.renderScreen();
	}// render()
 
	public static inline function renderQuad(rect:Rect,stroke:Stroke,fill:Fill)
	{
		var r = 0;
		var c = fill.color; //trace(c.r+":"+c.g+":"+c.b+":"+c.a);
		var b = stroke.color;
		
		r = DV.renderQuad(rect.x.i(),rect.y.i(),rect.w.i(),rect.h.i(),
			c.r,c.g,c.b,c.a, stroke.width.i(),b.r,b.g,b.b,b.a);

		return r;
	}// renderQuad()

	public static inline function renderImage(path:String, 
		x:Float,y:Float, tile:Rect = null, scale = 1.)
	{
		var r = 0;
		if(tile == null)tile = new Rect();
		r = DV.renderTexture(path,x.i(),y.i(),
			tile.x.i(),tile.y.i(),tile.w.i(),tile.h.i(),scale);

		return r;
	}// renderImage()

	public static inline function renderText(font:String,text:String,x:Float,y:Float,color:Color,wrap:Int)
	{ 
		var r = 0;
		var c = color; 
		if(font.good() && text.good()){
			r = DV.renderText(font,text,x.i(),y.i(),c.r,c.g,c.b,c.a, wrap);
		}
		
	}// renderText()

	public static inline function playMusic(music:String,action:Int=-1)
	{
		return DV.playMusic(music,action);
	}// playMusic()

	public static inline function getWindowSize()
	{
//		var a = get_window_size();
		return {w:1024, h:540};//{w:a[0], h:a[1]};
	}// getWindowSize()
///
	public dynamic static function onMouseWheel_(){}
	public dynamic static function onMouseUp_(x:Int,y:Int){}
	public dynamic static function onMouseDown_(x:Int,y:Int){}
	public dynamic static function onMouseMove_(x:Int,y:Int){}
	public dynamic static function onClick_(){}
	public dynamic static function onKeyUp_(key:Int){}
	public dynamic static function onKeyDown_(key:Int){}
///

}// abv.sys.cpp.SD

