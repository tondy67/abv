package abv.ds;
/**
 * Wallet
 **/
import haxe.crypto.Md5;

typedef SessionData = {start:Float, expire:Float, data:Map<String,String>}

@:dce
class Wallet{

	var sessions:Map<String,SessionData> = new Map();
	
	public inline function new(){}

	public inline function get(sid:String)
	{
		var r = new Map<String,String>();
		if(sessions.exists(sid)){
			var exp = sessions[sid].expire;
			var last = sessions[sid].start + exp*1000; 
			if((exp == 0)||(Date.now().getTime() < last))r = sessions[sid].data;
			else del(sid);
		}
 		return r;
	}// get()
	
	public inline function set(sid:String,data:Map<String,String>)
	{
		var r = false;
		if(sessions.exists(sid)){
			sessions[sid].data = data;
			r = true;
		}
		return r;
	}// set()
	
	public inline function del(sid:String)
	{
		var r = false;
		if(sessions.exists(sid)){
			sessions[sid] = null;
			r = sessions.remove(sid);
		}
		return r;
	}// del()
	
	public inline function add(expire=.0)
	{
		var now = Date.now().getTime();
		var sid = Md5.encode(Std.random(1000000) + now + "");
		if(sessions.exists(sid))sid = "";
		else sessions.set(sid,{start:now,expire:expire,data:["sid"=>sid]});
 		return sid;
	}// add()

	public inline function length()
	{
		var r = 0;
		for(k in sessions)r++;
		return r;
	}// length()
	
	public function toString()
	{
		return "Wallet(length: " + length +")";
	}// toString()

}// abv.ds.Wallet

