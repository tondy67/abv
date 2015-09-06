package abv.ui;
/**
 * Shape
 **/
import abv.lib.math.Rectangle;
import abv.lib.comp.Component;
import abv.ui.box.*;
import abv.ui.widget.*;

using abv.lib.CC;
using abv.lib.style.Color;

typedef ShapeBorder = {width:Float,color:Float,radius:Float};
typedef ShapeImage = {src:String,tile:Rectangle};
typedef ShapeText =  {src:String,font:String,size:Int,color:Float};

@:dce
class Shape{

	public var id(default,null) = "";
	public var x(default,null) = .0;
	public var y(default,null) = .0;
	public var w(default,null) = .0;
	public var h(default,null) = .0;
	public var scale(default,null) = .0;
	public var color(default,null) = .0;
	public var border(default,null):ShapeBorder;
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
		border = {width:.0,color:.0,radius:.0};
		image = {src:"",tile:null};
		text = {src:"",font:"",size:14,color:.0};
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

		setColor(o.color);

		if(o.style.border != null){ 
			setBorder(o.style.border.width,o.style.border.color,o.style.border.radius);
		}

		if(o.style.background != null){
			if(o.style.background.image.good()){
				var tile:Rectangle = null;
				if(o.style.background.position != null){
					tile = new Rectangle(-o.style.background.position.x,
						-o.style.background.position.y,w,h);
				}
				setImage(o.style.background.image,tile);
			}
			setColor(o.style.background.color);
		}
		
		var font = "";
		var size = 14;

		if(o.style.font != null){
			if(o.style.font.src.good())font = o.style.font.src;
			if(o.style.font.size != null)size = o.style.font.size.int();
		}
		setText(o.text,font,size, o.style.color);	
	}// copy()

	public function setColor(color=.0)
	{
		this.color = color;
	}// setColor()

	public function setBorder(width=.0,color=.0,radius=.0)
	{
		border = {width:width,color:color,radius:radius};
	}// setBorder()

	public function setImage(src:String,tile:Rectangle=null)
	{
		image = {src:src,tile:tile};
	}// setImage()
	
	public function setText(src:String,font:String,size:Int, color:Float)
	{
		text = {src:src,font:font,size:size,color:color};
	}// setText()
	
}// abv.ui.Shape

