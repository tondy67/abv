package abv.lib.math;
/**
 * Rectangle
 **/

class Rectangle{

	public var x:Float;
	public var y:Float;
	public var w:Float;
	public var h:Float;
	
	public inline function new(x=.0,y=.0,w=.0,h=.0)
	{
		this.x 	= x;
		this.y 	= y;
		this.w 	= w;
		this.h 	= h;
	}// new()

	public inline function containsPoint(p:Point)
	{
		return (p.x >= x)&&(p.x <= (x+w))&&(p.y >= y)&&(p.y <= (y + h));
	}// containsPoint()

	public function toString()
	{
		return 'Rectangle($x,$y,$w,$h)';
	}// toString()

}// abv.lib.math.Rectangle

