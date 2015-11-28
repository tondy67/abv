package abv.interfaces;
/**
 * 
 **/
import abv.lib.math.Point;

interface IAnim extends IObject{

	public var state(get,set):Int;
// width
	public var width(get,set):Float;
// height
	public var height(get,set):Float;
// depth
	public var depth(get,set):Float;
// transparency
	public var alpha(get,set):Float;
// position
	public var pos(get,set):Point;
// rotation
	public var rot(get,set):Point;
// scaling
	public var scale(get,set):Float;
	
	public function animBy(from:Point,delta:Point):Void;

}// abv.interfaces.IAnim

