package abv.sys.jsgui;
/**
 * SystemTools
 **/
import js.Browser;
import abv.cpu.Timer;

using abv.ds.TP;
using abv.lib.CC;

class ST{

	inline function new(){ }

	public static inline function trace(v:Null<Dynamic>,?infos:Null<haxe.PosInfos>)
	{   
		var s = Std.string(v).trim();
		var level = CC.getLevel(s);
		var m = s;
		if(CC.lvl2int(AM.verbose) >= CC.lvl2int(level)){ 
			if(m.starts("now:"))m = m.replace("now:",Timer.stamp+"");
			if(!AM.silent){
				m = m.replace(level+"","");
				m += " ["+infos.fileName+":"+infos.lineNumber+"]";
				if(level == FATAL)Browser.console.error(m); 
				else if(level == LOG)Browser.console.log(m); 
				else if(level == ERROR)Browser.console.error(m); 
				else if(level == WARN)Browser.console.warn(m); 
				else if(level == INFO)Browser.console.info(m); 
				else if(level == DEBUG)Browser.console.debug(m); 
			}
			CC.log(s,level);
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


}// abv.sys.jsgui.ST

