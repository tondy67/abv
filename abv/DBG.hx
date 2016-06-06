package abv;
/**
 * Log & Debug & Profiler class
 **/ 

import haxe.Timer;

using abv.sys.ST;

@:dce
class DBG{

	static var logs  = new List<String>();
	static var calls = new Map<String,Int>();
	static var cur   = .0;

	public static inline function bp(s:Dynamic,d:Dynamic=null)
	{
		var t = d == null ? s + "" : s + ": " + d;
		print();
		throw "Breakpoint> " + t;
	}// bp()

	public static inline function watch(s="",v:Dynamic=null)
	{
		var d = .0;
		if (cur > 0){
			var end = Timer.stamp(); 
			d = end - cur; 
			cur = end;
		}else{
			cur = Timer.stamp();
		}
		if (v != null) s += ": " + v;
		log(pad(d,9),s);
		return d;
	}// watch()

	public static inline function call(s:String)
	{
		if (calls[s] == null) calls.set(s,0);
		calls[s] += 1;
	}// call()

	public static inline function print()
	{
		var t:Array<String>;
		ST.info("=== Watch ===",null,null);
		for (it in logs){
			t = it.split(",");
			ST.debug(t[0],t[1],null);
		}
		ST.info("=== Calls ===",null,null);
		for (k in calls.keys()) ST.debug(" " + k,calls[k],null);
	}// print()

	public static inline function log(s:String,m="")
	{
		logs.add('$s,$m');
	}// log()

	static inline function pad(v:Float,len:Int)
	{
		var z = "0.0000000000000000";
		var s = v == 0? z : v + "";
		return s.substr(0,len);
	}
///
}// abv.DBG

