package abv.lib.anim;
/**
Inspired by (Starling) http://gamua.com/starling/
```haxe
import abv.lib.anim.*
```
**/
import abv.lib.anim.IAnim;
using Lambda; 

@:dce
class Juggler{
	var targets:List<IAnim> = new List();
	var tweens:Map<IAnim,List<Tween>> = new Map();
	var run = true;
	
	public function new()
	{
	}// new()

	public function update()
	{ //trace(targets.length);
		if(!run)return;
		for(target in targets){ //trace(tweens[target]);
			if(tweens[target].first().run)tweens[target].first().update();
			else remove(tweens[target].first());
		}
	}// update()
	
	public function add(tw:Tween)
	{ 
		if(tw.target == null) return;
		if(!targets.has(tw.target))targets.add(tw.target);
		if(!tweens.exists(tw.target))tweens.set(tw.target,new List());
//		tw.run = true;
		tweens[tw.target].add(tw); // push
//		tweens[tw.target].last().run = true; //trace(tweens);
	}// add()

	public function remove(tw:Tween)
	{
		if(tw.target == null) return;
		if(tweens[tw.target].has(tw)){
			tweens[tw.target].remove(tw);
			if(tweens[tw.target].length == 0)targets.remove(tw.target);
		}
	}// remove()

	public function removeAll(target:IAnim)
	{
		if(target == null)return;
		tweens.remove(target);
		targets.remove(target);
	}// removeAll()

	public function delTarget(name:String)
	{
		var target:IAnim = null;
		for(tr in targets){
			if(tr.id == name){
				target = tr;
				break;
			}
		}
		if(target != null)removeAll(target);
	}// delTarget()

	public function toString()
	{
		var s = "Juggler(tweens:\n";
		for(key in tweens.keys())s += key.id +"=>"+tweens[key]+",\n";
		s += ")";
		return s;
	}

}// abv.lib.anim.Juggler

