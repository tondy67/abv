package abv.ds;

import haxe.ds.StringMap;
import abv.CT;
/**
 * DataTools
 **/
class DT{
	
	public static inline function good<T>(v:StringMap<T>,msg="")
	{ 
		var r = true;
		var m = function(s){if(msg != "")log(s);}
		
		if(v == null){
			m('$msg: Null StringMap'); 
			r = false;
		}else{
			var i = 0;
			for(k in v.keys())i++;
			if(i == 0){
				m('$msg: Empty StringMap');
				r = false;
			}
		}
		
		return r;
	}// empty<T>()
	
	public static inline function empty<T>(v:Array<T>,msg="")
	{ 
		var r = false;
		var m = function(s){if(msg != "")log(s);}
		
		if(v == null){
			m('$msg: Null Array'); 
			r = true;
		}else if(v.length == 0){
			m('$msg: Empty Array');
			r = true;
		}
		
		return r;
	}// empty<T>()
	
	public static inline function blank<T>(v:List<T>,msg="")
	{ 
		var r = false;
		var m = function(s){if(msg != "")log(s);}
		
		if(v == null){
			m('$msg: Null List'); 
			r = true;
		}else if(v.length == 0){
			m('$msg: Empty List');
			r = true;
		}
		
		return r;
	}// blank<T>()
	
	static inline function log(msg=""){CT.log(msg);}


}// abv.ds.DT

