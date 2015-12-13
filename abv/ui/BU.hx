package abv.ui;
/**
 * BuildUI
 **/
import abv.lib.comp.Component;
import abv.lib.comp.Container;
import abv.ds.AMap;
import abv.ui.control.*; 
import abv.ui.control.*;
import abv.ui.control.Button;
import abv.lib.style.*;
import abv.lib.style.Style;
import abv.lib.Enums;
import abv.bus.*;
import abv.interfaces.*;
import abv.AM;

import haxe.Json;

using abv.lib.CC;
using abv.ds.TP;

class BU{

	static var wdg:AMap<String,Component>;
	static var styles:AMap<String,Style>;
	static var root:Container = null;
	
	public static inline function build(box:Container,path:String)
	{ 
		wdg = new AMap();
		if(!path.good(ERROR+' path: $path'))return;
		if(box.isNull(" in BU")) return;

		root = box;
		var name = path.basename(false);
		path = path.dirname(); 
		var cssFile = path + name + ".css"; 
		var css = AM.fsGetText(cssFile); 
		if(!css.good()){
			trace(ERROR+" no css: " + cssFile);
			return;
		}
		var skinFile = path + name + ".html";
		var skin = AM.fsGetText(skinFile);
		if(!skin.good()){
			trace(ERROR+" no skin: " + skinFile);
			return;
		}
		
		styles = CP.parse(css,path) ;  
		root.styles = styles.copy(); 
		
		try{  
			var html = Xml.parse(skin).firstElement();  
			var body = html.elementsNamed("body").next();  
			for(node in body.elements()) processNode(node); 
		}catch(d:Dynamic)trace(ERROR + " skin(" + name +"): "+d);

		for(obj in root.getChildren()){ 
			if(obj.isNull("in "+root.name))continue; 
			try obj.parent.placeChild(obj)
			catch(d:Dynamic)trace(ERROR+" "+obj.parent.name+"->"+obj.name+": "+d);
		} 
	}// build()

	static inline function processNode(node:Xml)
	{
		var att = new AMap<String,String>(); 
		for(a in node.attributes()) att.set(a,node.get(a)); 
 
		var elm = "" + node.nodeName;  
		var nid = "" + node.get("id");
		var cls = "" + node.get("class"); 

		if((elm == "") || (nid == "")) {
			trace("elm: "+elm+", nid: "+nid); 
			return;
		}
		var label = "" + node.firstChild().nodeValue; 
		var pid:Null<String> = node.parent.get("id");
		var obj:Component = null;
		
		switch(cls){
			case "vbox"		: obj = new VBox(nid); 
			case "hbox"		: obj = new HBox(nid); 
			case "fbox"		: obj = new FBox(nid); 
			case "label"	: obj = new Label(nid,label);
			case "dialog"	: obj = new VBox(nid); 
		}
//if(cls == "label")trace(node.parent);
		switch(elm){
			case "button"	: obj = new Button(nid,label);
			case "img"		: obj = new Image(nid); 
		}

		if(obj == null) obj = new Component(nid);

		wdg.set(nid,obj); //trace(pid+":"+nid);
// add child to parent / root
		if(pid == null)root.addChild(obj);else cast(wdg[pid],Box).addChild(obj); 

		applyAttributes(att,obj);		
		applyStyle(elm,att,obj);
		
		obj.style.state = NORMAL;
		styleApply(obj,obj.style);
		
		if(obj.parent == obj.root) styleApply(obj.parent,obj.parent.style);

		for(child in node.elements()){
			try processNode(child)
			catch(d:Dynamic)trace(ERROR + " " + child.get("id") +": "+d);
		}
	}// processNode()
	
	public static inline function styleApply(o:Component,s:Style)
	{
		if((o != null)&&(s != null)){
			o.style.copy(s);
			if(s.left != null) o.pos.x = s.left; else o.style.left = o.pos.x;
			if(s.top != null) o.pos.y = s.top; else o.style.top = o.pos.y;
			if(s.width != null) o.width = s.width; else o.style.width = o.width;
			if(s.height != null) o.height = s.height; else o.style.height = o.height;
			if(o.style.background == null) o.style.setBackground();
			if(o.style.background.color != null) o.color = o.style.background.color.i();
			else o.style.background.color = o.color;
			if(o.style.margin == null) o.style.setMargin();
			if(o.style.padding == null) o.style.setPadding();
		}else{
			trace('obj: $o \nstyle: $s');
		}
	}// styleApply()	

	static inline function applyStyle(elm:String,att:AMap<String,String>,obj:Component)
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
			try obj.style.copy(styles[s])
			catch(d:Dynamic) trace(ERROR+s +": "+d);
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
					try obj.style.copy(styles[s])
					catch(d:Dynamic) trace(ERROR+s +": "+d);
				}
			}
		}
	}// applyStyle()
	
	static inline function applyAttributes(attr:AMap<String,String>,obj:Component)
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
					try act = Json.parse(av)
					catch(d:Dynamic)trace(ERROR+attr["id"] +"(action): "+d); 
					if(act.length == 0)continue; 
					for(a in act){
						p = a.splitt(","); 
						cm = 0;
						if(p[3] != null)cm = MS.cmCode(p[3]); //trace(p[1]+": "+ID.show());
						obj.setAction(MS.msgCode(p[0]),p[1],MS.msgCode(p[2]),cm);
					}
				case "states": 
					try st = Json.parse(av)
					catch(d:Dynamic)trace(ERROR+attr["id"] +"(states): "+d); 
					if(st.length == 0)continue; 
					cast(obj, IStates).states = st;
					obj.text = cast(obj, IStates).states[obj.state].text;
				case "visible": obj.visible = av == "false" ? false:true;  
			}
		}
	}// applyAttributes()

}// abv.ui.BU

