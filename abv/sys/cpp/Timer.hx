package abv.sys.cpp;
/**
 * Timer 
 **/ 
@:dce
class Timer {
	
	var ms:Float;
	var last:Float;
	var cur:Float;
//	public var count = 0;
	
	public function new(tms=500)
    {
		ms = tms / 1000;// seconds
		last = stamp(); //trace(last);
	}// new()
// TODO: cpp MainLoop ?!
	public function update()
    { 
		cur = stamp();
		if ((cur - last) > ms) { 
			last = cur;
			run();
//			count++;
		}
	}// update()
	
	public static inline function stamp()
	{ 
		return haxe.Timer.stamp();
/*
var date:Date = new Date();
var numVal:Number = date.time;
* Sys.time
* */
	}// stamp()
	
	public dynamic function run() { }
	
}// abv.sys.cpp.Timer
