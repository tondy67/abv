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
import abv.lib.Enums;

using StringTools;

class BM {
	
	static var configFile = "config.json";
	static var langFile = "lang.json";
	static var err1 = "Missing config value: ";
	static var cfg:Dynamic = null;
	
	macro public static function buildR():Array<Field>
	{
		var fields = Context.getBuildFields();
#if !android return fields; #end
		var pos = Context.currentPos();
		var access = [AStatic,APublic,AInline];
		var kind = FVar(macro: Int,macro 0);
		var L1:Array<String>, L2:Array<String>, L3:Array<String>, L4:Array<String>;
		var names:Array<String> = [], vals:Array<Int> = [];
		if(cfg == null) cfg = getConfig(configFile);

		var s = "";  
		var pack = cfg.pack + "";
		pack = pack.replace(".","/"); 
//		var file = "bin/android/gen/"+pack+"/R.java"; 
var file = "bin/android/app/build/generated/source/r/debug/com/tondy/snake/R.java"; 
		if(!isFile(file)){
			trace("no file: "+file);
			return fields;
		}
		try s = File.getContent(file) catch(m:Dynamic){trace(m);}
		if(s == ""){
			trace("empty file: "+file);
			return fields;
		}
		
		var L1 = s.split("public static final class");
		L1.shift();
		for(l1 in L1){
			L2 = l1.split("{");
			L3 = L2[1].replace("public static final int","").split(";");
			L3.pop();
			for(l3 in L3){
				L4 = l3.split("=");
				names.push(L4[0].trim().toUpperCase());
				vals.push(Std.parseInt(L4[1].trim()));
			}
		}
		for(i in 0...names.length){
			kind = FVar(macro:Int,macro $v{vals[i]});
			fields.push({name: names[i], access: access, kind: kind, pos: pos, doc: null, meta: []});
		}

		return fields;
	}// buildR()
	
	macro public static function embedResources():Array<Field>
	{
		var fields = Context.getBuildFields();
		
		Context.addResource(configFile,File.getBytes(configFile));

		if(cfg == null) cfg = getConfig(configFile);

		var resDir:String = cfg.resDir == null?"res/":cfg.res;
		var a:Array<String> = cfg.resources; 
		if(a[0] == "*") a = getDir(resDir);
		var trg = "default";
#if android trg = "android"; #elseif ios trg = "ios"; #end
		for(w in a){
			if(w == "gui"){
				a.remove(w);
				a.push("ui/"+trg+"/gui.html");
				a.push("ui/"+trg+"/gui.css");
				break;
			}
		}
		
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

		return fields;
	}// embedResources()

	macro public static function buildConfig():Array<Field>
	{
		var fields = Context.getBuildFields();
		var pos = Context.currentPos();
		var name = basename(Sys.getCwd());
		var access = [AStatic,APublic];
		var kind = FVar(macro: String,macro "");
		var context = 2;
		
		if(cfg == null) cfg = getConfig(configFile); 

		var d:Dynamic = null;
		var props = Reflect.fields(cfg); 
		
		if(props.indexOf("context") != -1){
			context = Reflect.field(cfg,"context");  
			props.remove("context");  
		}

		for(f in props){ 
			name = f.toUpperCase(); 
			d = Reflect.field(cfg,f); 
#if debug 	Sys.println("abv.lib.CC."+name+": "+d); #end
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

		if(true){
			access = [AStatic,APublic]; 
			d = switch(context){
				case 1: CTX_1D;
				case 3: CTX_3D;
				default: CTX_2D;
			}
			kind = FVar(macro: RenderContext,macro $v{d});
			fields.push({name: "CONTEXT", access: access, kind: kind, pos: pos, doc: null, meta: []});
		}

        return fields;
	}// buildConfig()

	macro public static function buildLang():Array<Field>
	{ 
		var fields = Context.getBuildFields(); //trace("\n"+fields[1].kind);
		var pos = Context.currentPos();
		
		if(cfg == null) cfg = getConfig(configFile);
		
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
	
	static function getConfig(file:String)
	{
		var r:Dynamic = null;
		var name = basename(Sys.getCwd());

		if(isFile(file)) r = getJson(file);
		
		if(r == null)r = {name:name};
			
		if(!Reflect.hasField(r,"pack"))Reflect.setField(r,"pack","");
		if(!Reflect.hasField(r,"name"))Reflect.setField(r,"name",name);
		if(!Reflect.hasField(r,"main"))Reflect.setField(r,"main","");
		if(!Reflect.hasField(r,"width"))Reflect.setField(r,"width",0);
		if(!Reflect.hasField(r,"height"))Reflect.setField(r,"height",0);
		if(!Reflect.hasField(r,"ups"))Reflect.setField(r,"ups",0);
		if(!Reflect.hasField(r,"res"))Reflect.setField(r,"res","");
		if(!Reflect.hasField(r,"build"))Reflect.setField(r,"build",Date.now().toString()); 
		
		return r;
	}// getConfig()
	
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
		var rgx = ~/[ ][ ]+/g;
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
	

	macro public static function buildBoot():Array<Field>
	{
		var fields = Context.getBuildFields();
		var pos = Context.currentPos();
		var access = [AStatic,APublic];
		if(cfg == null) cfg = getConfig(configFile);
		var app = "new " + cfg.pack+"."+cfg.main + " ()";
#if !(android || ios || engine)
		var expr = Context.parse("{var app = "+app+";}",pos); 
#else	
		var expr = macro {}; 
#end
		var kind = FFun({ args : [], expr : expr, params : [], ret : null });
		fields.push({name: "main", access: access, kind: kind, pos: pos, doc: null, meta: []});
#if (android || ios || engine)
		kind = FVar(null,Context.parse(app,pos));
		fields.push({name: "app", access: access, kind: kind, pos: pos, doc: null, meta: []});
#end

		return fields;
	}// buildBoot()
	
	
  	
}// abv.macro.BM
