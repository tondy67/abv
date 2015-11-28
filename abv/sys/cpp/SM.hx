package abv.sys.cpp;

import abv.cpu.Timer;
import abv.ST;
import abv.ds.AMap;

using abv.ds.TP;
using abv.lib.CC;

@:dce
class SM {
	
	var width_:Float 	= CC.WIDTH;
	var height_:Float 	= CC.HEIGHT;

	public static var args(get,never):Array<String>;
	static var _args:Array<String> = null;
	static function get_args()
	{
		if(_args == null) _args = Sys.args();
		return _args;
	}
	
	public static var env(get,never):AMap<String,String>;
	static var _env:AMap<String,String> = null;
	static function get_env()
	{
		if(_env == null){
			var t = Sys.environment();
			for(k in t.keys())_env.set(k,t[k]);
		}
		return _env;
	}

    var updateTime:Float 	= 0;
	var last = Timer.stamp();
	public static var err = 0;
	var cfg:AMap<String,String>;
	public static var trace = haxe.Log.trace; 
	
	public function new(_config="")
	{ 
		haxe.Log.trace = ST.trace;  

		var hlp = ["help","--help","-help","-h","/h"];
		
		if(hlp.indexOf(args[0]) != -1){
			print(INFO + "" + help("help"));
		}else{
			cfg = config(_config);
			init();
		}
		
 	}// new()

	function config(s:String) 
	{
		var r = new AMap<String,String>();
		
		return r;
	}// config()
	
	function init() 
	{
	}// init()
	
	function update(delta:Float=0)
	{   
	}// update()

	function help(opt="")
	{
		var r = "Usage: app [help]";

		if(opt=="help")r = "Help help help";

		return r;
	}// help()

	function print(msg:String,color="")
	{
		CC.print(msg,color);
	}// print()

	inline function onCreate() { create(); };
	function create() { };

	inline function onResize() { resize(); };
	function resize() { };

	inline function onStart() { start(); };
	function start() { };

	inline function onRestart() { restart(); };
	function restart() { };

	inline function onResume() { resume(); };
	function resume() { };

	inline function onPause() { pause(); };
	function pause() { };

	inline function onStop() { stop(); };
	function stop() { };

	inline function onDestroy() { destroy(); };
	function destroy() { };

/**
 * AbstractMachine properties
 **/
	function setSize()
	{
		width_ = CC.WIDTH;
		height_ = CC.HEIGHT; 
	}// setSize()
	
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

}// abv.sys.cpp.SM

