package abv.lib;

import haxe.Utf8;

using StringTools;
using abv.CT;
using abv.lib.math.MT;

/**
 * TextProcessing encapsulate haxe String,StringTools,Utf8
 **/
class TP{

	public static inline function length(s:String)
	{
		var r = Utf8.length(s);
		return r;
	}// length()

	public static inline function order(a:Array<String>,cmp:String->String->Int=null)
	{
		if(a != null){
			if(cmp == null)
				cmp = function(a:String,b:String){return a==b?0:a<b?-1:1;}
			CT.sort(a, cmp);
		}
	}// order()

	public static inline function chr(code:Int)
	{
		var r = new Utf8();

		if(code.good('chr'))r.addChar(code);

		return r+"";
	}// chr()

	public static inline function ord(char:String)
	{
		var r:Null<Int> = null;

		try r = Utf8.charCodeAt(char,0) 
		catch(m:Dynamic){CT.print('ord: $char');}

		return r;
	}// chr()

	public static inline function splitt(v:String,sep=",")
	{ 
		var a:Array<String> = [];
		if(v.good("splitt")){
			a = v.split(sep);
			for(i in 0...a.length)a[i] = a[i].trim();
		}
		return a;
	}// splitt()
	
	public static inline function substr(s:String, pos:Int, len:Int)
	{
		var r = "", f = "encode";

		if(s.good(f)&&pos.good(f)&&len.good(f))r = Utf8.sub(s, pos, len);
		
		return r;
	}// substr()

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

	public static inline function rtrim(v:String,s="/")
	{ 
		var r = v;
		if(v.good("rtrim")){
			var len = v.length-1;
			r = StringTools.rtrim(v);
			for(i in 0...len+1){
				if(r.substr(len-i,1) == s)r = StringTools.rtrim(r).substr(0,len-i); 
				else break;
			}
		}
		
		return r;		
	}// rtrim()

	public static inline function ltrim(s:String)
	{
		return StringTools.ltrim(s);
	}// ltrim()

	public static inline function starts(s:String, start:String)
	{
		var r = false;
		if(s.good("starts") && start.good("starts"))
			r = StringTools.startsWith(s, start);
		return r;
	}// startsWith()

	public static inline function ends(s:String, end:String)
	{
		var r = false;
		if(s.good("ends") && end.good("ends"))
			r = StringTools.endsWith(s, end);
		return r;
	}// endsWith()

	public static inline function hex(n:Int,digits:Int = null)
	{
		var r = "";
		try r = StringTools.hex(n,digits) 
		catch(m:Dynamic){CT.print("hex: "+m);}
		return r;
	}// ltrim()

	public static inline function eof(c:Int)
	{
		return StringTools.isEof(c);
	}//eof()
	
	public static inline function space(s:String, pos:Int)
	{
		var cur = length(s.substr(0,pos));
		return StringTools.isSpace(s, cur);
	}//space()
	
	public static inline function lpad(s:String, c:String, l:Int)
	{
		return StringTools.lpad(s,c,l);
	}//lpad()
	
	public static inline function rpad(s:String, c:String, l:Int)
	{
		return StringTools.rpad(s,c,l);
	}//rpad()
	
	public static inline function replace(s:String, sub:String, by:String)
	{// todo: regex
		var r = "";

		if(s.good("replace")) r = StringTools.replace(s,sub,by);
		
		return r;
	}// replace()

	public static inline function has(src:String,what:String,start=0)
	{
		return src.has(what,start);
	}
	public static inline function search(src:String,what:String,start=0)
	{// todo: regex
		var r = -1;

		if(src.good("search: src") && what.good("search: what")){
			var len = src.length;
			start = Std.int(start.range(len-1,0));
			var i = src.indexOf(what,start);
			if((i >= 0)&&(i < len))r = length(src.substr(0,i));
		}
		
		return r;
	}// search()

	public static inline function find(src:String,what:String,start=0,len=0)
	{// todo: regex
		var r:Array<Int> = [];

		if(src.good("find: src") && what.good("find: what")){
			var srclen = length(src);
			if(len == 0)len = srclen;
			start = Std.int(start.range(srclen,0));
			len = Std.int(len.range(srclen-start,0));

			var cur = 0,i = 0;
			var str = substr(src,start,len); //trace(str.length);
 
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

	public static inline function extract(src:String,open="[",close="]")
	{	
		var r:Array<String> = [];

		if(src.good("extract: src") && open.good("extract: open") 
		&& close.good("extract: close")){
			// todo	
		}
		
		return r;
	}// extract()

	public static inline function urlencode(s:String){return s.urlEncode();}
	public static inline function urldecode(s:String){return s.urlDecode();}

}// abv.lib.TP

