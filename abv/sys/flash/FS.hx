package abv.sys.flash;

import abv.lib.math.Rect;
import abv.lib.math.MT;
import abv.ds.AMap;

import haxe.Resource;
import flash.text.Font;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.events.*;
import flash.net.*;

using abv.lib.CC;

@:font("../res/ui/default/font/regular.ttf") class DefaultFont extends Font {}

@:build(abv.macro.BM.embedResources())
class FS{

	static var textures = new AMap<String,BitmapData>();
	static var bmd = new AMap<String,BitmapData>();
	static var texts = new AMap<String,String>();
	static var err = false;
	static var names = new List<String>();
	
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
			return bd;
		}
		names.add(id);
		if (textures.exists(id)) { 
			bd = textures[id]; 
		}else {
			var loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
			var request = new URLRequest(id);
            loader.load(request); 
		}
		
		return bd;
	}// getTexture()	

	static function onComplete(e:Event)
	{ 
		var bdir = CC.dirname(e.target.loaderURL);
		var id = StringTools.replace(e.target.url,bdir, ""); 
		var bd = e.target.loader.content.bitmapData; 
		if (id.good() && (bd != null)) { 
			textures.set(id,bd);  
		}
		names.clear();
	}// onComplete()

	static function onError(e:IOErrorEvent)
	{
		if(!err){
			err = true;
			trace("can't load: " + names);
			names.clear();
		}
	}// onError()

	static function getTile(bm:BitmapData,rect:Rect,scale = 1.)
	{ 
		var sbm:BitmapData = null; 
		if(bm == null) return sbm; 
		if(rect == null){
			rect = new Rect(0,0,bm.width,bm.height);
		}
		var bd = new BitmapData(MT.closestPow2(rect.w.i()), MT.closestPow2(rect.h.i()), true, 0);
		var pos = new flash.geom.Point();
		var r = new flash.geom.Rectangle(rect.x,rect.y,rect.w,rect.h);
		bd.copyPixels(bm, r, pos, null, null, true);
		
		if(scale == 1){
			sbm = bd;
		}else{
			var m = new flash.geom.Matrix();
			m.scale(scale, scale);
			var w = (bd.width * scale).i(), h = (bd.height * scale).i();
			sbm = new BitmapData(w, h, true, 0x000000);
			sbm.draw(bd, m, null, null, null, true);
		}		
		return sbm;
	}// getTile()

	public static function getImage(src:String,tile:Rect,scale = 1.)
	{
		var bd:BitmapData = null;
		var id = src+tile;
		if(bmd.exists(id)){
			bd = bmd[id]; 
		}else{ 
			bd = getTile(getTexture(src),tile,scale);
			if(bd != null)bmd.set(id,bd); 
		}
		return bd;
	}// getImage()

}// abv.sys.flash.FS
