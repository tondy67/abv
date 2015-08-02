package abv.lib.comp;
/**
 * 
 **/
import abv.bus.*;
import abv.lib.style.Style;
using abv.lib.CR;

@:dce
class Object implements IComm{

	public static var traceInherited = true;
// unique id
	public var id(get,never):String;
	var _id = "";
	function get_id() { return _id; };
//
	public var sign(null,null):Int;
	public var msg(default,null):MsgProp;
	

	public function new(id:String)
	{
		if(id.good()) _id = id; else throw "No ID";

		msg = {accept:MD.NONE,action:new Map()};
		sign = MS.subscribe(this);
	}// new()

	public function update() { };
	
	function dispatch(md:MD){}
	
	public inline function exec(md:MD)
	{ 
		if(!MS.isSender(md))return;
		var m = md.msg & msg.accept; 
		
		dispatch(md); 
		if(msg.action.exists(m) &&  (msg.action[m] != null))
			MS.exec(msg.action[m].clone());
	}// exec()
	
	
	public function free(){ } 

	public function toString() 
	{
		var s = traceInherited?"\n":"";
		return '$s Object(id: $id)';
    }// toString() 

}// abv.lib.comp.Object

