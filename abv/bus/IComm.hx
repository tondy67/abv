package abv.bus;
/**
 * IComm
 **/
import abv.lib.comp.IObject;

@:dce
interface IComm extends IObject{

@:allow(abv.bus.MS)
	public var sign(null,null):Int;
	public var msg(default,null):MsgProp;
	
	public function exec(md:MD):Void;
	public function update():Void;

}// abv.bus.IComm

