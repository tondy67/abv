package abv.math;
/**
 * MathTools
 **/

using abv.sys.ST;

@:dce
class MT{

	inline function new(){ }

	public static inline function good(v:Null<Float>)
	{ 
		var r = true;

		if(v == null){
			r = false;
		}else if(Math.isNaN(v)){
			r = false;
		}else if(!Math.isFinite(v)){
			r = false;
		}

		return r;
	}// good()

	public static inline function range(f:Float,max:Float, min:Float=0)
	{
		if(good(f)){
			if(f >= max)f = max;
			else if(f <= min)f = min; 
		}else f = 0;
		
		return f;
	}// range()

	public static inline function closestPow2(v:Int)
	{
		var p = 2;
		while (p < v) p = p << 1;
		return p;
	}// closestPow2()
// css
	public static inline function auto(f:Float,v=.0)return f == CC.AUTO?v:f;
	
	public static inline function val(f:Float,max:Float)
	{
		var r:Float;
		if(f < 0)r = 0;
		else if((f >= 0)&&(f < 1))r = f * max;
		else r = f;
		return r;
	}// val()

	public static inline function cmpInt(a:Int,b:Int)
	{
		return a == b ? 0 : a < b ? -1:1;
	}

	public static inline function cmpFloat(a:Float,b:Float)
	{
		return Math.abs(a-b) > CC.E ? a < b ? -1:1 : 0;
	}


}// abv.math.MT

