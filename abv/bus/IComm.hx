package abv.bus;
/**
 * IComm
 **/
import abv.bus.MS;
import abv.lib.comp.IObject;

@:dce
interface IComm extends IObject{

	public var sign(null,null):Int;
	public var msg(default,null):MsgProp;
	
	public function exec(mdt:MD):Void;

}// abv.bus.IComm

