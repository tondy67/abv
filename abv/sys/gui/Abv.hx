package abv.sys.gui;
/**
 * Abv
 * look in abv-tools/gui/src for cpp source
 **/
import cpp.ConstCharStar;


@:include("../../../../abv-tools/gui/src/abv.h")
@:buildXml('<target id="haxe"><lib name="../../../abv-tools/libs/libABV.a"/></target>')
extern class Abv{
	
///
@:native("init_sdl")
   static function init_sdl(name: ConstCharStar, width:Int, height:Int):Bool;

@:native("close_sdl")
   static function close_sdl():Void;

@:native("poll_event")
	static function poll_event():cpp.Pointer<Int>;

@:native("clear_screen")
   static function clear_screen():Int;

@:native("render_screen")
   static function render_screen():Void;

@:native("play_music")
   static function play_music(path: ConstCharStar, action:Int):Int;

//@:native("get_window_size")
//   static function get_window_size():Void;

@:native("render_text_c")
   static function render_text_c(font: ConstCharStar,text: ConstCharStar, 
	x:Int, y:Int, r:Int,g:Int,b:Int,a:Int, wrap: Int):Int;

@:native("render_quad_c")
   static function render_quad_c( x:Int, y:Int, w:Int, h:Int, r:Int, g:Int, b:Int, a:Int,
	border:Int, br:Int, bg:Int, bb:Int, ba: Int ):Int;

@:native("render_texture_c")
   static function render_texture_c(path:ConstCharStar, x:Int, y:Int, 
	tx:Int, ty:Int, tw:Int, th:Int, scale: Float):Int;

}// abv.sys.gui.Abv

