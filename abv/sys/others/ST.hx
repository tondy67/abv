package abv.sys.others;

import abv.CT;
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

	public static inline function dir(path:String,msg="")
	{
		throw err;
		return false;
	}// dir()
	
	public static inline function print(msg="",level=1)
	{   
		throw err;
	}// print()

	static inline function log(msg=""){CT.log(err);}
	
}// abv.sys.others.ST

