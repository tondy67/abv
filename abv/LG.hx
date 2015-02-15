package abv;

import abv.lib.ui.box.Box;
import abv.lib.style.Style;
import abv.lib.Screen;
/**
 * Errors tracing and processing.
 * Debug & Profiler class
 **/ 
@:dce
@:final 
class LG{

	public static var screen:Screen = null;
	public static var txt = "";

/**
 * Throws an exception and (if -debug) traces message
 **/ 
	public static inline function log(d:Dynamic=null,?p:haxe.PosInfos)
	{
		var s = Std.string(d);
		if(s != ""){
			s = '<${p.fileName}:${p.lineNumber}> ' + s;
			if(screen != null)screen.con(s + " " + txt);
			else #if debug trace(s); #else throw s; #end
		}
	}// log()

}// abv.LG

