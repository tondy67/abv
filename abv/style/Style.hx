package abv.style;
/**
 * -1 = auto; 0-0.9999 = %; >=1 px
 * RGB.A
 **/
import abv.Enums;
import abv.factory.Component;

using abv.sys.ST;

@:dce
class Style extends StyleProps{

	public static var stylesheet = new Map<String,Style>();
	public var state:States = NORMAL;
	var styles:Map<States,StyleProps>; 

	public var states(get,never):Array<States>;
	function get_states()
	{
		var r:Array<States> = [];
		for (k in styles.keys()) r.push(k);
		return r;
	}
	
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
	override function set_color(v:Color){return styles[state].color = v;};

	override function get_stroke(){return styles[state].stroke;};
	override function set_stroke(v:Stroke){return styles[state].stroke = v;};

	override function get_margin(){return styles[state].margin;};
	override function set_margin(v:Margin){return styles[state].margin = v;};

	override function get_padding(){return styles[state].padding;};
	override function set_padding(v:Padding){return styles[state].padding = v;};

	override function get_fill(){return styles[state].fill;};
	override function set_fill(v:Fill){return styles[state].fill = v;};

	override function get_font(){return styles[state].font;};
	override function set_font(v:Font){return styles[state].font = v;};

	override function get_boxShadow(){return styles[state].boxShadow;};
	override function set_boxShadow(v:BoxShadow){return styles[state].boxShadow = v;};
	
	public function new(name="") 
	{ 
		super();
		this.name = name; 
		styles = new Map<States,StyleProps>(); 
		styles.set(NORMAL , new StyleProps());
	}// new()

	public function reset(sel:States = null)
	{
		state = sel == null? NORMAL:sel;
		styles.set(state, new StyleProps());
	}// set()
	
	public function get(sel:States = null) 
	{
		state = sel == null? NORMAL:sel;
		return styles[state];
	}// get()

	public function setFill()
	{
		if(fill == null){
			fill = new Fill();
			fill.color = 0;
		}
	}// setFill()
	
	public function setStroke()
	{
		if(stroke == null)stroke = new Stroke();
	}// setStroke()
	
	public function setFont()
	{
		if(font == null){
			font = new Font();
			font.size = 12;
		}
	}// setFont()
	
	public function setMargin(v=.0)
	{
		if(margin == null)margin = new Margin(v);
	}// setMargin()
	
	public function setPadding(v=.0)
	{
		if(padding == null)padding = new Padding(v);
	}// setPadding()
	
	public function setBoxShadow()
	{
		if(boxShadow == null){
			boxShadow = new BoxShadow();
			boxShadow.h = 0;
			boxShadow.v = 0;
		}
	}// setBoxShadow()
	
	public function copy(s:StyleProps)
	{ 
		if (s == null){
			ST.error("no style");
			return;
		}
		name = s.name; 

		if (s.left != null) left = s.left;  
		if (s.top != null) top = s.top;  
		if (s.right != null) right = s.right;  
		if (s.bottom != null) bottom = s.bottom;  
		if (s.width != null) width = s.width;  
		if (s.height != null) height = s.height;  
		if (s.color != null) color = s.color; 
		if (s.fill != null) {
			setFill();
			if (s.fill.color != null)  fill.color = s.fill.color;
			if (s.fill.image != null)  fill.image = s.fill.image;
			if (s.fill.repeat != null)  fill.repeat = s.fill.repeat;
			if (s.fill.tile != null)  fill.tile = s.fill.tile;
		}
		if (s.stroke != null) {
			setStroke();
			if (s.stroke.width != null)  stroke.width = s.stroke.width;
			if (s.stroke.color != null)  stroke.color = s.stroke.color;
			if (s.stroke.radius != null)  stroke.radius = s.stroke.radius;
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

	public static inline function sync(o:Component,s:Style=null)
	{
		if(o != null){
			if(s == null) s = o.style;
			else o.style.copy(s);
			if(s.left != null) o.x = s.left; else o.style.left = o.x;
			if(s.top != null) o.y = s.top; else o.style.top = o.y;
			if(s.width != null) o.width = s.width; else o.style.width = o.width;
			if(s.height != null) o.height = s.height; else o.style.height = o.height;
			if(o.style.fill == null) o.style.setFill();
			if(o.style.fill.color != null) o.color = o.style.fill.color.i();
			else o.style.fill.color = o.color;
			if(o.style.margin == null) o.style.setMargin();
			if(o.style.padding == null) o.style.setPadding();
		}else{
			ST.error(ST.getText(20));
		}
	}// sync()	

	public inline function clone()
	{ 
		var s = new Style();
		for(k in states){
			s.reset(k);
			s.copy(get(k));
		}
		return s;
	}// clone()
	
	public function toString() 
	{
		var s = 'Style(state: $state, name: $name, visibility: $visibility';
		if(left != null)s += 'left: $left,';
		if(top != null)s += 'top: $top,';
		if(width != null)s += 'width: $width,';
		if(height != null)s += 'height: $height,'; 
		if(color != null)s += 'color; $color,';
		if(stroke != null)s += '\nstroke: ${stroke},';
		if(margin != null)s += '\nmargin: ${margin},';
		if(padding != null)s += '\npadding: ${padding},';
		if(fill != null)s += '\nfill ${fill},';
		if(font != null)s += '\nfont: ${font},';
		if(boxShadow != null)s += '\nboxShadow: ${boxShadow},';
		s += ")";
		return s;
    }// toString() 

}// abv.style.Style

@:dce
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

	public var color(get,set):Null<Color>;
	var _color:Null<Color> = null;
	function get_color(){return _color;};
	function set_color(v:Color){return _color = v;};

	public var stroke(get,set):Null<Stroke>;
	var _stroke:Null<Stroke> = null;
	function get_stroke(){return _stroke;};
	function set_stroke(v:Stroke){return _stroke = v;};

	public var margin(get,set):Null<Margin>;
	var _margin:Null<Margin> = null;
	function get_margin(){return _margin;};
	function set_margin(v:Margin){return _margin = v;};

	public var padding(get,set):Null<Padding>;
	var _padding:Null<Padding> = null;
	function get_padding(){return _padding;};
	function set_padding(v:Padding){return _padding = v;};

	public var fill(get,set):Null<Fill>;
	var _fill:Null<Fill> = null;
	function get_fill(){return _fill;};
	function set_fill(v:Fill){return _fill = v;};

	public var font(get,set):Null<Font>;
	var _font:Null<Font> = null;
	function get_font(){return _font;};
	function set_font(v:Font){return _font = v;};

	public var boxShadow(get,set):Null<BoxShadow>;
	var _boxShadow:Null<BoxShadow> = null;
	function get_boxShadow(){return _boxShadow;};
	function set_boxShadow(v:BoxShadow){return _boxShadow = v;};
	
	public inline function new(){ }
	
}// abv.style.StyleProps
	
	
