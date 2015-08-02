package abv.ds;
/**
 * DataTools
 **/
import haxe.ds.StringMap;

using abv.lib.CR;
using abv.lib.TP;

@:dce
class DT{
	static inline var m1 = "Only Anonymous structures!";
	
	inline function new(){ }

	public static inline function good<T>(v:Array<T>,msg="")
	{ 
		var r = true;
		
		if(v == null){
			trace(CR.ERROR+msg+": Null Array"); 
			r = false;
		}else if(v.length == 0){
			trace(CR.WARN+msg+": Empty Array");
			r = false;
		}
		
		return r;
	}// good<T>()
	
	public static inline function empty<T>(v:StringMap<T>,msg="")
	{ 
		var r = false;
		
		
		if(v == null){
			trace(CR.ERROR+msg+": Null StringMap"); 
			r = true;
		}else if(length(v) == 0){
			trace(CR.WARN+msg+": Empty StringMap");
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
	
	public static inline function copy<T>(v:StringMap<T>,msg="")
	{ 
		var r:StringMap<T> = null;
		
		if(v == null)trace(CR.ERROR+msg+": Null StringMap"); 
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

	public static inline function blank<T>(v:List<T>,msg="")
	{ 
		var r = false;
		
		if(v == null){
			trace(CR.ERROR+msg+": Null List"); 
			r = true;
		}else if(v.length == 0){
			trace(CR.WARN+msg+": Empty List");
			r = true;
		}
		
		return r;
	}// blank<T>()

	public static inline function fields(o:Dynamic)
	{ 
		var r:Array<String> = [];
		var a:Array<String> = null;
		var cmp = function(a:String,b:String){return a==b?0:a<b?-1:1;}
		
		if(o != null){
			switch(Type.typeof(o)){
				case TObject: 
					a = Reflect.fields(o);
					if(a != null){ 
						haxe.ds.ArraySort.sort(a, cmp);
						for(s in a)if(!s.starts("#"))r.push(s);
					};
				default: 
					var msg = m1;
					trace(msg);
			}
		}
		return r;
	}// fields()

	public static inline function field(o:Dynamic, field:String)
	{ 
		var r:Dynamic = null;
		
		if(o != null){
			switch(Type.typeof(o)){
				case TObject: 
					if(field.good())r = Reflect.field(o,field);
					else trace(CR.WARN+"no field: " + field);
				default: 
					var msg = m1;
					trace(msg);
			}
		}

		return r;
	}// field()

	public static function setField(o:Dynamic, field:String, value:Dynamic)
	{
		if(o != null){
			switch(Type.typeof(o)){
				case TObject: 
					if(field.good())Reflect.setField(o,field,value);
					else trace(CR.WARN+"no field: " + field);
				default: 
					var msg = m1;
					trace(msg);
			}
		}
	}// setField()

	public static function hasField(o:Dynamic, field:String)
	{
		var r = false;
		
		if(o != null){
			switch(Type.typeof(o)){
				case TObject: 
					r = Reflect.hasField(o,field);
				default: 
					var msg = m1;
					trace(msg);
			}
		}
		return r;
	}//
		
}// abv.ds.DT

