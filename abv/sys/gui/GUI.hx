package abv.sys.gui;
/**
 * GUI
 * look in abv-tools/gui/src for cpp source
 **/
import abv.bus.MD;
import abv.lib.math.Rectangle;
#if cpp
import cpp.Lib;
import cpp.ConstCharStar;

#else
import neko.Lib;
#end

using abv.lib.CC;
using abv.lib.style.Color;

class GUI{

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
	static var sdl:GUI;
	static var reverse = false;
	static var music = 0;
	static var sound = 0;
	static var play = false;
	static var plays = false;
	
	inline function new(){ }

	public static inline function init(name:String, width:Int, height:Int)
	{
		if( _init_sdl(name, width, height) )	{
			ready = true;
		}
	}// init()

	public static inline function update()
	{
		var e:Array<Int>;
		var key = 0;
		while((e = _poll_event())[EVENT] != 0){ 
			if(e[MOUSE_DOWN] == MOUSE_DOWN)onMouseDown(e[MOUSE_X],e[MOUSE_Y]); 
			else if(e[MOUSE_UP] == MOUSE_UP)onMouseUp(e[MOUSE_X],e[MOUSE_Y]); 
			onMouseMove(e[MOUSE_X],e[MOUSE_Y]);
			
			if(e[KEY_DOWN] != 0) onKeyDown(e[KEY_DOWN]);
			else if(e[KEY_UP] != 0) onKeyUp(e[KEY_UP]);
			if(e[QUIT] == QUIT) quit();
		} 
	}// update()
	
	public static inline function quit()
	{
		CC.printLog();
		_close_sdl();
		Sys.exit(0);
	}// quit()
	
	public static inline function clearScreen()
	{
		_clear_screen();
	}// clearScreen()

	public static inline function renderScreen()
	{
		_render_screen();
	}// renderScreen()
 
	public static inline function renderQuad(rect:Rectangle,fillColor=.0, 
		border=0, borderColor=.0)
	{
		var r = 0;
		var c = fillColor.trgba(); //trace(c.r+":"+c.g+":"+c.b+":"+c.a);
		var b = borderColor.trgba();
		
		r = _render_quad(rect.x.int(),rect.y.int(),rect.w.int(),rect.h.int(),
			c.r,c.g,c.b,c.a, border,b.r,b.g,b.b,b.a);

		return r;
	}// renderQuad()

	public static inline function renderImage(path:String, 
		x:Float,y:Float, tile:Rectangle = null, scale = 1.)
	{
		var r = 0;
		if(tile == null)tile = new Rectangle();
		r = _render_texture(path,x.int(),y.int(),
			tile.x.int(),tile.y.int(),tile.w.int(),tile.h.int(),scale);

		return r;
	}// renderImage()

	public static inline function renderText(font:String,text:String,x:Float,y:Float,color:Float,wrap:Int)
	{ 
		var r = 0;
		var c = color.trgba(); 
		if(font.good() && text.good()){
			r = _render_text(font,text,x.int(),y.int(),c.r,c.g,c.b,c.a, wrap);
		}
		
	}// renderText()

	public static inline function playMusic(music:String,action:Int=-1)
	{
		return _play_music(music,action);
	}// playMusic()

	public static inline function getWindowSize()
	{
//		var a = get_window_size();
		return {w:1024, h:540};//{w:a[0], h:a[1]};
	}// getWindowSize()
///
	public dynamic static function onMouseWheel(){}
	public dynamic static function onMouseUp(x:Int,y:Int){}
	public dynamic static function onMouseDown(x:Int,y:Int){}
	public dynamic static function onMouseMove(x:Int,y:Int){}
	public dynamic static function onClick(){}
	public dynamic static function onKeyUp(key:Int){}
	public dynamic static function onKeyDown(key:Int){}
///
#if neko
	public static var _poll_event = Lib.load("abv","poll_event_hx",0);
	
	public static var _init_sdl = Lib.load("abv","init_sdl_hx",3);
	
	public static var _close_sdl = Lib.load("abv","close_sdl_hx",0);
	
	public static var _clear_screen = Lib.load("abv","clear_screen_hx",0); 
	
	public static var _render_screen = Lib.load("abv","render_screen_hx",0);
	
	public static var _play_music = Lib.load("abv","play_music_hx",2);  
	
//	public static var get_window_size = Lib.load("abv","get_window_size_hx",0);
	
// -1 for args > 5  
	public static var _render_text = Lib.load("abv","render_text_hx",-1);  
	
	public static var _render_quad = Lib.load("abv","render_quad_hx",-1); 
	
	public static var _render_texture = Lib.load("abv","render_texture_hx",-1); 
#else
// MAX_EVENTS = abv.h:MAX_EVENTS
	static var MAX_EVENTS = 10;

	static function _poll_event()
	{ 
		var p = Abv.poll_event(); 
		var r:Array<Int> = [];
		for(i in 0...MAX_EVENTS)r[i] = p[i];
		return r;
	}
	
	static function _init_sdl(name: String, width:Int, height:Int)
	{ 
		return Abv.init_sdl(name, width, height);
	}
	
	static function _close_sdl(){ Abv.close_sdl();}
	
	static function _clear_screen(){ Abv.clear_screen();} 
	
	static function _render_screen(){ Abv.render_screen();}
	
	static function _play_music(path: String, action:Int)
	{ 
		return Abv.play_music(path,action);
	}  
	
	static function _render_text(font:String,text:String, 
		x:Int, y:Int, r:Int,g:Int,b:Int,a:Int, wrap:Int)
	{
		return Abv.render_text_c(font,text,x, y, r,g,b,a, wrap);
	}
	
	static function _render_quad(x:Int, y:Int, w:Int, h:Int, 
		r:Int, g:Int, b:Int, a:Int, border:Int, br:Int, bg:Int, bb:Int, ba: Int)
	{ 
		return Abv.render_quad_c(x, y, w, h, r, g, b, a, border, br, bg, bb, ba);
	} 
	
	static function _render_texture(path:String, x:Int, y:Int, 
		tx:Int, ty:Int, tw:Int, th:Int, scale: Float)
	{ 
		return Abv.render_texture_c(path, x, y, tx, ty, tw, th, scale);
	} 
#end
}// abv.sys.gui.GUI

