package abv.bus;
/**
 * Message Data
 **/
import abv.lib.math.Point;
using abv.CR;

@:dce
class MD {
// Custom
	public static inline var NONE 			= 0;
	public static inline var MSG 			= 1;
// Keyboard
	public static inline var KUP 			= 1 << 2;
	public static inline var KDOWN 			= 1 << 3;
// Mouse
	public static inline var CLICK			= 1 << 4;
	public static inline var CLICK2 		= 1 << 5;
	public static inline var MUP 			= 1 << 6;
	public static inline var MDOWN 			= 1 << 7;
	public static inline var MMOVE 			= 1 << 8;
	public static inline var MWHEEL 		= 1 << 9;
	public static inline var MOVER 			= 1 << 10;
	public static inline var MOUT 			= 1 << 11;
	public static inline var MOUSE_X 		= 1 << 12;
	public static inline var MOUSE_Y 		= 1 << 13;
// Widget
	public static inline var NEW 			= 1 << 14;
	public static inline var OPEN 			= 1 << 15;
	public static inline var SAVE 			= 1 << 16;
	public static inline var STATE 			= 1 << 17;
	public static inline var CLOSE 			= 1 << 18;
	public static inline var DESTROY 		= 1 << 19;
	public static inline var RESIZE 		= 1 << 20;
	public static inline var DRAW 			= 1 << 21;
	public static inline var SCROLL 		= 1 << 22;
	public static inline var SELECT 		= 1 << 23;
	public static inline var TAB 			= 1 << 24;
// Play
	public static inline var START 			= 1 << 25;
	public static inline var STOP 			= 1 << 26;
	public static inline var PAUSE 			= 1 << 27;
	public static inline var PLAY 			= 1 << 28;
	public static inline var MOVE 			= 1 << 29;
	public static inline var TWEEN 			= 1 << 30;
	public static inline var EXIT 			= 1 << 31;

//
// Message groups
	public static inline var ALL 			= 0xFFFFFF;
	public static inline var MENABLED 		= CLICK | CLICK2 | MUP | 
		MDOWN | MMOVE |	MWHEEL | MOVER | MOUT;
	public static inline var KENABLED		= KUP | KDOWN;

// Subscribers
	public var from(get,never):String;
	var _from:String = "";
	function get_from(){return _from;}

	public var to(get,never):String;
	var _to:String = "";
	function get_to(){return _to;}

	public var msg(get,never):Int;
	var _msg:Int = 0;
	function get_msg(){return _msg;}
	
	public var sign(get,never):Int;
	var _sign:Int = 0;
	function get_sign(){return _sign;}
	
	public var f:Array<Float>;
	public var p:Array<Point>;
	public var s:String;
	
	public function new(from:String,to:String,msg:Int,sign:Int,af:Array<Float>=null,str:String="",ap:Array<Point>=null)
	{
		_from = from;
		_to = to;
		_msg = msg;
		_sign = sign;
		f = af != null?af.copy():new Array();
		s = str.good()?str:"";
		p = ap != null?ap.copy():new Array();
	}// new()

	public inline function signin(sign:Int=0)
	{
		_sign = sign;
	}
	public inline function i(k:Int)
	{
		return Std.int(f[k]);
	}
	public inline function clone()
	{
		var n = new MD(from,to,msg,sign);
		n.f = f.copy();
		n.s = s;
		n.p = p.copy();
		return n;
	}// copy()
	public inline function free()
	{
		_from = _to = null;
		_sign = 0;
		_msg = 0;
		clear(f);
		s = null;
		for(v in p)v = null;
		clear(p);
	}// free()

	function clear<T>(a:Array<T>)
	{
        #if (cpp||php) a.splice(0,a.length); #else untyped a.length = 0; #end
    }// clear()

	public inline function toString() 
	{
        return 'MD(from: $from,to: $to,msg: ${MS.msgName(msg)},f:"+$f,s: $s,p: $p,sign: $sign)';
    }// toString()


}// abv.bus.MD

