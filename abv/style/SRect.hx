package abv.style;
/**
 * SRect
 **/

@:dce
class SRect{

	public var top:Null<Float>;
	public var left:Null<Float>;
	public var bottom:Null<Float>;
	public var right:Null<Float>;
	
	public inline function new(v:Null<Float>=null) 
	{ 
		top = v;
		left = v;
		bottom = v;
		right = v;
	}// new()

	public function toString()
	{
		return '{top: $top,left: $left, bottom: $bottom, right: $right}';
	}// toString()


}// abv.style.SRect

