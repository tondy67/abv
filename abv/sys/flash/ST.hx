package abv.sys.flash;
/**
 * SystemTools
 **/
import haxe.Log;
import abv.lib.style.Color;

using abv.lib.TP;
using abv.lib.CC;

class ST{

	inline function new(){ }

	public static inline function print(msg:String,color="")
	{   
		if(msg.good()){
			if(color.good())msg = colorize(msg,color); 
			trace(msg); 
		}
	}// print()

	public static inline function colorize(msg:String,color:String)
	{   
		var r = msg;
		var c = -1;

		if(AM.colors){
			color = color.lower();
			c = switch(color){ 
				case "green": Color.GREEN;
				case "magenta": Color.FUCHSIA;
				case "CYAN": Color.AQUA;
				case "RED": Color.RED;
				case "YELLOW": Color.YELLOW;
				case "WHITE": Color.WHITE;
				case "BLUE": Color.BLUE;
				default: Color.BLACK;
			}
		}
		if(c != -1)Log.setColor(c);
		return r;
	}// colorize()

}// abv.sys.flash.ST

