package abv.ds;
/**
 * MapString
 **/
import haxe.ds.StringMap;

using abv.lib.CC;

class MapString{

	var ds = new StringMap<String>();
	
	public inline function new(){ }

	public inline function exists(key:String){return ds.exists(key);}
	
	public inline function get(key:String){return ds.get(key);}
	
	public inline function set(key:String, val:String){ds.set(key,val);}
	
	public inline function add(key:String,val:String = null) 
	{
		var r = false;
		if(!ds.exists(key)){
			ds.set(key, val);
			r = true;
		}
		return r;
	}// add()
	
	public inline function remove(key:String){return ds.remove(key);}
	
	public inline function iterator(){return ds.iterator();}
	
	public inline function keys(){return ds.keys();}
	
	public inline function sortK():Array<String> 
	{
		var a:Array<String> = [];
		for (k in ds.keys())a.push(k);
		a.sortAZ();
		return a;
	}// sortK()
	
	public inline function sortV(v:StringMapTS<String>):Array<String> 
	{
		var a:Array<String> = [];
		for (k in ds.keys())a.push(ds.get(k));
		a.sortAZ();
		return a;
	}// sortV()
	
	public inline function copy() 
	{
		var map = new MapString();
		for (k in ds.keys())map.set(k,ds.get(k));
 
		return map;
	}// copy()
	
	public inline function clear() 
	{
		for (k in ds.keys())ds.remove(k);
 	}// clear()
	
	public inline function pair(key:String,val:String) 
	{
		return ds.exists(key) && (ds.get(key) == val);
	}//
	
	public inline function length() 
	{
		var r = 0;
		for(k in ds)r++;

		return r;
	}// length() 

	public function toString()
	{
		var s = "MapString(";
		for(k in ds.keys()) s += k + " => " + ds.get(k) + ", ";
		s += ")";
	}// toString()

}// abv.ds.MapString

