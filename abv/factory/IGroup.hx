package abv.factory;
/** 
  *  IGroup
  **/
interface IGroup extends IMember{

@:allow(abv.factory.TGroup)
	public var childrenGR(null , null):Array<IMember>;

	public function numChildrenGR():Int;

	public function hasGR(obj:IMember):Bool;

	public function addChildGR(obj:IMember):Int;

	public function addChildAtGR(obj:IMember , pos:Int):Void;

	public function getChildGR(id:Int):IMember;
	
	public function getChildIdGR(obj:IMember):Int;
	
	public function delChildrenGR():Void;

	public function delChildGR(obj:IMember):Void;
	
	public function delChildAtGR(pos:Int):Void;
	
}// abv.factory.IGroup

