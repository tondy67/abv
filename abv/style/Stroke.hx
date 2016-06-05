package abv.style;
/**
 * Stroke
 **/
import abv.factory.Component;

@:dce
class Stroke{

	public var width:Null<Float>;
	public var color:Null<Color>;
	public var radius:Null<Float>;
	
	public inline function new(v:Null<Float> = null) 
	{ 
		width = v;
		color = v != null ? Std.int(v):0;
		radius = v;
	}// new()

	public inline function set(color:Color=0,width = .0,radius = .0) 
	{ 
		this.color = color;
		this.width = width;
		this.radius = radius;
	}// set()

	public inline function copy(v:Stroke) 
	{ 
		if(v == null) return;
		color = v.color;
		width = v.width;
		radius = v.radius;
	}// copy()

	public function toString()
	{
		return '{width: $width,color: $color, radius: $radius}';
	}// toString()

}// abv.style.Stroke

