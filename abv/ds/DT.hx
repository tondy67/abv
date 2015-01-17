package abv.ds;

import haxe.ds.StringMap;

using abv.CR;
/**
 * DataTools
 **/
class DT{
	
	public static inline function good<T>(v:Array<T>,msg="",?pif:haxe.PosInfos)
	{ 
#if debug msg = '${pif.fileName}->${pif.methodName}:$msg)'; #else msg = "";#end
		var r = true;
		
		if(v == null){
			CR.print(msg+": Null Array",ERROR); 
			r = false;
		}else if(v.length == 0){
			CR.print(msg+": Empty Array",WARN);
			r = false;
		}
		
		return r;
	}// good<T>()
	
	public static inline function empty<T>(v:StringMap<T>,msg="",?pif:haxe.PosInfos)
	{ 
#if debug msg = '${pif.fileName}->${pif.methodName}:$msg)'; #else msg = "";#end
		var r = false;
		
		
		if(v == null){
			CR.print(msg+": Null StringMap",ERROR); 
			r = true;
		}else if(length(v) == 0){
			CR.print(msg+": Empty StringMap",WARN);
			r = true;
		}
		
		return r;
	}// empty<T>()
	
	public static inline function sortK<T>(v:StringMap<T>)
	{ 
		var a:Array<String> = [];
		if(!empty(v)){
			for(k in v.keys())a.push(k); 
			a.sortAZ();
		}
		return a;
	}// sortK<T>()
	
	public static inline function length<T>(v:StringMap<T>)
	{ 
		var r = 0;
		
		if(v != null)for(k in v)r++;
		
		return r;
	}// length<T>()
	
	public static inline function indexOf<T>(m:StringMap<T>,v:T):Null<String> 
	{
		var r:Null<String> = null;
		for (k in m.keys())if(m.get(k) == v){r = k;break;}
 
		return r;
	}// indexOf<T>()
	
	public static inline function copy<T>(v:StringMap<T>,msg="",?pif:haxe.PosInfos)
	{ 
#if debug msg = '${pif.fileName}->${pif.methodName}:$msg)'; #else msg = "";#end
		var r:StringMap<T> = null;
		
		if(v == null)CR.print(msg+": Null StringMap",ERROR); 
		else{ 
			r = new StringMap<T>();
			for(k in v.keys())r.set(k,v.get(k));
		}
		
		return r;
	}// copy<T>()

	public static inline function pair<T>(m:StringMap<T>,k:String,v:T)
	{   
		var r = false;
		if(k.good() && m.exists(k) && (m.get(k) == v)) r = true;

		return r;
	}// pair<T>(()

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

