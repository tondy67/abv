package abv.sys.javagui;
/**
 * SystemTools
 **/
import haxe.Log;
import abv.lib.style.Color;
import abv.cpu.Timer;

using abv.ds.TP;
using abv.lib.CC;

class ST{

	inline function new(){ }

	public static inline function trace(v:Null<Dynamic>,?infos:Null<haxe.PosInfos>)
	{   
		var s = Std.string(v).trim();
		var level = CC.getLevel(s);
		if(CC.lvl2int(AM.verbose) >= CC.lvl2int(level)){ 
			if(s.starts("now:"))s = s.replace("now:",Timer.stamp+"");
			s = s.replace(level+"","");
			var color = CC.lvl2color(level);
			if(color.good())s = colorize(s,color); 
			Sys.print(s);
			Sys.print(" ["+infos.fileName+":"+infos.lineNumber+"]\n");
			CC.log(s,level);
		}
	}// trace()

	public static inline function print(msg:String,color="")
	{   
		if(msg.good() && !AM.silent){
			if(color.good())msg = colorize(msg,color); 
			Sys.print(msg); 
		}
	}// print()

	public static inline function println(msg:String,color="")
	{   
		print(msg + CC.LF, color);
	}// println()

	public static inline function colorize(msg:String,color:String)
	{   
		var r = msg;
		var rst = "\x1b[0m";
		var bold = "\x1b[1m";
		var red = "\x1b[31;1m";
		var green = "\x1b[32;1m";
		var yellow = "\x1b[33;1m";
		var blue = "\x1b[34;1m";
		var magenta = "\x1b[35;1m";
		var cyan = "\x1b[36;1m";
		var white = "\x1b[37;1m"; 
		if(AM.colors && hasColor()){ 
			color = color.lower();
			if(color == "green")r = green + msg;
			else if(color == "magenta")r = magenta + msg;
			else if(color == "cyan")r = cyan + msg;
			else if(color == "red")r = red + msg;
			else if(color == "yellow")r = yellow + msg;
			else if(color == "white")r = white + msg;
			else if(color == "blue")r = blue + msg;
			r += rst; 
		}
		return r;
	}// colorize()
	
	public static inline function hasColor()
	{ 
		return Sys.getEnv("TERM") == "xterm" || Sys.getEnv("ANSICON") != null;
	}// hasColor()


}// abv.sys.javagui.ST

