package abv.sys;

#if !build
import abv.style.Font;
#end 

#if !(flash || js)
import sys.io.File;
import sys.FileSystem;
#end

import haxe.io.Bytes;
import haxe.io.BytesData;
import haxe.PosInfos;
import haxe.Json;
import haxe.Timer;

using haxe.io.Path;
using StringTools;

#if (!build && !macro) 
typedef CC = abv.CC;
typedef DBG = abv.DBG;
#end 
typedef MapSS = Map<String,String>;
typedef MapIS = Map<Int,String>;
typedef MapSI = Map<String,Int>;
typedef MapSB = Map<String,Bytes>;
/* chmod +x gradlew
 * ./gradlew installDebug
 * adb -d logcat com.tondy.snake:I *:S
 */
@:dce
class ST {

// log levels
	public static inline var OFF 	= 0;
	public static inline var ERROR 	= 1;
	public static inline var WARN 	= 2;
	public static inline var INFO 	= 3;
	public static inline var DEBUG 	= 4;
	public static inline var LOG 	= 5;
///
	public static var NOGUI 		= false;
	public static var SILENT 		= false;
	public static var COLORS 		= #if nocolor false; #else true; #end 
	public static var VERBOSE 		= 
#if !build
 #if error ERROR; #elseif warn WARN; #elseif info INFO; 
 #elseif debug DEBUG; #elseif log LOG; #else OFF; #end
#else LOG; #end

	public static inline var RES_DIR = "res";
// operating system
	public static var OS(get,never):String;
	static var _OS = "";
	static function get_OS()
	{
		if(_OS == ""){
			var os = "";
#if flash 
			os = flash.system.Capabilities.os;
#elseif js 	
			os = js.Browser.navigator.platform; 
#else 
			os = Sys.systemName(); 
#end
			if(os.startsWith("Linux"))_OS = "Linux";
			else if(os.startsWith("Windows"))_OS = "Windows";
			else if(os.startsWith("Mac"))_OS = "Mac";
			else if(os.startsWith("BSD"))_OS = "BSD";
		}
		return _OS;
	}// get_OS()

	public static var args(get,never):Array<String>;
	static var _args:Array<String> = null;
	static function get_args()
	{
		if(_args == null){
#if flash
			_args = [""];
#elseif js
			_args = [""];
#else
			_args = Sys.args();
#end 
		}
		return _args;
	}//

// log 
	static var logs:Array<String>= [];
	static var maxLogs 			= 1 << 16;
	public static var start 	= Timer.stamp();

	static var T:Array<String> 	= initText();
	public static inline var BUILD_DIR  = "build/";
	public static inline var CFG_FILE 	= "abv.json";
#if !build
	static var F:Array<Font> 	= [];
	public static inline var TARGET =
 #if flash "flash" #elseif js "js" #elseif cpp "cpp" #elseif neko "neko" 
 #elseif android "android" #elseif ios "ios" #elseif java "java" #end ;
#else 	
	var arch = "";
	var CONN = " --connect 6000 ";
	static inline var FLASH 	= "flash";
	static inline var JS 		= "js";
	static inline var NEKO 		= "neko";
	static inline var CPP 		= "cpp";
	static inline var JAVA 		= "java";
	static inline var ANDROID 	= "android";
	static inline var IOS 		= "ios";
	static inline var ENGINE 	= "engine";
	static inline var HTML_FILE = "index.html";
	static inline var MAINCLASS = "Boot";
	static inline var GIT_URL 	= "https://github.com/tondy67/";
	static inline var HL 		= "haxelib";
	static var TOOLS_DIR		= "";
	static var TARGETS 	= [FLASH,JS,NEKO,CPP,JAVA,ANDROID,IOS,ENGINE];
//

	var cfg:Dynamic = null;
	var projectDir:String;
	var browser:String;
	var app:String;
	var ndll :String;
	var target:String;
	var verbose:String;
	var targets:Array<String> = [];
	var libs:Array<String> = [];
	var src:Array<String>  = [];
	var opt:Array<String>  = ["haxeJSON"];
	var res:Array<String>  = [];

	public function new()
	{ 
		init(); 
		create();
	}// new()
	
 	function init()
	{
		var a:Array<String>;
		var path = Sys.programPath();
		var self = basename(path)  +  ".n";
		projectDir = dirname(path); 
		cd(projectDir);
		projectDir = pwd();
		if(exists(self))rm(self);

		arch = osArch(); 
		ndll = TOOLS_DIR + "libs/" + OS + "/";
		switch(OS){
			case "Linux": 
				ndll  += arch  +  "/libABV.so"; 
				browser = "xdg-open";
			case "Windows": 
				ndll  += "ABV.dll"; 
				browser = "start";
			case "Mac": "";
				browser = "open";
			default: browser = "";
		}

		try cfg = getJson(CFG_FILE)catch(m:Dynamic){error(m);};
		if(cfg == null)exit(getText(22));
		var v:Array<String> = [];  
		if(cfg.name == null) v.push("name");
		if(cfg.main == null) v.push("main");
		if(cfg.targets == null) v.push("targets");
		if(v.length > 0)exit("no cfg values: " + v.join(", "));

		app = cfg.name;

		a = cfg.targets;
		a = unique(a);
		for(i in 0...a.length){
			a[i] = a[i].toLowerCase();
			if(TARGETS.indexOf(a[i]) != -1) targets.push(a[i]);
		}

		if (cfg.libs != null) libs = cfg.libs; 
		libs.push("abv");
		if (cfg.src != null)  src  = cfg.src; 
		if (cfg.opt != null)  opt  = cfg.opt; 

		if(cfg.resources != null){
			var a:Array<String> = cfg.resources ;
			for(l in a)res.push(l);
		}

		if((cfg.width == null) || (cfg.height == null) || 
			(cfg.ups == null) || (cfg.ups == 0)) NOGUI = true;
		COLORS = args.join(",").indexOf("nocolor") == -1 ? true : false;
 
		var c = "";
		if(good(args[2]))c = args[2].toLowerCase();
		verbose = switch(c){
			case "error": "error";  
			case "warn" : "warn";  
			case "info" : "info";  
			case "debug": "debug";  
			case "log"  : "log";  
			default: "";  
		}  

		if(good(args[1]))c = args[1].toLowerCase();
		target = switch(c){
			case FLASH: 	FLASH;
			case JS:		JS;
			case NEKO: 		NEKO;
			case CPP: 		CPP;
			case JAVA: 		JAVA;
			case ANDROID: 	ANDROID;
			case IOS	: 	IOS;
			case ENGINE	: 	ENGINE;
			default: "";
		}

		if (command("haxe",["--connect","6000"]) != 0){
			neko.vm.Thread.create(exec.bind("haxe",["--wait","6000","&"]));
			log("Start","haxe server");
		}
				

	}// init()
	
	function pathLib(name:String)
	{
		var r = "";
		setupLib(name);
		var t = exec(HL,["path",name]).split("\n");
		var p = t[0].trim();		
		if (isDir(p)) r = p;
		return r;
	}// pathLib()

	function isLib(name:String)
	{
		var r = false;
		var s = exec(HL,["list",name]);		
		if (s.indexOf(name+":") != -1) r = true;
		return r;
	}// isLib()

	function setupLib(name:String, url="")
	{
		info("Check", name, null);
		if (isLib(name)) return;
		warn('Do you want to install $name library? (y/n)', null, null);
		var s = read();	
		if (s == "y"){
			if (good(url)) command(HL,["git",name,url]);
			else command(HL,["install",name]);

			if (!isLib(name)) exit("Bye");	
		}else{
			exit("Bye");
		}
	}// setupLib()

	function create()
	{
		var c = "";
		if(good(args[0]))c = args[0].toLowerCase();
		switch(c){
			case "info": 	projectInfo();
			case "rebuild": rebuild(); build();
			case "build": 	build();
			case "run": 	run();
			case "test": 	test();
			default: help();
		}
	}// create()

	function projectInfo()
	{
		warn("Name    ", app,null);
		if((cfg.width != null) && (cfg.height != null))
							   warn("Size    ", cfg.width + "x" + cfg.height,null);
		if(cfg.ups != null)    warn("FPS     ", cfg.ups,null);
		if(cfg.version != null)warn("Version ", cfg.version,null);
		if(cfg.author != null) warn("Author  ", cfg.author,null);
		if(cfg.web != null)    warn("Web     ", cfg.web,null);
		if(cfg.desc != null)   warn("Desc    ", cfg.desc,null);
		warn("Targets ", targets.join(","),null);
	}// projectInfo()
	
	function getOptions()
	{
		var r = "-main abv."  +  MAINCLASS;

		libs = unique(libs);
		for(it in libs)if (good(it)) r += " -lib "  +  it;
		src = unique(src);
		for(it in src) if (good(it)) r += " -cp "  +  it;
		opt = unique(opt);
		for(it in opt) if (good(it)) r += " -D "  +  it;

//		
		if (!NOGUI) r  += " -D gui";
		if (!COLORS) r  += " -D nocolor";

		if(good(verbose))r  += " -D "  +  verbose;
		if(verbose == "log")r  += " --times ";
		if((verbose != "debug") && (target != FLASH))r  += " -D no-traces";
		if(target == ANDROID)r  += " -D "  +  ANDROID  +  " -D no-compilation";
		if(target == IOS)r  += " -D "  +  IOS  +  " -lib hxcpp -D static_link ";
		if(target == ENGINE)r  += " -D "  +  ENGINE  +  " -D static_link";
//if(target == JAVA)r  += " -D no-compilation";

		return r;
	}// getOptions()

	function build()
	{ 
		var out = "";
		var dir = ""; 

		if (targets.indexOf(target) == -1) exit("Supported targets: " + targets.join(","));

		if (!exists(BUILD_DIR)) setupLib("abv",GIT_URL + "abv"); 

		switch(target){
			case FLASH: 
				dir = addSlash(BUILD_DIR + FLASH);
				out = " -swf " +  dir  + app + ".swf -swf-version 11.2 -swf-header " + cfg.width + ":" + cfg.height + ":32:FFFFFF  ";
			case JS:
				dir = addSlash(BUILD_DIR + JS);
				out = " -js " +  dir  +  app  +  ".js";
			case NEKO:
				dir = addSlash(BUILD_DIR + NEKO);
				out = " -neko " +  dir  +  app  +  ".n";
			case CPP:
				dir = addSlash(BUILD_DIR + CPP);
				out = " -cpp " +  dir ;
			case JAVA:
				dir = addSlash(BUILD_DIR + JAVA);
				out = " -java " +  dir;
			case ANDROID:
				dir = addSlash(BUILD_DIR + ANDROID + "/app/src/main/java"); // "/app/src/main/java"
				rm(BUILD_DIR  +  ANDROID,true);
				out = " -java " +  dir;
				var sdk = envKey("ANDROID_HOME"); 
				if (sdk == "") sdk = OS == "Windows" ? "C:\\":"/opt/" + "android-sdk";
				out  += ' -java-lib $sdk/platforms/android-19/android.jar';
			case IOS: 
				dir = addSlash(BUILD_DIR + IOS);
				out = " -cpp " +  dir  +  " -D simulator ";//-D HXCPP_M64 ";// " -D no-compilation";
			case ENGINE:
				dir = addSlash(BUILD_DIR + ENGINE);  
				out = " -cpp " +  dir ;
			default: exit(T[15]); 
		}
		
		if (!exists(dir)) rebuild(); 
		
		println('[b][blue]Build [white]${cfg.name}[blue] on $OS ([cyan]$target[blue])');
		var s = getOptions()  +  out; 
		switch(target){
			case NEKO, FLASH, JS: s = CONN + s;
		}
		warn("haxe " + s,null,null);
		var arg = s.split(" "); 
		command("haxe",arg);
		switch(target){
//			case ANDROID: mv(BUILD_DIR + ANDROID + "/src",BUILD_DIR + ANDROID + "/JAVA");
			case NEKO:
				cd(BUILD_DIR + NEKO);
				command("nekotools",["boot",app + ".n"]);
				if(exists(app)) rm(app + ".n");
				if(!NOGUI && !exists("abv.ndll")){
					TOOLS_DIR = pathLib("abv-tools");
					cp(TOOLS_DIR + ndll,"abv.ndll");
				}
			case CPP:
				dir = addSlash(BUILD_DIR + CPP);  
				mv(dir+MAINCLASS,dir+app);
			case JAVA:
				dir = addSlash(BUILD_DIR + JAVA);  
				out = dir+MAINCLASS;
				if (VERBOSE == LOG) out += "-Debug";
				out += ".jar";
				mv(out,dir+app+".jar");
		}
	}// build()
	
	function getCss(src:String)
	{
		var r = "";
		if(exists(src)) r = "<link rel=\"stylesheet\" type=\"text/css\" href=\"" + src + "\" />";
		return r;
	}// getCss()
	
	function getHtml()
	{
		var s = "<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01//EN\" \"http://www.w3.org/TR/html4/strict.dtd\">\n<html>\n<head>\n\t<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">";

		if(target == JS){
			s += getCss(cfg.res + cfg.name + ".css");
			s += getCss("res/ui/default/gui.css");
		}
		
		s  += "\n\t<title>" + cfg.name + "</title>\n</head>\n<body id=\"body\" >\n";
		
		if(target == FLASH) s  += "<object type=\"application/x-shockwave-FLASH\" data=\"" + app + ".swf\" width=\"" + cfg.width + "\" height=\"" + cfg.height + "\">\n\t<param name=\"movie\" value=\"" + app + ".swf\" />\n\t<param name=\"quality\" value=\"high\" />\n\t<param name=\"wmode\" value=\"direct\" />\n</object>";
		else s  += "<script type=\"text/javascript\" src=\"" + app + ".js\"></script>";

		s  += "\n</body>\n</html>";
		return s;
	}// getHtml()

	function rebuild()
	{
		var dir = ""; 
		if (cfg.res != null) dir += cfg.res;
		if (good(dir) && !exists(dir)) exit(T[12] + ": " + dir); 
		if (!exists(RES_DIR)) cp(dir,RES_DIR,true);

		dir = "";
		switch(target){
			case FLASH: 
				dir = addSlash(BUILD_DIR + FLASH);
				prebuild(dir); save(dir + HTML_FILE,getHtml());
			case JS:
				dir = addSlash(BUILD_DIR + JS);
				prebuild(dir); save(dir + HTML_FILE,getHtml());
			case NEKO:
				prebuild(BUILD_DIR + NEKO);
			case CPP:
				prebuild(BUILD_DIR + CPP);
			case JAVA:
				prebuild(BUILD_DIR + JAVA);
			case ANDROID:
				prebuild(BUILD_DIR + ANDROID);
			case IOS:
				prebuild(BUILD_DIR + IOS);
			case ENGINE:  
				prebuild(BUILD_DIR + ENGINE);
			default: exit(T[15]);  
		}
	}// rebuild()

	function prebuild(dir:String)
	{
		var res = addSlash(dir) + RES_DIR;
		cd(projectDir); 
		if(exists(dir))rm(dir,true); 

		switch(target){
			case ANDROID: 
				cp(TOOLS_DIR + "tpl/android/gradle/",dir,true);
			default: mkdir(dir);
		}
		
		if(!exists(res)) cp(RES_DIR,res,true);

		cd(dir);

		switch(target){
			case ANDROID: {};
		}
	//	if(target == NEKO) cp("../../" + ndll,"abv.ndll");
		cd(projectDir);
	}// prebuild()

	function run()
	{
		var s = "Run";
		log(s,target,null);
		switch(target){
			case FLASH: 
				command(browser,[ addSlash(BUILD_DIR + FLASH)  +  HTML_FILE]);
			case JS:
				command(browser,[ addSlash(BUILD_DIR + JS)  +  HTML_FILE]);
			case NEKO:
				cd(BUILD_DIR + NEKO);
				command(pwd()  +  app);
			case CPP:
				cd(BUILD_DIR + CPP);
				command(pwd()  +  app);
			case JAVA:
				cd(BUILD_DIR + JAVA);
				command("java",["-jar",app+".jar"]);
			case ANDROID:
				cd(BUILD_DIR + ANDROID);
	//			var f = debug?main + "-Debug.jar":main + ".jar";
	//			command("JAVA",["-jar",f]);
			default: help(); return;
		}
	}// run()
	
	function test()
	{
		build();
		run();
	}// test()

	function help()
	{
		var pf = OS == "Windows"?"":"./";
		println('[b][white]Usage[rst]: [cyan]${pf}abv COMMAND [TARGET] [DEBUG] [nocolor][rst]');
		println(' [b][green]Commands[rst]: [cyan]build|run |test|info |help|rebuild[rst]');
		println(' [b][red]Targets[rst]:  [cyan]flash|js  |neko|cpp  |java|android|ios[rst]');
		println(' [b][gray]Debug[rst]:    [cyan]error|warn|info|debug|log[rst]');
	}// help()

	public static function main() 
	{ 
		var n = new ST();
	}// main() 
#end
	
/***********************************************************************
 * 
 */	
	public static inline function g(b:BytesData, pos:Int) return Bytes.fastGet(b,pos);

	public static inline function i(f:Float) return Std.int(f);

	public static inline function toInt(s:String) return Std.parseInt(s); 

	public static inline function toFloat(s:String) return Std.parseFloat(s); 
	
	public static inline function eq(str:String,cmp:String)
	{
		return str.toLowerCase() == cmp.toLowerCase();
	}// eq()

	public static inline function unique<T>(a:Array<T>)
	{
		var r:Array<T> = [];
		var m = new haxe.ds.BalancedTree<T,Null<Int>>();
		for(it in a)m.set(it,null);
		for (k in m.keys())r.push(k);
		return r;
    }// unique<T>()
	
	public static inline function addUnique<T>(a:Array<T>,v:T)
	{   
		var ix = -1; 
		if(v != null){
			ix = a.indexOf(v);
			if(ix == -1)ix = a.push(v) - 1; 
		} 
		return ix;
	}// addUnique<T>()

	public static inline function get<T>(a:Array<T>,ix:Int,p:PosInfos)
	{   
		var r:T = null;
		if((ix < 0)||(ix >= a.length))ST.error(T[6] + ": " + ix,p);
		else r = a[ix];
		return r;
	}// get<T>()

	
	public static inline function setText(s:String)return addUnique(T,s);

	public static inline function getText(id:Int,?p:PosInfos) return get(T,id,p);
#if !build 
	public static inline function setFont(f:Font)return addUnique(F,f);

	public static inline function getFont(id:Int,?p:PosInfos) return get(F,id,p);
#end 
	public static inline function realpath(path:String)
	{
		if(!good(path))path = ".";
		return path.normalize();
	}// realpath()
	
	public static inline function dirname(path:String)
	{
		if(!good(path))path = ".";
		return path.directory();
	}// dirname()
	
	public static inline function basename(path:String,ext=true)
	{
		var r = good(path)?path:".";
		r = r.withoutDirectory();
		if(!ext)r = r.withoutExtension();
		
		return r;
	}// basename()
	
	public static inline function extname(path:String)
	{
		if(!good(path))path = ".";
		return path.extension();
	}// extname()

	public static inline function addSlash(path:String)
	{
		if(!good(path))path = ".";
		return path.addTrailingSlash();
	}// addSlash()

	public static inline function delSlash(path:String)
	{
		if(!good(path))path = ".";
		return path.removeTrailingSlashes();
	}// delSlash()

	public static inline function good(v:String)return (v != null) && (v != "");

	public static inline function rand():Int
	{   
		return 	Std.int(10000000 * (Timer.stamp() - Std.int(Timer.stamp())  +  
			Math.random())); 

	}// rand()

	public static inline function clear<T>(a:Array<T>)
	{
#if flash 
		untyped a.length = 0; 
#else 	
		a.splice(0,a.length); 
#end
    }// clear<T>()
	
	public static function exit(s="")
	{ 
		var code = 0;
		if(good(s)){
			error(s,null,null);
			code = 1;
		}
#if flash 
		flash.system.System.exit(code);
#elseif (js && gui) 
		js.Browser.window.close();
#elseif (ios || android)
#elseif java 
		Sys.exit(code);
#elseif (cpp || neko) 
 #if (gui && !macro)
		abv.sys.cpp.SD.quit();
 #end 
		Sys.exit(code);
#end 
	}// exit()

	
	public static inline function openUrl(url:String)
	{
		var r = "";
		if(url.startsWith("http://")){
#if !flash
			try r = haxe.Http.requestUrl(url)catch(m:Dynamic){error(m);}
#end
		}
		return r;
	}// openUrl()

/////	
///	
	public static inline function print(s:String,?p:PosInfos)
	{   
		if(good(s)){
			s = colorize(s); 
#if flash
			if(p == null)haxe.Log.trace(s); else haxe.Log.trace(s,p); 
#elseif js
			js.Browser.console.log(msg(s,null,null)); 
#elseif android
//			android.util.Log.d(NAME,s);
#else 
			Sys.print(s); 
#end
		}
	}// print()

	public static inline function println(s="",?p:PosInfos)
	{   
		var sf = "\r\n";
#if (flash || js || android)
		sf = "";
#end  
		if(!SILENT)print(s  +  sf,p);
		else logs.push(s);
	}// println()

// aliases
	public static inline function toBytes(s:String) return Bytes.ofString(s);
	public static inline function errNullObject(s="",?p:PosInfos) error(T[20],s,p);
	public static inline function errBadName(s="",?p:PosInfos) error(T[14],s,p);
	public static inline function errObjectExists(s="",?p:PosInfos) error(T[9],s,p);
//
	public static inline function error(s:Dynamic,d:Dynamic=null,?p:PosInfos)
	{ 
		if(VERBOSE >= ERROR){  
#if flash
			print(msg(T[0] + s,d,null),p); 
#elseif js
			js.Browser.console.error(msg(s,d,p)); 
#elseif android
//			android.util.Log.e(NAME,msg(s,d,p));
#else  
			println(msg(T[0] + s,d,p));
#end 
		}
	}// error()

	public static inline function warn(s:Dynamic,d:Dynamic=null,?p:PosInfos)
	{
		if(VERBOSE >= WARN){
#if flash
			print(msg(T[1] + s,d,null),p);
#elseif js
			js.Browser.console.warn(msg(s,d,p)); 
#elseif android
//			android.util.Log.w(NAME,msg(s,d,p));
#else 
			println(msg(T[1] + s,d,p)); 
#end
		}
	}// warn()

	public static inline function info(s:Dynamic,d:Dynamic=null,?p:PosInfos)
	{
		if(VERBOSE >= INFO){
#if flash
			print(msg(T[2] + s,d,null),p);
#elseif js
			js.Browser.console.info(msg(s,d,p)); 
#elseif android
//			android.util.Log.i(NAME,msg(s,d,p));
#else 
			println(msg(T[2] + s,d,p));
#end
		}
	}// info()

	public static inline function debug(s:Dynamic,d:Dynamic=null,?p:PosInfos)
	{
		if(VERBOSE >= DEBUG){
#if flash
			print(msg(T[3] + s,d,null),p);
#elseif js
			js.Browser.console.debug(msg(s,d,p)); 
#elseif android
//			android.util.Log.d(NAME,msg(s,d,p));
#else 
			println(msg(T[3] + s,d,p));
#end
		}
	}// debug()

	public static inline function log(s:Dynamic,d:Dynamic=null,?p:PosInfos)
	{
		if(VERBOSE >= LOG){
#if flash
			print(msg(T[4] + s,d,null),p);
#elseif js
			js.Browser.console.log(msg(s,d,p)); 
#elseif android
//			android.util.Log.v(NAME,msg(s,d,p));
#else 
			println(msg(T[4] + s,d,p));
#end 
		}
	}// log()

	public static inline function msg(s:String,d:Dynamic,pos:PosInfos=null)
	{ 
		var p = d == null ? " " : ": " +  d;
#if (cpp || neko || java)
		if(COLORS){ 
			if(s.startsWith(T[0]))s = s.replace(T[0],"[b][red]");
			else if(s.startsWith(T[1]))s = s.replace(T[1],"[b][green]");
			else if(s.startsWith(T[2]))s = s.replace(T[2],"[b][yellow]");
			else if(s.startsWith(T[3]))s = s.replace(T[3],"[b][blue]");
			else if(s.startsWith(T[4]))s = s.replace(T[4],"[b][white]");
			s  += "[rst]";
			p = '[b][cyan]$p[rst]'; 
		}
#end 
		var r = s  +  p;  
		if(pos != null){
			var name = VERBOSE >= DEBUG ?pos.className:pos.fileName;  
			r  += ' [$name:${pos.lineNumber}]';  
		} 
//		if(SILENT)logs.push(r);
		return r;
	}

	public static inline function getLog(last=1024)
	{   
		return logs;
	}//

	public static inline function printLog(last=1024)
	{
		for(it in logs)print(msg(it,null,null) + "\r\n");
	}// printLog()

	public static inline function colorize(msg:String)
	{   
		var r = msg;
		var c = hasColor() && COLORS;
		 
		var rst 	= c ? "\x1b[0m" : "";
		var bold 	= c ? "\x1b[1m" : "";
		var bw 		= c ? "\x1b[30;47;1m" : "";
		var red 	= c ? "\x1b[31m" : "";
		var green 	= c ? "\x1b[32m" : "";
		var yellow 	= c ? "\x1b[33m" : "";
		var blue 	= c ? "\x1b[34m" : "";
		var magenta	= c ? "\x1b[35m" : "";
		var cyan 	= c ? "\x1b[36m" : "";
		var white 	= c ? "\x1b[37m" : "";
		var gray 	= c ? "\x1b[30;1m" : "";

		r = r.replace("[rst]",rst);
		r = r.replace("[b]",bold);
		r = r.replace("[bw]",bw);
		r = r.replace("[red]",red);
		r = r.replace("[green]",green);
		r = r.replace("[yellow]",yellow);
		r = r.replace("[blue]",blue);
		r = r.replace("[magenta]",magenta);
		r = r.replace("[cyan]",cyan);
		r = r.replace("[white]",white);
		r = r.replace("[gray]",gray);
		r  += rst;
		return r;
	}// colorize()
	
	public static inline function hasColor()
	{ 
#if (flash || js)
		return false;
#else 
		return Sys.getEnv("TERM") == "xterm" || Sys.getEnv("ANSICON") != null;
#end
	}// hasColor()

/////////////////////////
#if !(flash || js)
	public static inline function exists(path:String)
	{ 
		return good(path) && FileSystem.exists(path);
	}
	
	public static inline function absPath(path:String)
	{
		return FileSystem.fullPath(path);
	}// absPath()

	public static inline function isDir(path:String)
	{ 	
		return exists(path) && FileSystem.isDirectory(path);
	}// isDir()

	public static inline function isFile(path:String)
	{ 	
		return exists(path) && !FileSystem.isDirectory(path);
	}// isFile()
	
	public static inline function cd(path:String)
	{
 #if !java
		if(isDir(path))Sys.setCwd(path); 
 #end
	}// cd()
	
	public static inline function pwd() 
	{
		return Sys.getCwd();
	}// pwd() 
	
	public static inline function exe() 
	{
		return Sys.programPath();
	}// exe() 
	
	public static inline function rm(path:String,recursive=false)
	{ 
		if(!exists(path)){ 
			log(T[12],path);
		}else{
			var a = ls(path,true);
			a.unshift(path); 
			if(isDir(path)){
				if(recursive){
					a.reverse();
				}else if(a.length > 1){
					clear(a);
					error("Not empty",path);
				}
			}
			for(it in a){
				if(isDir(it)){ 
					try FileSystem.deleteDirectory(it)
					catch(e:Dynamic){error(T[10],it);}
				}else{ 
					try FileSystem.deleteFile(it)
					catch(e:Dynamic){error(T[10],it);}
				}
			}
		}
	}// rm()

	public static inline function mkdir(path:String)
	{ 
		var err = false;
		if(!good(path)){
		}else if((path == ".")||(path == "..")){
		}else{
			var cur = "";
			for(it in path.normalize().split("/")){ 
				cur  += it;  
				if(isFile(cur)){
					err = true;
					error(T[11],cur);
					break;
				}
				cur  += "/";  
			}
			if(!err){
				try FileSystem.createDirectory(path)
				catch(e:Dynamic){err=true;error(T[10],path);}
			}
		}
		return !err;
	}// mkdir()
	
	public static inline function read()
	{
		return Sys.stdin().readLine();
	}// read()

	public static inline function mv(src:String,dst:String)
	{
		if(exists(src) && good(dst)){
			FileSystem.rename(src,dst);
		}
	}// mv()
	
	public static inline function cp(src:String,dst:String,recursive=false)
	{
		if(!good(dst)){
			error(T[14],'$src -> ???');
		}else if(!exists(src)){
			error(T[12],src);
		}else{
			var path = "";
			var root = "";

			if(isDir(src)){
				if(isFile(dst)){
					error(T[11],dst);
				}else{ 
					dst = addSlash(dst); 
					if(exists(dst)) dst  += addSlash(basename(src));
					src = addSlash(src);
					var a = ls(src,recursive); 
					for(it in a){  
						path = dst  +  it.replace(src,""); 
						if(isDir(it)){
							if(isFile(path)){
								error(T[11],path);
								break;
							}else{ 
								if(!mkdir(path))break;
							}
						}else{  
							if(mkdir(dirname(path))){
								if(isDir(path)){
									error(T[11],path);
									break;
								}else{
									try File.copy(it, path)
									catch(e:Dynamic){error(T[10],path);}
								}
							}else break;
						} 
					}
				}
			}else{ 
				path = isDir(dirname(dst))?addSlash(dst) + basename(src):dst; 
				if(!good(basename(dst)) && !exists(dirname(dst))){
					error(T[18],path);
				}else if(isDir(path)){
					error(T[11],path);
				}else{  
					if(mkdir(dirname(dst))){  
						try File.copy(src, path)
						catch(e:Dynamic){error(T[10],path);}
					}
				}
			}
		}
	}// cp()
	
	public static function ln(path:String,link:String)
	{
//		path = addSlash(path); 		
//		link = addSlash(link);

		if(exists(path)){
			if(OS == "Windows")command("cmd",["/c","STlink","/D",link,path]);
			else command("ln",["-s",path,link]);
		}
	}// ln()
	
	public static inline function command(cmd:String, args:Array<String>=null)
	{ 
		var r = 0;

		if(good(cmd)){
			if(args == null){
				r = Sys.command(cmd);
			}else{
				var a = new Array<String>();
				for(it in args)if(good(it))a.push(it.trim());
				r = Sys.command(cmd,a); 
			}
		}
		
		return r;
	}// command()

	public static inline function exec(cmd:String, args:Array<String>=null)
	{ 
		var r = "-1";
		if(good(cmd)){
			if(args == null) args = [];
			try{
				var p = new sys.io.Process(cmd,args); 
				r = p.stdout.readAll()  +  ""; 
			}catch(e:Dynamic){ error(e);}
		}
		return r;
	}// exec()
	
	public static inline function stat(path:String)
	{ 
		if(!good(path))path= ".";

		return FileSystem.stat(path);
	}// stat()
	
	public static inline function ls(path:String,recursive=false,r:Array<String>=null)
	{
		if(r == null) r = new Array<String>();
		var a:Array<String>;
		var cur:String;
		
		if(isDir(path)){ 
			a = FileSystem.readDirectory(path); 
			for(it in a){
				cur = path == "." ? it : addSlash(path)  +  it;
				r.push(cur);
				if(recursive && isDir(cur))ls(cur,true,r);
			}
		}			
	
		return r;
	}// ls()

	public static inline function osArch()
	{
		var r = "x64";
		var s:String; 
		if(OS != "Windows"){
			s = exec("getconf",["LONG_BIT"]); 
			if(s.indexOf("32") != -1) r = "x86";
		}
		return r;
	}// osArch()
	
	public static inline function getJson(path:String)
	{
		var r:Dynamic = null;
		if(isFile(path)){
			try r = Json.parse(open(path))catch(e:Dynamic){error(e);}
		}else{
			error(T[12],path);
		}
// del comments
		if(r != null){
			var props = Reflect.fields(r); 
			for(f in props)if(f.charAt(0) == "#")Reflect.deleteField(r,f);
		}
		return r;
	}// getJson()
	
	public static inline function save(path:String,s:String)
	{
		if(good(path)){
			try File.saveContent(path, s)catch(m:Dynamic){error(m);}
		}
	}// save()

	public static inline function saveFile(path:String,b:Bytes)
	{
		if(good(path)){
			try File.saveBytes(path, b)catch(e:Dynamic){error(e);}
		}
	}// saveFile()

	public static inline function open(path:String)
	{
		var r = ""; 
		if(isFile(path)) r = File.getContent(path);
		else if(isDir(path)) error("is dir",path);
		return r;
	}// open()

	public static inline function openFile(path:String)
	{
		var r:Bytes = null; 
		if(isFile(path))r = File.getBytes(path);
		else if(isDir(path)) error("is dir",path);
		return r;
	}// openFile()

	public static inline function file(path:String)
	{
		var extHtm = " hxml htm html xml xhtml shtml ";
		var extImg = " png gif jpg jpeg bmp ico svg xcf tiff ";
		var extBin = " n o exe bin cgi class ";
		var extTxt = " txt css md json ";
		var extSrc = " js php sh pl py hxs cpp h hx neko java ";
		var extZip = " zip 7z gz lz bz2 xz ";
		var extMp3 = " mp3 m3u mid wav rm ";
		var extMp4 = " mp4 avi flv swf mov mkv webm ";
		var extFnt = " ttf ";
		var extVar = " pdf ";  
		var typeTxt = extHtm + extTxt + extSrc + " svg ";
		
		var r = {type:"non",bin:true};
		
		if(good(path)){
			var ext = " " + extname(path) + " ";
			if(extHtm.indexOf(ext) != -1)	  r.type = "htm";
			else if(extImg.indexOf(ext) != -1)r.type = "img";
			else if(extBin.indexOf(ext) != -1)r.type = "bin";
			else if(extTxt.indexOf(ext) != -1)r.type = "txt";
			else if(extSrc.indexOf(ext) != -1)r.type = "src";
			else if(extZip.indexOf(ext) != -1)r.type = "zip";
			else if(extMp3.indexOf(ext) != -1)r.type = "mp3";
			else if(extMp4.indexOf(ext) != -1)r.type = "mp4";
			else if(extFnt.indexOf(ext) != -1)r.type = "font";
			else{
				var i = extVar.indexOf(ext);
				if(i != -1)r.type = extVar.substr(i+1,ext.length-2);
			}
			
			if(typeTxt.indexOf(ext) != -1) r.bin = false;
		}
 
		return r;
	}// file()	

	public static inline function zip(src:String,dst:String)
	{
		if (!good(src) || !good(dst)){
			error(T[20], src +":"+ dst);
			return;
		}
		var entry:haxe.zip.Entry;
		var entries = new List<haxe.zip.Entry>();
		var bytes:Bytes;
		var a:Array<String> = [];
		if (isFile(src)) a.push(src); else a = ls(src,true);
		for(f in a){
			if(isFile(f)){ 
				bytes = ST.openFile(f);
				entry = {
				        fileName:f, 
				        fileSize:bytes.length,
				        fileTime:Date.now(),
				        compressed: false,
				        dataSize: 0,
				        data: bytes,
				        crc32:haxe.crypto.Crc32.make(bytes)
				        };
				haxe.zip.Tools.compress(entry,6);      
				entries.add(entry);
			}
		}
		if (!entries.isEmpty()){
			var out = sys.io.File.write(dst,true);
			var writer = new haxe.zip.Writer(out);
			writer.write(entries);
			out.close();
		}
	}// zip()

	public static inline function unzip(src:String, dst=".")
	{
		if (!isFile(src)){
			return;
		}

		if (!exists(dst)) mkdir(dst);
		dst = addSlash(dst);

		var body:Bytes;
		var cur:String;
		var input = File.read(src,true);
		var entries = haxe.zip.Reader.readZip(input); 
		for(it in entries){
			body = it.compressed ? haxe.zip.Reader.unzip(it) : null;
			if (body != null){
				cur = dst + it.fileName;
				mkdir(dirname(cur));
				saveFile(cur,body);
			}
		}
	}// unzip()
	
	public static inline function env()
	{ 
		return Sys.environment();
	}// env()

	public static inline function envKey(s:String)
	{ 
		var r = "";
		var m =  Sys.environment();
		var k = m.get(s);
		if (k != null) r = k;
		return r;
	}// envKey()
#end 
	public static inline function zipVFS(fs:MapSB)
	{
		var r:Bytes = null;
		if (fs != null){
			var sr = haxe.Serializer.run(fs);
			r = haxe.zip.Compress.run(Bytes.ofString(sr),6);
		}
		return r;
	}// zipVFS()

	public static inline function unzipVFS(b:Bytes)
	{
		var r:MapSB = null;
		if (b != null){
			var bytes = haxe.zip.Uncompress.run(b);  
			try r = haxe.Unserializer.run(bytes+"") catch(e:Dynamic){ error(e);}
		}
		return r;
	}// unzipVFS()


	public static inline function ip2int(s:String)
	{
		var r = 0;
		var a = s.split(".");
		if (a.length == 4){
			var t:Null<Int>;
			for (i in 0...4) {
				t = toInt(a[i].trim());
				if (t == null){
					r = 0;
					break;
				}
			    r += t << (24 - (8 * i));
			}
		}
		return r;
	}// ip2int()

	public static inline function int2ip(v:Int)
	{
		var r:Array<Int> = [];
		for (i in 0...4) {
		    r[i] =  (v >> (24 - (8 * i))) & 0xFF;
		}

		return r.join(".");
	}// int2ip()
	
	public static inline function indexOf(b:Bytes, s:Bytes, start = 0)
	{
		var r = -1;
		if ((b != null) && (s != null) && (b.length > 0) && (s.length > 0) && (b.length >= s.length)){
			var slen = s.length;
			var len = b.length - slen;
			var d = b.getData();
			var f = s.getData();
			var cur = -1; 
			if (start < 0) start = 0;
		    while (start <= len){
		    	for (i in 0...slen){
		    		if (g(d,start+i) != g(f,i)){
		    			start++;
		    			break;
		    		}else{
		    			cur = i;
		    		}
		    	}
		    	if (cur == (slen - 1)){
		    		r = start;
		    		break;
		    	}
		    }
		}

		return r;
	}// indexOf()
	
//
	static inline function initText()
	{   
		var r:Array<String> = [];
		r[0] = "ERROR: ";
		r[1] = "WARN : ";
		r[2] = "INFO : ";
		r[3] = "DEBUG: ";
		r[4] = "LOG  : ";
		r[5] = "Only one instance is allowed";
		r[6] = "Out of bounds";
		r[7] = "Force break";
		r[8] = "Cannot execute";
		r[9] = "Object exists";
		r[10] = "Permission denied";
		r[11] = "Cannot overwrite";
		r[12] = "No such file or directory";
		r[13] = "Unknown";
		r[14] = "Bad name";
		r[15] = "No target";
		r[16] = "Not implemented";
		r[17] = "Item exists";
		r[18] = "Cannot create";
		r[19] = "No ID";
		r[20] = "Null Object";
		r[21] = "Could not initialise"; 
		r[22] = "Bye"; 

		return r;
	}// initText()


}// abv.sys.ST

