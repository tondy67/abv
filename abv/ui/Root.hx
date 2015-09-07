package abv.ui;
/**
 * Root
 **/
import abv.lib.comp.Component;
import abv.lib.box.Container;
import abv.lib.math.Point;
import abv.ui.box.*; 
import abv.ui.widget.*;
import abv.ui.widget.Button;
import abv.lib.style.*;
import abv.lib.style.Style;
import abv.bus.*;
import abv.io.Screen;
import abv.interfaces.*;
import abv.ds.AMap;

import haxe.Json;

using abv.lib.CC;
using abv.ds.TP;

@:dce
@:allow(abv.io.Screen)
class Root extends Box{
	
	var wdg = new AMap<String,Component>() ;
	var styles:AMap<String,Style>;
	public var context = CC.CTX_2D;
	
	public inline function new(id:String,width=100.,height=100.)
	{
		super(id);
		
		root = this;
		_pos.reset();
		this.width = width;
		this.height = height;
	}// new()

	override function draw(obj:Component)
	{
		Screen.render(obj);
	}// draw()

	public override function delChild(obj:Component)
	{
		if (obj != null){
			Screen.clear(obj); 
			super.delChild(obj);
		}
	}// delChild()
	
	public function refresh(w:Float,h:Float)
	{
		_pos.reset();
		width = w; height = h; 
		for(o in children){
			placeChild(o); // con???
		}
//		trace(this.childSizes);
//		trace(this);
		resize();
	}// refresh()

	public function build(path:String, name:String)
	{
		if(!path.good()||!name.good()){
			trace(ERROR+'path: $path, name: $name');
			return;
		}
		var cssFile = path + name + ".css";
		var css = AM.getText(cssFile);
		if(!css.good()){
			trace(ERROR+"no css: " + cssFile);
			return;
		}
		var skinFile = path + name + ".html";
		var skin = AM.getText(skinFile);
		if(!skin.good()){
			trace(ERROR+"no skin: " + skinFile);
			return;
		}
		
		var cp = new CssParser();
		styles = cp.parse(css,path) ;  
		
		try{
			var html = Xml.parse(skin).firstElement(); 
			var body = html.elementsNamed("body").next(); 
			for(node in body.elements())processNode(node);
		}catch(d:Dynamic)trace(ERROR + name +": "+d);

		for(obj in getChildren()){	
			try obj.parent.placeChild(obj)
			catch(d:Dynamic)trace(ERROR+obj.parent.id+"->"+obj.id+": "+d);
		}
	}// build()

	function processNode(node:Xml)
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
			case "text"		: obj = new Text(nid,label);
			case "dialog"	: obj = new VBox(nid); 
		}
		switch(elm){
			case "button"	: obj = new Button(nid,label);
			case "img"		: obj = new Image(nid); 
		}

		if(obj == null) obj = new Component(nid);
		
		wdg.set(nid,obj);
// add child to parent / root
		if(pid == null)addChild(obj);else cast(wdg[pid],Box).addChild(obj);

		applyAttributes(att,obj);		
		applyStyle(elm,att,obj);
		
		obj.style.state = NORMAL;
		Style.apply(obj,obj.style);
		if(obj.parent == obj.root)Style.apply(obj.parent,obj.parent.style);
//trace(obj.id+":"+obj.parent.style);	

		for(child in node.elements())processNode(child);
	}// processNode()
	
	function applyStyle(elm:String,att:AMap<String,String>,obj:Component)
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
		var pc:String;
		for (k in Style.State.keys()) { 
			sel.clear();
			pc = ":" + k;
			if(styles.exists(elm+pc)) sel.add(elm+pc);
			if(styles.exists(cl+pc)) sel.add(cl+pc);
			if(styles.exists(nid+pc)) sel.add(nid+pc);
			if(styles.exists(cid + pc)) sel.add(cid + pc); 
			if(sel.length > 0) { 
				obj.style.set(Style.State[k]); 
				for (s in sel) { 
					try obj.style.copy(styles[s])
					catch(d:Dynamic) trace(ERROR+s +": "+d);
				}
			}
		}
	}// applyStyle()
	
	function applyAttributes(attr:AMap<String,String>,obj:Component)
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
						if(p[3] != null)cm = MS.cmCode(p[3]);
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

}// abv.ui.Root

