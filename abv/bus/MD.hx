package abv.bus;
/**
 * Message Data
 **/
import abv.math.Point;
import abv.factory.IComm;

using abv.sys.ST;

@:dce
class MD {
// Custom
	public static inline var NONE 			= 0;
	public static inline var MSG 			= 1;
// Keyboard
	public static inline var KEY_UP 		= 1 << 2;
	public static inline var KEY_DOWN 		= 1 << 3;
// Mouse
	public static inline var CLICK			= 1 << 4;
	public static inline var DOUBLE_CLICK 	= 1 << 5;
	public static inline var MOUSE_UP 		= 1 << 6;
	public static inline var MOUSE_DOWN 	= 1 << 7;
	public static inline var MOUSE_MOVE 	= 1 << 8;
	public static inline var MOUSE_WHEEL 	= 1 << 9;
	public static inline var MOUSE_OVER 	= 1 << 10;
	public static inline var MOUSE_OUT 		= 1 << 11;
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

// Message groups
	public static inline var ALL 			= 0xFFFFFF;
	public static inline var MOUSE_ENABLED 		= CLICK | DOUBLE_CLICK | MOUSE_UP | 
		MOUSE_DOWN | MOUSE_MOVE |	MOUSE_WHEEL | MOUSE_OVER | MOUSE_OUT;
	public static inline var KEY_ENABLED		= KEY_UP | KEY_DOWN;

// Subscribers
	public var to(get,never):String;
	var _to = "";
	function get_to() return _to;

	public var msg(get,never):Int;
	var _msg:Int = 0;
	function get_msg() return _msg;

@:allow(abv.bus.MS)	
	public var from(default,null):IComm;
	
	public var f:Array<Float> = [];
	public var p:Array<Point> = [];
	public var s = "";
	
	public function new(from:IComm,to:String,msg:Int,f:Array<Float>=null,s="",p:Array<Point>=null)
	{
		_to = to;
		_msg = msg;
		this.from = from;
		if(f != null)this.f = f.copy();
		if(s.good())this.s = s;
		if(p != null)this.p = p.copy();
	}// new()

	public inline function clone()
	{
		var n = new MD(from,to,msg);
		n.f = f.copy();
		n.s = s;
		n.p = p.copy();
		return n;
	}// copy()
	
	public inline function dispose()
	{
		_to  = "";
		from = null;
		_msg = 0;
		f.clear();
		s = null;
		for(v in p)v = null;
		p.clear();
	}// dispose()

	public inline function toString() 
	{
        return 'MD(from: ${from},to: $to,msg: ${MS.msgName(msg)},f: $f,s: $s,p: $p)';
    }// toString()


}// abv.bus.MD

