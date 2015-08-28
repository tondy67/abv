package abv.sys.cpp;

import abv.cpu.Timer;
import abv.sys.ST;

using abv.lib.TP;
using abv.lib.CC;

@:dce
class AM {
	
	public static var verbose 	= DEBUG;
	public static var exitTime 	= .0;
	public static var silent 	= false;
	public static var logFile	= "";
	public static var colors 	= true;

	public static var args(get,never):Array<String>;
	static var _args:Array<String> = null;
	static function get_args()
	{
		if(_args == null) _args = Sys.args();
		return _args;
	}
	
	public static var env(get,never):Map<String,String>;
	static var _env:Map<String,String> = null;
	static function get_env()
	{
		if(_env == null) _env = Sys.environment();
		return _env;
	}

    var updateTime:Float 	= 0;
	var last = Timer.stamp();
	public static var err = 0;
	var cfg:Map<String,String>;
	public static var trace = haxe.Log.trace; 
	
	public function new(_config="")
	{ 
		haxe.Log.trace = ST.trace;  

		var hlp = ["help","--help","-help","-h","/h"];
		
		if(hlp.indexOf(args[0]) != -1){
			print(INFO + "" + help("help"));
			exit();
		}else{
			cfg = config(_config);
			init();
		}
		
		colors = true;
 	}// new()

	function config(s:String) 
	{
		var r = new Map<String,String>();
		
		return r;
	}// config()
	
	function init() 
	{
	}// init()
	
	function update(delta:Null<Float> = null)
	{   
	}// update()

	function help(opt="")
	{
		var r = "Usage: app [help]";

		if(opt=="help")r = "Help help help";

		return r;
	}// help()

	public static inline function exit()
	{
		Sys.sleep(.5);
		Sys.exit(err);
	}// exit()

	function print(msg:String,color="")
	{
		CC.print(msg,color);
	}// print()


/**
 * AbstractMachine properties
 **/
	public static function info()
	{
		var lang = "",os = CC.OS,home = "",run = "cpp";

		try lang = Sys.getEnv("LANG") catch(m:Dynamic){} 
		try home = Sys.getEnv("HOME") catch(m:Dynamic){}  

#if neko 
		run = "neko";
#elseif windows
		try home = Sys.getEnv("USERPROFILE") catch(m:Dynamic){}  
#end
		if(lang.good())lang = lang.substr(0,2);
 
		return {lang:lang,os:os,home:home,run:run};
	}// info()

}// abv.sys.cpp.AM

