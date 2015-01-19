package abv.ds;
/**
 * Wallet
 **/

using StringTools;

class Wallet{

	var sessions:Map<String,Map<String,String>> = new Map();
	
	public inline function new(){}

	public function get(sid:String)
	{
		var r:Map<String,String> = null;
		if(sessions.exists(sid))r = sessions[sid];
		return r;
	}// get()
	
	public function del(sid:String)
	{
		return sessions.remove(sid);
	}// del()
	
	public function add()
	{
		var sid = Std.random(100000) + "";
		sid = sid.lpad("00000",5);
		sessions.set(sid,["start" => Date.now().getTime()+""]);
 
		return sid;
	}// add()

	public function toString()
	{
		return "Wallet()";
	}// toString()

}// abv.ds.Wallet

