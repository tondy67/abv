package abv.factory;
/**
 * IComm
 **/
import abv.bus.*;

@:allow(abv.bus.MS)
interface IComm {

	public var id(get,never):Int;
	public var msg(default,null):MsgProp;
	
	public function call(md:MD):Void;
	public function update():Void;

}// abv.factory.IComm

