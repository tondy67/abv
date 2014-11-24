package abv.lib;

import haxe.Utf8;
import StringTools;

using abv.lib.Tools;

/**
 * TextProcessing encapsulate haxe String,StringTools,Utf8
 **/
class TP{

	public static inline function length(s:String)
	{
		var r = Utf8.length(s);
		return r;
	}// length()

	public static inline function chr(code:Int)
	{
		var r = new Utf8();

		if(code.num('chr'))r.addChar(code);

		return r+"";
	}// chr()

	public static inline function ord(char:String)
	{
		var r:Null<Int> = null;

		try r = Utf8.charCodeAt(char,0) 
		catch(m:Dynamic){Tools.log('ord: $char');}

		return r;
	}// chr()

	public static inline function sub(s:String, pos:Int, len:Int)
	{
		var r = "", f = "encode";

		if(s.good(f)&&pos.num(f)&&len.num(f))r = Utf8.sub(s, pos, len);
		
		return r;
	}// sub()

	public static inline function encode(s:String)
	{
		var r = "";

		if(s.good("encode"))r = Utf8.encode(s);

		return r;
	}// encode()

	public static inline function decode(s:String)
	{
		var r = "";

		if(s.good("encode"))r = Utf8.decode(s);

		return r;
	}// decode()

	public static inline function lower(s:String)
	{
		return s.toLowerCase();
	}// lower()

	public static inline function upper(s:String)
	{
		return s.toUpperCase();
	}// upper()

	public static inline function trim(s:String)
	{
		return StringTools.trim(s);
	}// trim()

	public static inline function rtrim(s:String)
	{
		return StringTools.rtrim(s);
	}// rtrim()

	public static inline function ltrim(s:String)
	{
		return StringTools.ltrim(s);
	}// ltrim()

	public static inline function startsWith(s:String, start:String)
	{
		var r = false;
		if(s.good("startsWith") && start.good("startsWith"))
			r = StringTools.startsWith(s, start);
		return r;
	}// startsWith()

	public static inline function endsWith(s:String, end:String)
	{
		var r = false;
		if(s.good("endsWith") && end.good("endsWith"))
			r = StringTools.endsWith(s, end);
		return r;
	}// endsWith()

	public static inline function hex(n:Int,digits:Int = null)
	{
		var r = "";
		try r = StringTools.hex(n,digits) 
		catch(m:Dynamic){Tools.log("hex: "+m);}
		return r;
	}// ltrim()

	public static inline function isEof(c:Int)
	{
		return StringTools.isEof(c);
	}//isEof()
	
	public static inline function isSpace(s:String, pos:Int)
	{
		var cur = length(s.substr(0,pos));
		return StringTools.isSpace(s, cur);
	}//isSpace()
	
	public static inline function lpad(s:String, c:String, l:Int)
	{
		return StringTools.lpad(s,c,l);
	}//lpad()
	
	public static inline function rpad(s:String, c:String, l:Int)
	{
		return StringTools.rpad(s,c,l);
	}//rpad()
	
	public static inline function replace(s:String, sub:String, by:String)
	{
		var r = "";

		if(s.good("replace")) r = StringTools.replace(s,sub,by);
		
		return r;
	}// replace()

	public static inline function find(src:String,what:String,pos=0,len=0)
	{
		var r:Array<Int> = [];

		if(src.good("find: src") && what.good("find: what")){
			var srclen = length(src);
			if(len == 0)len = srclen;
			pos = Std.int(pos.range(srclen,0));
			len = Std.int(len.range(srclen-pos,0));

			var cur = 0,i = 0;
			var str = sub(src,pos,len); //trace(str.length);
 
			while(cur < str.length){ 
				i = str.indexOf(what,cur); //trace(i+":"+cur+":"+str.length);
				if(i == -1)cur = str.length;
				else{
					cur = i+what.length-1;
					r.push(length(src.substr(0,i)));
				} 
			}			
		}
		
		return r;
	}// find()

}// abv.lib.TP

