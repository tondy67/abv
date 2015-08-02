package abv.lib;
/**
 * Common Constants & Tools
 * 
 **/
import haxe.crypto.Md5;

import abv.AM;
import abv.cpu.Timer;
import abv.lib.math.MT;
import abv.sys.ST;

using abv.lib.TP;

enum States{
	DISABLED;
	NORMAL;
	ACTIVE;
	VISITED;
	HOVER;
	FOCUS;
	LINK;
	PRESSED;
	CLICK;
}

@:dce
class CR{

//  Levels
	public static inline var OFF 	= "OFF:";
	public static inline var FATAL 	= "FATAL:";
	public static inline var LOG 	= "LOG:";
	public static inline var ERROR 	= "ERROR:";
	public static inline var INFO 	= "INFO:";
	public static inline var WARN 	= "WARN:";
	public static inline var DEBUG 	= "DEBUG:";
// Separators
	public static inline var SEP1 		= "|";
	public static inline var SEP3 		= "|||";

// constants
	public static inline var AUTO 		= -1;
	public static inline var PI 		= 3.141592653589793;
	public static inline var LF 		= "\r\n";
	public static inline var LF2 		= "\r\n\r\n";
// degree, radian
	public static inline var DEG 		= 0.01745329251;
	public static inline var RAD 		= 57.295779513;
// log 
	static var logData:Array<String>	= [];
	static var logMax 					= 1 << 16;
//
	static var start = Timer.stamp();

	inline function new(){ }

	public static inline function md5(s:String)
	{
		return Md5.encode(s);
	}// md5()

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
		return int(24 * Math.ceil(t / 24 / ms ) - t/ms);  
	}// timezone();
	
	public static inline function int(f:Float)return Std.int(f);

	public static inline function json(s="")
	{
		var r:Dynamic = null;
		if(good(s))
			try r = haxe.Json.parse(s) catch (m:Dynamic){trace(ERROR+m);} 
		return r;
	}// json()
	
	public static inline function good(v:String,msg="")
	{ 
		var r = true;
		function m(s){if(msg != ""){trace(DEBUG+msg+s);}}
		
		if(v == null){
			m(" Null String"); 
			r = false;
		}else if(v == ""){
			m(" Empty String");
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
		var sep = "/";
		var a = path.trim().splitt(sep); 
		r = a.pop(); 
//		if(!good(r))r = a.pop();
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
		if(good(name) && !name.starts(".")){  
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
#if flash untyped a.length = 0; #else a.splice(0,a.length); #end
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
			ST.print(t[1],lvl2color(t[0]));
		}
	}// printLog()

	public static inline function unique<T>(a:Array<T>)
	{
		var r:Array<String> = [];
		return r;
    }// unique()
	
	public static inline function print(msg="",color="")
	{   
		if(good(msg)){
			var level = getLevel(msg);
			if(good(level)){
				msg = msg.replace(level,"");
				color = lvl2color(level);
			}
			ST.print(msg,color);
			log(msg.trim(),level);
		}
	}// print()

	public static inline function getLevel(s:String)
	{//AM.trace(s);
		var r = "";
		if(s.starts(OFF)) 			r = OFF;
		else if(s.starts(FATAL)) 	r = FATAL;
		else if(s.starts(LOG)) 		r = LOG;
		else if(s.starts(ERROR)) 	r = ERROR;
		else if(s.starts(INFO)) 	r = INFO;
		else if(s.starts(WARN)) 	r = WARN;
		else if(s.starts(DEBUG)) 	r = DEBUG;
		return r;
	}// getLevel()

	public static inline function lvl2int(level:String)
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
	
	public static inline function lvl2color(level:String)
	{   
		var r = "";
		if(good(level)){
			if(level == CR.OFF)r = "green";
			else if(level == CR.FATAL)r = "magenta";
			else if(level == CR.LOG)r = "cyan";
			else if(level == CR.ERROR)r = "red";
			else if(level == CR.WARN)r = "yellow";
			else if(level == CR.INFO)r = "white";
			else if(level == CR.DEBUG)r = "blue";
		}
		return r;
	}// lvl2color()

	public static inline function log(msg:String,level="")
	{   
		if(good(msg)){
			if(!good(level))level = LOG;
			logData.push(level+SEP3+msg);
		}
	}// log()

}// abv.lib.CR

