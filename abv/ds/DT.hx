package abv.ds;
/**
 * DataTools
 **/
using abv.sys.ST;
using abv.ds.TP;
using abv.math.MT;

@:dce
class DT{
	static inline var m1 = "Only Anonymous structures!";
	
	public static inline function good<T>(v:Array<T>)
	{ 
		return (v != null) && (v.length > 0);
	}// good<T>()
	
	public static inline function fields(o:Dynamic)
	{ 
		var r:Array<String> = [];
		var a:Array<String> = null;
		var cmp = function(a:String,b:String) return a==b?0:a<b?-1:1;
		
		if(o != null){
			switch(Type.typeof(o)){
				case TObject: 
					a = Reflect.fields(o);
					if(a != null){ 
						haxe.ds.ArraySort.sort(a, cmp);
						for(s in a)if(!s.starts("#"))r.push(s);
					};
				default: trace(m1);
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
					else ST.warn("no field" , field);
				default: trace(m1);
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
					else ST.warn("no field" , field);
				default: trace(m1);
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
				default: trace(m1);
			}
		}
		return r;
	}//

	public static inline function sort<T>(v:Array<T>)
	{
		var r = v.copy();
		if(r.length > 0){
			switch(Type.typeof(r[0])){
				case TClass(String): 
					var a:Array<String> = untyped r.copy();
					a.sortAZ();
					r = untyped a.copy();
				case TInt: 
					var a:Array<Int> = untyped r.copy();
					a.sort(MT.cmpInt);
					r = untyped a.copy();
				case TFloat: 
					var a:Array<Float> = untyped r.copy();
					a.sort(MT.cmpFloat);
					r = untyped a.copy();
				default: 
					var cmp = function(a:T,b:T) return Reflect.compare(a,b);
					r.sort(cmp);
			} 
		}
		return r;
	}// sort<T>()
	
		
}// abv.ds.DT

