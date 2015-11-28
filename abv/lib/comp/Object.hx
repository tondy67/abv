package abv.lib.comp;
/**
 * 
 **/
import abv.bus.*;
import abv.lib.style.Style;
import abv.interfaces.IComm;
import abv.ds.AMap;


using abv.lib.CC;

@:dce
class Object implements IComm{

	public static var traceInherited = true;
// unique id
@:allow(abv.ui.Shape)
	public var id(null,null):Int;
//
	public var name(get,never):String;
	function get_name() {return MS.getName(id);}
//
	public var msg(default,null):MS.MsgProp;
	

	public inline function new(id:String)
	{
		if(id.good()) this.id = MS.subscribe(this,id); else throw "No ID";

		msg = {accept:MD.NONE,action:new AMap()};
	}// new()

	public function update() { };
	
	function dispatch(md:MD){}
	
	public inline function exec(md:MD)
	{ 
		if(!MS.isSender(md))return;
		var m = md.msg & msg.accept; 
		
		dispatch(md); 
		if(msg.action.good(m)) MS.exec(msg.action[m].clone()); 
	}// exec()
	

	public function dispose()
	{ 
		MS.unsubscribe(id);
	}// dispose() 

	public function toString() 
	{
		return 'Object(id: $name)';
    }// toString() 

}// abv.lib.comp.Object

