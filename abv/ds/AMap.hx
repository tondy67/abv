package abv.ds;
/**
 * AMap
 **/
using abv.ds.DT;

//@:dce
abstract AMap<K,V>(BMap<K,V>){

	public var length(get,never):Int;
	inline function get_length()return this != null ?this.length:0;
	
	public inline function new() this = new BMap<K,V>();
	
	public inline function exists(key:K) return this.exists(key);

	public inline function good(key:K) return this.good(key);
	
// TODO: debug warning for IntMap key != index ?!?
@:arrayAccess 
	public inline function get(key:K) return this.get(key);

@:arrayAccess 
	public inline function getIndex(key:Int) return this.getIndex(key);

	public inline function getK() return this.getK();

	public inline function getV() return this.getV();

@:arrayAccess 
	public inline function set(key:K, val:V) this.set(key,val);
	
	public inline function setIndex(key:K, val:V, id:Null<Int>) this.setIndex(key,val,id);
	
	public inline function add(key:K,val:V) return this.add(key,val);
	
	public inline function remove(key:K) return this.remove(key);
	
	public inline function iterator() return this.iterator();
	
	public inline function keys() return this.keys();
	
	public inline function copy()
	{ 
		var r = new AMap();
		for(k in keys())r.set(k,get(k));
		return r; 
	}// copy()
	
	public inline function clear() this.clear();
	
	public inline function isPair(key:K,val:V) return this.isPair(key,val);
	
	public inline function find(val:V) return this.find(val);

	public inline function indexOf(val:V) return this.indexOf(val);

	public inline function findK(key:K) return this.findK(key);

	public function toString() return this.toString();

}// abv.ds.AMap

