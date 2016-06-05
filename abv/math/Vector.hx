package abv.math;
/**
 * Vector represents a vector in 3D cartesian coordinate space.
 **/

class Vector{

	public var x:Float;
	public var y:Float;
	public var z:Float;
	public var w:Float = 0;
	
	public inline function new(x=.0,y=.0,z=.0)
	{
		this.x = x;
		this.y = y;
		this.z = z;
	}// new()

	public inline function set(x=.0,y=.0,z=.0)
	{
		this.x = x;
		this.y = y;
		this.z = z;
		w = 0;
	}// set()

	public inline function copy(v:Vector)
	{
		x = v.x;
		y = v.y;
		z = v.z;
		w = v.w;
		return this;
	}// copy()

	public inline function clone()
	{
		var v = new Vector(x,y,z);
		v.w = w;
		return v;
	}// clone()

	public function toString()
	{
		return "("+x+","+y+","+z+")";
	}// toString()

}// abv.math.Vector

