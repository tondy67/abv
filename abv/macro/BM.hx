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

enum Types{
	INT;
	FLOAT;
	STRING;
	ARRAY_INT;
	ARRAY_FLOAT;
	ARRAY_STRING;
	UNKNOWN;
}

class BM {
	
	static var configFile = "config.json";
	static var langFile = "lang.json";
	static var err1 = "Missing config value: ";
	static var cfg:Dynamic = null;
	
	macro public static function embedResources():Array<Field>
	{
		var fields = Context.getBuildFields();
		
		Context.addResource(configFile,File.getBytes(configFile));

		if(cfg == null) cfg = getJson(configFile);
		if(cfg != null){
			var resDir:String = cfg.resDir == null?"res/":cfg.res;
			var a:Array<String> = cfg.resources; 
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

	macro public static function buildConfig():Array<Field>
	{
		var fields = Context.getBuildFields();
		var pos = Context.currentPos();
		var check = ["name","width","height","ups","res"];
		var name = basename(Sys.getCwd());
		var access = [AStatic,APublic];
		var kind = FVar(macro: String,macro "");
		
		if(cfg == null){
			if(isFile(configFile)) cfg = getJson(configFile); 
			else cfg = {name:name};
			
			if(!Reflect.hasField(cfg,"name"))Reflect.setField(cfg,"name",name);
			if(!Reflect.hasField(cfg,"width"))Reflect.setField(cfg,"width",0);
			if(!Reflect.hasField(cfg,"height"))Reflect.setField(cfg,"height",0);
			if(!Reflect.hasField(cfg,"ups"))Reflect.setField(cfg,"ups",0);
			if(!Reflect.hasField(cfg,"res"))Reflect.setField(cfg,"res","");
		}

		var d:Dynamic = null;
		var props = Reflect.fields(cfg); 
		
		if(props.indexOf("context") == -1){
			Reflect.setField(cfg,"context",2); 
			props.push("context");
		}

		Reflect.setField(cfg,"build",Date.now().toString()); 
		props.push("build");
				
		for(f in props){ 
			name = f.toUpperCase();
			d = Reflect.field(cfg,f);
			switch(getType(d)){
				case ARRAY_STRING:
					access = [AStatic,APublic]; 
					kind = FVar(macro: Array<String>,macro $v{d});
				case ARRAY_INT: 
					access = [AStatic,APublic]; 
					kind = FVar(macro: Array<Int>,macro $v{d});
				case ARRAY_FLOAT: 
					access = [AStatic,APublic]; 
					kind = FVar(macro: Array<Float>,macro $v{d});
				case STRING: 
					access = [AStatic,APublic,AInline]; 
					kind = FVar(macro: String,macro $v{d});
				case INT: 
					access = [AStatic,APublic,AInline]; 
					kind = FVar(macro: Int,macro $v{d});
				case FLOAT: 
					access = [AStatic,APublic,AInline]; 
					kind = FVar(macro: Float,macro $v{d});
				default: name = ""; trace(f+": unknown");
			}

			if(name != ""){
				fields.push({name: name, access: access, kind: kind, pos: pos, doc: null, meta: []});
			}
		}

        return fields;
	}// buildConfig()

	macro public static function buildLang():Array<Field>
	{ 
		var fields = Context.getBuildFields(); //trace("\n"+fields[1].kind);
		var pos = Context.currentPos();
		
		if(cfg == null) cfg = getJson(configFile);
		if(cfg == null) cfg = {res:""};
		
		var access = [AStatic,APublic];
		var props:Array<String> = [];
		var d:Dynamic = null;
		var lg:Dynamic = null;
		var langs:Array<String> = [];
		var id:Array<String> = [];
		var words:Array<Array<String>> = [];
		var file = cfg.res + langFile;
		if(isFile(file)){
			lg = getJson(file); 
			props = Reflect.fields(lg); 
		}

		for(f in props){
			d = Reflect.field(lg,f);
			if(getType(d) != ARRAY_STRING) continue;
			if(f == "langs"){
				langs = d; 
			}else{
				id.push(f);
				words.push(d);
			}
		}
		
		var kind = FVar(macro: Array<String>,macro $v{langs});
		fields.push({name: "langs", access: access, kind: kind, pos: pos, doc: null, meta: []});
		kind = FVar(macro: Array<String>,macro $v{id});
		fields.push({name: "id", access: access, kind: kind, pos: pos, doc: null, meta: []});
		kind = FVar(macro: Array<Array<String>>,macro $v{words});
		fields.push({name: "words", access: access, kind: kind, pos: pos, doc: null, meta: []});

		
        return fields;
	}// buildLang()

	static function getType(d:Dynamic)
	{
		var r = 
			switch(Type.typeof(d)){
				case TClass(Array):  
					switch(Type.typeof(d[0])){
						case TClass(String): ARRAY_STRING;
						case TInt: ARRAY_INT;
						case TFloat: ARRAY_FLOAT;
						default: UNKNOWN;
					}
				case TClass(String): STRING;
				case TInt: INT;
				case TFloat: FLOAT;
				default: UNKNOWN;
			}
		return r;
	}// getType()
	
	static function getJson(file:String)
	{
		var r:Dynamic = null;
		if(!isFile(file))return r;

		try r = Json.parse(File.getContent(file))catch(m:Dynamic){trace(m);}
		if(r == null)throw "No valid json!";

		var props = Reflect.fields(r); 

		for(f in props){ 
			if(f.charAt(0) == "#")Reflect.deleteField(r,f);
		}
	
		return r;
	}// getJson()
	
	static function getDir(dir:String)
	{// TODO: getDir
		var r:Array<String> = [];
		
		return r;
		
	}// getDir()
	
	static function isFile(f:String)
	{
		return FileSystem.exists(f) && !FileSystem.isDirectory(f);
	}// isFile()
	
	static function basename(path:String,ext=true)
	{
		var r = "";
		var sep = "/";
		var dir = dirname(path);
		r = path.replace(dir,"");
		r = r.replace(sep,"");

		if(!ext){
			var t = r.split(".");
			r = t[0];
		}
		
		return r;
	}// basename()
	
	static function dirname(path:String)
	{
		var sep = "/";
		var r = "";
		var a = path.trim().split(sep); 
		if(a.length > 1){
			var last = a.pop();
			if(last == "")last = a.pop();
			r = a.join(sep) + sep;
		}
		return r;
	}// dirname()
	
	static function embedText(f:String)
	{
		var s = File.getContent(f);
		var rgx = ~/\s\s+/g;
		s = rgx.replace(s," "); 
		Context.addResource(f,Bytes.ofString(s));
	}// embedText()

	static function embedImage(f:String)
	{// TODO: embedImage
	}// embedImage()

	static function embedFont(f:String)
	{// TODO: embedFont
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
