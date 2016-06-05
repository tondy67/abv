package abv.sys.cpp;
/**
 * DeVice
 * look in abv-tools/gui/src for cpp source
 **/
#if cpp
import cpp.ConstCharStar;

@:include("../../../../../abv-tools/gui/src/abv.h")
@:buildXml('<target id="haxe">
 <section if="linux">
	<lib name="../../../../abv-tools/libs/Linux/x64/libABV.a" if="HXCPP_M64"/>
	<lib name="../../../../abv-tools/libs/Linux/x86/libABV.a" unless="HXCPP_M64"/>
	<lib name="-lm" />
	<lib name="-ldl" />
	<lib name="-lpthread" /> 
	<lib name="-lrt" />
	<lib name="-lGL" />
 </section>
 <section if="windows">
	<lib name="../../../abv-tools/libs/Windows/ABV.lib" />
	<lib name="shell32.lib"/>
	<lib name="gdi32.lib"/>
	<lib name="winmm.lib"/>
	<lib name="imm32.lib"/>
	<lib name="ole32.lib"/>
	<lib name="oleaut32.lib"/>
	<lib name="version.lib"/>
	<lib name="uuid.lib"/>
	<lib name="dinput8.lib"/>
	<flag value="/NODEFAULTLIB:MSVCRT" />
	<flag value="/FORCE" />
 </section>
</target>')

extern class DV{
	
///
@:native("init_sdl")
	static function initSdl(name: ConstCharStar, width:Int, height:Int):Bool;

@:native("close_sdl")
	static function closeSdl():Void;
	
@:native("poll_event")
	static function pollEvent():cpp.Pointer<Int>;

@:native("set_page")
	static function setLayer(root:Int):Int;

@:native("clear_screen")
	static function clearLayer(root:Int):Int;

@:native("render_screen")
	static function renderScreen():Void;

@:native("play_music")
	static function playMusic(path: ConstCharStar, action:Int):Int;

//@:native("get_window_size")
//	static function get_window_size():Void;

@:native("render_text_c")
	static function renderText(font: ConstCharStar,text: ConstCharStar, 
	x:Int, y:Int, r:Int,g:Int,b:Int,a:Int, wrap: Int):Int;

@:native("render_quad_c")
	static function renderQuad( x:Int, y:Int, w:Int, h:Int, r:Int, g:Int, b:Int, a:Int,
	border:Int, br:Int, bg:Int, bb:Int, ba: Int ):Int;

@:native("render_texture_c")
	static function renderTexture(path:ConstCharStar, x:Int, y:Int, 
	tx:Int, ty:Int, tw:Int, th:Int, scale: Float):Int;

}// abv.sys.cpp.DV
#elseif neko
import neko.Lib;

class DV{
	public static var pollEvent = Lib.load("abv","poll_event_hx",0);
	
	public static var initSdl = Lib.load("abv","init_sdl_hx",3);
	
	public static var closeSdl = Lib.load("abv","close_sdl_hx",0);
	
	public static var setLayer = Lib.load("abv","set_page_hx",1); 

	public static var clearLayer = Lib.load("abv","clear_screen_hx",1); 
	
	public static var renderScreen = Lib.load("abv","render_screen_hx",0);
	
	public static var playMusic = Lib.load("abv","play_music_hx",2);  
	
//	public static var get_window_size = Lib.load("abv","get_window_size_hx",0);
	
// -1 for args > 5  
	public static var renderText = Lib.load("abv","render_text_hx",-1);  
	
	public static var renderQuad = Lib.load("abv","render_quad_hx",-1); 
	
	public static var renderTexture = Lib.load("abv","render_texture_hx",-1); 
}
#end

