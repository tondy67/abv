package abv.factory;
/**
 * 
 **/
import abv.bus.*;
import abv.style.Style;
import abv.factory.IComm;

using abv.sys.ST;

@:dce
class Object implements IComm{

	public static var showInherited = false;
// unique id
//@:allow(abv.io.AD)
	public var id(get,never):Int;
	function get_id() return MS.getID(name);
//
	public var name(get,never):String;
	var _name = "";
	function get_name() return _name;
//
	public var msg(default,null) = new MsgProp();
	

	public inline function new(name="")
	{
		if(!name.good()) name = "_"+ST.rand();
		if(!MS.add(this,name)) throw name + ": no ID"; 
		_name = name;
	}// new()

	public function update() { };
	
	function dispatch(md:MD){}
	
	public inline function call(md:MD)
	{ 
		if(!MS.has(md.from.id))return;  
		var m = md.msg & msg.accept; 
		
		dispatch(md); 
		if(msg.action.exists(m)) MS.call(msg.action[m].clone()); 
	}// call()
	

	public function dispose()
	{  
		MS.remove(name);
	}// dispose() 

	public function toString() 
	{
		return 'Object($id:$name)';
    }// toString() 

}// abv.factory.Object

