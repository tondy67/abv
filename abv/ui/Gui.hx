package abv.ui;


import abv.lib.comp.Component;
import abv.bus.*;
import abv.lib.math.Point;
import abv.ui.box.*; 
import abv.ui.widget.*;
import abv.ui.widget.Button;
import abv.lib.style.*;
import abv.lib.style.Style;
import abv.io.Screen;
import abv.ds.FS;
import haxe.Json;

using abv.lib.CR;
using abv.lib.TP;
/**
 * 
 **/
@:dce
class Gui extends Root{
	
	var styles:Map<String,Style>;

	public function new(w:Float,h:Float) 
	{
		_id = "Gui";
		super(id,w,h);
		context = Ctx1D;
//		init() ;
	}// new() 
	
	public function build(skin:String,css:String)
	{
		var cp = new CssParser();
		styles = cp.parse(css) ;  //for(k in styles.keys())trace(k);
		
		try{
			var html = Xml.parse(skin).firstElement(); 
			var body = html.elementsNamed("body").next(); 
			for(node in body.elements())processNode(node);
		}catch(d:Dynamic){trace(CR.ERROR+skin.basename() +": "+d);}
	}// build()

	function processNode(node:Xml)
	{
		var att = new Map<String,String>(); 
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

		if(obj == null){
			trace(elm+"> id: "+nid+", class: "+cls);
			return;
		}
		
		wdg.set(nid,obj);
// add child to parent / root
		if(pid == null)addChild(obj);else cast(wdg[pid],Box).addChild(obj);

		applyAttributes(att,obj);		
		applyStyle(elm,att,obj);
	
		obj.style.state = NORMAL;
		try cast(obj.parent,Box).placeChild(obj)
		catch(d:Dynamic){trace(CR.ERROR+obj.parent.id+": "+d);}

		for(child in node.elements())processNode(child);
	}// processNode()
	
	function applyStyle(elm:String,att:Map<String,String>,obj:Component)
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
			try obj.style.apply(styles[s])
			catch(d:Dynamic) {trace(CR.ERROR+s +": "+d);}
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
					try obj.style.apply(styles[s])
					catch(d:Dynamic) {trace(CR.ERROR+s +": "+d);}
				}
			}
		}
	}
	
	function applyAttributes(attr:Map<String,String>,obj:Component)
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
					catch(d:Dynamic){trace(CR.ERROR+attr["id"] +"(action): "+d);}; 
					if(act.length == 0)continue;
					for(a in act){
						p = a.split(","); 
						for(i in 0...p.length)p[i] = p[i].trim();
						cm = 0;
						if(p[3] != null)cm = MS.cmCode(p[3]);
						obj.action(MS.msgCode(p[0]),p[1],MS.msgCode(p[2]),cm);
					}
				case "states": 
					try st = Json.parse(av)
					catch(d:Dynamic){trace(CR.ERROR+attr["id"] +"(states): "+d);}; 
					if(st.length == 0)continue;
					st.unshift({text:Button.Normal});
					cast(obj, Button).states = st;
					obj.text = cast(obj, Button).states[obj.state].text;
				case "visible": obj.visible = av == "false" ? false:true;  
			}
		}
	}//
	
	public function init() 
	{

	}// init() 
	
}// abv.ui.Gui
