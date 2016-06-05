package abv.math;
/**
 * Quat represents a rotational transform in 3D cartesian 
 * coordinate space in quaternion form.
 **/
class Quat{

	public var x:Float;
	public var y:Float;
	public var z:Float;
	public var w:Float = 0;
	
	public inline function new(x=.0,y=.0,z=.0,w=.0)
	{
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
	}// new()

	public inline function set(x=.0,y=.0,z=.0,w=.0)
	{
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
	}// set()

	public inline function copy(q:Quat)
	{
		x = q.x;
		y = q.y;
		z = q.z;
		w = q.w;
		return this;
	}// copy()

	public inline function clone()
	{
		return new Quat(x,y,z,w);
	}// clone()


	public function toString()
	{
		return 'Quat($x,$y,$z,$w)';
	}// toString()

}// abv.math.Quat

