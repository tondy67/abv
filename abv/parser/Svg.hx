package abv.parser;
/**
 * Svg
 **/
import abv.factory.*;
import abv.style.Style;
import abv.math.Point;

using abv.sys.ST;
using abv.ds.TP;

@:dce
class Svg{

	public function new()
	{

	}// new()

	public static function parse(str:String):Component
	{ 
		var root:Component = null;
		var xml:Xml = null, svg:Xml = null;	
		
		try{  
			xml = Xml.parse(str); 
			svg = xml.firstElement();
		}catch(e:Dynamic)ST.error("svg",e); 

		if(svg != null) root = processNode(svg);
 
		return root;
	}// parse()

	static inline function processNode(node:Xml,parent:Component=null)
	{
//		if(parent == null) parent = new Component("svg."+ST.rand());
		var obj:Component = null;
//		var att = new MapSS(); 
		var v:Null<Int>;
		var elm = node.nodeName; 
		
		switch (elm){
			case "svg": 
				obj = new Component(mkName(node));  
				for(it in node.elements()){
					try processNode(it,obj)
					catch(e:Dynamic)ST.error("node: "+it.nodeName,e);
				} 
			case "rect": obj = new Component(mkName(node)); 
			case "circle": obj = new Component(mkName(node),CIRCLE); 
			case "line": obj = new Component(mkName(node),LINE); 
			case "polygon": obj = new Component(mkName(node),POLYGON); 
		}
		
		if(obj != null){  
			for(it in node.attributes()){ //trace(it);
				v = node.get(it).toInt();
				if(v == null) continue;
				
				 switch (it){ 
					 case "x": obj.x = v; 
					 case "y": obj.y = v; 
					 case "width": obj.width = v; 
					 case "height": obj.height = v; 
					 case "r": obj.width = obj.height = 2 * v; 
					 case "cx": obj.x = v - obj.width/2; 
					 case "cy": obj.y = v - obj.width/2;  
					 case "x1": obj.x = v; 
					 case "y1": obj.y = v; 
					 case "x2": obj.width = v; 
					 case "y2": obj.height = v; 
					 case "points": obj.outline = getPoints(node.get(it)); 
				 }
			}
//if(obj.kind == POLYGON)trace(obj.outline);			
obj.style.setFill();
obj.style.fill.set();
obj.style.setStroke();
obj.style.stroke.set(0xFF00AAFF,1);

//if(parent != null){
	if(obj.name == "rect222")obj.style.fill.color = 0xCCDDFFAA;
	else if(elm == "rect")obj.style.fill.color = 0x00FF00FF;
	else if(elm == "circle") obj.style.fill.color = 0xCC0000FF;
	else if(elm == "polygon"){
		obj.style.fill.color = 0x00CCCCFF;
		obj.style.stroke.color = 0x0000FFFF;
	}else obj.style.fill.color = 0;
//} 
//if(elm == "line")obj.style.stroke.set(0x00FF00FF,1);
//trace(obj.style);
//			obj.style.left = obj.pos.x;
//			obj.style.top = obj.pos.y;
//			obj.style.width = obj.width;
//			obj.style.height = obj.height;
//			obj.style.background = new abv.css.Fill();
	//		obj.style.background.color = obj.color;
			if(parent != null)parent.addChild(obj);  	
			else parent = obj;
		} 
		return parent;
	}//

	static function mkName(node:Xml)
	{
		var name:String = node.get("id");
		return ST.good(name) ? name : node.nodeName + "." + ST.rand();
	}
	
	static function getPoints(s:String)
	{
		var r:Array<Point> = [];
		if(ST.good(s)){
			var x:Null<Int>, y:Null<Int>;
			s= s.reduceSpaces();
			s = s.replace(" ",",");
			var t:Array<String> = s.split(","); 
			for (i in 0...t.length) {
				if (i % 2 != 0) continue;
				x = t[i].toInt();
				y = t[i+1].toInt();
				if((x != null)&&(y != null))r.push(new Point(x,y));
			}
		} 
///for(it in r) trace(it);
		return r;
	}// getPoints()
	
	public function toString()
	{
		return "Svg()";
	}// toString()

}// abv.parser.Svg

