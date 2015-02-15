package abv.lib.comp;


import abv.lib.anim.*;
import abv.lib.math.Point;
import abv.lib.comp.Component;

/**
 * 
 **/
@:dce
class Animator extends Component {

	var stStop = 0;
	var stPlay = 1;
	var stAnimate = 2;
	var dir:Point;
// mirror -> 1 = horizontal, 2 = vertical
	public var mirror:Int;
	var _mirror = 0;
	function get_mirror() { return _mirror; }
	function set_mirror(i:Int) { _mirror = i; return i; }
	
	
	public function new(id:String)
	{
		super(id);
		dir = new Point();
		state = stPlay;
		text = id;
	}// new()

	public function moveTo(dest:Point,fixed=false)
	{
		moveBy(dest.sub(pos),fixed);
	}// moveTo()
	
	public function moveBy(delta:Point,fixed=false)
	{
		if(delta.length == 0){
			dir.set(0,0);
			return;
		}
		pos = pos.add(delta);  
		update();
	}// moveBy()
	
	override function update()
	{
	// override me
	}// update()

	public override function toString() 
	{
		var s = Object.traceInherited?super.toString() + "\n  └>":""; 
		return s + "Animator(id:"+id+")";
    }// toString() 

}// abv.lib.comp.Animator

