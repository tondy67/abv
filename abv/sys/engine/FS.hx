package abv.sys.engine;

import abv.lib.math.Rect;
import abv.lib.math.MT;
import abv.ds.AMap;

import haxe.Resource;

using abv.lib.CC;

@:build(abv.macro.BM.embedResources())
class FS{

	static var texts = new AMap<String,String>();
	
	inline function new(){ }

	public static function getText(id:String)
	{
		var r = Resource.getString(id);
		return r;
	}// getText()

	public static function loadText(url:String)
	{
		var r = "";
				
		return r;
	}// loadText()
			
/*
	public static function getFont (id:String):Font 
	{
		Font.registerFont(DefaultFont);
		return new DefaultFont();
	}// getFont()
*/
	public static function getTexture(id:String)
	{
	}// getBitmapData()	


}// abv.sys.engine.FS