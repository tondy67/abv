package abv.anim;
/**
 * Juggler
 **/

@:dce
class Juggler{

	static var tweens =  new List<Tween>();
	public static var run = true;
	
	inline function new(){ }

	public static inline function update()
	{ 
		if(!run)return;
		for(tw in tweens){ 
			if(tw.run)tw.update(); else remove(tw);
		}
	}// update()
	
	public static inline function add(tw:Tween)
	{ 
		tweens.add(tw);
	}// add()

	public static inline function remove(tw:Tween)
	{
		tweens.remove(tw);
	}// remove()

	public static inline function clear()
	{
		tweens.clear();
	}// clear()

	public static inline function info()
	{
		var s = "Juggler(tweens: " + tweens.length + ")";
		return s;
	}// toString()

}// abv.anim.Juggler

