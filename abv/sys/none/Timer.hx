package abv.sys.none;
/**
 * Timer 
 **/ 
@:dce
class Timer {
	
	var ms:Float;
	var last:Float;
	var cur:Float;
	
	public function new(tms=500.){ }
	
	public dynamic function run(){ }

	public static inline function stamp()
	{ 
		return haxe.Timer.stamp();
	}// stamp()
	
}// abv.sys.none.Timer

