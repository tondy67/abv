package abv.ui;
/**
 * Shape
 **/
import abv.lib.math.Rectangle;
import abv.lib.comp.Component;
import abv.ui.box.*;
import abv.ui.widget.*;
import abv.lib.style.*;

using abv.lib.CC;
using abv.lib.style.Color;

typedef ShapeImage = {src:String,tile:Rectangle};
typedef ShapeText =  {src:String,font:Font,color:Float};

@:dce
class Shape{

	public var id(default,null) = "";
	public var x(default,null) = .0;
	public var y(default,null) = .0;
	public var w(default,null) = .0;
	public var h(default,null) = .0;
	public var scale(default,null) = .0;
	public var color(default,null) = .0;
	public var border(default,null) = new Border(0);
	public var image(default,null):ShapeImage;
	public var text(default,null):ShapeText;
	public var visible(default,null) = false;
	public var context(default,null) = 2;
	public var kind(default,null) = "";
	public var root(default,null) = "";
	public var parent(default,null) = "";
	public var style(default,null) = "";
	
	public inline function new(o:Component=null)
	{ 
		image = {src:"",tile:null};
		text = {src:"",font:new Font(),color:0};
		text.font.size = 14;
		text.font.src = "";

		if(o != null)copy(o);
	}// new()

	public function copy(o:Component)
	{
		id = o.id;
		visible = o.visible;
		x 		= o.gX;
		y 		= o.gY;
		w 	= o.width;
		h 	= o.height;
		scale 	= o.scale;
		context = o.root.context;
		root = o.root.id;
		parent = o.parent.id;
		style = o.style.name;
		kind = o.kind;
		color = o.color;
		
		if(o.style.border != null)border = o.style.border;

		if(o.style.background != null){
			if(o.style.background.image.good()){
				var tile:Rectangle = null;
				if(o.style.background.position != null){
					tile = new Rectangle(-o.style.background.position.x,
						-o.style.background.position.y,w,h);
				}

				image.src = o.style.background.image;
				image.tile = tile;
			}
			color = o.style.background.color;
		}
		
		text.src = o.text;
		if(o.style.font != null)text.font = o.style.font;
		if(o.style.color != null)text.color = o.style.color;	
	}// copy()

}// abv.ui.Shape

