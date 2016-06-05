package abv.factory;
/** 
  *  IMember
  **/
interface IMember extends ITrait{

	public var rootNode(get , set):IGroup;
	public var parentNode(default , null):IGroup;

	public function getFamilyGR(r:List<IMember> = null):Null<List<IMember>>;

}// abv.factory.IMember

