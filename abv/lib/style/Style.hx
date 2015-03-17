package abv.lib.style;

import abv.lib.comp.Component;
import abv.lib.Color;

typedef BoxShadow = {h:Null<Float>,v:Null<Float>,blur:Null<Float>,spread:Null<Float>,color:Null<Float>};
typedef Margin = {top:Null<Float>,right:Null<Float>,bottom:Null<Float>,left:Null<Float>}
typedef Padding = {top:Null<Float>,right:Null<Float>,bottom:Null<Float>,left:Null<Float>}
typedef Font = {name:Null<String>,size:Null<Float>,style:Null<Int>}
typedef Background = {color:Null<Float>,image:Null<String>,repeat:Null<Int>,position:Null<Int>}
typedef Border = {width:Null<Float>,color:Null<Float>,radius:Null<Float>}

	
enum StyleState{
	Disabled;
	Normal;
	Active;
	Visited;
	Hover;
	Focus;
	Link;
}
/**
 * 
 **/
@:dce
class Style extends StyleProps{
// -1 = auto; 0-0.9999 = %; >=1 px
// RGB.A
// states
	public static var State:Map<String,StyleState> = ["active" => Active, 
	"visited" => Visited, "hover" => Hover, "focus" => Focus,"link" => Link];
	
	public function new(name="",basic = false) 
	{ 
		super();
		if(basic){
			width = height = left = top = 0;
			color = Color.WHITE;
			set("background");
			set("border");
			set("font");
			set("margin");
			set("padding");
			set("boxShadow");
		}
		this.name = name;
	}

	public function set(s:String)
	{
		switch(s){
			case "background":
				if(background == null)background = { color:null, image:null, repeat:null, position:null };
			case "border":
				if(border == null)border = { width:0, color:null, radius:0 };
			case "font":
				if(font == null)font = { name:null, size:null, style:null };
			case "margin":
				if(margin == null)margin = { top:0, right:0, bottom:0, left:0 };
			case "padding":
				if(padding == null)padding = { top:0, right:0, bottom:0, left:0 };
			case "boxShadow":
				if(boxShadow == null)boxShadow = { h:0, v:0, blur:null, spread:null, color:null };
		}
	}

	public function apply(s:Style)
	{ 
		if (s == null) return;
		name = s.name;
		if (s.left != null) left = s.left;  
		if (s.top != null) top = s.top;  
		if (s.width != null) width = s.width;  
		if (s.height != null) height = s.height;  
		if (s.color != null) color = s.color; 
		if (s.background != null) {
			set("background");
			if (s.background.color != null)  background.color = s.background.color;
			if (s.background.image != null)  background.image = s.background.image;
			if (s.background.repeat != null)  background.repeat = s.background.repeat;
			if (s.background.position != null)  background.position = s.background.position;
		}
		if (s.border != null) {
			set("border");
			if (s.border.width != null)  border.width = s.border.width;
			if (s.border.color != null)  border.color = s.border.color;
			if (s.border.radius != null)  border.radius = s.border.radius;
		}
		if (s.font != null) {
			set("font");
			if (s.font.name != null)  font.name = s.font.name;
			if (s.font.size != null)  font.size = s.font.size;
			if (s.font.style != null)  font.style = s.font.style;
		}
		if (s.margin != null) {
			set("margin");
			if (s.margin.top != null)  margin.top = s.margin.top;
			if (s.margin.right != null)  margin.right = s.margin.right;
			if (s.margin.bottom != null)  margin.bottom = s.margin.bottom;
			if (s.margin.left != null)  margin.left = s.margin.left;
		}
		if (s.padding != null) {
			set("padding");
			if (s.padding.top != null)  padding.top = s.padding.top;
			if (s.padding.right != null)  padding.right = s.padding.right;
			if (s.padding.bottom != null)  padding.bottom = s.padding.bottom;
			if (s.padding.left != null)  padding.left = s.padding.left;
		}
		if (s.boxShadow != null) {
			set("boxShadow");
			if (s.boxShadow.h != null)  boxShadow.h = s.boxShadow.h;
			if (s.boxShadow.v != null)  boxShadow.v = s.boxShadow.v;
			if (s.boxShadow.blur != null)  boxShadow.blur = s.boxShadow.blur;
			if (s.boxShadow.spread != null)  boxShadow.spread = s.boxShadow.spread;
			if (s.boxShadow.color != null)  boxShadow.color = s.boxShadow.color;
		}
	
	}// apply()

	public function export() 
	{
/*		var o:StyleProps = {left:left,top:top,width:width,height:height,color:color,border:border,
			margin:margin,padding:padding,background:background,
			font:font,boxShadow:boxShadow}; */
		return cast(this,StyleProps);//haxe.Json.stringify(o);
	}

	public static inline function applyStyle(obj:Component,style:Style)
	{
		if(style == null){
			return;
		}
		if (style.left != null) obj.pos.x = style.left;
		if (style.top != null) obj.pos.y = style.top;
		if (style.width != null) obj.width = style.width;
		if (style.height != null) obj.height = style.height;
		if ((style.background != null) && (style.background.color != null)) 
			obj.color = Std.int(style.background.color);
//trace(cast(obj,IStyle).style[Normal]);
	}	

	public function toString() 
	{
		var s = "Style(";
		if(left != null)s += '\nleft: $left,';
		if(top != null)s += '\ntop: $top,';
		if(width != null)s += '\nwidth: $width,';
		if(height != null)s += '\nheight: $height,'; 
		if(color != null)s += '\ncolor; $color,';
		if(border != null)s += '\nborder: ${border},';
		if(margin != null)s += '\nmargin: ${margin},';
		if(padding != null)s += '\npadding: ${padding},';
		if(background != null)s += '\nbackground ${background},';
		if(font != null)s += '\nfont: ${font},';
		if(boxShadow != null)s += '\nboxShadow: ${boxShadow},';
		s += ")";
		return s;
    }// toString() 

}// abv.lib.style.Style

class StyleProps{
	public var name = "";
	public var visibility = "";
	public var left:Null<Float> = null;
	public var top:Null<Float> = null;
	public var width:Null<Float> = null;
	public var height:Null<Float> = null;
	public var color:Null<Float> = null;
	public var border:Null<Border>;
	public var margin:Null<Margin>;
	public var padding:Null<Padding>;
	public var background:Null<Background>;
	public var font:Null<Font>;
	public var boxShadow:Null<BoxShadow>;
	
	public inline function new(){}
	
}// abv.lib.style.StyleProps
	
	
