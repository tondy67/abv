package abv.sys.cppgui;

import abv.ds.AMap;

import haxe.Resource;

using abv.ST;

@:build(abv.macro.BM.embedResources())
class FS{

	static var texts = new AMap<String,String>();

	inline function new(){ }

	public static function getText(id:String)
	{
		var r = Resource.getString(id);
		return r;
	}// getText()

	public static function loadText(path:String)
	{
		return path.open();
	}// loadText()



}// abv.sys.cppgui.FS

