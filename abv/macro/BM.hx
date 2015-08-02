package abv.macro;
/**
 * Build Macros
 **/
import haxe.macro.Context;
import haxe.macro.Expr;
import sys.io.File;
import sys.FileSystem;
import haxe.Json;
import haxe.io.Bytes;

using StringTools;

class BM {
	
	macro public static function embedResources(configFile:String):Array<Field>
	{
		var fields = Context.getBuildFields();
		
		Context.addResource(configFile,File.getBytes(configFile));
		var s = File.getContent(configFile);
		var json = null;
		try json = Json.parse(s)catch(m:Dynamic){trace(m);}
		if(json != null){
			var resDir:String = json.resDir == null?"res/":json.resDir;
			var a:Array<String> = json.appResources; 
			if(a[0] == "*") a = getDir(resDir);
			for(r in a){
				var f = resDir + r;
				if(isFile(f)){
					switch(getFileType(f)){
						case "txt": embedText(f);
						case "img": embedImage(f);
						case "font": embedFont(f);
					}					
				}
			}
		}
		
		return fields;
	}// embedResources()

// TODO: getDir
	static function getDir(dir:String)
	{
		var r:Array<String> = [];
		
		return r;
		
	}// getDir()
	
	static function isFile(f:String)
	{
		return FileSystem.exists(f) && !FileSystem.isDirectory(f);
	}// isFile()
	
	static function embedText(f:String)
	{
		var s = File.getContent(f);
		var rgx = ~/\s\s+/g;
		s = rgx.replace(s," "); 
		Context.addResource(f,Bytes.ofString(s));
	}// embedText()

// TODO: embedImage
	static function embedImage(f:String)
	{
	}// embedImage()

// TODO: embedFont
	static function embedFont(f:String)
	{
	}// embedFont()
	
	static function getFileType(f:String)
	{
		var r = "";
		var txt = ["css","htm","html","json","txt"];
		var img = ["jpg","jpeg","png","gif","bmp"];
		var font = ["ttf"];
		
		for(ext in txt)if(f.endsWith(ext)) r = "txt";
		if(r == "")for(ext in img)if(f.endsWith(ext)) r = "img";
		else if(r == "")for(ext in font)if(f.endsWith(ext)) r = "font";
		
		return r;
	}// getFileType()
	

	
  	
}// abv.macro.BM
