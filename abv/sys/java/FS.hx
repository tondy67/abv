package abv.sys.java;

import abv.ds.VFS;

using abv.sys.ST;

@:build(abv.macro.BM.embedResources())
class FS{

	static var texts = new MapSS();
	
	public static function getText(path:String)
	{
		return VFS.open(path);
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


}// abv.sys.java.FS
