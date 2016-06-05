package abv.sys.flash;

import abv.math.Rect;
import abv.math.MT;
import abv.ds.VFS;

import flash.text.Font;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.events.*;
import flash.net.*;

using haxe.io.Path;
using abv.sys.ST;

@:font("../res/ui/default/font/regular.ttf") class DefaultFont extends Font {}

class FS{

	static var textures = new Map<String,BitmapData>();
	static var bmd = new Map<String,BitmapData>();
	static var texts = new MapSS();
	static var err = false;
	static var names = new List<String>();
	
	public static function getText(path:String)
	{
		return VFS.open(path);
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
			loader.load(request);  
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
		ST.error("load text error",e.target+"");
	}// onLoadError()


	public static function getFont (id:String):Font 
	{
		Font.registerFont(DefaultFont);
		return new DefaultFont();
	}// getFont()

	public static function getTexture(id:String)
	{ 
		var bd:BitmapData = null;

		if(!ST.good(id)){
			ST.error(ST.getText(19));
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
		var bdir = Path.directory(e.target.loaderURL).addTrailingSlash(); 
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
			ST.error("can't load",names+"");
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
