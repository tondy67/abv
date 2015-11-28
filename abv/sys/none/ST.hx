package abv.sys.none;

import abv.lib.CC;
/**
 * SystemTools
 **/
class ST{

	static inline var err = "Not implemented for this platform"; 

	public static inline function printLog()
	{   
		throw err;
	}// printLog()

	public static inline function clear<T>(a:Array<T>)
	{
		untyped a.length = 0; 
    }// clear()
	
	public static inline function exists(path:Null<String>,msg="")
	{ 
		var r = false;
		throw err;
		return r;
	}// exists()

	public static inline function isDir(path:String,msg="")
	{
		throw err;
		return false;
	}// isDir()
	
	public static inline function print(msg="",color="")
	{   
		trace(msg);
	}// print()

	static inline function log(msg=""){CC.log(err);}
	
}// abv.sys.none.ST

