package abv.ds;
/**
 * AbstractMap
 **/
import haxe.Json;

@:dce
@:forward(exists, good,getIndex,vals,setIndex,add,remove,clear,isPair,keyOf,indexOf,indexOfKey,toString)
abstract AMap<K,V>(BMap<K,V>){

	public var length(get,never):Int;
	inline function get_length()return this != null ?this.length:0;
	
	public inline function new() this = new BMap<K,V>();
	
// TODO: debug warning for IntMap, key != index !!!
@:arrayAccess 
	public inline function get(key:K) return this.get(key);

@:arrayAccess 
	public inline function set(key:K, val:V) this.set(key,val);
	
// FIXME: (haxe) no iterator call when K is Int/Float [suspect: build macro]
	public inline function iterator() return this.iterator();
	
	public inline function keys() return this.keys();
	
	public inline function copy()
	{ 
		var r = new AMap();
		for(k in keys())r.set(k,get(k));
		return r; 
	}// copy()

	public static inline function fromJson(json:String)
	{
		var m = new AMap<String,String>();
		var r:Dynamic = null;
		try r = Json.parse(json) catch(d:Dynamic){trace(d);}
		if(r != null){
			var keys = Reflect.fields(r); 
			for(it in keys) m.set(it+"",Reflect.field(r,it)+"");
		}
		return m;
	}// fromJson()
	
	
}// abv.ds.AMap

