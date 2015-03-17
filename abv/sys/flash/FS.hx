package abv.sys.flash;

import flash.text.Font;
import flash.display.BitmapData;

@:font("res/fonts/regular.ttf") class DefaultFont extends Font {}
@:bitmap("res/img/0.120.png") class BD1 extends BitmapData {}
@:bitmap("res/img/ok.gif") class BD2 extends BitmapData {}

class FS{

	public static function getText(id:String):String
	{
		return haxe.Resource.getString(id);
	}

	public static function getFont (id:String, useCache:Bool = true):Font 
	{
		Font.registerFont(DefaultFont);
		return new DefaultFont();
	}

	public static function getBitmapData(id:String, useCache:Bool = true):BitmapData
	{
		var bd:BitmapData = null;
		if(id.indexOf("ok") != -1)bd = new BD2(12,12);
		else bd = new BD1(120,120);
		return bd;
	}	

}// abv.sys.flash.FS
