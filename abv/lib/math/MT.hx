package abv.lib.math;
/**
 * MathTools
 **/
class MT{

	public static inline function good(v:Null<Float>,msg="")
	{ 
		var r = true;
		var m = function(s){if(msg != "")log(s);}

		if(v == null){
			m('$msg: Null number'); 
			r = false;
		}else if(Math.isNaN(v)){
			m('$msg: NaN number'); 
			r = false;
		}else if(!Math.isFinite(v)){
			m('$msg: Not number'); 
			r = false;
		}

		return r;
	}// good()

	public static inline function range(f:Null<Float>,max:Float, min:Float=0)
	{
		if(good(f,"range")){
			if(f >= max)f = max;
			else if(f <= min)f = min; 
		}else f = 0;
		
		return f;
	}// range()

	static inline function log(msg=""){CT.log(msg);}

}// abv.lib.math.MT

