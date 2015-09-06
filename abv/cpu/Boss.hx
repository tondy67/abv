package abv.cpu;
/**
 * Boss
 **/
import abv.cpu.WorkerSys;
import abv.cpu.Timer;
import sys.io.Process;
import abv.ST;
import abv.cpu.Thread;

using abv.lib.CC;

class Boss{

	public static var main(get, never):Thread;
	static var _main:Thread = null;
	static function get_main():Thread 
	{
		if (_main == null)_main = Thread.current();
		return _main;
	}
	static inline var maxThreads = 1 << 8;
	static var workers:Array<Thread> = [];
	static var stdout:Array<Array<String>> = [];
	static var queue = new List<Int>();
	static var last = Timer.stamp();
	
	public static inline function create(func:Void->Void)
	{ 
		var id = -1;
		var w:Thread = null;
		if(queue.isEmpty()){
			if(workers.length < maxThreads){
				try w = Thread.create(func)catch(m:Dynamic){trace(ERROR+m);}
				if(w != null){
					id = workers.push(w) - 1; 
					stdout.push([]);
				}
			}else trace(WARN+"Threads > " + maxThreads);
		}else id = queue.pop();
	
		return id;
	}

	public static inline function exec(cmd:String, args:Array<String>=null,input="")
	{ 
		var id = -1;
		var arg = "";
		if(cmd.good()){
			if((args != null)&&(args.length > 0))arg = args.join(CC.SEP1);
			var worker = new WorkerSys();
			id = create(worker.run); 	
			if(id != -1){
				arg = cmd + CC.SEP3 + arg + CC.SEP3 + input;
				workers[id].sendMessage(main);
				workers[id].sendMessage(id);
				workers[id].sendMessage(arg);
			}
		}
		return id;
	}// exec()

	public static inline function run(func:Void->Void,arg="")
	{ 
		var id = create(func); 	
		if(id != -1){
			workers[id].sendMessage(main);
			workers[id].sendMessage(id);
			workers[id].sendMessage(arg);
		}

		return id;
	}// run()

	public static inline function read(id:Int)
	{ 
		var r:Array<String> = [];
		var ix = -1, t = 0, max = 0, s = "";
		var delta = Timer.stamp() - last; 
		last += delta;

		if(delta > .01){
			while((s = Thread.readMessage(false)) != null){ 
				if(Type.enumEq(Type.typeof(s),TClass(String)) && (s != "")){ 
					if((ix = s.indexOf(":")) != -1){
						t = Std.parseInt(s.substr(0,ix)); 
						if(check(t))stdout[t].push(s.substr(ix+1));
					}
				}
				max++;
				if(max > 1000)trace(WARN+"Messages > 1000");
			}
		}

		if(check(id)){ 
			r = stdout[id].copy(); 
			if(r[r.length-1] == "exit")queue.add(id);
			stdout[id].clear(); 
		}

		return r;
	}// read()

	static inline function check(id:Int)
	{ 
		return (id >= 0) && (id < workers.length);
	}// check()
	

}// abv.cpu.Boss

