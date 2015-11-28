package abv.lib.comp;
/**
 *
 **/
import abv.interfaces.*;
import abv.lib.math.Point;
import abv.bus.MD;
import abv.lib.style.Color;

@:dce
class MObject extends Object implements IAnim {

// position
	public var pos(get,set):Point;
	var _pos = new Point();
	function get_pos(){return _pos;}
	function set_pos(p:Point){return _pos.copy(p);}
// width
	public var width(get,set):Float;
	var _width = .0;
	function get_width(){return _width;}
	function set_width(f:Float){return _width = f;}
// height
	public var height(get,set):Float;
	var _height = .0;
	function get_height(){return _height;}
	function set_height(f:Float){return _height = f; }
// depth
	public var depth(get,set):Float;
	var _depth:Float;
	function get_depth(){return _depth * _scale;}
	function set_depth(f:Float){_depth = f/_scale; return f;}
// scaling
	public var scale(get,set):Float;
	var _scale = 1.;
	function get_scale(){return _scale;}
	function set_scale(f:Float){return _scale = f;}
// rotation
	public var rot(get,set):Point;
	var _rot = new Point();
	function get_rot(){return _rot;}
	function set_rot(p:Point){_rot.copy(p); return p;}
// transparency
	public var alpha(get,set):Float;
	var _alpha = 1.;
	function get_alpha(){return _alpha;};
	function set_alpha(f:Float){return _alpha = f <= 0 ? 0:f >= 1 ? 1: f;};
//
	public var color(get, set):Color;
	var _color = new Color();
	function get_color() { return _color; }
	function set_color(c:Color) { return _color = c; }
//
	public var state(get,set):Int;
	var _state = 0;
	function get_state(){return _state;}
	function set_state(i:Int){ return _state = i;}



//
	public inline function new(id:String)
	{
		super(id);
	}// new()

	public function moveBy(from:Point,delta:Point){ }

	public function animBy(from:Point,delta:Point){ }

	public function setAction(act:Int,to:String,m:Int,customMsg=MD.NONE)
	{
		var md = new MD(id,to,m,[customMsg]);
		msg.action.set(act,md); //trace(msg.action);
	}
	
	public override function toString() 
	{
		var s = Object.traceInherited?super.toString() + "\n└>":""; // ─
		return '$s MObject(id: $name, pos: $pos, width:$width, height: $height, scale: $scale)';
    }// toString() 

}// abv.lib.comp.MObject

