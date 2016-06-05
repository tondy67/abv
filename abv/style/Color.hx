package abv.style;
/**
 * Color RGBA
 **/
using abv.sys.ST;
using StringTools;

@:dce
abstract Color(Int) from Int to Int {  

	public static inline var WHITE:Int 		= 0xFFFFFFFF;
	public static inline var SILVER:Int 	= 0xC0C0C0FF;
	public static inline var GRAY:Int 		= 0x808080FF;
	public static inline var BLACK:Int 		= 0x000000FF;
	public static inline var RED:Int 		= 0xFF0000FF;
	public static inline var MAROON:Int 	= 0x800000FF;
	public static inline var YELLOW:Int 	= 0xFFFF00FF;
	public static inline var OLIVE:Int 		= 0x808000FF;
	public static inline var LIME:Int 		= 0x00FF00FF;
	public static inline var GREEN:Int 		= 0x008000FF;
	public static inline var AQUA:Int 		= 0x00FFFFFF;
	public static inline var TEAL:Int 		= 0x008080FF;
	public static inline var BLUE:Int 		= 0x0000FFFF;
	public static inline var NAVY:Int 		= 0x000080FF;
	public static inline var FUCHSIA:Int 	= 0xFF00FFFF;
	public static inline var PURPLE:Int 	= 0x800080FF;

	static var names = setNames();
	
	public var r(get, never):Int;
	inline function get_r():Int return (this >> 24) & 0xFF;

	public var g(get, never):Int;
	inline function get_g():Int return (this >> 16) & 0xFF;

	public var b(get, never):Int;
	inline function get_b():Int return (this >> 8) & 0xFF;

	public var a(get, never):Int;
	inline function get_a():Int return this & 0xFF;

	public var rgb(get, never):Int;
	inline function get_rgb():Int return this >> 8;

	public var alpha(get, never):Float;
	inline function get_alpha():Float return a/255;

	public inline function new(color:Int = 0):Color this = color;

	public inline function toCssRgba() return toString();

	public inline function toHex(prefix="#")
	{
		return prefix + r.hex(2) + g.hex(2) + b.hex(2) + a.hex(2);
	}// toHex()

	public static inline function name2clr(s:String)
	{
		var r:Null<Color> = null;
		if(names.exists(s))r = names[s];
		return r;
	}// name2clr()

	public static inline function fromRgba(r:Int,g:Int,b:Int,a:Int):Color
	{
		return ((r & 0xFF) << 24) | ((g & 0xFF) << 16) | ((b & 0xFF) << 8) | ((a & 0xFF) << 0);
	}// fromRgba()


@:from
	public static inline  function fromString(s:String):Color
	{ 
		var v = s.trim().toLowerCase();
		var r = new Color();
		if(v.startsWith("#")){
			r = fromHex(v.replace("#",""));
		}else if(v.startsWith("rgba(")){ 
			v = v.replace("rgba(","");
			var p = v.split(","); 
			r = fromRgba(p[0].toInt(),p[1].toInt(),p[2].toInt(),(p[3].toFloat()*255).i());
		}else if(name2clr(v) != null){
			r = name2clr(v);
		}else{
			r = v.toInt();
		}
		
		return r;	
	}// fromString()
 
@:from 
	public static inline function fromInt(rgba:Int):Color
	{ trace(rgba);
		return rgba;
	}

@:from 
	public static inline function fromInts(a:Array<Int>):Color
	{
		return fromRgba(a[0], a[1], a[2], a[3]);
	}

	public static inline function fromHex(s:String):Color
	{
		var r = 0;
		if(s.length == 3)s = s.charAt(0)+s.charAt(0)
			+s.charAt(1)+s.charAt(1)+s.charAt(2)+s.charAt(2);
		
		var rgb = Std.parseInt("0x"+s);
		if(rgb != null){
			if(s.length == 6) r = (rgb << 8) + 255; 
			else if(s.length == 8) r = rgb;
		}
		return r;
	}// fromHex()


@:to 
	public function toString():String return 'rgba($r,$g,$b,$alpha)';

	static function setNames()
	{
		var r = new Map<String,Int>();
		r.set("white", WHITE);
		r.set("silver", SILVER);
		r.set("gray", GRAY);
		r.set("black", BLACK);
		r.set("red", RED);
		r.set("maroon", MAROON);
		r.set("yellow", YELLOW);
		r.set("olive", OLIVE);
		r.set("lime", LIME);
		r.set("green", GREEN);
		r.set("aqua", AQUA);
		r.set("teal", TEAL);
		r.set("blue", BLUE);
		r.set("navy", NAVY);
		r.set("fuchsia", FUCHSIA);
		r.set("purple", PURPLE);
		return r;
	}// setNames()
	
}// abv.style.Color

