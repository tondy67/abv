package abv.lib.style;


import abv.lib.style.Style;
import abv.ds.AMap;
import abv.lib.style.Color;

import Type;

using abv.lib.CC;
using abv.lib.math.MT;
using abv.ds.TP;

@:dce
class CP {

//	public static var styleType = new AMap<String,Int>();
	static var styles:AMap<String,Style>;
	static var path = "";
	
	public static inline function parse(css:String,dir="")
	{// TODO: build macro ?! 
		styles = new AMap<String,Style>(); 
		if(!css.good("no css")) return styles; 
		path = dir; 
		css = css.reduceSpaces();
		css = delComments(css); 
		var L1:Array<String> = [];
		var L2:Array<String> = [];
		var L3:Array<String> = [];
		var L4:Array<String> = [];
		var name = "";
		var field = "";
		var val = "";
		
		L1 = css.trim().splitt("}"); 
		for(i in 0...L1.length-1){
			L2 = L1[i].trim().splitt("{"); 
			if(L2[1] != null){
				name = L2[0].trim(); if(name=="")continue;
				L3 = L2[1].trim().splitt(";"); 
				for(j in 0...L3.length){
					if (L3[j] == null) continue;
					L4 = L3[j].trim().splitt(":"); 
					if(L4.length != 2) continue;
					field = L4[0].trim(); 
					val = L4[1].trim();   
					if(!styles.exists(name)){ 
					
						styles.set(name,new Style(name)); 
					}
					try setField(name,field,val) catch(d:Dynamic){trace(ERROR + " " +name + ": "+ d);} 
				}
			}
		}

		return styles;
	}// parse()

	static inline function setField(name:String,field:String,val:String)
	{  
		var p = field.splitt("-");
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
try{				styles[name].setBorder();}catch(d:Dynamic){trace(d);}
				switch(sub){
					case "width": styles[name].border.width = val.toFloat();
					case "color": styles[name].border.color = val;
					case "radius": styles[name].border.radius = val.toFloat();
				}
			case "background": 
				styles[name].setBackground();
				switch(sub){
					case "color": styles[name].background.color = val;
					case "image": styles[name].background.image = path+val;
					case "repeat": styles[name].background.repeat = 1;
					case "position": styles[name].background.position = getPosition(val);
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
			default: trace(WARN+" "+name+":"+field+" Not implemented");
		}
	}// setField()
	
	static inline function getSrc(s:String)
	{
		var r = "";
		if(s.good()){
			var t = s.splitt(" "); 
			r = t[0].trim();
		}
		return r;
	}//
	
	static inline function getPosition(s:String)
	{
		var p:BgPosition = null; 
		var t = s.splitt(" "); 
		var x:Null<Int> = Std.parseInt(t[0]);
		var y:Null<Int> = Std.parseInt(t[1]); 
		if((x != null) && (y != null) )p = new BgPosition(x,y);
		
		return p;		
	}// getPosition()
	
	static inline function delComments(s:String)
	{ 
		var r:Array<String> = [];
		var L1:Array<String> = [];
		var L2:Array<String> = [];
		L1 = s.trim().splitt("*/"); 	
		for(a in 0...L1.length){
			L2 = L1[a].trim().splitt("/*"); 
			if(L2[0] != "")r.push(L2[0]);
		}; 
		return r.join(""); 
	}// delComments()


}// abv.lib.style.CP
