package abv.ds;

import haxe.io.Bytes;
import haxe.Resource;
import haxe.Unserializer;
import haxe.zip.Uncompress;

using abv.sys.ST;

@:dce
class VFS{
	
	static var ready = false;
	static var fs = new MapSB();

	static function init()
	{
		var zip = Resource.getBytes("zip"); 
		if (zip == null){
			ST.error("zip");
			return;
		} 

		var m = ST.unzipVFS(zip);
		if (m != null){
			for(k in m.keys()){
				fs.set(k,m[k]);
			}
			ready = true;
		}
	}// init()
	
	public static inline function save(path:String,body:Bytes)
	{
		if (ST.good(path)){
			fs.set(path,body);
		}
	}// save()

	public static inline function isFile(path:String)
	{
		return fs.exists(path);
	}// isFile()

	public static inline function open(path:String)
	{
		var r = ""; 
		var b = openFile(path);
		if ( b != null ) r = b + "";
		return r;
	}// open()

	public static inline function openFile(path:String)
	{
		var r:Bytes = null;
		if (!ready) init();
		if (isFile(path)) r = fs[path];
		return r;
	}// openFile()

	public static inline function ls()
	{
		if (!ready) init();
		return fs.keys();
	}

}// abv.ds.VFS

