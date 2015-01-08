package abv.cpu;
/**
 * Boss
 **/
import abv.cpu.WorkerSys;
import abv.lib.Timer;
import sys.io.Process;
import abv.sys.ST;
import abv.cpu.Thread;
using abv.CT;

class Boss{

	static var main = Thread.current();
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
				try w = Thread.create(func)catch(m:Dynamic){CT.print(m+"");}
				if(w != null){
					id = workers.push(w) - 1; 
					stdout.push([]);
				}
			}else CT.print("Threads > " + maxThreads,CT.WARN);
		}else id = queue.pop();
	
		return id;
	}

	public static inline function exec(cmd:String, args:Array<String>=null,input="")
	{ 
		var id = -1;
		var arg = "";
		if(cmd.good()){
			if((args != null)&&(args.length > 0))arg = args.join("|");
			var worker = new WorkerSys();
			id = create(worker.run); 	
			if(id != -1){
				arg = cmd + CT.sep + arg + CT.sep + input;
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
		var ix:Int, t:Int, max = 0, s = "";
		var delta = Timer.stamp() - last; 
		last += delta;
		
		if(delta > .01){
			while((s = Thread.readMessage(false)) != null){ 
				if(s.good()){ 
					if((ix = s.indexOf(":")) != -1){
						t = Std.parseInt(s.substr(0,ix)); 
						if(check(t))stdout[t].push(s.substr(ix+1));
					}
				}
				max++;
				if(max > 1000)CT.print("Messages > 1000",CT.WARN);
			}
		}

		if(check(id)){ 
			r = stdout[id].copy(); 
			for(m in r)if(m == "exit")queue.add(id);
			stdout[id].clear(); 
		}

		return r;
	}// read()

	static inline function check(id:Int)
	{ 
		return (id >= 0) && (id < workers.length);
	}// check()
	

}// abv.cpu.Boss

