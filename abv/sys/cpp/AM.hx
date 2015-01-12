package abv.sys.cpp;

import abv.lib.Timer;

using abv.CR;

class AM {
	
	public static var exitTime 	= .0;
	public static var verbose:LogLevel 	= DEBUG;
	public static var silent 	= false;
	public static var usage 	= true;
	public static var colors 	= true;
	
	static var _args:Array<String>;
	static var _env:Map<String,String>;

    var updateTime:Float 	= 0;
	var last = Timer.stamp();
	public static var err = 0;
	var cfg:Map<String,String>;
	
	public function new(_config="")
	{
		args();

		if(!usage){}
		else if(_args.length == 0){ 
			print(help(),INFO);
			exit();
		}else if(_args[0].eq("help")){
			print(help("help"),INFO);
			exit();
		}else{
			cfg = config(_config);
			init();
		}
 	}// new()

	public static inline function args()      
	{
		if(_args == null) _args = Sys.args();
		return _args.copy();
	}//args()
	
	public static inline function env()      
	{
		if(_env == null) _env = Sys.environment();
		return _env;
	}//env()
	
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

	public static inline function sleep(seconds:Float)
	{
		Sys.sleep(seconds);
	}// sleep()

	public static inline function exit()
	{
		sleep(.5);
		Sys.exit(err);
	}// exit()

	function print(msg="",level:LogLevel)
	{
		CR.print(msg,level);
	}// print()


/**
 * AbstractMachine properties
 **/
	public static function info()
	{
		var lang = "",os = "",home = "",run = "cpp";

		try lang = Sys.getEnv("LANG") catch(m:Dynamic){} 
		try os = Sys.systemName().toLowerCase() catch(m:Dynamic){} 
		try home = Sys.getEnv("HOME") catch(m:Dynamic){}  

#if neko 
		run = "neko";
#elseif windows
		try home = Sys.getEnv("USERPROFILE") catch(m:Dynamic){}  
#end
 		var r = {lang:lang,os:os,home:home,run:run};
		return r;
	}// info()

}// abv.sys.cpp.AM

