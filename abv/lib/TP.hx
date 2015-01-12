package abv.lib;

import haxe.Utf8;

using StringTools;
using abv.CR;
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
			CR.sort(a, cmp);
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
		catch(m:Dynamic){CR.print(char,ERROR);}

		return r;
	}// chr()

	public static inline function splitt(v:String,sep=",")
	{ 
		var a:Array<String> = [];
		if(v.good()){
			a = v.split(sep);
			for(i in 0...a.length)a[i] = a[i].trim();
		}
		return a;
	}// splitt()
	
	public static inline function substr(s:String, pos:Int, len:Int)
	{
		var r = "";

		if(s.good()&&pos.good()&&len.good())r = Utf8.sub(s, pos, len);
		
		return r;
	}// substr()

	public static inline function encode(s:String)
	{
		var r = "";

		if(s.good())r = Utf8.encode(s);

		return r;
	}// encode()

	public static inline function decode(s:String)
	{
		var r = "";

		if(s.good())r = Utf8.decode(s);

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
		if(v.good()){
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

	public static inline function starts(s:String, start:String,msg="")
	{
		var r = false; 
		if(s.good(msg) && start.good(msg) &&
			StringTools.startsWith(s, start)) r = true; 
		return r;
	}// startsWith()

	public static inline function ends(s:String, end:String,msg="")
	{
		var r = false;
		if(s.good(msg) && end.good(msg) &&
			 StringTools.endsWith(s, end)) r = true;
		return r;
	}// endsWith()

	public static inline function hex(n:Int,digits:Int = null)
	{
		var r = "";
		try r = StringTools.hex(n,digits) 
		catch(m:Dynamic){CR.print(m,ERROR);}
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
	
	public static inline function replace(s:String, sub:String, by:String,msg="")
	{// todo: regex
		var r = "";

		if(s.good(msg)) r = StringTools.replace(s,sub,by);
		
		return r;
	}// replace()

	public static inline function has(src:String,what:String,start=0)
	{
		return src.has(what,start);
	}
	public static inline function search(src:String,what:String,start=0)
	{// todo: regex
		var r = -1;

		if(src.good("src") && what.good(what)){
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

		if(src.good("src") && what.good(what)){
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

	public static inline function extract(src:String,open="",close="")
	{	
		var a:Array<String> = [];
		if(src.good()){
			var o = 0, c = 0, s = "";
			var len = src.length;
 	
			if(!open.good()){
				if(close.good()){
					c = src.indexOf(close);  
					if(c != -1)a.push(src.substring(0,c));
				}
			}else if(!close.good()){
				if(open.good()){
					o = src.indexOf(open);  
					if(o != -1)a.push(src.substr(o+open.length));
				}
			}else{
				while(o < len-1){ 
					o = src.indexOf(open,o);
					if(o == -1)break;
					else{
						c = src.indexOf(close,o);
						if(c > o){
							s = src.substring(o + open.length, c);
							if(s.indexOf(open) == -1)a.push(s);
							o = c+1; 
						}else if(c == -1)break;
					}
				}
			}
		}
		
		return a;
	}// extract()

	public static inline function urlencode(s:String){return s.urlEncode();}
	public static inline function urldecode(s:String){return s.urlDecode();}

}// abv.lib.TP

