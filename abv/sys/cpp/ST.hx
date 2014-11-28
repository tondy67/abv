package abv.sys.cpp;

import abv.CT;
import sys.FileSystem;
/**
 * SystemTools
 **/
class ST{

	public static inline function printLog()
	{   
		if(AM.verbose > 0){
			for(m in CT.getLog())Sys.println(m);
		}
	}// printLog()

	public static inline function clear<T>(a:Array<T>)
	{
		a.splice(0,a.length); 
    }// clear()
	
	public static inline function exists(path:Null<String>,msg="")
	{ 
		var r = true;
		
		if(CT.good(path,msg) && !FileSystem.exists(path)){
			if(msg != "")log(msg + ": No such file or directory"); 
			r = false;
		}

		return r;
	}// exists()

	public static inline function dir(path:String,msg="")
	{
		return exists(path,msg) && FileSystem.isDirectory(path);
	}// dir()
	
	public static inline function print(msg="",level=1)
	{   
		if(AM.verbose >= level){
			if(CT.good(msg))Sys.println(msg);
			log(msg);
		}
	}// print()

	static inline function log(msg=""){CT.log(msg);}
	
}// abv.sys.cpp.ST

