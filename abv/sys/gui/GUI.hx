package abv.sys.gui;
/**
 * GUI
 * look in abv-native/src/gui for cpp source
 **/
import haxe.crypto.Md5;
import abv.bus.MD;
import abv.lib.math.Rectangle;
#if cpp
import cpp.Lib;
#else
import neko.Lib;
#end

using abv.CR;
using abv.lib.Color;

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
	static var textures = new Map<String,Texture>();
	static var SCREEN_WIDTH = 1024;
	static var SCREEN_HEIGHT = 540;
	static var mX = 0;
	static var sdl:GUI;
	static var reverse = false;
	static var font = 0;
	static var music = 0;
	static var sound = 0;
	static var play = false;
	static var plays = false;
	public static var quit = false;
	
	public static inline function init(width:Int,height:Int)
	{
		if( !init_sdl(width,height) )
		{
			CR.print( getLog(), ERROR);
		}else{
			ready = true;
			font = loadFont("../../res/fonts/regular.ttf",14); //trace(ttt);
			music = loadMusic("../../res/audio/beat.wav"); 
			sound = loadSound("../../res/audio/scratch.wav"); 
		}
	}// init()

	public static inline function update()
	{
		var e:Array<Int>;
		var key = 0;
		while((e = poll_event())[EVENT] != 0){ 
			if(e[MOUSE_DOWN] == MOUSE_DOWN){
//	trace(e[MOUSE_X]+":"+e[MOUSE_Y]);
				onMouseDown(e[MOUSE_X],e[MOUSE_Y]); 
			}
			 onMouseMove(e[MOUSE_X],e[MOUSE_Y]);
			
			if(e[KEY_DOWN] != 0) onKeyDown(e[KEY_DOWN]);
			if(e[KEY_UP] != 0) onKeyUp(e[KEY_UP]);
			if(e[QUIT] == QUIT) quit = true;
		}
		if( quit ){
			CR.printLog();
			close_sdl();
			Sys.exit(0);
		}
	}//
	
	public static inline function clearScreen()
	{
		clear_screen();
	}// clearScreen()

	public static inline function renderScreen()
	{
		render_screen();
	}// renderScreen()
 
	public static inline function renderTexture(texture:Int,src:Rectangle,dst:Rectangle)
	{
		var x = int(src.x), y = int(src.y);
		var w = int(dst.w), h = int(dst.h);
		var a = int(dst.x), b = int(dst.y);
		var a = int(dst.x), b = int(dst.y);
		render_texture(texture,x,y,w,h,a,b,w,h);
	}// renderTexture()
	
	static inline function int(f:Float){return Std.int(f);}
	
	public static inline function renderQuad(x=0,y=0,w=100,h=100,color:Float, border=1, borderColor=.0)
	{
		var c = color.trgba(); //trace(c.r+":"+c.g+":"+c.b+":"+c.a);
		var b = borderColor.trgba();
		return render_quad(x,y,w,h,c.r,c.g,c.b,c.a, border,b.r,b.g,b.b,b.a);
	}// renderQuad()

	public static inline function loadText(s:String,color:Float,wrap)
	{
		var c = color.trgba();
		var a = [0,0,0];
		var font = 1;
		try a = load_text(font,s,c.r,c.g,c.b,wrap)catch(d:Dynamic){trace(d);}
		return a;
	}// loadText()

	public static inline function loadImage(path:String)
	{
		return load_texture(path);
	}// loadImage()

	public static inline function loadFont(path:String,size=14)
	{
		return load_font(path,size);
	}// loadFont()

	static inline function md5(s:String)
	{
		return Md5.encode(s);
	}// md5()

	static inline function getTexture(s:String)
	{
		var r:Texture = null;
		var id = md5(s);
		if(textures.exists(id))r = textures[id];
		return r;
	}// getTexture()

	public static inline function renderText(fnt:Int,text:String,x:Float,y:Float,color:Float,wrap:Int)
	{
		var txt = text.good()?text:" ";
		var txr = getTexture(text+color);
		if(txr == null){
			txr = new Texture();
			txr.setText(txt,color,wrap); 
			textures.set(md5(text+color),txr);
		}
		var src = new Rectangle();
		var dst = new Rectangle(int(x), int(y), txr.width, txr.height);
		renderTexture(txr.id,src,dst); 
	}// renderText()

	public static inline function getLog()
	{
		return get_log();
	}// getLog()

	public static inline function loadMusic(path:String)
	{
		return load_music(path);
	}// loadMusic()

	public static inline function playMusic(music:Int,action:Int)
	{
		return play_music(music,action);
	}// playMusic()

	public static inline function loadSound(path:String)
	{
		return load_sound(path);
	}// loadSound()

	public static inline function playSound(sound:Int)
	{
		return play_sound(sound);
	}// playSound()

	public static inline function queryTexture(texture:Int)
	{
		var a = query_texture(texture);
		return {w:a[0], h:a[1]};
	}// queryTexture()

	public static inline function getWindowSize()
	{
		var a = get_window_size();
		return {w:a[0], h:a[1]};
	}// getWindowSize()
///
	public dynamic static function onMouseWheel(){}
	public dynamic static function onMouseUp(){}
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
   public static var render_texture = Lib.load("abv","render_texture_hx",-1); 
   public static var render_quad = Lib.load("abv","render_quad_hx",-1); 
   public static var load_texture = Lib.load("abv","load_texture_hx",1);  
   public static var load_font = Lib.load("abv","load_font_hx",2);  
   public static var load_text = Lib.load("abv","load_text_hx",-1);  
   public static var get_log = Lib.load("abv","get_log_hx",0);  
   public static var load_music = Lib.load("abv","load_music_hx",1);  
   public static var play_music = Lib.load("abv","play_music_hx",2);  
   public static var load_sound = Lib.load("abv","load_sound_hx",1);  
   public static var play_sound = Lib.load("abv","play_sound_hx",1);  
   public static var query_texture = Lib.load("abv","query_texture_hx",1);  
   public static var get_window_size = Lib.load("abv","get_window_size_hx",0);  

}// abv.sys.gui.GUI

class Texture{

	public var id = 0;
	public var width = 0;
	public var height = 0;

	public function new(path="")
	{
		if(path.good()){
			var a = GUI.loadImage(path);
			if(a[0] > 0){
				id = a[0];
				width = a[1];
				height = a[2];
			}
		}
	}// new();
	
	public function setText(s:String,color:Float,wrap:Int)
	{
		if(s.good()){
			var a = GUI.loadText(s,color,wrap);
			if(a[0] > 0){
				id = a[0];
				width = a[1];
				height = a[2];
			}
		}
	}// setText()
	
	public function toString() 
	{
        return 'Texture(id:$id, width:$width, height:$height)';
    }// toString()

}// Texture
