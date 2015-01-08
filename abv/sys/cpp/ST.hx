package abv.sys.cpp;

import sys.FileSystem;
import sys.io.File;

using StringTools;
using abv.CT;
/**
 * SystemTools
 **/
class ST{

	public static inline function printLog()
	{   
		var t:Array<String>;
		var rst = "\x1b[0m";
		var line = "\x1b[33;1m>" + rst;
		var bold = "\x1b[1m";
		var red = "\x1b[31;1m"; 

		for(m in CT.getLog()){
			t = m.split(CT.sep); 
			if(t[0] == "4")m = bold + t[1].trim();
			else if(t[0] == "3")m = red + t[1].trim();
			else m = t[1].trim();
			Sys.println('$m $rst');
		}
	}// printLog()

	public static inline function clear<T>(a:Array<T>)
	{
		a.splice(0,a.length); 
    }// clear()
	
	public static inline function exists(path:Null<String>,msg="")
	{ 
		var r = true;
		
		if(path.good(msg) && !FileSystem.exists(path)){
			if(msg.good())CT.print(msg + ": No such file or directory",CT.ERROR); 
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
	
	public static inline function print(msg="")
	{   
		if(msg.good() && !AM.silent)Sys.println(msg);
	}// print()

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
		return dir(path)?"is dir":File.getContent(path);
	}// open()

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
		if(path.good("mkdir") && !path.dir('mkdir: $path')) 
			FileSystem.createDirectory(path);
	}// mkdir()
	

}// abv.sys.cpp.ST

