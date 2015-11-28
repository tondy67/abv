package abv.interfaces;
/**
 * IComm
 **/
import abv.bus.MD;

@:allow(abv.bus.MS)
interface IComm {

	public var id(null,null):Int;
	public var msg(default,null):abv.bus.MS.MsgProp;
	
	public function exec(md:MD):Void;
	public function update():Void;

}// abv.interfaces.IComm

