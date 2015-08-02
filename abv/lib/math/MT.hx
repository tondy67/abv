package abv.lib.math;

using abv.lib.CR;
/**
 * MathTools
 **/
@:dce
class MT{

	inline function new(){ }

	public static inline function good(v:Null<Float>,msg="")
	{ 
		var r = true;
		function m(s){if(msg != ""){trace(CR.DEBUG+msg+s);}}

		if(v == null){
			m(" Null number"); 
			r = false;
		}else if(Math.isNaN(v)){
			m(" NaN number"); 
			r = false;
		}else if(!Math.isFinite(v)){
			m(" Not number"); 
			r = false;
		}

		return r;
	}// good()

	public static inline function range(f:Null<Float>,max:Float, min:Float=0)
	{
		if(good(f)){
			if(f >= max)f = max;
			else if(f <= min)f = min; 
		}else f = 0;
		
		return f;
	}// range()

	public static inline function val(f:Float,max:Float)
	{
		var r:Float;
		if(f < 0)r = 0;
		else if((f >= 0)&&(f < 1))r = f * max;
		else r = f;
		return r;
	}// val()

	public static inline function closestPow2(v:Int)
	{
		var p = 2;
		while (p < v) p = p << 1;
		return p;
	}// closestPow2()


}// abv.lib.math.MT

