package abv.ui;
/**
 * Shape
 **/
import abv.lib.math.Rect;
import abv.lib.comp.Component;
import abv.ui.box.*;
import abv.ui.widget.*;
import abv.lib.style.*;
import abv.lib.Enums;
import abv.lib.style.Color;

using abv.lib.CC;

typedef ShapeImage = {src:String,tile:Rect};
typedef ShapeText =  {src:String,font:Font,color:Color};

@:dce
class Shape{

	public var id(default,null):Int;
	public var x(default,null):Float;
	public var y(default,null):Float;
	public var w(default,null):Float;
	public var h(default,null):Float;
	public var scale(default,null):Float;
	public var color(default,null):Color;
	public var alpha(default,null):Float;
	public var border(default,null):Border;
	public var image(default,null):ShapeImage;
	public var text(default,null):ShapeText;
	public var visible(default,null):Bool;
	public var context(default,null):RenderContext;
	public var kind(default,null):RenderKind;
	public var root(default,null):Int;
	public var parent(default,null):Int;
	public var style(default,null):String;
	
	public inline function new(o:Component=null)
	{ 
		if(o == null)reset(); else copy(o);
	}// new()

	public inline function reset()
	{
		id = 0;
		x = .0;
		y = .0;
		w = .0;
		h = .0;
		scale = .0;
		color = new Color();
		alpha = .0;
		border = new Border(0);
		image = {src:"",tile:null};
		text = {src:"",font:new Font(),color:0};
		text.font.size = 14;
		text.font.src = "";
		visible = false;
		context = CTX_2D;
		kind = RK_NONE;
		root = 0;
		parent = 0;
		style = "";
	}// reset()
	
	public function copy(o:Component)
	{
		reset();
		id 		= o.id;
		visible = o.visible;
		x 		= o.gX;
		y 		= o.gY;
		w 		= o.width;
		h 		= o.height;
		scale 	= o.scale;
		context = o.root.context;
		root 	= o.root.id;
		parent 	= o.parent.id;
		style 	= o.style.name;
		kind 	= o.kind;
		alpha 	= o.alpha;
		var _alpha = alpha < 1?1 + alpha:1;
		color 	= o.color;// * _alpha;
		
		if(o.style.border != null)border = o.style.border;

		if(o.style.background != null){
			if(o.style.background.image.good()){
				var tile:Rect = null;
				if(o.style.background.position != null){
					tile = new Rect(-o.style.background.position.x,
						-o.style.background.position.y,w,h);
				}

				image.src = o.style.background.image;  
				image.tile = tile;
			}
			color = o.style.background.color;// * _alpha;
		}
		
		text.src = o.text;
		if(o.style.font != null)text.font = o.style.font;
		if(o.style.color != null)text.color = o.style.color;	
	}// copy()

}// abv.ui.Shape

