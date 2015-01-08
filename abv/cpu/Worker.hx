package abv.cpu;
/**
 * Worker
 **/
import abv.cpu.Thread;

using abv.CT;

class Worker{

	var boss:Thread;
	var id = "";
	var arg = "";

	public function new()
	{ 
	}// new()
	
	public function run()
	{ 
		while(true){   
			boss = Thread.readMessage(true);
			id = Thread.readMessage(true);
			arg = Thread.readMessage(true);
			try exec()catch(m:Dynamic){send("err:" + m);}
			send("exit");
		}
	}// run()

	function exec(){ }

	function send(s:String){boss.sendMessage(id + ":" + s);}
	
	
}// abv.cpu.Worker

