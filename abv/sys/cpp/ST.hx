package abv.sys.cpp;

import sys.io.Process;
import sys.FileSystem;
import sys.io.File;
import abv.cpu.Boss;
import abv.cpu.Mutex;

using abv.lib.TP;
using abv.CR;
/**
 * SystemTools
 **/
@:dce
class ST{

	public static var lock(default,null) = new Mutex();

	public static inline function print(msg="",level:LogLevel)
	{   
		if(msg.good()){
			msg = colorize(msg,level);
			Sys.println(msg);
		}
	}// print()

	public static inline function colorize(msg:String,level:LogLevel)
	{   
		var rst = "\x1b[0m";
		var bold = "\x1b[1m";
		var red = "\x1b[31;1m";
		var green = "\x1b[32;1m";
		var yellow = "\x1b[33;1m";
		var blue = "\x1b[34;1m";
		var magenta = "\x1b[35;1m";
		var cyan = "\x1b[36;1m";
		var white = "\x1b[37;1m";
		if(AM.colors){
			if(level == OFF)msg = bold + msg;
			else if(level == FATAL)msg = magenta + msg;
//			else if(level == LOG)msg = cyan + msg;
			else if(level == ERROR)msg = red + msg;
			else if(level == WARN)msg = yellow + msg;
			else if(level == INFO)msg = white + msg;
			else if(level == DEBUG)msg = blue + msg;
			msg += rst; 
		}
		return msg;
	}// colorize()
	
	public static inline function exists(path:Null<String>,msg="")
	{ 
		var r = true;

		if(path.good(msg) && !FileSystem.exists(path)){
			if(msg.good())CR.print(msg + ": No such file or directory",ERROR); 
			r = false;
		}

		return r;
	}// exists()

	public static inline function get(path:String,msg="")
	{
		var a:Array<String> = [];
		
		if(dir(path,msg))a = FileSystem.readDirectory(path);
		
		return a;
	}// get()
	
	public static inline function dir(path:String,msg="")
	{ 		
		return exists(path,msg) && FileSystem.isDirectory(path);
	}// dir()
	
	public static inline function sleep(seconds:Float)
	{
		Sys.sleep(seconds);
	}// sleep()

	public static inline function abs(path:String)
	{
		return FileSystem.fullPath(path);
	}// abs()

	public static inline function open(path:String)
	{
		var r = "";
		if(exists(path))r = dir(path)?"is dir":File.getContent(path);
		return r;
	}// open()

	public static inline function openurl(url:String)
	{
		var r = "";
		if(url.starts("http")){
			try r = haxe.Http.requestUrl(url)catch(m:Dynamic){CR.print(m+"",ERROR);}
		}
		return r;
	}// openurl()

	public static inline function save(path:String,s:String)
	{
		File.saveContent(path, s);
	}// save()

	public static inline function copy(src:String,dst:String)
	{
		if(src.good("copy: src")){
			if(exists(src,'copy: $src'))File.copy(src, dst);
		}
	}// copy()

	public static inline function del(path:String)
	{
		if(dir(path,"del"))FileSystem.deleteDirectory(path);
		else FileSystem.deleteFile(path);
	}// del()

	public static inline function mkdir(path:Null<String>,opt="p")
	{
		if(path.good() && !dir(path,path)) 
			FileSystem.createDirectory(path);
	}// mkdir()
	
	public static inline function exec(cmd:String, args:Array<String>=null,background=false,input="")
	{ 
		var r = "-1";

		if(cmd.good()){
			if(!background){
					var p:Process = null;
					if((args == null)||(args.length == 0))args = [""];
					try{
						p = new Process(cmd,args);
						if(input.good()){
							p.stdin.writeString(input+"\n");
							p.stdin.flush();
						}
						r = p.stdout.readAll() + ""; 
					}catch(m:Dynamic){ print(m,ERROR);}
			}else r = Boss.exec(cmd,args,input) + "";
		}
		return r;
	}// exec()

	public static inline function bg(id:String)
	{ 
		var r:Array<String> = [];
		var i = Std.parseInt(id); 
		if(i != -1)r = Boss.read(i); 

		return r;
	}// bg()

	public static inline function stat(path:String)
	{ 
		if(!path.good())path= "";

		return FileSystem.stat(path);
	}// stat()


}// abv.sys.cpp.ST

