package abv.lib.style;
/**
 * BgPosition
 **/
class BgPosition{

	public var x:Int;
	public var y:Int;
	
	public inline function new(x=0,y=0)
	{ 
		this.x = x;
		this.y = y;
	}// new()

	public function toString()
	{
		return '(x: $x, y: $y)';
	}// toString()

}// abv.lib.style.BgPosition

