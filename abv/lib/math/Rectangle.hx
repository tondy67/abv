package abv.lib.math;
/**
 * Rectangle
 **/
#if flash
typedef Rectangle = flash.geom.Rectangle;
#else
class Rectangle{

	public var x:Float;
	public var y:Float;
	public var w:Float;
	public var h:Float;
	
	public function new(x=.0,y=.0,w=.0,h=.0)
	{
		this.x 	= x;
		this.y 	= y;
		this.w 	= w;
		this.h 	= h;
	}// new()

	public function toString()
	{
		return 'Rectangle($x,$y,$w,$h)';
	}// toString()

}// abv.lib.math.Rectangle
#end
