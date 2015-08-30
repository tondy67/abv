package abv.ds;
/**
 * Thread-safe StringMap
 **/
import abv.cpu.Mutex;
import haxe.ds.StringMap;

using abv.lib.CC;

abstract StringMapTS<V>(StringMap<V>){
	
	public inline function new()
	{
		this = new StringMap<V>();
		Reflect.setField(this, "lock", new Mutex());
	}// new()
	
	public inline function exists(key:String):Bool 
	{
		var lock:Mutex = Reflect.field(this, "lock");
		lock.acquire();
		var r = key == null ? false: this.exists(key);
		lock.release();
		return r;
	}// exists()
	
@:arrayAccess 
	public inline function get(key:String):Null<V> 
	{
		var lock:Mutex = Reflect.field(this, "lock");
		lock.acquire();
		var r = this.get(key);
		lock.release();
		return r;
	}// get()
	
@:arrayAccess
	public inline function set(key:String, val:Null<V>):Null<V> 
	{
		var lock:Mutex = Reflect.field(this, "lock");
		lock.acquire();
		if(key != null)this.set(key, val);
		lock.release();
		return val;
	}// set()
	
	public inline function add(key:String,val:Null<V> = null):Bool 
	{
		var lock:Mutex = Reflect.field(this, "lock");
		lock.acquire();
		var r = false;
		if(!this.exists(key)){
			this.set(key, val);
			r = true;
		}
		lock.release();
		return r;
	}// add()
	
	public inline function remove(key:String):Bool 
	{
		var lock:Mutex = Reflect.field(this, "lock");
		lock.acquire();
		var r = this.remove(key);
		lock.release();
		return r;
	}// remove()
	
	public inline function iterator():Iterator<V> 
	{
		var lock:Mutex = Reflect.field(this, "lock");
		var a = new Array<V>();
		lock.acquire();
		for(i in this.iterator()) a.push(i);
		lock.release();
		return a.iterator();
	}// iterator()
	
	public inline function keys():Array<String> 
	{
		var lock:Mutex = Reflect.field(this, "lock");
		lock.acquire();
		var a = new Array<String>();
		for (k in this.keys())a.push(k);
		lock.release();
		return a;
	}// keys()
	
	public inline function sortK():Array<String> 
	{
		var a:Array<String> = [];
		var lock:Mutex = Reflect.field(this, "lock");
		lock.acquire();
		for (k in this.keys())a.push(k);
		a.sortAZ();
		lock.release();
		return a;
	}// sortK()

	public static inline function sortV(v:StringMapTS<String>):Array<String> 
	{
		var a:Array<String> = [];
		var lock:Mutex = Reflect.field(v, "lock");
		lock.acquire();
		for (k in v.keys())a.push(v.get(k));
		a.sortAZ();
		lock.release();
		return a;
	}// sortV()
	
	public inline function copy():StringMapTS<V> 
	{
		var lock:Mutex = Reflect.field(this, "lock");
		lock.acquire();
		var map = new StringMapTS<V>();
		for (k in this.keys())map.set(k,this.get(k));
		lock.release();
		return map;
	}// copy()
	
	public inline function length():Int 
	{
		var lock:Mutex = Reflect.field(this, "lock");
		lock.acquire();
		var r = 0;
		for(k in this)r++;
		lock.release();
		return r;
	}// length()
	
	public inline function pair(key:String,val:V):Bool 
	{
		var lock:Mutex = Reflect.field(this, "lock");
		lock.acquire();
		var r = this.exists(key) && (this.get(key) == val);
		lock.release();
		return r;
	}// pair()
	
	public inline function toString():String 
	{
		var lock:Mutex = Reflect.field(this, "lock");
		lock.acquire();
		var r = this.toString();
		lock.release();
		return r;
	}// toString()
	
}// abv.ds.StringMapTS
