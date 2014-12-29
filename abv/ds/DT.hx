package abv.ds;

import haxe.ds.StringMap;
import abv.CT;
/**
 * DataTools
 **/
class DT{
	
	public static inline function good<T>(v:StringMap<T>,msg="")
	{ trace("v: "+v);
		var r = true;
		
		
		if(v == null){
			log("Null StringMap",msg); 
			r = false;
		}else{
			var i = 0;
			for(k in v.keys())i++;
			if(i == 0){
				log("Empty StringMap",msg);
				r = false;
			}
		}
		
		return r;
	}// good<T>()
	
	public static inline function copy<T>(v:StringMap<T>,msg="")
	{ 
		var r:StringMap<T> = null;
		
		
		if(v == null){
			log("Null StringMap",msg); 
		}else{ 
			r = new StringMap<T>();
			for(k in v.keys())r.set(k,v.get(k));
		}
		
		return r;
	}// copy<T>()

	public static inline function empty<T>(v:Array<T>,msg="")
	{ 
		var r = false;
		
		if(v == null){
			log("Null Array",msg); 
			r = true;
		}else if(v.length == 0){
			log("Empty Array",msg);
			r = true;
		}
		
		return r;
	}// empty<T>()
	
	public static inline function blank<T>(v:List<T>,msg="")
	{ 
		var r = false;
		
		if(v == null){
			log("Null List",msg); 
			r = true;
		}else if(v.length == 0){
			log("Empty List",msg);
			r = true;
		}
		
		return r;
	}// blank<T>()
	
	static inline function log(s="",msg="")
	{
		if(msg != "") msg += ": ";
		if(s != "") CT.log('$msg $s');
	}// log()


}// abv.ds.DT

