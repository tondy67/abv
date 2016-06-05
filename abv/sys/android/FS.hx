package abv.sys.android;

import abv.math.Rect;
import abv.math.MT;


import haxe.Resource;

using abv.sys.ST;

@:build(abv.macro.BM.embedResources())
class FS{

	static var texts = new MapSS();
	
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


}// abv.sys.android.FS
