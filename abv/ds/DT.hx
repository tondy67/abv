package abv.ds;

import haxe.ds.StringMap;

using abv.CR;
/**
 * DataTools
 **/
class DT{
	
	public static inline function good<T>(v:StringMap<T>,msg="",?pif:haxe.PosInfos)
	{ 
#if debug msg = '${pif.fileName}->${pif.methodName}:$msg)'; #else msg = "";#end
		var r = true;
		
		
		if(v == null){
			CR.print(msg+": Null StringMap",ERROR); 
			r = false;
		}else if(length(v) == 0){
			CR.print(msg+": Empty StringMap",WARN);
			r = false;
		}
		
		return r;
	}// good<T>()
	
	public static inline function sortK<T>(v:StringMap<T>)
	{ 
		var a:Array<String> = [];
		if(good(v)){
			for(k in v.keys())a.push(k); 
			a.sortAZ();
		}
		return a;
	}// sortK<T>()
	
	public static inline function length<T>(v:StringMap<T>)
	{ 
		var r = 0;
		
		if(v != null){
			var i = 0;
			for(k in v.keys())i++;
			r = i;
		}
		
		return r;
	}// length<T>()
	
	public static inline function copy<T>(v:StringMap<T>,msg="",?pif:haxe.PosInfos)
	{ 
#if debug msg = '${pif.fileName}->${pif.methodName}:$msg)'; #else msg = "";#end
		var r:StringMap<T> = null;
		
		
		if(v == null){
			CR.print(msg+": Null StringMap",ERROR); 
		}else{ 
			r = new StringMap<T>();
			for(k in v.keys())r.set(k,v.get(k));
		}
		
		return r;
	}// copy<T>()

	public static inline function empty<T>(v:Array<T>,msg="",?pif:haxe.PosInfos)
	{ 
#if debug msg = '${pif.fileName}->${pif.methodName}:$msg)'; #else msg = "";#end
		var r = false;
		
		if(v == null){
			CR.print(msg+": Null Array",ERROR); 
			r = true;
		}else if(v.length == 0){
			CR.print(msg+": Empty Array",WARN);
			r = true;
		}
		
		return r;
	}// empty<T>()
	
	public static inline function blank<T>(v:List<T>,msg="",?pif:haxe.PosInfos)
	{ 
#if debug msg = '${pif.fileName}->${pif.methodName}:$msg)'; #else msg = "";#end
		var r = false;
		
		if(v == null){
			CR.print(msg+": Null List",ERROR); 
			r = true;
		}else if(v.length == 0){
			CR.print(msg+": Empty List",WARN);
			r = true;
		}
		
		return r;
	}// blank<T>()
	
}// abv.ds.DT

