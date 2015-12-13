package abv.sys.java;
/**
 * JavaTimer 
 **/ 
import java.util.TimerTask;

@:dce
class JavaTimer {
	
	public function new(time_ms:Float)
    {
		var tm = new java.util.Timer();
		var task = new TmTask();
        task.runme = runme;
        tm.scheduleAtFixedRate(task, 100, time_ms);      

	}// new()
	
	function runme(){run();};
	
	public dynamic function run(){ }

}// abv.sys.java.JavaTimer

class TmTask extends TimerTask {

@:overload
        public override function run() 
        {
			runme();
        }
        
        public dynamic function runme(){};
}// abv.sys.java.JavaTimer.TmTask
