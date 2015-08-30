package abv.sys.js;

import haxe.Resource;
import js.html.*;

@:build(abv.macro.BM.embedResources())
class FS{

	static var textures = new Map<String,Image>();
	static var texts = new Map<String,String>();

	inline function new(){ }
	
	public static function getText(id:String)
	{
		var r = Resource.getString(id);
		
		return r;
	}// getText()

	public static function loadText(url:String)
	{
		var r = "";
		
		if(texts.exists(url)){
			r = texts[url];
		}else{
			var req = new XMLHttpRequest();
			req.open("GET", url, false);
			req.onreadystatechange = function (){
				if(req.readyState == 4){
					if(req.status == 200 || req.status == 0){
						texts.set(url,req.responseText);
					}
				}
			}
			req.send(null);
		}
		
		return r;
	}// loadText()

	public static function getTexture(path:String)
	{
		var img:Image = null;
		if(textures.exists(path)){
			img = textures[path];
		}else{
			img = new Image();
			img.src = path;
			img.onload = function(e:Event){textures.set(path,img);}
			img.onerror = function() { trace("error: " + path); };
		}
		
		return img;
	}// getTexture()
	


}// abv.sys.js.FS

