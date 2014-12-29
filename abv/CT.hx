package abv;

import abv.AM;
import abv.lib.Timer;
import abv.lib.math.MT;
import abv.sys.ST;

using StringTools;

/**
 * Common Constants & Tools
 * 
 **/
@:dce
class CT{
//--- constants
	public static inline var AUTO:Int 		= -1;
	public static inline var PI:Float 		= 3.141592653589793;
// degree, radian
	public static inline var DEG:Float 		= 0.01745329251;
	public static inline var RAD:Float 		= 57.295779513;

	static var logData:Array<String> = [];
	static var start = Timer.stamp();

	public static inline function dow(week:Array<String>=null)
	{
		var w = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"];
		if(week != null) w = week;
		return w[Date.now().getDay()];
	}
	
	public static inline function month(months:Array<String>=null)
	{
		var m = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
		if(months != null) m = months;
		return m[Date.now().getMonth()];
	}
	
	public static inline function timezone()
	{
		var ms = 3600000;
		var now = Date.now();
		var y = now.getFullYear();
		var m = now.getMonth();
		var d = now.getDate();
		var n = new Date(y, m, d, 0, 0, 0 );
		var t =  n.getTime(); 
		return Std.int(24 * Math.ceil(t / 24 / ms ) - t/ms);  
	}// timezone();
	
	public static inline function json(s="")
	{
		var r:Dynamic = null;
		if(good(s))
			try r = haxe.Json.parse(s) catch (m:Dynamic){log('CT.json: $m');} 
		return r;
	}// json()
	
	public static inline function utf8(s:Null<String>,msg="")
	{
		var r = false;
		if(good(s,"CT.utf8")){
			r = haxe.Utf8.validate(s);
			if(!r)log(msg + " Not utf8"); 
		}
		return r;
	}// utf8()

	public static inline function fields(o:Dynamic)
	{ 
		var r:Array<String> = [];
		var a:Array<String> = null;
		var cmp = function(a:String,b:String){return a==b?0:a<b?-1:1;}
		
		if(o != null){
			switch(Type.typeof(o)){
				case TObject: 
					a = Reflect.fields(o);
					if(a != null){ 
						haxe.ds.ArraySort.sort(a, cmp);
						for(s in a)if(!s.startsWith("#"))r.push(s);
					};
				default: trace("Only Anonymous structures!");
			}
		}
		return r;
	}// fields()

	public static inline function good(v:String,msg="")
	{ 
		var r = true;
		function m(s){if(msg != ""){msg += ": ";log(msg+s);}}
		
		if(v == null){
			m("Null String"); 
			r = false;
		}else if(v == ""){
			m("Empty String");
			r = false;
		}
		
		return r;
	}// good()
	
	public static inline function has(src:String,what:String,start=0)
	{
		var r = false; 

		if(good(src,"has: src") && good(what,"has: what")){
			var len = src.length;
			start = Std.int(MT.range(start,len-1,0)); 
			var t = src.indexOf(what,start);
			if((t >= 0)&&(t < len))r = true;
		}
		
		return r;
	}// has()

	public static inline function eq(str:String,cmp:String)
	{
		return str.toLowerCase() == cmp.toLowerCase();
	}// eq()

	public static inline function dirname(path:Null<String>)
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
	
	public static inline function basename(path:Null<String>)
	{
		var sep = "/";
		var a = path.trim().split(sep); 
		var last = a.pop();
		if(!good(last))last = a.pop();
		return last;
	}// basename()
	
	public static function extname(path:Null<String>)
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
	
	public static function sortAZ(a:Array<String>)
	{
		var cmp = function(a:String,b:String){return a==b?0:a<b?-1:1;}
		if((a != null)&&(a.length > 0))haxe.ds.ArraySort.sort(a, cmp);
	}// sortAZ()
	
	public static inline function log(msg="")
	{
		var d = Timer.stamp() - start;
		var now = "now:", pnow = '$now $d', err="err:",perr='$err $d';
		if((msg == null)||(msg == ""))msg = pnow;
		else if(msg.startsWith(now))msg = pnow + msg.replace(now,":");
		else if(msg.startsWith(err))msg = perr + msg.replace(err,":");
		logData.push(msg.trim());
	}// log()

	public static inline function getLog(line=0,filter="")
	{
		var r:Array<String> = [];

		if(line == MT.range(line,logData.length,1)){
			if(good(logData[line],'getLog: $line'))r.push(logData[line]);
		}else r = logData;

		if(filter != ""){
			var t:Array<String> = [];
			for(l in logData)if(l.indexOf(filter) != -1)t.push(l);
			r = t;
		}
		
		return r;
	}// getLog()

///
	public static inline function printLog()
	{   
		ST.printLog();
	}// printLog()

	public static inline function unique<T>(a:Array<T>)
	{
		var r:Array<String> = [];
		return r;
    }// unique()
	
	public static inline function clear<T>(a:Array<T>)
	{
		ST.clear(a);
    }// clear()
	
	public static inline function exists(path:Null<String>,msg="")
	{ 
		return ST.exists(path,msg);
	}// exists()

	public static inline function dir(path:Null<String>,msg="")
	{
		return ST.dir(path,msg);
	}// dir()
	
	public static inline function print(msg="",level=1)
	{   
		ST.print(msg,level);
	}// print()


}// abv.CT

