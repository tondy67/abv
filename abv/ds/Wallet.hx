package abv.ds;
/**
 * Wallet
 **/
import haxe.crypto.Md5;

typedef SessionData = {start:Float, expire:Float, data:AMap<String,String>}

@:dce
class Wallet{
// TODO: create vars, save state
	var sessions = new AMap<String,SessionData>();
	
	public inline function new(){}

	public inline function get(sid:String)
	{
		var r = new AMap<String,String>();
		if(sessions.exists(sid)){
			var exp = sessions[sid].expire;
			var last = sessions[sid].start + exp*1000; 
			if((exp == 0)||(Date.now().getTime() < last))r = sessions[sid].data;
			else del(sid);
		}
 		return r;
	}// get()
	
	public inline function set(sid:String,data:AMap<String,String>)
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
			sessions.set(sid,null);
			r = sessions.remove(sid);
		}
		return r;
	}// del()
	
	public inline function add(expire=.0)
	{
		var now = Date.now().getTime();
		var sid = Md5.encode(Std.random(1000000) + now + "");
		var dt = new AMap(); dt.set("sid",sid);
		if(sessions.exists(sid))sid = "";
		else sessions.set(sid,{start:now,expire:expire,data:dt});
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

