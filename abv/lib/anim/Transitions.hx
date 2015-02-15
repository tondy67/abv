package abv.lib.anim;
/**
 * Easing functions thankfully taken from http://www.robertpenner.com/easing
 **/
@:dce
class Transitions{
	public static inline var linear 			= "linear";
	public static inline var easeIn 			= "easeIn";
	public static inline var easeOut 			= "easeOut";
	public static inline var easeInOut 			= "easeInOut";
	public static inline var easeOutIn 			= "easeOutIn";
	public static inline var easeInBack 		= "easeInBack";
	public static inline var easeOutBack 		= "easeOutBack";
	public static inline var easeInOutBack 		= "easeInOutBack";
	public static inline var easeOutInBack 		= "easeOutInBack";
	public static inline var easeInElastic 		= "easeInElastic";
	public static inline var easeOutElastic 	= "easeOutElastic";
	public static inline var easeInOutElastic 	= "easeInOutElastic";
	public static inline var easeOutInElastic 	= "easeOutInElastic";  
	public static inline var easeInBounce 		= "easeInBounce";
	public static inline var easeOutBounce 		= "easeOutBounce";
	public static inline var easeInOutBounce 	= "easeInOutBounce";
	public static inline var easeOutInBounce 	= "easeOutInBounce";
 	static var transitions:Map<String,Float->Float>;
 	
	function new()
	{

	}// new()

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
		transitions = new Map();

		register(linear, _linear);
		register(easeIn, _easeIn);
		register(easeOut, _easeOut);
		register(easeInOut, _easeInOut);
		register(easeOutIn, _easeOutIn);
		register(easeInBack, _easeInBack);
		register(easeOutBack, _easeOutBack);
		register(easeInOutBack, _easeInOutBack);
		register(easeOutInBack, _easeOutInBack);
		register(easeInElastic, _easeInElastic);
		register(easeOutElastic, _easeOutElastic);
		register(easeInOutElastic, _easeInOutElastic);
		register(easeOutInElastic, _easeOutInElastic);
		register(easeInBounce, _easeInBounce);
		register(easeOutBounce, _easeOutBounce);
		register(easeInOutBounce, _easeInOutBounce);
		register(easeOutInBounce, _easeOutInBounce);
	}// registerDefaults() 

// transition functions
	static function _linear(ratio:Float)
	{
		return ratio;
	}// _linear()
			
	static function _easeIn(ratio:Float)
	{
		return ratio * ratio * ratio;
	}// _easeIn    

	static function _easeOut(ratio:Float)
	{
		var inverse = ratio - 1.0;
		return inverse * inverse * inverse + 1;
	}

	static function _easeInOut(ratio:Float)
	{
		return _easeCombined(_easeIn, _easeOut, ratio);
	}   

	static function _easeOutIn(ratio:Float)
	{
		return _easeCombined(_easeOut, _easeIn, ratio);
	}

	static function _easeInBack(ratio:Float)
	{
		var s:Float = 1.70158;
		return Math.pow(ratio, 2) * ((s + 1.0)*ratio - s);
	}

	static function _easeOutBack(ratio:Float)
	{
		var invRatio:Float = ratio - 1.0;
		var s:Float = 1.70158;
		return Math.pow(invRatio, 2) * ((s + 1.0)*invRatio + s) + 1.0;
	}

	static function _easeInOutBack(ratio:Float)
	{
		return _easeCombined(_easeInBack, _easeOutBack, ratio);
	}   

	static function _easeOutInBack(ratio:Float)
	{
		return _easeCombined(_easeOutBack, _easeInBack, ratio);
	}

	static function _easeInElastic(ratio:Float)
	{
		if (ratio == 0 || ratio == 1) return ratio;
		else{
			var p:Float = 0.3;
			var s:Float = p/4.0;
			var invRatio:Float = ratio - 1;
			return -1.0 * Math.pow(2.0, 10.0*invRatio) * Math.sin((invRatio-s)*(2.0*Math.PI)/p);
		}
	}

	static function _easeOutElastic(ratio:Float)
	{
		if (ratio == 0 || ratio == 1) return ratio;
		else{
			var p:Float = 0.3;
			var s:Float = p/4.0;
			return Math.pow(2.0, -10.0*ratio) * Math.sin((ratio-s)*(2.0*Math.PI)/p) + 1;
		}
	}

	static function _easeInOutElastic(ratio:Float)
	{
		return _easeCombined(_easeInElastic, _easeOutElastic, ratio);
	}   

	static function _easeOutInElastic(ratio:Float)
	{
		return _easeCombined(_easeOutElastic, _easeInElastic, ratio);
	}

	static function _easeInBounce(ratio:Float)
	{
		return 1.0 - _easeOutBounce(1.0 - ratio);
	}

	static function _easeOutBounce(ratio:Float)
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

	static function _easeInOutBounce(ratio:Float)
	{
		return _easeCombined(_easeInBounce, _easeOutBounce, ratio);
	}   

	static function _easeOutInBounce(ratio:Float)
	{
		return _easeCombined(_easeOutBounce, _easeInBounce, ratio);
	}

	static function _easeCombined(startFunc:Float->Float, endFunc:Float->Float, ratio:Float)
	{
		if (ratio < 0.5) return 0.5 * startFunc(ratio*2.0);
		else return 0.5 * endFunc((ratio-0.5)*2.0) + 0.5;
	}// _easeCombined()

}// abv.lib.anim.Transitions

