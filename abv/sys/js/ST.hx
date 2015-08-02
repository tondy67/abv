package abv.sys.js;
/**
 * SystemTools
 **/
import js.Browser;
import abv.cpu.Timer;

using abv.lib.TP;
using abv.lib.CR;

class ST{

	inline function new(){ }

	public static inline function trace(v:Null<Dynamic>,?infos:Null<haxe.PosInfos>)
	{   
		var s = Std.string(v).trim();
		var level = CR.getLevel(s);
		var m = s;
		if(CR.lvl2int(AM.verbose) >= CR.lvl2int(level)){ 
			if(m.starts("now:"))m = m.replace("now:",Timer.stamp+"");
			if(!AM.silent){
				if(level != "")m = m.replace(level,"");
				m += " ["+infos.fileName+":"+infos.lineNumber+"]";
				if(level == CR.FATAL)Browser.console.error(m); 
				else if(level == CR.LOG)Browser.console.log(m); 
				else if(level == CR.ERROR)Browser.console.error(m); 
				else if(level == CR.WARN)Browser.console.warn(m); 
				else if(level == CR.INFO)Browser.console.info(m); 
				else if(level == CR.DEBUG)Browser.console.debug(m); 
			}
			CR.log(s);
		}
	}// trace()

	public static inline function print(msg:String,color="")
	{   
		if(msg.good()){
			color = color.lower();
			if(color == "red")Browser.console.error(msg); 
			else if(color == "blue")Browser.console.debug(msg); 
			else if(color == "yellow")Browser.console.warn(msg); 
			else Browser.console.log(msg); 
		}
	}// print()


}// abv.sys.js.ST

