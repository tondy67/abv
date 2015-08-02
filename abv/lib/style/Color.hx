package abv.lib.style;


using abv.lib.CR;
using abv.lib.math.MT;
using abv.lib.TP;
/**
 * Color
 **/
@:dce
class Color{

	public static inline var WHITE:Int 		= 0xFFFFFF;
	public static inline var SILVER:Int 	= 0xC0C0C0;
	public static inline var GRAY:Int 		= 0x808080;
	public static inline var BLACK:Int 		= 0x000000;
	public static inline var RED:Int 		= 0xFF0000;
	public static inline var MAROON:Int 	= 0x800000;
	public static inline var YELLOW:Int 	= 0xFFFF00;
	public static inline var OLIVE:Int 		= 0x808000;
	public static inline var LIME:Int 		= 0x00FF00;
	public static inline var GREEN:Int 		= 0x008000;
	public static inline var AQUA:Int 		= 0x00FFFF;
	public static inline var TEAL:Int 		= 0x008080;
	public static inline var BLUE:Int 		= 0x0000FF;
	public static inline var NAVY:Int 		= 0x000080;
	public static inline var FUCHSIA:Int 	= 0xFF00FF;
	public static inline var PURPLE:Int 	= 0x800080;

	static var names = ["white" => WHITE,"silver" => SILVER,
		"gray" => GRAY,"black" => BLACK,"red" => RED,"maroon" => MAROON,
		"yellow" => YELLOW,"olive" => OLIVE,"lime" => LIME,
		"green" => GREEN,"aqua" => AQUA,"teal" => TEAL,"blue" => BLUE,
		"navy" => NAVY,"fuchsia" => FUCHSIA,"purple" => PURPLE];
	
	static inline function argb(rgb:Int,alpha:Float) 
	{
		var a:Float;
		alpha = alpha.range(alpha,0);
		a = alpha > .99?.99:alpha;
		return rgb + a;
	}// argb()

	public static inline function srgba(f:Float)
	{
		var c = trgba(f);
		return 'rgba(${c.r},${c.g},${c.b},${c.a})';
	}// srgba()

	public static inline function trgba(f:Float)
	{
		var c = clr(f);
		var rgb = c.rgb;
 
		var r = (rgb >> 16) & 255;  
		var g = (rgb >> 8) & 255;
		var b = rgb & 255;
		var a = Std.int(c.alpha * 255);
		return {r:r, g:g, b:b, a:a};
	}// trgba()

	public static inline function web(rgb:Int)
	{
		return "#" + rgb.hex(6);
	}// web()

	public static inline function clr(f:Float) 
	{
		var rgb = Std.int(f.range(16777215)); 
		var a = (f - rgb).range(.99,0); 
		var alpha = a == 0?.99:a;
		return {rgb:rgb,alpha:alpha};
	}// new()

	public static inline function name2clr(s:String)
	{
		var r:Null<Float> = null;
		if(names.exists(s))r = argb(names[s],1);
		return r;
	}// name2clr()

	public static inline function rgba(r:Int,g:Int,b:Int,a:Float)
	{
		var alpha = a.range(.99,0);
		var rgb = Std.int(r.range(255)*65536 + g.range(255)*256 + b.range(255));
		return argb(rgb,alpha);
	}// rgba()

	public static inline function hex2clr(s:String,a:Float=1)
	{
		if(s.length == 3)s = s.charAt(0)+s.charAt(0)
			+s.charAt(1)+s.charAt(1)+s.charAt(2)+s.charAt(2);
		else if(s.length != 6)s = "FFFFFF";
		
		var alpha = a.range(.99,0);
		var rgb = Std.parseInt("0x"+s);
		return argb(rgb,alpha);
	}// hex2clr()

}// abv.lib.style.Color

