package abv.lib;
/**
 * Common Constants & Tools
 * 
 **/
import haxe.crypto.Md5;

import abv.AM;
import abv.cpu.Timer;
import abv.lib.math.MT;
import abv.ST;

using abv.ds.TP;

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

enum LogLevels{
	OFF;
	FATAL;
	LOG;
	ERROR;
	INFO;
	WARN;
	DEBUG;
}

enum OsName{
	BSD;
	LINUX;
	MAC;
	WINDOWS;
}

@:dce
@:build(abv.macro.BM.buildConfig())
class CC{
// css
	public static inline var AUTO 	= -1;
// render context
	public static inline var CTX_1D = 1;
	public static inline var CTX_2D = 2;
	public static inline var CTX_3D = 3;

// Separators
	public static inline var SEP1 	= "|";
	public static inline var SEP3 	= "|||";

// constants
	public static inline var ERR 	= -1;
	public static inline var PI 	= 3.141592653589793;
	public static inline var LF 	= "\r\n";
	public static inline var LF2 	= "\r\n\r\n";
	public static inline var E 		= 2.220446049250313e-16;
// degree, radian
	public static inline var DEG 	= 0.01745329251;
	public static inline var RAD 	= 57.295779513;
// log 
	static var logData:Array<String>= [];
	static var logMax 				= 1 << 16;
//
	static var start = Timer.stamp();
	
	inline function new(){ }

	public static inline function md5(s:String)return Md5.encode(s);

	public static inline function int(f:Float)return Std.int(f);

	public static inline function json(s:String)
	{
		var r:Dynamic = null;
		if(good(s))
			try r = haxe.Json.parse(s) catch (m:Dynamic)trace(ERROR+m); 
		return r;
	}// json()
	
	public static inline function good(v:String,msg="")
	{ 
		var r = true;
		
		if(v == null){
			if(msg != "")trace(DEBUG+"Null String: "+msg); 
			r = false;
		}else if(v == ""){
			if(msg != "")trace(DEBUG+"Empty String: "+msg); 
			r = false;
		}
		
		return r;
	}// good()
	
	public static inline function eq(str:String,cmp:String)
	{
		return str.toLowerCase() == cmp.toLowerCase();
	}// eq()

	public static inline function dirname(path:String)
	{
		var r = "";
		if(good(path)){
			var sep = "/";
			r = path.trim();
			var a = r.splitt(sep); 
			if(a.length > 1){
				var last = a.pop();
				if(!good(last)) a.pop();
				r = a.join(sep) + "/";
			}
		}
		return r;
	}// dirname()
	
	public static inline function basename(path:String,ext=true)
	{
		var r = "";
		if(good(path)){
			r = path.replace(dirname(path),"");

			if(!ext){
				var sep = ".";
				var a = r.splitt(sep);
				a.pop();
				r = a.join(sep);
			}
		}
		return r;
	}// basename()
	
	public static function extname(path:String)
	{
		var r = ""; 
		if(good(path)){
			var sep = ".";
			var name = basename(path); 
			if(good(name)){  
				var a = name.splitt(sep); 
				if(a.length > 1)r = a.pop(); 
			}
		}
		return r;
	}// extname()

	public static inline function clear<T>(a:Array<T>)
	{
#if flash untyped a.length = 0; #else a.splice(0,a.length); #end
    }// clear<T>()
	
	public static inline function slash(s:String)
	{
		var r = "";
		if(good(s)){
			if(OS == WINDOWS) r = s.replace("/","\\");
			else r = s.replace("\\","/");
		}
		return r;
	}// slash()
	
	public static inline function getLog(line=0,filter="")
	{
		var r:Array<String> = [];

		if(line == MT.range(line,logData.length,1)){
			if(good(logData[line]))r.push(logData[line]);
		}else if(good(filter)){
			for(l in logData)if(l.indexOf(filter) != ERR)r.push(l); 
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
			print(m);
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
			msg = msg.replace(level+"","");
			color = lvl2color(level);
			ST.print(msg,color);
			log(msg.trim(),level);
		}
	}// print()

	public static inline function getLevel(s:String)
	{//AM.trace(s);
		var r = DEBUG;
		if(s.starts(OFF+"")) 		r = OFF;
		else if(s.starts(FATAL+"")) r = FATAL;
		else if(s.starts(LOG+"")) 	r = LOG;
		else if(s.starts(ERROR+"")) r = ERROR;
		else if(s.starts(INFO+"")) 	r = INFO;
		else if(s.starts(WARN+"")) 	r = WARN;

		return r;
	}// getLevel()

	public static inline function lvl2int(level:LogLevels)
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
	
	public static inline function lvl2color(level:LogLevels)
	{   
		return
			switch(level){
				case OFF: 	 "green";
				case FATAL:  "magenta";
				case LOG: 	 "cyan";
				case ERROR:  "red";
				case INFO: 	 "yellow";
				case WARN: 	 "white";
				case DEBUG:  "blue";
				default: 	 "";
			}
	}// lvl2color()

	public static inline function log(msg:String,level:LogLevels)
	{   
		if(good(msg)){
			logData.push(level+""+msg);
		}
	}// log()

// operating system
	public static var OS(get,never):OsName;
	static var _OS:OsName = null;
	static function get_OS()
	{
		if(_OS == null){
			var os = "";
#if flash 
			os = flash.system.Capabilities.os;
#elseif js 	
			os = js.Browser.navigator.platform; 
#else 
			os = Sys.systemName(); 
#end
			if(os.starts("Linux"))_OS = LINUX;
			else if(os.starts("Windows"))_OS = WINDOWS;
			else if(os.starts("Mac"))_OS = MAC;
			else if(os.starts("BSD"))_OS = BSD;
		}
		return _OS;
	}// get_OS()

}// abv.lib.CC

