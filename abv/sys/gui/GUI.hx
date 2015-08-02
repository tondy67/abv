package abv.sys.gui;
/**
 * GUI
 * look in abv-native/src/gui for cpp source
 **/
import abv.bus.MD;
import abv.lib.math.Rectangle;
#if cpp
import cpp.Lib;
#else
import neko.Lib;
#end

using abv.lib.CR;
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
	static var SCREEN_WIDTH = 1024;
	static var SCREEN_HEIGHT = 540;
	static var mX = 0;
	static var sdl:GUI;
	static var reverse = false;
	static var music = 0;
	static var sound = 0;
	static var play = false;
	static var plays = false;
	
	inline function new(){ }

	public static inline function init(width:Int,height:Int)
	{
		if( !init_sdl(width,height) )
		{
			trace(CR.ERROR+ getLog());
		}else{
			ready = true;
		}
	}// init()

	public static inline function update()
	{
		var e:Array<Int>;
		var key = 0;
		while((e = poll_event())[EVENT] != 0){ 
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
		CR.printLog();
		close_sdl();
		Sys.exit(0);
	}// quit()
	
	public static inline function clearScreen()
	{
		clear_screen();
	}// clearScreen()

	public static inline function renderScreen()
	{
		render_screen();
	}// renderScreen()
 
	public static inline function renderQuad(rect:Rectangle,fillColor=.0, 
		border=0, borderColor=.0)
	{
		var r = 0;
		var c = fillColor.trgba(); //trace(c.r+":"+c.g+":"+c.b+":"+c.a);
		var b = borderColor.trgba();
		
		r = render_quad(rect.x.int(),rect.y.int(),rect.w.int(),rect.h.int(),
			c.r,c.g,c.b,c.a, border,b.r,b.g,b.b,b.a);

		return r;
	}// renderQuad()

	public static inline function renderImage(path:String, 
		x:Float,y:Float, tile:Rectangle = null, scale = 1.)
	{
		var r = 0;
		if(tile == null)tile = new Rectangle();
		r = render_texture(path,x.int(),y.int(),
			tile.x.int(),tile.y.int(),tile.w.int(),tile.h.int(),scale);

		return r;
	}// renderImage()

	public static inline function renderText(font:String,text:String,x:Float,y:Float,color:Float,wrap:Int)
	{
		var c = color.trgba();
		if(font.good() && text.good()){
			render_text(font,text,x.int(),y.int(),c.r,c.g,c.b,wrap);
		}
	}// renderText()

	public static inline function getLog()
	{
		return get_log();
	}// getLog()

	public static inline function playMusic(music:String,action:Int=-1)
	{
		return play_music(music,action);
	}// playMusic()

	public static inline function getWindowSize()
	{
		var a = get_window_size();
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
   public static var poll_event = Lib.load("abv","poll_event_hx",0);
   public static var init_sdl = Lib.load("abv","init_sdl_hx",2);
   public static var close_sdl = Lib.load("abv","close_sdl_hx",0);
   public static var clear_screen = Lib.load("abv","clear_screen_hx",0); 
   public static var render_screen = Lib.load("abv","render_screen_hx",0);
   public static var get_log = Lib.load("abv","get_log_hx",0);  
   public static var play_music = Lib.load("abv","play_music_hx",2);  
   public static var get_window_size = Lib.load("abv","get_window_size_hx",0);  
   public static var render_text = Lib.load("abv","render_text_hx",-1);  
   public static var render_quad = Lib.load("abv","render_quad_hx",-1); 
   public static var render_texture = Lib.load("abv","render_texture_hx",-1); 

}// abv.sys.gui.GUI

