package abv.sys.js;

import haxe.io.Bytes;

import abv.ds.VFS;

import js.html.*;

class FS{

	static var textures = new Map<String,Image>();

	public static function getText(path:String)
	{
		return VFS.open(path);
	}// getText()

	public static function loadText(url:String)
	{
		var r = "";
		
		if(VFS.isFile(url)){
			r = VFS.open(url);
		}else{
			var req = new XMLHttpRequest();
			req.open("GET", url, false);
			req.onreadystatechange = function (){
				if(req.readyState == 4){
					if(req.status == 200 || req.status == 0){
						VFS.save(url,Bytes.ofString(req.responseText));
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
			img.onerror = function() { ST.error(path); };
		}
		
		return img;
	}// getTexture()
	


}// abv.sys.js.FS

