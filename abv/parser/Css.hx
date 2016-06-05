package abv.parser;


import abv.style.Style;
import abv.style.Color;
import abv.math.Rect;

import Type;

using haxe.io.Path;
using abv.sys.ST;
using abv.math.MT;
using abv.ds.TP;

@:dce
class Css {

//	public static var styleType = new Map<String,Int>();
	static var styles:Map<String,Style>;
	static var path = "";
	
	public static inline function parse(css:String,basedir="")
	{ 
		styles = new Map<String,Style>(); 
		if(!ST.good(css)) return styles; 
		path = basedir.addSlash(); 
		css = css.reduceSpaces();
		css = delComments(css); 
		var L1:Array<String> = [];
		var L2:Array<String> = [];
		var L3:Array<String> = [];
		var L4:Array<String> = [];
		var name = "";
		var field = "";
		var val = "";
		
		L1 = css.trim().explode("}"); 
		for(i in 0...L1.length-1){
			L2 = L1[i].trim().explode("{"); 
			if(L2[1] != null){
				name = L2[0].trim(); if(name=="")continue;
				L3 = L2[1].trim().explode(";"); 
				for(j in 0...L3.length){
					if (L3[j] == null) continue;
					L4 = L3[j].trim().explode(":"); 
					if(L4.length != 2) continue;
					field = L4[0].trim(); 
					val = L4[1].trim();   
					if(!styles.exists(name)){ 
						styles.set(name,new Style(name)); 
					}
					try setField(name,field,val) catch(e:Dynamic){ST.error(name ,e);} 
				}
			}
		}

		return styles;
	}// parse()

	static inline function setField(name:String,field:String,val:String)
	{  
		var p = field.explode("-");
		field = p[0].lower().trim();
		if(field == "display")return;
		var sub = p.length == 2 ? p[1].lower().trim():"";
		var f:Float;
		
		val = val.trim();
		var m = ["px"=>"","url("=>"",")"=>"","'"=>"",'"'=>"",
		"auto"=>"-1"];
		for(k in m.keys())if(val.indexOf(k) != -1)val = val.replace(k,m[k]); 

		if(val.indexOf("%") != -1){
			f = val.replace("%","").toFloat().range(100); 
			if(f == 100)f = 99; 
			f /= 100;
			val = f+"";
		};	

		switch(field){
			case "border": 
				styles[name].setStroke();
				switch(sub){
					case "width": styles[name].stroke.width = val.toFloat();
					case "color": styles[name].stroke.color = val;
					case "radius": styles[name].stroke.radius = val.toFloat();
				}
			case "background": 
				styles[name].setFill();
				switch(sub){
					case "color": styles[name].fill.color = val;
					case "image": styles[name].fill.image = path+val;
					case "repeat": styles[name].fill.repeat = 1;
					case "position": styles[name].fill.tile = getPos(val);
				}
			case "margin":
				f = sub == ""?val.toFloat():0;
				styles[name].setMargin(f);
				switch(sub){
					case "top": styles[name].margin.top = val.toFloat();
					case "right": styles[name].margin.right = val.toFloat();
					case "bottom": styles[name].margin.bottom = val.toFloat();
					case "left": styles[name].margin.left = val.toFloat();
				}
			case "padding": 
				f = sub == ""?val.toFloat():0;
				styles[name].setPadding(f);
				switch(sub){
					case "top": styles[name].padding.top = val.toFloat();
					case "right": styles[name].padding.right = val.toFloat();
					case "bottom": styles[name].padding.bottom = val.toFloat();
					case "left": styles[name].padding.left = val.toFloat();
				}
			case "box": 
				styles[name].setBoxShadow();
				switch(sub){
					case "shadow": styles[name].boxShadow = null;
				}
			case "font": 
				styles[name].setFont();
				switch(sub){
					case "family": styles[name].font.name = val;
					case "size": styles[name].font.size = val.toFloat();
					case "style": styles[name].font.style = 1;
				}
			case "left": styles[name].left = val.toFloat();
			case "top": styles[name].top = val.toFloat();
			case "bottom":styles[name].bottom = val.toFloat();
			case "right":styles[name].right = val.toFloat();
			case "width": styles[name].width = val.toFloat();
			case "height": styles[name].height = val.toFloat();
			case "color": styles[name].color = val;
			case "src":styles[name].font.src = path + getSrc(val);
			case "position":{};
			case "align":{};
			default: ST.warn(ST.getText(16),name+"->"+field);
		}
	}// setField()
	
	static inline function getSrc(s:String)
	{
		var r = "";
		if(s.good()){
			var t = s.explode(" "); 
			r = t[0].trim();
		}
		return r;
	}//
	
	static inline function getPos(s:String)
	{
		var p:Rect = null; 
		var t = s.explode(" "); 
		var x:Null<Int> = Std.parseInt(t[0]);
		var y:Null<Int> = Std.parseInt(t[1]); 
		if((x != null) && (y != null) )p = new Rect(x,y,0,0);
		
		return p;		
	}// getPos()
	
	static inline function delComments(s:String)
	{ 
		var r:Array<String> = [];
		var L1:Array<String> = [];
		var L2:Array<String> = [];
		L1 = s.trim().explode("*/"); 	
		for(a in 0...L1.length){
			L2 = L1[a].trim().explode("/*"); 
			if(L2[0] != "")r.push(L2[0]);
		}; 
		return r.join(""); 
	}// delComments()


}// abv.parser.Css
