package abv.lib.style;


import abv.lib.style.Style;
import Type;

using abv.lib.CR;
using abv.lib.math.MT;
using abv.lib.TP;
using abv.lib.style.Color;

@:dce
class CssParser {

	public static var styleType:Map<String,Int> = ["Class"=>1,"ID"=>2,"Elm"=>3];
	var styles = new Map<String,Style>();

	public function new()
	{
	}
	
	public function parse(css:String)
	{  
		css = css.reduceSpaces();
		css = delComments(css);
		var L1:Array<String> = [];
		var L2:Array<String> = [];
		var L3:Array<String> = [];
		var L4:Array<String> = [];
		var name = "";
		var field = "";
		var val = "";
		
		L1 = css.trim().split("}"); 
		for(i in 0...L1.length-1){
			L2 = L1[i].trim().split("{"); 
			if(L2[1] != null){
				name = L2[0].trim();
				L3 = L2[1].trim().split(";"); 
				for(j in 0...L3.length){
					if (L3[j] == null) continue;
					L4 = L3[j].trim().split(":"); 
					if(L4.length != 2) continue;
					field = L4[0].trim(); 
					val = L4[1].trim();
					if(!styles.exists(name))styles.set(name,new Style(name));
					setField(name,field,val); 
				}
			}
		}

		return styles;
	}// str()

	function setField(name:String,field:String,val:String)
	{
		var p = field.split("-");
		field = p[0].toLowerCase().trim();
		if(field == "display")return;
		var sub = p.length == 2 ? p[1].toLowerCase().trim():"";
		
		val = val.trim();
		var m = ["px"=>"","url("=>"",")"=>"","'"=>"",'"'=>"",
		"auto"=>Std.string(CR.AUTO)];
		for(k in m.keys())if(val.indexOf(k) != -1)val = val.replace(k,m[k]); 

		if(val.indexOf("%") != -1){
			var f = float(val.replace("%","")).range(100); 
			if(f == 100)f = 99; 
			f /= 100;
			val = f+"";
		};	

		switch(field){
			case "border": 
				styles[name].setBorder();
				switch(sub){
					case "width": styles[name].border.width = float(val);
					case "color": styles[name].border.color = getColor(val);
					case "radius": styles[name].border.radius = float(val);
				}
			case "background": 
				styles[name].setBackground();
				switch(sub){
					case "color": styles[name].background.color = getColor(val);
					case "image": styles[name].background.image = val;
					case "repeat": styles[name].background.repeat = 1;
					case "position": styles[name].background.position = getPosition(val);
				}
			case "margin": 
				styles[name].setMargin();
				switch(sub){
					case "top": styles[name].margin.top = float(val);
					case "right": styles[name].margin.right = float(val);
					case "bottom": styles[name].margin.bottom = float(val);
					case "left": styles[name].margin.left = float(val);
				}
			case "padding": 
				styles[name].setPadding();
				switch(sub){
					case "top": styles[name].padding.top = float(val);
					case "right": styles[name].padding.right = float(val);
					case "bottom": styles[name].padding.bottom = float(val);
					case "left": styles[name].padding.left = float(val);
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
					case "size": styles[name].font.size = float(val);
					case "style": styles[name].font.style = 1;
				}
			case "left": styles[name].left = float(val);
			case "top": styles[name].top = float(val);
			case "width": styles[name].width = float(val);
			case "height": styles[name].height = float(val);
			case "color": styles[name].color = getColor(val);
			case "src":styles[name].font.src = getSrc(val);
			default: trace(CR.WARN+name+":"+field+" Not implemented");
		}
	}// setField()
	
	inline function int(s:String) {return Std.parseInt(s); }
	inline function float(s:String) {return Std.parseFloat(s); }
	
	function getSrc(s:String)
	{
		var r = "";
		if(s.good()){
			var t = s.splitt(" "); 
			r = t[0].trim();
		}
		return r;
	}//
	
	function getColor(s:String)
	{
		var v = s.trim().toLowerCase();
		var f:Null<Float> = null;
		if(v.indexOf("#") != -1){
			f = v.replace("#","").hex2clr();
		}else if(v.indexOf("rgba(") != -1){ 
			v = v.replace("rgba(","");
			var p = v.split(","); 
			f = Color.rgba(int(p[0]),int(p[1]),int(p[2]),float(p[3]));
		}else if(v.name2clr() != null){
			f = v.name2clr();
		}else f = float(v);
		
		return f;		
	}// getColor()
	
	function getPosition(s:String)
	{
		var p:BgPosition = null; 
		var t = s.split(" "); 
		var x:Null<Int> = Std.parseInt(t[0]);
		var y:Null<Int> = Std.parseInt(t[1]); 
		if((x != null) && (y != null) )p = {x:x,y:y};
		
		return p;		
	}// getPosition()
	
	function delComments(s:String)
	{ 
		var r:Array<String> = [];
		var L1:Array<String> = [];
		var L2:Array<String> = [];
		L1 = s.trim().split("*/"); 	
		for(a in 0...L1.length){
			L2 = L1[a].trim().split("/*"); 
			if(L2[0] != "")r.push(L2[0]);
		}; 
		return r.join(""); 
	}// delComments()


}// abv.lib.style.CssParser
