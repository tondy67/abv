package abv.lib;

import haxe.Utf8;
import haxe.ds.StringMap;

using StringTools;
using abv.lib.CC;
using abv.lib.math.MT;

/**
 * TextProcessing encapsulate haxe String,StringTools,Utf8
 **/
@:dce
class TP{

	inline function new(){ }

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
			CC.sort(a, cmp);
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
		catch(m:Dynamic){trace(ERROR+char);}

		return r;
	}// chr()

	public static inline function splitt(v:String,sep=",")
	{ 
		var a:Array<String> = [];
		if(v.good()){
			a = v.trim().split(sep); 
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
	
	public static function reduceSpaces(s:String,sp=" ")
	{
		var rgx = ~/\s\s+/g;
		return rgx.replace(s,sp); 
	}// reduceSpaces()
	
	public static inline function isUtf8(s:Null<String>,msg="")
	{
		var r = false;
		if(s.good(msg)){
			r = haxe.Utf8.validate(s);
			if(!r)trace(ERROR+msg + " Not utf8"); 
		}
		return r;
	}// isUtf8()

	public static inline function toUtf8(s:String)
	{
		var r = "";

		if(s.good())r = Utf8.encode(s);

		return r;
	}// encode()

	public static inline function fromUtf8(s:String)
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
		catch(m:Dynamic){trace(ERROR+m);}
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

	public static inline function nl2br(s:String)
	{
		var r = "";

		if(s.good()) r = StringTools.replace(s,"\n","<br>");
		
		return r;
	}// nl2br()

	public static inline function br2nl(s:String)
	{
		var r = "";

		if(s.good()) r = StringTools.replace(s,"<br>","\n");
		
		return r;
	}// br2nl()

	public static inline function has(src:String,what:String,start=0)
	{
		var r = false; 

		if(src.good() && what.good()){
			var len = src.length;
			start = Std.int(start.range(len-1,0)); 
			var t = src.indexOf(what,start);
			if((t >= 0)&&(t < len))r = true;
		}
		
		return r;
	}// has()

	public static inline function search(src:String,what:String,start=0)
	{// todo: regex
		var r = CC.ERR;

		if(src.good() && what.good(what)){
			var len = src.length;
			start = Std.int(start.range(len-1));
			var i = src.indexOf(what,start);
			if((i >= 0)&&(i < len))r = length(src.substr(0,i));
		}
		
		return r;
	}// search()

	public static inline function find(src:String,what:String,start=0,len=0)
	{// TODO: regex
		var r:Array<Int> = [];

		if(src.good("src") && what.good(what)){
			var srclen = length(src);
			if(len == 0)len = srclen;
			start = Std.int(start.range(srclen,0));
			len = Std.int(len.range(srclen-start,0));

			var cur = 0,i = 0;
			var str = substr(src,start,len); 
 
			while(cur < str.length){ 
				i = str.indexOf(what,cur); 
				if(i == CC.ERR)cur = str.length;
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
					if(c != CC.ERR)a.push(src.substring(0,c));
				}
			}else if(!close.good()){
				if(open.good()){
					o = src.indexOf(open);  
					if(o != CC.ERR)a.push(src.substr(o+open.length));
				}
			}else{
				while(o < len-1){ 
					o = src.indexOf(open,o);
					if(o == CC.ERR)break;
					else{
						c = src.indexOf(close,o);
						if(c > o){
							s = src.substring(o + open.length, c);
							if(s.indexOf(open) == CC.ERR)a.push(s);
							o = c+1; 
						}else if(c == CC.ERR)break;
					}
				}
			}
		}
		
		return a;
	}// extract()
	public static inline function map2str(m:Map<String,String>,sep1=CC.SEP1,sep3=CC.SEP3)
	{   
		var r = "";
		for(k in m.keys()) r += k + sep1 + m.get(k) + sep3;

		return r;
	}// map2str()

	public static inline function str2map(s:String,sep1=CC.SEP1,sep3=CC.SEP3)
	{   
		var r = new Map<String,String>();
		var a:Array<String>;
		var t:Array<String>;
		var v = "";
		if(s.good()){
			a = splitt(s,sep3);
			for(i in a){
				t = splitt(i,sep1);
				if(t[0].good()){
					if(t[1].good())v = t[1];
					if(r.exists(t[0]))r[t[0]] += CC.SEP1 + v;
					else r.set(t[0],v);
				}
			}
		}

		return r;
	}// str2map()

	public static inline function urlEncode(s:String){return s.urlEncode();}
	public static inline function urlDecode(s:String){return s.urlDecode();}


}// abv.lib.TP

