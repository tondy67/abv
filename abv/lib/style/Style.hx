package abv.lib.style;
/**
 * -1 = auto; 0-0.9999 = %; >=1 px
 * RGB.A
 **/
import abv.lib.comp.Component;


using abv.lib.CC;

typedef BoxShadow = {h:Null<Float>,v:Null<Float>,blur:Null<Float>,spread:Null<Float>,color:Null<Float>};
typedef Margin = {top:Null<Float>,right:Null<Float>,bottom:Null<Float>,left:Null<Float>}
typedef Padding = {top:Null<Float>,right:Null<Float>,bottom:Null<Float>,left:Null<Float>}
typedef Font = {name:Null<String>,size:Null<Float>,style:Null<Int>,src:Null<String>}
typedef Background = {color:Null<Float>,image:Null<String>,repeat:Null<Int>,position:Null<BgPosition>}
typedef Border = {width:Null<Float>,color:Null<Float>,radius:Null<Float>}
typedef BgPosition = {x:Int,y:Int}
	
@:dce
class Style extends StyleProps{

	public static var State = [
		"active" 	=> ACTIVE, 
		"visited" 	=> VISITED, 
		"hover" 	=> HOVER, 
		"focus" 	=> FOCUS,
		"link" 		=> LINK
	];
	
	public var state:States = NORMAL;
	var styles = [NORMAL => new StyleProps()];

	override function get_left(){return styles[state].left;};
	override function set_left(v:Float){return styles[state].left = v;};

	override function get_top(){return styles[state].top;};
	override function set_top(v:Float){return styles[state].top = v;};

	override function get_bottom(){return styles[state].bottom;};
	override function set_bottom(v:Float){return styles[state].bottom = v;};

	override function get_right(){return styles[state].right;};
	override function set_right(v:Float){return styles[state].right = v;};

	override function get_width(){return styles[state].width;};
	override function set_width(v:Float){return styles[state].width = v;};

	override function get_height(){return _height;};
	override function set_height(v:Float){return _height = v;};

	override function get_color(){return styles[state].color;};
	override function set_color(v:Float){return styles[state].color = v;};

	override function get_border(){return styles[state].border;};
	override function set_border(v:Border){return styles[state].border = v;};

	override function get_margin(){return styles[state].margin;};
	override function set_margin(v:Margin){return styles[state].margin = v;};

	override function get_padding(){return styles[state].padding;};
	override function set_padding(v:Padding){return styles[state].padding = v;};

	override function get_background(){return styles[state].background;};
	override function set_background(v:Background){return styles[state].background = v;};

	override function get_font(){return styles[state].font;};
	override function set_font(v:Font){return styles[state].font = v;};

	override function get_boxShadow(){return styles[state].boxShadow;};
	override function set_boxShadow(v:BoxShadow){return styles[state].boxShadow = v;};
	
	public function new(name="") 
	{ 
		super();
		this.name = name;
	}// new()

	public function set(sel:States = null)
	{
		state = sel == null? NORMAL:sel;
		styles.set(state, new StyleProps());
	}// set()
	
	public function get(sel:States = null) 
	{
		state = sel == null? NORMAL:sel;
		return styles[state];
	}// get()

	public function setBackground()
	{
		if(background == null)background = { color:0, image:null, repeat:null, position:null };
	}// setBackground()
	
	public function setBorder()
	{
		if(border == null)border = { width:0, color:0, radius:0 };
	}// setBorder()
	
	public function setFont()
	{
		if(font == null)font = { name:null, size:12, style:null,src:null };
	}// setFont()
	
	public function setMargin(v=.0)
	{
		if(margin == null)margin = { top:v, right:v, bottom:v, left:v };
	}// setMargin()
	
	public function setPadding(v=.0)
	{
		if(padding == null)padding = { top:v, right:v, bottom:v, left:v };
	}// setPadding()
	
	public function setBoxShadow()
	{
		if(boxShadow == null)boxShadow = { h:0, v:0, blur:null, spread:null, color:null };
	}// setBoxShadow()
	
	public function copy(s:Style)
	{ 
		if (s == null){trace("no style");return;}
		name = s.name;
		if (s.left != null) left = s.left;  
		if (s.top != null) top = s.top;  
		if (s.right != null) right = s.right;  
		if (s.bottom != null) bottom = s.bottom;  
		if (s.width != null) width = s.width;  
		if (s.height != null) height = s.height;  
		if (s.color != null) color = s.color; 
		if (s.background != null) {
			setBackground();
			if (s.background.color != null)  background.color = s.background.color;
			if (s.background.image != null)  background.image = s.background.image;
			if (s.background.repeat != null)  background.repeat = s.background.repeat;
			if (s.background.position != null)  background.position = s.background.position;
		}
		if (s.border != null) {
			setBorder();
			if (s.border.width != null)  border.width = s.border.width;
			if (s.border.color != null)  border.color = s.border.color;
			if (s.border.radius != null)  border.radius = s.border.radius;
		}
		if (s.font != null) {
			setFont();
			if (s.font.name != null)  font.name = s.font.name;
			if (s.font.size != null)  font.size = s.font.size;
			if (s.font.style != null)  font.style = s.font.style;
			if (s.font.src != null)  font.src = s.font.src;
		}
		if (s.margin != null) {
			setMargin();
			if (s.margin.top != null)  margin.top = s.margin.top;
			if (s.margin.right != null)  margin.right = s.margin.right;
			if (s.margin.bottom != null)  margin.bottom = s.margin.bottom;
			if (s.margin.left != null)  margin.left = s.margin.left;
		}
		if (s.padding != null) {
			setPadding();
			if (s.padding.top != null)  padding.top = s.padding.top;
			if (s.padding.right != null)  padding.right = s.padding.right;
			if (s.padding.bottom != null)  padding.bottom = s.padding.bottom;
			if (s.padding.left != null)  padding.left = s.padding.left;
		}
		if (s.boxShadow != null) {
			setBoxShadow();
			if (s.boxShadow.h != null)  boxShadow.h = s.boxShadow.h;
			if (s.boxShadow.v != null)  boxShadow.v = s.boxShadow.v;
			if (s.boxShadow.blur != null)  boxShadow.blur = s.boxShadow.blur;
			if (s.boxShadow.spread != null)  boxShadow.spread = s.boxShadow.spread;
			if (s.boxShadow.color != null)  boxShadow.color = s.boxShadow.color;
		}
	
	}// copy()

	public function clone()
	{ 
		var s = new Style();
		s.copy(this);
		return s;
	}// clone()
	
	public static inline function apply(o:Component,s:Style)
	{
		if((o != null)&&(s != null)){
			o.style.copy(s);
			if(s.left != null) o.pos.x = s.left; else o.style.left = o.pos.x;
			if(s.top != null) o.pos.y = s.top; else o.style.top = o.pos.y;
			if(s.width != null) o.width = s.width; else o.style.width = o.width;
			if(s.height != null) o.height = s.height; else o.style.height = o.height;
			if(o.style.background == null) o.style.setBackground();
			if(o.style.background.color != null) o.color = o.style.background.color.int();
			else o.style.background.color = o.color;
			if(o.style.margin == null) o.style.setMargin();
			if(o.style.padding == null) o.style.setPadding();
		}else{
			trace('obj: $o \nstyle: $s');
		}
	}// apply()	

	public function toString() 
	{
		var s = 'Style(state: $state, ';
		if(left != null)s += 'left: $left,';
		if(top != null)s += 'top: $top,';
		if(width != null)s += 'width: $width,';
		if(height != null)s += 'height: $height,'; 
		if(color != null)s += 'color; $color,';
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

	public var left(get,set):Null<Float>;
	var _left:Null<Float> = null;
	function get_left(){return _left;};
	function set_left(v:Float){return _left = v;};

	public var top(get,set):Null<Float>;
	var _top:Null<Float> = null;
	function get_top(){return _top;};
	function set_top(v:Float){return _top = v;};

	public var right(get,set):Null<Float>;
	var _right:Null<Float> = null;
	function get_right(){return _right;};
	function set_right(v:Float){return _right = v;};

	public var bottom(get,set):Null<Float>;
	var _bottom:Null<Float> = null;
	function get_bottom(){return _bottom;};
	function set_bottom(v:Float){return _bottom = v;};

	public var width(get,set):Null<Float>;
	var _width:Null<Float> = null;
	function get_width(){return _width;};
	function set_width(v:Float){return _width = v;};

	public var height(get,set):Null<Float>;
	var _height:Null<Float> = null;
	function get_height(){return _height;};
	function set_height(v:Float){return _height = v;};

	public var color(get,set):Null<Float>;
	var _color:Null<Float> = null;
	function get_color(){return _color;};
	function set_color(v:Float){return _color = v;};

	public var border(get,set):Null<Border>;
	var _border:Null<Border> = null;
	function get_border(){return _border;};
	function set_border(v:Border){return _border = v;};

	public var margin(get,set):Null<Margin>;
	var _margin:Null<Margin> = null;
	function get_margin(){return _margin;};
	function set_margin(v:Margin){return _margin = v;};

	public var padding(get,set):Null<Padding>;
	var _padding:Null<Padding> = null;
	function get_padding(){return _padding;};
	function set_padding(v:Padding){return _padding = v;};

	public var background(get,set):Null<Background>;
	var _background:Null<Background> = null;
	function get_background(){return _background;};
	function set_background(v:Background){return _background = v;};

	public var font(get,set):Null<Font>;
	var _font:Null<Font> = null;
	function get_font(){return _font;};
	function set_font(v:Font){return _font = v;};

	public var boxShadow(get,set):Null<BoxShadow>;
	var _boxShadow:Null<BoxShadow> = null;
	function get_boxShadow(){return _boxShadow;};
	function set_boxShadow(v:BoxShadow){return _boxShadow = v;};
	
	public inline function new(){}
	
}// abv.lib.style.StyleProps
	
	