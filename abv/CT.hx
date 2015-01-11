package abv;
/**
 * Common Constants & Tools
 * 
 **/
import abv.AM;
import abv.lib.Timer;
import abv.lib.math.MT;
import abv.sys.ST;

using abv.lib.TP;

enum LogLevel{
	OFF;
	FATAL;
	LOG;
	ERROR;
	INFO;
	WARN;
	DEBUG;
}

@:dce
class CT{
// constants
	public static inline var AUTO 		= -1;
	public static inline var PI 		= 3.141592653589793;
	public static inline var CR 		= "\n\r";
// degree, radian
	public static inline var DEG 		= 0.01745329251;
	public static inline var RAD 		= 57.295779513;
// separator
	public static inline var sep 		= "|||";
// log 
	static var logData:Array<String> 	= [];
	static var logMax 					= 1 << 16;
	public static var logFile			= "";
//
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
			try r = haxe.Json.parse(s) catch (m:Dynamic){print(m,ERROR);} 
		return r;
	}// json()
	
	public static inline function utf8(s:Null<String>,msg="")
	{
		var r = false;
		if(good(s,msg)){
			r = haxe.Utf8.validate(s);
			if(!r)print(msg + " Not utf8",ERROR); 
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
						for(s in a)if(!s.starts("#"))r.push(s);
					};
				default: trace("Only Anonymous structures!");
			}
		}
		return r;
	}// fields()

	public static inline function good(v:String,msg="",?pif:haxe.PosInfos)
	{ 
#if debug msg = '${pif.fileName}->${pif.methodName}:$msg)'; #else msg = "";#end
		var r = true;
		function m(s){if(msg != ""){msg += " ";print(msg+s,WARN);}}
		
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

		if(good(src) && good(what,"what")){
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
		var a = path.trim().splitt(sep); 
		if(a.length > 1){
			var last = a.pop();
			if(!good(last))last = a.pop();
			r = a.join(sep);
		}
		return r;
	}// dirname()
	
	public static inline function basename(path:Null<String>,ext=true)
	{
		var r = "";
		var sep = "/";
		var a = path.trim().splitt(sep); 
		r = a.pop();
		if(!good(r))r = a.pop();
		if(!ext){
			var t = r.splitt(".");
			r = t[0];
		}
		
		return r;
	}// basename()
	
	public static function extname(path:Null<String>)
	{
		var r = "", sep = ".";
		var name = basename(path);
		if(!name.starts(".")){  
			var a = name.splitt(sep); 
			if(a.length > 1)r = a.pop(); 
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
	
	public static inline function clear<T>(a:Array<T>)
	{
		a.splice(0,a.length); 
    }// clear()
	
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
	public static inline function printLog(last=1024)
	{   
		var t:Array<String>;
		var a = getLog();
		a = a.slice(a.length - last);
		for(m in a){ 
			t = m.splitt(sep); 
			ST.print(t[1],getLogLevel(t[0]));
		}
	}// printLog()

	public static inline function unique<T>(a:Array<T>)
	{
		var r:Array<String> = [];
		return r;
    }// unique()
	
	public static inline function print(msg="",level:LogLevel)
	{   
		var s = "OFF FATAL LOG ERROR INFO WARN DEBUG";
		var a = s.indexOf(AM.verbose+"");
		var b = s.indexOf(level+""); //trace(a+":"+b);
		if(a >= b){ // AM.verbose >= level
			var d = (Timer.stamp() - start) + " ";
			if(!good(msg))msg = d;
			if(msg.starts("now:"))msg = msg.replace("now:",d);
			if(!AM.silent)ST.print(msg,level);
			log(level + sep + msg.trim());
		}
	}// print()

	public static inline function getLogLevel(s="")
	{   
		var r:LogLevel;
		switch(s){
			case "OFF": 	r = OFF;
			case "FATAL": 	r = FATAL;
			case "LOG": 	r = LOG;
			case "ERROR": 	r = ERROR;
			case "INFO": 	r = INFO;
			case "WARN": 	r = WARN;
			case "DEBUG": 	r = DEBUG;
			default: r = INFO;
		}
		return r;
	}// getLogLevel()


	public static inline function log(msg="")
	{   
		if(good(msg))logData.push(msg);
	}// log()

	public static inline function key(m:Map<String,String>,k:String,v="")
	{   
		var r = false;
		if(good(k) && m.exists(k) && (m[k] == v)) r = true;

		return r;
	}// key()

}// abv.CT

