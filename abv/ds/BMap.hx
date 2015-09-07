package abv.ds;
/**
 * BMap
 **/

using abv.lib.CC;

@:dce
class BMap<K,V>{

	var ids:Array<K> = [];
	var dat:Array<V> = [];
	public var length(get,never):Int;
	function get_length() return ids.length;
	
	public inline function new(){ }

	public inline function exists(key:Null<K>)
	{
		var r = false;
		if((key != null) && (findK(key) != -1))r = true;
		return r;
	}// exists()
	
	public inline function good(key:Null<K>)
	{
		var r = false;
		if(exists(key) && (get(key) != null))r = true;
		return r;
	}// exists()
	
	public inline function get(key:Null<K>)
	{ 
		var r:Null<V> = null;
		if(key != null){
			var ix = findK(key);
			if(ix != -1) r = dat[ix];
		}
		return r;
	}// get()
	
	public inline function getIndex(key:Null<Int>)
	{ 
		var r:Null<V> = null;
		if((key != null)&&(key >= 0)&&(key < length)) r = dat[key];
		return r;
	}// getIndex()
	
	public inline function getK() return ids.copy();

	public inline function getV() return dat.copy();

	public inline function set(key:Null<K>, val:Null<V>)
	{
		if(key != null){
			var ix = findK(key);

			if(ix != -1){
				dat[ix] = val;
			}else{
				ids.push(key);
				dat.push(val);
			}
		}
	}// set()
	
	public inline function setIndex(key:Null<K>, val:Null<V>, id:Null<Int>)
	{
		if((key != null)&&(id != null)){
			var ix = findK(key);

			if((id >= 0)&&(id < length)){
				if(ix != -1){
					ids.remove(key);
					dat.remove(val);
				}
				ids.insert(id,key);
				dat.insert(id,val);
			}
		}
	}// setIndex()
	
	public inline function add(key:Null<K>,val:Null<V>) 
	{
		var r = false;
		if(key != null){
			var ix = findK(key);
			if(ix == -1){
				ids.push(key);
				dat.push(val);
				r = true;
			}
		}
		return r;
	}// add()
	
	public inline function remove(key:Null<K>)
	{
		var r = false;
		var ix = findK(key);
		if(ix != -1){
			var v = dat[ix];
			dat.remove(v);
			ids.remove(key);
			r = true;
		}
		return r;
	}// remove()
	
	public inline function iterator() return dat.iterator();
	
	public inline function keys() return ids.iterator();
	
	public inline function copy() 
	{
		var map = new BMap();
		for (i in 0...ids.length)map.set(ids[i],dat[i]);
 
		return map;
	}// copy()
	
	public inline function clear() 
	{
		ids.clear();
		dat.clear();
 	}// clear()
	
	public inline function isPair(key:K,val:V)return exists(key)&&(get(key) == val);
	
	public inline function find(val:Null<V>)
	{ 
		var r:Null<K> = null;
		var ix = indexOf(val);
		if(ix != -1) r = ids[ix];
		return r;
	}// find()

	public inline function indexOf(val:Null<V>) return val != null?dat.indexOf(val):-1;

	public inline function findK(key:Null<K>) return key != null?ids.indexOf(key):-1;

	public function toString()
	{ // FIXME: java error  here
		var s = "{";
		for(i in 0...ids.length) s += ids[i] + " => " + dat[i] + ", ";
		s += "}";
		return s;
	}// toString()

}// abv.ds.BMap

