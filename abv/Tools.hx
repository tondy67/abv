package abv;

/**
 * Tools
 **/
class Tools{

	static var logData:Array<String> = [];
	static var start:Float = Sys.time();

	static function __init__()
	{
    }// __init__()

	public static inline function good(s:Null<String>,msg="")
	{ 
		var r = true;

		if(s == null){
			log(msg + ": Null"); 
			r = false;
		}else if(s == ""){
			log(msg + ": Empty"); 
			r = false;
		}
		
		return r;
	}// good()

	public static inline function num(f:Null<Float>,msg="")
	{ 
		var r = true;

		if(f == null){
			log(msg + ": Null value"); 
			r = false;
		}else if(f == Math.NaN){
			log(msg + ": NaN value"); 
			r = false;
		}else if(f == Math.NEGATIVE_INFINITY){
			log(msg + ": NEGATIVE_INFINITY value"); 
			r = false;
		}else if(f == Math.POSITIVE_INFINITY){
			log(msg + ": POSITIVE_INFINITY value"); 
			r = false;
		}

		return r;
	}// num()

	public static inline function range(f:Null<Float>,max:Float, min:Float=0)
	{
		if(num(f,"range")){
			if(f >= max)f = max;
			else if(f <= min)f = min; 
		}else f = 0;
		
		return f;
	}// range()
	
	public static inline function clear<T>(a:Array<T>)
	{
#if (cpp||php) a.splice(0,a.length); #else untyped a.length = 0; #end
    }// clear()
	
	public static inline function exists(path:Null<String>,msg="")
	{ 
		var r = true;
		
		if(good(path,msg) && !sys.FileSystem.exists(path)){
			log(msg + ": No such file or directory"); 
			r = false;
		}

		return r;
	}// exists()

	public static inline function dir(path:String,msg="")
	{
		return exists(path,msg) && sys.FileSystem.isDirectory(path);
	}// dir()
	
	public static inline function eq(str:String,cmp:String)
	{
		return str.toLowerCase() == cmp.toLowerCase();
	}// eq()

	public static inline function log(msg="")
	{
		if(start == 0)start = Sys.time();
		if(msg == "")msg = "" + (Sys.time() - start);
		logData.push(msg);
	}// log()

	public static inline function getLog()
	{
		return logData;
	}// log()

	

}// abvm.Tools

