package abv.cpu;
/**
 * Timer 
 **/ 

class Timer{
	
	var id:Int;
	var start:Float;
	var cur:Float;
	var time:Float;
	var repeat:Int;
	var count = 0;
	static var timers:Array<Timer> = [];
#if (cpp||neko||java) static var m = new Mutex(); #end
	
	public inline function new(ms:Int,repeat=0)
    {
		this.repeat = repeat;
		time = ms / 1000;
		start = cur = stamp(); 
		id = set(this); 
	}// new()

	public dynamic function run() { }

	public inline function stop() 
	{ 
		remove(id);
	}// stop()
///

	static inline function set(tm:Timer)
	{ 
		var r = timers.push(tm) - 1; 
		return r;
	}// set()
	
	static inline function remove(id:Int)
	{ 
		timers[id] = null;
	}// remove()

	public static inline function delay(f:Void->Void, ms:Int):Timer
	{ 
		var tm = new Timer(ms,1);
		tm.run = f;
		return tm;
	}// delay()
	
	public static inline function measure<T>(f:Void->T):T
    { 
		var r = f();
		var t = stamp();
		trace((stamp() - t) + "s");
		return r;
	}// measure()
	
	static inline function run_(tm:Timer)
    { 
#if (cpp||neko||java) 
		m.acquire();
		tm.run();
		m.release();
#else
		tm.run();
#end
	}// run_()
	
	public static inline function update()
    { 
		var t = stamp();
		
		for(it in timers){
			if(it == null)continue; //trace((t - it.cur) +": "+ it.time);
			if((t - it.cur) > it.time){
				it.cur = t;
				it.count++;
				run_(it);
				if((it.repeat > 0)&&(it.count >= it.repeat))remove(it.id);
			}
		}
	}// update()
	
	public static inline function stamp()
	{ 
		var r = .0;
#if flash
		r = flash.Lib.getTimer() / 1000;
#elseif js
		r = Date.now().getTime() / 1000;
#else
		r = Sys.time();
#end
		return r;
	}// stamp()
	
}// abv.cpu.Timer
