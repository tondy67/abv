package abv.lib.comp;


import abv.lib.anim.*;
import abv.lib.math.Point;
//

@:dce
class Animators extends Animator {

	var animators(default,null):Array<Animator> = [];
	
	
	public function new(id:String)
	{
		super(id);
		dir = new Point();
//		animators.push(this); 
		state = stPlay;
	}// new()

	public function addChild(obj:Animator)
	{
		animators.push(obj);
	}// addChild()

	public function getChildren()
	{
		return animators;
	}// getChildren()

}// abv.lib.comp.Animators

