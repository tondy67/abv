package abv.lib.math;

using abv.CR;
/**
 * MathTools
 **/
class MT{

	public static inline function good(v:Null<Float>,msg="",?pif:haxe.PosInfos)
	{ 
#if debug msg = '${pif.fileName}->${pif.methodName}:$msg)'; #else msg = "";#end
		var r = true;

		if(v == null){
			CR.print(msg+": Null number",WARN); 
			r = false;
		}else if(Math.isNaN(v)){
			CR.print(msg+": NaN number",WARN); 
			r = false;
		}else if(!Math.isFinite(v)){
			CR.print(msg+": Not number",WARN); 
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

}// abv.lib.math.MT

