package abv;
/**
 * Common Constants & Tools
 * 
 **/
import abv.cpu.Mutex;
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
class CR{
// constants
	public static inline var AUTO 		= -1;
	public static inline var PI 		= 3.141592653589793;
	public static inline var LF 		= "\r\n";
	public static inline var LF2 		= "\r\n\r\n";
// degree, radian
	public static inline var DEG 		= 0.01745329251;
	public static inline var RAD 		= 57.295779513;
// SEP3arators
	public static inline var SEP1 		= "|";
	public static inline var SEP3 		= "|||";
// log 
	static var logData:Array<String>	= [];
	static var logMax 					= 1 << 16;
//
	static var start = Timer.stamp();
	public static var lock(default,null)= new Mutex();

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
	
	public static inline function eq(str:String,cmp:String)
	{
		return str.toLowerCase() == cmp.toLowerCase();
	}// eq()

	public static inline function dirname(path:Null<String>)
	{
		var SEP3 = "/";
		var r = ".";
		var a = path.trim().splitt(SEP3); 
		if(a.length > 1){
			var last = a.pop();
			if(!good(last))last = a.pop();
			r = a.join(SEP3);
		}
		return r;
	}// dirname()
	
	public static inline function basename(path:Null<String>,ext=true)
	{
		var r = "";
		var SEP3 = "/";
		var a = path.trim().splitt(SEP3); 
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
		var r = "", SEP3 = ".";
		var name = basename(path);
		if(!name.starts(".")){  
			var a = name.splitt(SEP3); 
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
			if(good(logData[line]))r.push(logData[line]);
		}else if(good(filter)){
			for(l in logData)if(l.indexOf(filter) != -1)r.push(l); 
		}else r = logData;
 
		return r;
	}// getLog()

///
	public static inline function printLog(last=1024)
	{   
		var t:Array<String>;
		var a = getLog();
		a = a.slice(a.length - last);
		for(m in a){ 
			t = m.splitt(SEP3); 
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
		if(lvl2int(AM.verbose) >= lvl2int(level)){ 
			var d = (Timer.stamp() - start) + " ";
			if(!good(msg))msg = d;
			if(msg.starts("now:"))msg = msg.replace("now:",d);
			if(!AM.silent)ST.print(msg,level);
			log(level + SEP3 + msg.trim());
		}
	}// print()

	public static inline function lvl2int(level:LogLevel)
	{
		return
			switch(level){
				case OFF: 	 0;
				case FATAL:  1;
				case LOG: 	 2;
				case ERROR:  3;
				case INFO: 	 4;
				case WARN: 	 5;
				case DEBUG:  6;
				default: 	 0;
			}
	}// lvl2int()
	
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

}// abv.CR

