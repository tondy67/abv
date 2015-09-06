package abv.sys.java;
/**
 * Timer 
 **/ 
import java.util.Timer as JavaTimer;
import java.util.TimerTask;

@:dce
class Timer {
	
	var ms:Float;
	var last:Float;
	var cur:Float;
//	public var count = 0;
	
	public function new(tms=500.)
    {
		ms = tms / 1000;// seconds
		last = stamp(); //trace(last);

		var tm = new JavaTimer();
		var task = new TmTask();
        task.runme = runme;
        tm.scheduleAtFixedRate(task, 100, 1/tms);      

	}// new()
	
	function runme(){run();};
	
	public dynamic function run(){ }

	public static inline function stamp()
	{ 
		return haxe.Timer.stamp();
	}// stamp()
	
}// abv.sys.java.Timer

class TmTask extends TimerTask {

@:overload
        public override function run() 
        {
			runme();
        }
        
        public dynamic function runme(){};
}// abv.sys.java.Timer.TmTask
