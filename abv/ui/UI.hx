package abv.ui;
/**
 * UI
 **/
import abv.factory.Component;
import abv.parser.Css;
import abv.ds.*;
import abv.ui.controls.*; 
import abv.ui.controls.Button;
import abv.style.*;
import abv.Enums;
import abv.bus.*;
import abv.factory.*;
import abv.AM;

import haxe.Json;

using haxe.io.Path;
using abv.sys.ST;
using abv.ds.TP;

class UI{

	static var wdg:Map<String,Component>;
	static var styles:Map<String,Style>;
	static var root:Component = null;
	
	public static inline function build(box:Component,path:String)
	{ 
		wdg = new Map();
		if(!ST.good(path)){
			ST.error("path",path);
			return;
		}
		
		if(box == null){
			ST.errNullObject();
			return;
		}

		root = box;
		var cssFile = path.withExtension("css");  
		var css = FS.getText(cssFile); 
		if(!ST.good(css)){
			ST.error("no css:",cssFile);
			return;
		}

		var skin = FS.getText(path);
		if(!ST.good(skin)){
			ST.error("no skin:",path);
			return;
		}
		
		path = path.directory(); 
		styles = Css.parse(css,path) ;  
//		root.styles = styles.copy(); 
		for (k in styles.keys()) Style.stylesheet.set(k,styles[k]);
		
		var html:Xml = null, body:Xml = null;
		var err = 'skin($path)';

		try{
			html = Xml.parse(skin).firstElement();  
			body = html.elementsNamed("body").next();
		}catch(e:Dynamic)ST.error(err,e);  

		if(body != null){
			for(node in body.elements()){		
				try processNode(node)catch(e:Dynamic)ST.error(err,node.get("id"));
			}
		}
			
		for(it in root.getChildren()){ 
			if(it == null){ 
				ST.error(ST.getText(20),root.name);
				continue; 
			} 
			try cast(it.parent,Box).placeChild(it)
			catch(e:Dynamic)ST.error(ST.getText(20),it.parent.name+"->"+it.name);
		} 
	}// build()

	static inline function processNode(node:Xml)
	{
		var att = new MapSS(); 
		for(it in node.attributes()) att.set(it,node.get(it)); 
 
		var elm = node.nodeName;  
		var nid = node.get("id"); 
		var cls = node.get("class"); 

		if(!ST.good(nid)) {
			ST.error("elm",elm); 
			return;
		}
		var label = node.firstChild().nodeValue; 
		var pid = node.parent.get("id");
		var obj:Component = null;
 
		if(cls != null){
			switch(cls){
				case "vbox"		: obj = new VBox(nid); 
				case "hbox"		: obj = new HBox(nid); 
				case "fbox"		: obj = new FBox(nid); 
				case "label"	: obj = new Label(nid,label);
				case "dialog"	: obj = new VBox(nid); 
			}
		}

		if(elm != null){
			switch(elm){
				case "button"	: obj = new Button(nid,label);
				case "img"		: obj = new Image(nid); 
			}
		}

		if(obj == null) obj = new Component(nid);
		wdg.set(nid,obj); //trace(pid+":"+nid);
// add child to parent / root
		if(pid == null) root.addChild(obj); else wdg[pid].addChild(obj); 

		applyAttributes(att,obj);		
		applyStyle(elm,att,obj);
		
		obj.style.state = NORMAL;
		Style.sync(obj);
	
		if(obj.parent.parent == null) Style.sync(obj.parent);

		for(it in node.elements()){ 
			try processNode(it)catch(e:Dynamic)ST.error(it.get("id"),e);
		}
	}// processNode()
	
	static inline function applyStyle(elm:String,att:MapSS,obj:Component)
	{
		var cl = "." + att["class"];
		var nid = "#" + att["id"]; 
		var cid = cl + nid; 
		var sel = new List<String>(); //trace(elm+":"+cl+":"+nid+":"+cid);
		if(styles.exists(elm)) sel.add(elm);
		if(styles.exists(cl)) sel.add(cl);
		if(styles.exists(nid))sel.add(nid);
		if(styles.exists(cid)) sel.add(cid);
		for (s in sel) {
			try obj.style.copy(styles[s])catch(e:Dynamic)ST.error(s,e);
		}

		var state:String;
		for (k in Type.allEnums(States)) { 
			state = ":" + (k+"").toLowerCase(); 
			sel.clear();
			if(styles.exists(elm+state)) sel.add(elm+state);
			if(styles.exists(cl+state)) sel.add(cl+state);
			if(styles.exists(nid+state)) sel.add(nid+state);
			if(styles.exists(cid + state)) sel.add(cid + state); 
			if(sel.length > 0) { 
				obj.style.reset(k); 
				for (s in sel) { 
					try obj.style.copy(styles[s])catch(e:Dynamic)ST.error(s,e);
				}
			}
		}
	}// applyStyle()
	
	static inline function applyAttributes(attr:MapSS,obj:Component)
	{
		var av:String;
		var p:Array<String>;
		var cm:Int;
		var st:Array<StateData> = [];
		var act:Array<String> = [];

		for(att in attr.keys()){
			av = attr[att].trim().replace("'",'"'); 
			switch(att){
				case "action": 
					try act = Json.parse(av)catch(e:Dynamic)ST.error(attr["id"] +"(action):",e); 
					if(act.length == 0)continue; 
					for(a in act){
						p = a.explode(","); 
						cm = 0;
						if(p[3] != null)cm = MS.cmCode(p[3]); 
						obj.setAction(MS.msgCode(p[0]),p[1],MS.msgCode(p[2]),cm);
					}
				case "states": 
					try st = Json.parse(av)catch(e:Dynamic)ST.error(attr["id"] +"(states):",e); 
					if(st.length == 0)continue; 
					if (obj.kind == BUTTON){
				// FIXME: hxcpp 3.3.49 cast error?!
				#if !cpp
						cast(obj, IStates).states = st;
						obj.text = cast(obj, IStates).states[obj.state].text;
				#end
					}
				case "visible": obj.visible = av == "false" ? false:true;  
			}
		}
	}// applyAttributes()

}// abv.ui.UI

