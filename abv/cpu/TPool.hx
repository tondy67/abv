package abv.cpu;

import abv.cpu.Thread;

private typedef Worker = {
	var id: Int;
	var t: Thread;
	var free:Bool;
	var task:Int;
}

private typedef Task = {
	var id:Int;
	var task:Void->Dynamic;
	var result:Dynamic->Int->Void;
	var done:Bool;
}

class TPool {

	public var updateTime = 1.;
	var boss: Thread;
	var stderr = Sys.stderr();
	var nextTask = 0;
	
	public function new(workers=2) 
	{
		if (workers < 1) workers = 1;
		boss = Thread.create(runBoss.bind(workers));
		if (updateTime > 0) Thread.create(runTimer);
	}// new()
	
	inline function runBoss(numWorkers:Int) 
	{
		var busy = new List<Int>();
		var w:Worker;
		var workers: Array<Worker> = [];
		var t:Task;
		var tasks = new List<Task>();
		var helper:Thread;
		
		helper = Thread.create(runHelper);
		
		for (i in 0...numWorkers){
			w = {id: i,t:null,free:true,task:-1}
			w.t = Thread.create(runWorker.bind(w));
			workers.push(w);
		}
		
		while( true ) {
			t = Thread.readMessage(true); 
			if (t == null){
				for (it in workers) it.t.sendMessage(null);
				break;
			}else if (t.id == -2){
				busy.clear(); for (it in workers) if (!it.free) busy.add(it.task);
				helper.sendMessage(status.bind(tasks.length,busy));
			}else {
				tasks.add(t); 
			}
			
			if (tasks.isEmpty()) continue;
			
			for (it in workers){
				if (it.free){ 
					t = tasks.pop(); 
					if (t != null){ //trace(it.id);
						it.free = false;
						it.task = t.id;
						it.t.sendMessage(t);
					}
				}
			}
		}
	}// runBoss() 
	
	inline function runTimer() 
	{
		var l = new Lock();
		while( true ) {
			l.wait(updateTime);
			try update() catch(e:Dynamic){ logError(e);}
		}
	}// runTimer()
	
	inline function runWorker(w:Worker) 
	{
		var t:Task;
		var r:Dynamic;
		
		while( true ) {
			r = null;
			t = Thread.readMessage(true); 
			if (t == null) break;
			try {
				r = t.task();
				if (t.result != null){
					try t.result(r,t.id)catch(e:Dynamic){ logError(e);}
				}
				t.done = true; 
			}catch(e:Dynamic){ logError(e);}
			if (!w.free) w.free = true;
		}
	}// runWorker()

	inline function runHelper() 
	{
		var f:Void->Void;
		
		while( true ) {
			f = Thread.readMessage(true); 
			try f() catch(e:Dynamic){ logError(e);}
		}
	}// runHelper()

	public inline function send( task:Task ) 
	{ 
		if ((task != null) && (task.id == -1)){
			task.id = nextTask;
			nextTask++;
		}
		boss.sendMessage(task);
	}// send()
	
	public inline function stop()
	{
		send(null);
	}// stop()

	public inline function info()
	{
		send({id: -2, task: null, done: false, result: null});
	}// exec()

	public inline function run(task:Void->Void, id = -1)
	{
		var f = function () {task(); return null;};
		send({id: id, task: f, done: false, result: null});
	}// run()

	public inline function submit<V>(task:Void->V, result:V->Int->Void=null, id = -1)
	{
		send({id: id, task: task, done: false, result: result});
	}// submit<V>()

	function logError( e:Dynamic ) 
	{
		var stack = haxe.CallStack.exceptionStack();
		if( Thread.current() == boss ) onError(e,stack);
		else run(onError.bind(e,stack));
	}// logError()
	
///	
	public dynamic function onError( e:Dynamic, stack ) 
	{
		var s = try Std.string(e) catch( e2: Dynamic ) "???" + 
			try "["+Std.string(e2)+"]" catch( e:Dynamic ) "";
		stderr.writeString( s + "\n" + haxe.CallStack.toString(stack) );
		stderr.flush();
	}// onError()

	public dynamic function update() 
	{ 
//		info();
	}

	public dynamic function status(queue:Int,busy:List<Int>) 
	{
		trace(queue,busy);
		if ((queue==0) && busy.isEmpty()) { 
//			stop();
		}
	}// status()

}
