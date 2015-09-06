package abv.ds;
/**
 * let hscript be happy
 **/
using abv.lib.CC;

@:dce
class TextProcessing {
	
	public inline function new(){}
	
	public inline function length(s:String){return TP.length(s);}
	public inline function chr(code:Int){return TP.chr(code);}
	public inline function ord(char:String){return TP.ord(char);}
	public inline function split(v:String,sep=","){return TP.splitt(v,sep);}
	public inline function substr(s:String, pos:Int, len:Int){return TP.substr(s,pos,len);}
	public inline function reduceSpaces(s:String,sp=" "){return TP.reduceSpaces(s,sp);}
	public inline function toUtf8(s:String){return TP.toUtf8(s);}
	public inline function fromUtf8(s:String){return TP.fromUtf8(s);}
	public inline function lower(s:String){return TP.lower(s);}
	public inline function upper(s:String){return TP.upper(s);}
	public inline function trim(s:String){return TP.trim(s);}
	public inline function rtrim(v:String,s="/"){return TP.rtrimm(v,s);}
	public inline function ltrim(s:String){return TP.ltrim(s);}
	public inline function starts(s:String, start:String){return TP.starts(s,start);}
	public inline function ends(s:String, end:String){return TP.ends(s,end);}
	public inline function hex(n:Int){return TP.hex(n);}
	public inline function eof(c:Int){return TP.eof(c);}
	public inline function space(s:String, pos:Int){return TP.space(s,pos);}
	public inline function lpad(s:String, c:String, l:Int){return TP.lpad(s,c,l);}
	public inline function rpad(s:String, c:String, l:Int){return TP.rpad(s,c,l);}
	public inline function replace(s:String, sub:String, by:String){return TP.replace(s,sub,by);}
	public inline function has(src:String,what:String,start=0){return TP.has(src,what,start);}
	public inline function search(src:String,what:String,start=0){return TP.search(src,what,start);}
	public inline function find(src:String,what:String,start=0,len=0){return TP.find(src,what,start);}
	public inline function extract(src:String,open="",close=""){return TP.extract(src,open,close);}
	public inline function map2str(m:AMap<String,String>,sep1=CC.SEP1,sep3=CC.SEP3){return TP.map2str(m,sep1,sep3);}
	public inline function str2map(s:String,sep1=CC.SEP1,sep3=CC.SEP3){return TP.str2map(s,sep1,sep3);}
	public inline function urlEncode(s:String){return TP.urlEncode(s);}
	public inline function urlDecode(s:String){return TP.urlDecode(s);}   
}// abv.ds.TextProcessing

