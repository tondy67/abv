package abv.lib.style;
/**
 * Border
 **/

@:dce
class Border{

	public var width:Null<Float>;
	public var color:Null<Float>;
	public var radius:Null<Float>;
	
	public inline function new(v:Null<Float> = null) 
	{ 
		width = v;
		color = v;
		radius = v;
	}// new()

	public function toString()
	{
		return '{width: $width,color: $color, radius: $radius}';
	}// toString()

}// abv.lib.style.Border

