package abv.sys.gui;

import haxe.Resource;

using abv.sys.ST;

@:build(abv.macro.BM.embedResources("res/config.json"))
class FS{

	static var texts = new Map<String,String>();

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



}// abv.sys.gui.FS

