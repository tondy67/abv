package abv.lib;


using StringTools;

/**
 * Tools
 **/
class Tools{

	static var logData:Array<String> = [];
	static var start = Sys.time();

	static function __init__()
	{
    }// __init__()

	public static inline function json(s:String)
	{
		var r:Dynamic = null;
		try r = haxe.Json.parse(s) catch (m:Dynamic) { log("json: "+m); } 
		return r;
	}// json()
	
	public static inline function utf8(s:Null<String>,msg="")
	{
		var r = false;
		if(good(s,"utf8")){
			r = haxe.Utf8.validate(s);
			if(!r)log(msg + "Not utf8"); 
		}
		return r;
	}// utf8()

	public static inline function good(s:Null<String>,msg="")
	{ 
		var r = true;
		var v = msg == ""?false:true;

		if(s == null){
			if(v)log(msg + ": Null"); 
			r = false;
		}else if(s == ""){
			if(v)log(msg + ": Empty"); 
			r = false;
		}
		
		return r;
	}// good()

	public static inline function has(src:String,what:String,start=0)
	{
		var r = false; 

		if(good(src,"has: src") && good(what,"has: what")){
			var len = src.length;
			start = Std.int(range(start,len-1,0)); 
			var t = src.indexOf(what,start);
			if((t >= 0)&&(t < len))r = true;
		}
		
		return r;
	}// has()

	public static inline function num(f:Null<Float>,msg="")
	{ 
		var r = true;

		if(f == null){
			log(msg + "Null value"); 
			r = false;
		}else if(f == Math.NaN){
			log(msg + "NaN value"); 
			r = false;
		}else if(f == Math.NEGATIVE_INFINITY){
			log(msg + "NEGATIVE_INFINITY value"); 
			r = false;
		}else if(f == Math.POSITIVE_INFINITY){
			log(msg + "POSITIVE_INFINITY value"); 
			r = false;
		}

		return r;
	}// num()

	public static inline function range(f:Null<Float>,max:Float, min:Float=0)
	{
		if(num(f,"range")){
			if(f >= max)f = max;
			else if(f <= min)f = min; 
		}else f = 0;
		
		return f;
	}// range()
	
	public static inline function clear<T>(a:Array<T>)
	{
#if (cpp||php) a.splice(0,a.length); #else untyped a.length = 0; #end
    }// clear()
	
	public static inline function exists(path:Null<String>,msg="")
	{ 
		var r = true;
		
		if(good(path,msg) && !sys.FileSystem.exists(path)){
			if(msg != "")log(msg + ": No such file or directory"); 
			r = false;
		}

		return r;
	}// exists()

	public static inline function dir(path:String,msg="")
	{
		return exists(path,msg) && sys.FileSystem.isDirectory(path);
	}// dir()
	
	public static inline function eq(str:String,cmp:String)
	{
		return str.toLowerCase() == cmp.toLowerCase();
	}// eq()

	public static inline function dirname(path:String)
	{
		var sep = "/";
		var r = ".";
		var a = path.trim().split(sep); 
		if(a.length > 1){
			var last = a.pop();
			if(!good(last))last = a.pop();
			r = a.join(sep);
		}
		return r;
	}// dirname()
	
	public static inline function basename(path:String)
	{
		var sep = "/";
		var a = path.trim().split(sep); 
		var last = a.pop();
		if(!good(last))last = a.pop();
		return last;
	}// basename()
	
	public static function extname(path:String)
	{
		var r = "", sep = ".", name = basename(path); 
		if(good(name,"ext")){
			var a = name.split(sep); 
			if(a.length > 1){
				r = a.pop();
				if(!good(r))r = a.pop();
			}
		}
		return r;
	}// extname()

	public static inline function sort<T>(a:Array<T>, cmp:T->T->Int)
	{
		if((a != null)&&(cmp != null))haxe.ds.ArraySort.sort(a, cmp);
	}// sort<T>()
	
	public static inline function log(msg="")
	{
		if((msg == null)||(msg == ""))msg = "> time: " + (Sys.time() - start);
		else msg = "> "+msg;
		logData.push(msg);
	}// log()

	public static function getLog(line=0,filter="")
	{
		var r:Array<String> = [];

		if(line == range(line,logData.length,1)){
			if(good(logData[line],'getLog: $line'))r.push(logData[line]);
		}else r = logData;

		if(filter != ""){
			var t:Array<String> = [];
			for(l in logData)if(l.indexOf(filter) != -1)t.push(l);
			r = t;
		}
		
		return r;
	}// getLog()

	

}// abv.lib.Tools

