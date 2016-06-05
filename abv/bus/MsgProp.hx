package abv.bus;
/**
 * MsgProp
 **/
class MsgProp{

	public var accept = 0;
	public var action = new Map<Int,MD>();
	
	public inline function new(){ }
	
	public function toString()
	{
		return 'MsgProp(accept: $accept, action: $action)';
	}// toString()

}// MsgProp

