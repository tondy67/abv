package abv.lib.math;

import abv.CT;
/**
 * MathTools
 **/
class MT{

	public static inline function good(v:Null<Float>,msg="")
	{ 
		var r = true;

		if(v == null){
			log("Null number",msg); 
			r = false;
		}else if(Math.isNaN(v)){
			log("NaN number",msg); 
			r = false;
		}else if(!Math.isFinite(v)){
			log("Not number",msg); 
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

	static inline function log(s="",msg="")
	{
		if(msg != "") msg += ": ";
		if(s != "") CT.log('$msg $s');
	}// log()


}// abv.lib.math.MT

