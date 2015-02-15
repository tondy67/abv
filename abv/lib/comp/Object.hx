package abv.lib.comp;

import abv.lib.math.Point;
import abv.lib.style.Style;
using abv.CR;

typedef ObjectProps = {id:String,x:Float,y:Float,width:Float,height:Float,
	fade:Float,rot:Float,scale:Float,visible:Bool,text:String,color:Float,
	style:StyleProps}
/**
 * 
 **/
@:dce
class Object implements IObject{

	public static var traceInherited = true;
// unique id
	public var id(get,never):String;
	var _id:String = "";
	function get_id() { return _id; };
// position
	public var pos(get,set):Point;
	var _pos:Point;
	function get_pos(){return _pos;}
	function set_pos(p:Point){return _pos.copy(p);}
// width
	public var width(get,set):Float;
	var _width:Float = 0;
	function get_width(){return _width * _scale;}
	function set_width(f:Float){return _width = f/_scale;}
// height
	public var height(get,set):Float;
	var _height:Float = 0;
	function get_height(){return _height * _scale;}
	function set_height(f:Float){return _height = f/_scale; }
// scaling
	public var scale(get,set):Float;
	var _scale:Float = 1;
	function get_scale(){return _scale;}
	function set_scale(f:Float){return _scale = f;}

	public function new(id:String)
	{
		if(id.good('No ID!')) _id = id;
		_pos = new Point();
	}// new()

	public function free() 
	{
    }// free() 

	public function toString() 
	{
		var s = traceInherited?"\n":"";
		return '$s Object(id: $id, pos: $pos, width:$width, height: $height, scale: $scale)';
    }// toString() 

}// abv.lib.comp.Object

