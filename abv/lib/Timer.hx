package abv.lib;
/**
 * Of course Timer class must be rewriten to hold many timers.
 **/ 
@:dce
class Timer {
	
	var ms:Float;
	var last:Float;
	var cur:Float;
	public var count = 0;
	
	public function new(tms = 500.)
    {
		ms = tms / 1000;// seconds
		last = stamp(); //trace(last);
	}// new()

	public function update()
    { 
		cur = stamp();
		if ((cur - last) > ms) { 
			last = cur;
			run();
			count++;
		}
	}// update()
	
	public static function stamp(){ 
#if (flash || js)
		return haxe.Timer.stamp();
#else
		return Sys.time();
#end
	}// stamp()
	
	public dynamic function run() { }
	
}// abv.lib.Timer
