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
import abv.Enums;

using StringTools;
using abv.sys.ST;

class BM {
	
	static var langFile 	= "lang.json";
	static var cfg:Dynamic 	= null;
//
	static inline var TRAIT = "ITrait";
	static inline var TPATH = "abv.factory";
	static var fieldsMap 	= new Map<String,Map<String,Field>>();
	static var parentsMap 	= new Map<String,String>();
   	static var args: Array<FunctionArg>;
   	static var kind: FieldType;
   	static var expr: Expr;
   	static var meta: Null<Metadata>;
	static var pos: Position;
	static var access: Null<Array<Access>>;
	static var field: Field;
	static var fields: Array<Field>;

	macro public static function buildR():Array<Field>
	{
		fields = Context.getBuildFields();
#if !android return null; #end
		pos = Context.currentPos();
		access = [AStatic,APublic,AInline];
		kind = FVar(macro: Int,macro 0);
		var L1:Array<String>, L2:Array<String>, L3:Array<String>, L4:Array<String>;
		var names:Array<String> = [], vals:Array<Int> = [];
		if(cfg == null) cfg = getConfig(ST.CFG_FILE);

		var s = "";  
		var pack = cfg.pack + "";
		pack = pack.replace(".","/"); 
//		var file = "bin/android/gen/"+pack+"/R.java"; 
var file = "bin/android/app/build/generated/source/r/debug/com/tondy/snake/R.java"; 
		if(!ST.isFile(file)){
			trace("no file: "+file);
			return fields;
		}
		try s = File.getContent(file) catch(m:Dynamic){trace(m);}
		if(s == ""){
			ST.error("empty file",file);
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
			fields.push(mkField(names[i],kind,access,pos));
		}

		return fields;
	}// buildR()
	
	static function embedResources():Array<Field>
	{
//		if(!ST.exists(ST.CFG_FILE))throw ST.getText(22);

//		Context.addResource(ST.CFG_FILE,File.getBytes(ST.CFG_FILE));
	
		if(cfg == null) cfg = getConfig(ST.CFG_FILE); 

		var a:Array<String> = cfg.resources; 
		if(a == null) return null;
		var files:Array<String> = [];
		var cur = ""; 
		if(a[0] == "*"){
			files = ST.ls(ST.RES_DIR,true); 
		}else{
			for (it in a){
				cur = ST.RES_DIR.addSlash() + it; 
				if (ST.isDir(cur)) files = files.concat(ST.ls(cur,true));	
				else files.push(cur);
			} 
		} 
/*
			var trg = "default";
#if android 
			trg = "android"; 
#elseif ios 
			trg = "ios"; 
#end
			for(w in a){
				if(w == "gui"){
					a.remove(w);
					a.push("ui/"+trg+"/gui.html");
					a.push("ui/"+trg+"/gui.css");
					break;
				}
			}
*/	
		var target = getTarget();
		var m = new Map<String,Bytes>();

		for(f in files){ 
			if(ST.isFile(f)){ 
				if (!ST.file(f).bin || (ST.file(f).type == "img")){
					m.set(f,ST.openFile(f));		
				}else{
					switch(ST.file(f).type){
						case "font": embedFont(f);
					}	
				} 
				ST.rm(ST.BUILD_DIR + ST.addSlash(target) + f);
			}
		}
#if !android
		var z = ST.zipVFS(m); 
		if (z != null) Context.addResource("zip",z);
#end
		return null;
	}// embedResources()

	static function getTarget()
	{
		var r = "";
		if (Context.defined("flash"))        r = "flash";
		else if (Context.defined("js"))      r = "js";
		else if (Context.defined("neko"))    r = "neko";
		else if (Context.defined("cpp"))     r = "cpp";
		else if (Context.defined("java"))    r = "java";
		else if (Context.defined("android")) r = "android";
		else if (Context.defined("ios"))     r = "ios";
		else if (Context.defined("engine"))  r = "engine";

		return r;
	}

	macro public static function buildConfig():Array<Field>
	{
		fields = Context.getBuildFields();
		pos = Context.currentPos();
		var name = ST.basename(ST.pwd());
		access = [AStatic,APublic];
		kind = FVar(macro: String,macro "");
		
		if(cfg == null) cfg = getConfig(ST.CFG_FILE); 

		var d:Dynamic = null;
		var props = Reflect.fields(cfg); 
		
		for(f in props){ 
			name = f.toUpperCase(); 
			d = Reflect.field(cfg,f); 
			ST.info("abv.CC."+name,d,null); 
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
				default: name = ""; ST.error(ST.getText(9),f);
			}

			if(name != "")fields.push(mkField(name,kind,access,pos));
		}
		
		embedResources();
        
        return fields;
	}// buildConfig()

	macro public static function buildLang():Array<Field>
	{ 
		fields = Context.getBuildFields(); //trace("\n"+fields[1].kind);
		pos = Context.currentPos();
		
		if(cfg == null) cfg = getConfig(ST.CFG_FILE);
		
		access = [AStatic,APublic];
		var props:Array<String> = [];
		var d:Dynamic = null;
		var lg:Dynamic = null;
		var langs:Array<String> = [];
		var id:Array<String> = [];
		var words:Array<Array<String>> = [];
		var file = ST.addSlash(cfg.res) + langFile; 
		if(ST.isFile(file)){
			lg = getJson(file); 
			props = Reflect.fields(lg); 
			ST.rm(ST.BUILD_DIR + ST.addSlash(getTarget()) + ST.addSlash(ST.RES_DIR)+langFile);			
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
		
		kind = FVar(macro: Array<String>,macro $v{langs});
		fields.push(mkField("langs",kind,access,pos));
		kind = FVar(macro: Array<String>,macro $v{id});
		fields.push(mkField("id",kind,access,pos));
		kind = FVar(macro: Array<Array<String>>,macro $v{words});
		fields.push(mkField("words",kind,access,pos));

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
		var name = ST.basename(ST.delSlash(ST.pwd()));

		if(ST.isFile(file)) r = getJson(file);
		
		if(r == null)r = {name:name};
			
		if(!Reflect.hasField(r,"pack"))Reflect.setField(r,"pack","");
		if(!Reflect.hasField(r,"name"))Reflect.setField(r,"name",name);
		if(!Reflect.hasField(r,"main"))Reflect.setField(r,"main","App");
		if(!Reflect.hasField(r,"src"))Reflect.setField(r,"src",["src"]);
		if(!Reflect.hasField(r,"width"))Reflect.setField(r,"width",0);
		if(!Reflect.hasField(r,"height"))Reflect.setField(r,"height",0);
		if(!Reflect.hasField(r,"ups"))Reflect.setField(r,"ups",0);
		if(!Reflect.hasField(r,"res"))Reflect.setField(r,"res","");
		if(!Reflect.hasField(r,"build"))Reflect.setField(r,"build",Date.now().toString()); 
		
		return r;
	}// getConfig()
	
	static function getJson(file:String)
	{
		var r:Dynamic = ST.getJson(file);
		if(r == null)throw "No valid json!";

		return r;
	}// getJson()
	
	static inline function embedText(f:String)
	{ 
		var s = ST.open(f); 
		var rgx = ~/[ ][ ]+/g;
		s = rgx.replace(s," "); 
		Context.addResource(f,Bytes.ofString(s));
	}// embedText()

	static inline function embedImage(f:String)
	{// TODO: embedImage
	}// embedImage()

	static inline function embedFont(f:String)
	{// TODO: embedFont
	}// embedFont()
	
/**
 * Boot
 */
	macro public static function buildBoot():Array<Field>
	{
		fields = Context.getBuildFields();
		pos = Context.currentPos();
		access = [AStatic,APublic];
		if(cfg == null) cfg = getConfig(ST.CFG_FILE);
		var app = "new " + cfg.main + " ()"; // cfg.pack+"."+
#if !(android || ios || engine)
		expr = Context.parse("{var app = "+app+";}",pos); 
#else	
		expr = macro {}; 
#end
		kind = FFun({ args : [], expr : expr, params : [], ret : null });
		fields.push(mkField("main",kind,access,pos));
#if (android || ios || engine)
		kind = FVar(null,Context.parse(app,pos));
		fields.push(mkField("app",kind,access,pos));
#end

		return fields;
	}// buildBoot()
/**
 * Traits
 */
	macro public static function addTraits():Array<Field>
	{
        fields 	= Context.getBuildFields();
        pos    	= Context.currentPos();
        var cur    	= Context.getLocalClass().get();
        var cls 	= cur.name; // Context.getLocalModule()
        var parent 	= "";
        var trait 	= "";
        var s 		= "";
        var d:Dynamic;
        var a:Array<String>;

        if(cur.isInterface){
        	parent = cur.interfaces[0].t.get().name; 
        	if(parent == TRAIT)parent = ""; 
        }else{
        	d = Reflect.field(cur,'superClass'); 
        	if(d != null) parent = d.t.get().name; 
    	}
    	
    	if(!parentsMap.exists(cls))parentsMap.set(cls,parent); 
    	else ST.error(ST.getText(7),cls);
 //trace(cls+":"+getParents(cls));
 
 		if(!fieldsMap.exists(cls)){
			fieldsMap.set(cls,new Map());
			for(it in fields){
				s = cur.isInterface ? cls + "." + it.name : it.name;
				fieldsMap[cls].set(s,it);
			}
			for(it in getParents(cls)){
				for(k in fieldsMap[it].keys()) fieldsMap[cls].set(k,fieldsMap[it][k]);
			}
		}else{
		  ST.error(ST.getText(7),cls);
		}

		if(!cur.isInterface){
			ST.debug("Implementing.. .",null,null); 
			for(it in cur.interfaces){
				trait = it.t.get().name; 
				for(k in fieldsMap[trait].keys()){ 
					a = k.split(".");  
					if(!fieldsMap[cls].exists(a[1])){
						s = TPATH + ".T" + a[0].substr(1);
						field = copyField(s,cls,fieldsMap[trait][k]);
						addField(cls,field,fields);
						// setter/getter
						for(it in mkGetSet(cls,field))addField(cls,it,fields);
					}
				}
				ST.debug("trait",trait,null); 
			}
#if log
			s = cls + "{";
			for(k in fieldsMap[cls].keys()) s += fieldsMap[cls][k].name +", ";
			s += "}";
			ST.log(s,null,null);
#end
		}

if(cls == "ITree"){
//	trace(fieldsMap[cls]["ttt"]);
//	trace(Context.parse("abv.factory.TTree",Context.currentPos()));
}
		return fields;
	}// addTraits()

    static inline function getParents(cls:String) 
    { 
    	var r:Array<String> = [];
    	if(parentsMap.exists(cls)){
    		var p = "";
    		var cur = cls;
    		while(parentsMap[cur] != ""){
    			p = parentsMap[cur];
    			r.push(p);
    			cur = p;
    		}
    	}
    	return r;
    }// getParents()

    static inline function mkGetSet(cls:String,f:Field) 
    { 
    	var r:Array<Field>  = [];
    	pos = Context.currentPos();
    	var pvar = "_" + f.name;
    	var name:String;

		switch(f.kind){
          	case FProp(get,set,t,e): 
				if((get == "get")&&(set == "set")){ // private var
					if(!fieldsMap[cls].exists(pvar))r.push(mkField(pvar,FVar(t,e)));
				}
				if(set == "set"){ // setter
					args = [{ name: "v", type: t, opt: false, value: null }];
    				expr = Context.parse("{return "+pvar+"= v;}",pos);
        			kind = FFun({expr: expr, args: args, ret: null, params: null});
        			name = "set_" + f.name;
					if(!fieldsMap[cls].exists(name))r.push(mkField(name,kind));
				}
				if(get == "get"){ // getter
    				expr = Context.parse("{return "+pvar+";}",pos);
        			kind = FFun({expr: expr, args: [], ret: null, params: null});
        			name = "get_" + f.name;
					if(!fieldsMap[cls].exists(name))r.push(mkField(name,kind));
				}
           	default:{};
		}

    	return r;
    }// mkGetSet()

    static inline function mkField(name:String, kind: FieldType, access: Null<Array<Access>>=null, 
    	pos: Position=null, doc:Null<Null<String>>= null, meta:Null<Metadata>= null) 
    {  //if(name == "childrenTree") trace(meta);
    	if(access == null)access = [];
    	if(pos == null)pos = Context.currentPos();
   		if(meta == null)meta = [];
       	return {name: name, kind: kind, access: access, pos: pos, doc: doc, meta: meta};
    }// mkField()

    static inline function addField(cls:String,field:Field,fields:Array<Field>) 
    {
		fieldsMap[cls].set(field.name,field);
		fields.push(field); //trace(field.name);
    }// addField()

	static inline function copyField(trait:String,cls:String,field:Field):Field 
	{  
    	kind = switch(field.kind){
	                case FFun(f): FFun(copyFunc(trait,field.name,f));
	                default: field.kind;
	            }
    	return mkField(field.name,kind,field.access.copy(),field.pos,field.doc,field.meta);
	}// copyField()

	static inline function copyFunc(trait:String,name:String,fn:Function):Function 
	{ 
    	var body = "{return " + trait + "." + name + "(this"; 
    	for(i in 0...fn.args.length) body += "," + fn.args[i].name;
    	body += ");}";   
    	expr = Context.parse(body,Context.currentPos());
        return {expr: expr, args: fn.args, ret: fn.ret, params: fn.params};
	}// copyFunc()

	static inline function print(d:Dynamic) 
    { 
    	if(d != null){
    		var s = d + "";
    		Sys.println(s);
    	}
    }
}// abv.macro.BM
