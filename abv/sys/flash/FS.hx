package abv.sys.flash;

import abv.lib.math.Rectangle;
import abv.lib.math.MT;
import haxe.Resource;
import flash.text.Font;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.events.*;
import flash.net.*;

using abv.lib.CR;

@:font("res/fonts/regular.ttf") class DefaultFont extends Font {}

@:build(abv.macro.BM.embedResources("res/config.json"))
class FS{

	static var textures = new Map<String,BitmapData>();
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
			var loader = new URLLoader();

			loader.addEventListener(Event.COMPLETE, onLoaded);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);

			var request = new URLRequest(url); 
			loader.load(request); trace(url);
			texts.set(url,"");
		}
		
		return r;
	}// loadText()
			
	static function onLoaded(e:Event)
	{
		for(k in texts.keys()){
			if(texts[k] == ""){
				texts[k] = e.target.data;
				break;
			}
		}
	}// onLoaded()
	
	static function onLoadError(e:IOErrorEvent)
	{
		trace("error: " + e.target);
	}// onLoadError()


	public static function getFont (id:String):Font 
	{
		Font.registerFont(DefaultFont);
		return new DefaultFont();
	}// getFont()

	public static function getTexture(id:String)
	{
		var bd:BitmapData = null;
//trace(id+":"+textures);
		if(!id.good()){
			trace("no id?");
		}else if (textures.exists(id)) { 
			bd = textures[id]; 
		}else {
			var loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
			var request = new URLRequest(id);
            loader.load(request); 
		}
		
		return bd;
	}// getBitmapData()	

	static function onComplete(e:Event)
	{ 
		var bdir = CR.dirname(e.target.loaderURL);
		var id = StringTools.replace(e.target.url,bdir + "/", ""); 
		var bd = e.target.loader.content.bitmapData; 
		if (id.good() && (bd != null)) { 
			textures.set(id,bd);  //trace(textures);
		}
	}// onComplete()

	static function onError(e:IOErrorEvent)
	{
		trace("error: " + e.target.url);
	}// onError()


}// abv.sys.flash.FS
