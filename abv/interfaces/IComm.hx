package abv.interfaces;
/**
 * IComm
 **/
import abv.bus.MD;

interface IComm extends IObject{

@:allow(abv.bus.MS)
	public var sign(null,null):Int;
	public var msg(default,null):abv.bus.MS.MsgProp;
	
	public function exec(md:MD):Void;
	public function update():Void;

}// abv.interfaces.IComm

