package abv.ds;
/**
 * Wallet
 **/
import haxe.crypto.Md5;

using abv.sys.ST;

@:dce
class Wallet{
// TODO: create vars, save state
	var sessions = new Map<String,Session>();
	public var length = 0;
	
	public inline function new(){}

	public inline function get(sid:String)
	{
		var r = new MapSS();
		if(sessions.exists(sid)){
			var exp = sessions[sid].expire;
			var last = sessions[sid].start + exp*1000; 
			if((exp == 0)||(Date.now().getTime() < last)){
				r = sessions[sid].data;
			}else{
				remove(sid);
			}
		}
 		return r;
	}// get()
	
	public inline function set(sid:String,data:MapSS)
	{
		var r = false;
		if(sessions.exists(sid)){
			sessions[sid].data = data;
			r = true;
		}
		return r;
	}// set()
	
	public inline function remove(sid:String)
	{
		var r = false;
		if(sessions.exists(sid)){
			sessions.set(sid,null);
			r = sessions.remove(sid);
		}
		return r;
	}// remove()
	
	public inline function add(expire=.0)
	{
		var now = Date.now().getTime();
		var sid = Md5.encode(Std.random(1000000) + now + "");
		var dt = new Map(); dt.set("sid",sid);
		if(sessions.exists(sid)){
			sid = "";
		}else{
			sessions.set(sid,new Session(now,expire,dt));
			length++;
		}
 		return sid;
	}// add()

	public function toString()
	{
		return "Wallet(length: " + length +")";
	}// toString()

}// abv.ds.Wallet

