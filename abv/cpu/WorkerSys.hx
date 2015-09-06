package abv.cpu;
/**
 * WorkerSys
 **/
import sys.io.Process;
import abv.cpu.Worker;

using abv.lib.CC;
using abv.ds.TP;

class WorkerSys extends Worker{

	var p:Process = null;
	var input = "";
	var args:Array<String>;
	var cmd = "";

	public function new()
	{ 
		super();
	}// new()
	
	override function exec()
	{ 
		var s = "";
		var t = arg.splitt(CC.SEP3);
		cmd = t[0];
		args = t[1].splitt(CC.SEP1);
		input = t[2];
		p = new Process(cmd,args); 
		if(input.good()){
			p.stdin.writeString(input+"\n");
			p.stdin.flush();
		}
		s = p.stdout.readAll() + ""; 
		if(s.good())send(s); 
		else{
			s = p.stderr.readAll() + ""; 
			if(s.good())send("err:" + s); 
		}
	}// exec()

	
}// abv.cpu.WorkerSys

