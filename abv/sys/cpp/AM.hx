package abv.sys.cpp;

import haxe.Timer;

using abv.lib.Tools;

class AM {
	
	public static var verbose = 9;
	
	public var args(get,never):Array<String>;
	var _args = [""];
	function get_args(){return _args;}

	var last = Timer.stamp();
	var err = 0;
	var cfg:Map<String,String>;
	
	public function new(_config="")
	{
		_args = parseArgs(); 
		
		if(args.length == 0){ 
			print(help());
			exit();
		}else if(args[0].eq("help")){
			print(help("help"));
			exit();
		}else{
			cfg = config(_config);
			init();
		}
 	}// new()

	function parseArgs()
	{
		return Sys.args();
	}//parseArgs()
	
	function config(s:String) 
	{
		var r = new Map<String,String>();
		
		return r;
	}// config()
	
	function init() 
	{
	}// init()
	
	function update(delta:Float)
	{   
	}// update()

	function help(opt="")
	{
		var r = "Usage: app [help]";

		if(opt=="help")r = "Help help help";

		return r;
	}// help()

	function exit()
	{
		Sys.exit(err);
	}// exit()

	function log(msg="")
	{   
		Tools.log(msg);
	}// log()

	function print(msg="",level=1)
	{   
		if(verbose >= level){
			Sys.println(msg);
			log(msg);
		}
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

		if(os == "mac")os = "osx";
#if neko 
		run = "neko";
#elseif windows
		try home = Sys.getEnv("USERPROFILE") catch(m:Dynamic){}  
#end
 		var r = {lang:lang,os:os,home:home,run:run};
		return r;
	}// info()

}// abv.sys.cpp.AM

