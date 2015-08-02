package abv.lib.comp;

import abv.lib.math.Point;
import abv.bus.MD;
/**
 *
 **/
@:dce
class MObject extends Object {

// position
	public var pos(get,set):Point;
	var _pos:Point;
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
// scaling
	public var scale(get,set):Float;
	var _scale = 1.;
	function get_scale(){return _scale;}
	function set_scale(f:Float){return _scale = f;}


//
	public function new(id:String)
	{
		super(id);
		_pos = new Point();
	}// new()


	public function action(act:Int,to:String,m:Int,customMsg=MD.NONE)
	{
		var md = new MD(sign,to,m,[customMsg]);
		msg.action.set(act,md); //trace(msg.action);
	}
	
	public override function toString() 
	{
		var s = Object.traceInherited?super.toString() + "\n└>":""; // ─
		return '$s MObject(id: $id, pos: $pos, width:$width, height: $height, scale: $scale)';
    }// toString() 

}// abv.lib.comp.MObject

