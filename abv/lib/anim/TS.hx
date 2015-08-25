package abv.lib.anim;
/**
 * Transitions
 * Easing functions thankfully taken from http://www.robertpenner.com/easing
 **/
@:dce
class TS{
	public static inline var LINEAR 				= "linear";
	public static inline var EASE_IN 				= "easeIn";
	public static inline var EASE_OUT 				= "easeOut";
	public static inline var EASE_IN_OUT 			= "easeInOut";
	public static inline var EASE_OUT_IN 			= "easeOutIn";
	public static inline var EASE_IN_BACK 			= "easeInBack";
	public static inline var EASE_OUT_BACK 			= "easeOutBack";
	public static inline var EASE_IN_OUT_BACK 		= "easeInOutBack";
	public static inline var EASE_OUT_IN_BACK 		= "easeOutInBack";
	public static inline var EASE_IN_ELASTIC 		= "easeInElastic";
	public static inline var EASE_OUT_ELASTIC 		= "easeOutElastic";
	public static inline var EASE_IN_OUT_ELASTIC 	= "easeInOutElastic";
	public static inline var EASE_OUT_IN_ELASTIC 	= "easeOutInElastic";  
	public static inline var EASE_IN_BOUNCE 		= "easeInBounce";
	public static inline var EASE_OUT_BOUNCE 		= "easeOutBounce";
	public static inline var EASE_IN_OUT_BOUNCE 	= "easeInOutBounce";
	public static inline var EASE_OUT_IN_BOUNCE 	= "easeOutInBounce";
 	static var transitions:Map<String,Float->Float> = null;
 	
	inline function new(){	}

	public static function get(name = "")
	{
		if (transitions == null)registerDefaults();
		return transitions[name];
	}// get()
	
	public static function register(name = "", func:Float->Float)
	{
		if (transitions == null)registerDefaults();
		transitions[name] = func;
	}// register()
	
	static function registerDefaults()
	{
		transitions = [
			LINEAR 				=> linear ,
			EASE_IN 			=> easeIn ,
			EASE_OUT 			=> easeOut ,
			EASE_IN_OUT 		=> easeInOut ,
			EASE_OUT_IN 		=> easeOutIn ,
			EASE_IN_BACK 		=> easeInBack ,
			EASE_OUT_BACK 		=> easeOutBack ,
			EASE_IN_OUT_BACK 	=> easeInOutBack ,
			EASE_OUT_IN_BACK 	=> easeOutInBack ,
			EASE_IN_ELASTIC 	=> easeInElastic ,
			EASE_OUT_ELASTIC 	=> easeOutElastic ,
			EASE_IN_OUT_ELASTIC => easeInOutElastic ,
			EASE_OUT_IN_ELASTIC => easeOutInElastic ,
			EASE_IN_BOUNCE 		=> easeInBounce ,
			EASE_OUT_BOUNCE 	=> easeOutBounce ,
			EASE_IN_OUT_BOUNCE 	=> easeInOutBounce ,
			EASE_OUT_IN_BOUNCE 	=> easeOutInBounce 
		];
	}// registerDefaults() 

// transition functions
	static function linear(ratio:Float)
	{
		return ratio;
	}// linear()
			
	static function easeIn(ratio:Float)
	{
		return ratio * ratio * ratio;
	}// easeIn    

	static function easeOut(ratio:Float)
	{
		var inverse = ratio - 1.0;
		return inverse * inverse * inverse + 1;
	}

	static function easeInOut(ratio:Float)
	{
		return easeCombined(easeIn, easeOut, ratio);
	}   

	static function easeOutIn(ratio:Float)
	{
		return easeCombined(easeOut, easeIn, ratio);
	}

	static function easeInBack(ratio:Float)
	{
		var s:Float = 1.70158;
		return Math.pow(ratio, 2) * ((s + 1.0)*ratio - s);
	}

	static function easeOutBack(ratio:Float)
	{
		var invRatio:Float = ratio - 1.0;
		var s:Float = 1.70158;
		return Math.pow(invRatio, 2) * ((s + 1.0)*invRatio + s) + 1.0;
	}

	static function easeInOutBack(ratio:Float)
	{
		return easeCombined(easeInBack, easeOutBack, ratio);
	}   

	static function easeOutInBack(ratio:Float)
	{
		return easeCombined(easeOutBack, easeInBack, ratio);
	}

	static function easeInElastic(ratio:Float)
	{
		if (ratio == 0 || ratio == 1) return ratio;
		else{
			var p:Float = 0.3;
			var s:Float = p/4.0;
			var invRatio:Float = ratio - 1;
			return -1.0 * Math.pow(2.0, 10.0*invRatio) * Math.sin((invRatio-s)*(2.0*Math.PI)/p);
		}
	}

	static function easeOutElastic(ratio:Float)
	{
		if (ratio == 0 || ratio == 1) return ratio;
		else{
			var p:Float = 0.3;
			var s:Float = p/4.0;
			return Math.pow(2.0, -10.0*ratio) * Math.sin((ratio-s)*(2.0*Math.PI)/p) + 1;
		}
	}

	static function easeInOutElastic(ratio:Float)
	{
		return easeCombined(easeInElastic, easeOutElastic, ratio);
	}   

	static function easeOutInElastic(ratio:Float)
	{
		return easeCombined(easeOutElastic, easeInElastic, ratio);
	}

	static function easeInBounce(ratio:Float)
	{
		return 1.0 - easeOutBounce(1.0 - ratio);
	}

	static function easeOutBounce(ratio:Float)
	{
		var s:Float = 7.5625;
		var p:Float = 2.75;
		var l:Float;
		if (ratio < (1.0/p)){
			l = s * Math.pow(ratio, 2);
		}else{
			if (ratio < (2.0/p)){
			ratio -= 1.5/p;
			l = s * Math.pow(ratio, 2) + 0.75;
			}else{
				if (ratio < 2.5/p){
					ratio -= 2.25/p;
					l = s * Math.pow(ratio, 2) + 0.9375;
				}else{
					ratio -= 2.625/p;
					l =  s * Math.pow(ratio, 2) + 0.984375;
				}
			}
		}
		return l;
	}

	static function easeInOutBounce(ratio:Float)
	{
		return easeCombined(easeInBounce, easeOutBounce, ratio);
	}   

	static function easeOutInBounce(ratio:Float)
	{
		return easeCombined(easeOutBounce, easeInBounce, ratio);
	}

	static function easeCombined(startFunc:Float->Float, endFunc:Float->Float, ratio:Float)
	{
		if (ratio < 0.5) return 0.5 * startFunc(ratio*2.0);
		else return 0.5 * endFunc((ratio-0.5)*2.0) + 0.5;
	}// easeCombined()

}// abv.lib.anim.TS
