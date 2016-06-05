package abv.math;
/**
 *	Point represents a point in 3D cartesian coordinate space.
 **/
 
using abv.sys.ST;

@:dce
class Point{
	public var x(get,set):Null<Float>;
	var _x:Null<Float>;
	public var y(get,set):Null<Float>;
	var _y:Null<Float>;
	public var z(get,set):Null<Float>;
	var _z:Null<Float>;
	public var length(get,never):Float;
	var _length:Float;
	
	public inline function new(x=.0,y=.0,z=.0)
	{// TODO: separate point/vector stuff
		this.x = x;
		this.y = y;
		this.z = z;
	}// new()

	public inline function set(x=.0,y=.0,z=.0)
	{
		this.x = x;
		this.y = y;
		this.z = z;
	}
	
	public inline function reset()
	{
		x = 0;
		y = 0;
		z = 0;
	}
	
	public inline function clone()
	{
		return new Point(x,y,z);
	}
	
	public inline function copy(p:Point)
	{
		x = p.x;
		y = p.y;
		z = p.z;
		return this;
	}

    public inline function eq(p:Point)
    {
        return (x == p.x) && (y == p.y);
    }

    public inline function gt(p:Point)
    {
        return (x > p.x) && (y > p.y);
    }
    
    public inline function gte(p:Point)
    {
        return (x >= p.x) && (y >= p.y);
    }
// is less than point
    public inline function lt(p:Point)
    {
        return (x < p.x) && (y < p.y);
    }
//  is less than or equal point
    public inline function lte(p:Point)
    {
        return (x <= p.x) && (y <= p.y);
    }
// subtract point    
    public inline function sub(p:Point)
    {
       return new Point(x - p.x, y - p.y, z - p.z);
    }

    public inline function add(p:Point)
    {
       return new Point(x + p.x, y + p.y, z + p.z);
    }
    public static inline function interpolate(p0:Point, p1:Point, f=.5)
    {
		if(f < 0)f = 0; 
		if(f > 1)f = 1; 
        return new Point((p0.x-p1.x)*f+p1.x,(p0.y-p1.y)*f+p1.y);
    }
    public static inline function extrapolate(p0:Point, p1:Point, f=2.)
    {
		if(f < 1)f = 1; 
        return new Point((p1.x-p0.x)*f+p0.x,(p1.y-p0.y)*f+p0.y);
    }

    public inline function abs()
    {
        return new Point(Math.abs(x), Math.abs(y));
    }
    
	public inline function between(p0:Point,p1:Point)
	{
		var c = (y - p0.y) * (p1.x - p0.x) - (x - p0.x) * (p1.y - p0.y);
		if(Math.abs(c) > CC.E) return false; 

		var d = (x - p0.x) * (p1.x - p0.x) + (y - p0.y)*(p1.y - p0.y);
		if (d < 0)return false;

		var s = (p1.x - p0.x)*(p1.x - p0.x) + (p1.y - p0.y)*(p1.y - p0.y);
		if(d > s)return false;

		return true;
 	}
	
    public inline function normalize(?thickness=1.)
    {
        var m = thickness/length;
        x *= m;
        y *= m;
        return this;
    }

    public static inline function distance(p0:Point, p1:Point)
    {
        var x = p0.x-p1.x;
        var y = p0.y-p1.y;
        return Math.sqrt(x*x + y*y);
    }

    public static inline function dot(p0:Point, p1:Point)
    {
        return p0.x*p1.x + p0.y*p1.y;
    }
    

    public static inline function cross(p0:Point, p1:Point)
    {
        return p0.x*p1.y - p0.y*p1.x;
    }

    public inline function near(p:Point,proximity=.0) 
    {
        var x = Math.abs(x-p.x);
        var y = Math.abs(y-p.y);
        return (x <= proximity) && (y <= proximity);
    }
 
	public inline function offset(dx:Float, dy:Float)
	{
		x += dx; y += dy;
	}
	
    public static inline function polar(length:Float, angle:Float)
    {
        return new Point(length * Math.cos(angle),length * Math.sin(angle));
    }
    
    public inline function angle(p:Point=null)
    {
        return p != null?Math.atan2(p.y - y, p.x - x):Math.atan2(y,x);
    }

    public inline function scale(m=1.)
    {
		if(m < 0)m = 0;
        x *= m;
        y *= m;
        return this;
    }
    
    public inline function opposite()
    {
        return new Point(-x, -y);
    }
    
    public inline function perpendicular()
    {
        return new Point(-y, x);
    }

    public inline function pivot(p:Point, a=.0)
    {
        var x = x - p.y;
        var y = y - p.y;
        var l = Math.sqrt(x*x + y*y);
        var r = Math.atan2(y, x)+a;
        return new Point(p.x+l*Math.cos(a), p.y+l*Math.sin(a));
    }

    public inline function project(p:Point)
    {
        var il = 1/(Math.sqrt(x*x + y*y) * Math.sqrt(p.x*p.x + p.y*p.y));
        var m = (x*p.x + y*p.y) * il;
        return new Point(p.x*m, p.y*m);
    }
   
   

	public function toString()
	{
		var r = "(" + x + "," + y;
		if(z != 0) r+= "," + z;
		r += ")";
		return r;
	}// toString()
/////////////////////////////////////
	inline function get_x()
	{
		return _x;
	}// get_x()
	
	function set_x(f:Float)
	{
		_x = f;
		return f;
	}// set_x()
	
	inline function get_y()
	{
		return _y;
	}// get_y()
	
	inline function set_y(f:Float)
	{
		_y = f;
		return f;
	}// set_y()

	inline function get_z()
	{
		return _z;
	}// get_z()
	
	inline function set_z(f:Float)
	{
		_z = f;
		return f;
	}// set_z()

	inline function get_length()
	{
		_length = 0;
		if((x != 0)||(y != 0)||(z != 0))
			_length = Math.sqrt(_x * _x + _y * _y + _z * _z);
		return _length;
	}// get_length()

}// abv.math.Point

