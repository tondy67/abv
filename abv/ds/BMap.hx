package abv.ds;
/**
 * BaseMap
 * slow add/set, fast search
 **/
import haxe.ds.BalancedTree;

@:dce
class BMap<K,V>{

	var ids = new Array<K>();
	var dat = new BalancedTree<K,V>();
	var vls:BalancedTree<V,K> = null;

	public var length(default,null) = 0;
	
	public inline function new(){ }

	public inline function exists(key:Null<K>)
	{
		return (key != null) && dat.exists(key);
	}// exists()
	
	public inline function good(key:Null<K>,val:Null<V>=null)
	{
		var r = false;
		if(exists(key)){
			var v = get(key);
			if(v != null){
				if(val == null) r = true;
				else if(v == val) r = true;
			}
		}
		return r;
	}// good()
	
	public inline function get(key:Null<K>)
	{ 
		var r:Null<V> = null;
		if(key != null){
			r = dat.get(key);
		}
		return r;
	}// get()
	
	public inline function getIndex(id:Null<Int>)
	{ 
		var r:Null<V> = null;
		if(check(id)) r = dat.get(ids[id]);
		return r;
	}// getIndex()
	
	public inline function getKey(id:Null<Int>)
	{ 
		var r:Null<K> = null;
		if(check(id)) r = ids[id];
		return r;
	}// getKey()
	
	public inline function iterator() return dat.iterator();
	
	public inline function keys() return ids.copy();
	
	public inline function vals()
	{
		var r:Array<V> = [];
		for(k in ids)r.push(dat.get(k));
		return r;
	}

	public inline function set(key:Null<K>, val:Null<V>)
	{ 
		var ix = -1;
		if(key != null){
			if(!exists(key)){
				ix = ids.push(key) - 1;
				length++;
			}
			dat.set(key,val);
			if(vls != null)vls.set(val,key);
		} 
		return ix;
	}// set()
	
	public inline function setIndex(key:Null<K>, val:Null<V>, id:Null<Int>)
	{
		if((key != null)&&(id != null)){
			if(check(id)){
				ids.remove(key);
				ids.insert(id,key);
				dat.set(key,val);
				if(vls != null)vls.set(val,key);
			}
		} 
	}// setIndex()
	
	public inline function add(key:Null<K>,val:Null<V>) 
	{
		var r = false;
		if((key != null)&&(!exists(key))){
			set(key,val);
		} 
		return r;
	}// add()
	
	public inline function remove(key:Null<K>)
	{
		var r = false;
		if((key != null)&&(length > 0)){
			if(vls != null)vls.remove(dat.get(key));
			dat.remove(key);
			ids.remove(key);
			length--;
		}
		return r;
	}// remove()
	
	public inline function copy() 
	{
		var map = new BMap<K,V>();
		for (k in ids)map.set(k,dat.get(k));
 
		return map;
	}// copy()
	
	public inline function keyOf(val:Null<V>)
	{ 
		var r:Null<K> = null;
		if(vls == null)setIndexVals();
		if(vls.exists(val))r = vls.get(val);
		return r;
	}// keyOf()
	
	inline function setIndexVals()
	{
		vls = new BalancedTree<V,K>();
		for(k in ids)vls.set(dat.get(k),k);
	}// setIndexVals()
	
	public inline function indexOf(val:Null<V>)
	{
		var r = -1;
		if(vls == null)setIndexVals();
		if(vls.exists(val))r = ids.indexOf(vls.get(val));
		return r;
	}// indexOf()

	public inline function indexOfKey(key:Null<K>) return key != null?ids.indexOf(key):-1;

	inline function check(id:Null<Int>)
	{
		return (id != null) && (id >= 0) && (id < length);
	}// check()
	
	public function toString()
	{ // FIXME: (java) error  here <K,V> ?!
		var s = "{";
		for(i in 0...ids.length){
			s += ids[i] + " => " + dat.get(ids[i]);
			if(i < length - 1) s += ", ";
		}
		s += "}";
		return s;
	}// toString()

}// abv.ds.BMap

