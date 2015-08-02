package abv.lib.anim;

import abv.lib.comp.IObject;
import abv.lib.math.Point;

/**
 * 
 **/
@:dce
interface IAnim extends IObject{

	public var state(get,set):Int;
// label, name, tile ...
	public var text(get,set):String;
// width
	public var width(get,set):Float;
// height
	public var height(get,set):Float;
// depth
	public var depth(get,set):Float;
// transparency
	public var fade(get,set):Float;
// position
	public var pos(get,set):Point;
// rotation
	public var rot(get,set):Point;
// scaling
	public var scale(get,set):Float;
	
	public function moveTo(dest:Point):Void;
	public function moveBy(from:Point,delta:Point):Void;

}// abv.lib.anim.IAnim

