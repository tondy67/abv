package abv.factory;

/** 
  *  TGroup
  **/
class TGroup {

	public static inline function numChildrenGR(o:IGroup):Int {
		return o.childrenGR.length;
	}// numChildrenGR()

	public static inline function hasGR(o:IGroup , obj:IMember):Bool {
		return o.childrenGR.indexOf(obj) !=  -1 ? true:false;
	}// hasGR()

	public static inline function addChildGR(o:IGroup , obj:IMember):Int {
		var r =  -1;
		
		return r;
	}// addChildGR()

	public static inline function addChildAtGR(o:IGroup , obj:IMember ,  pos:Int) {
		
	}// addChildAtGR()
	
	public static inline function getChildGR(o:IGroup , id:Int):IMember { 
		var r:IMember = null;
		
		return r;
	}// getChildGR()
	
	public static inline function getChildIdGR(o:IGroup , obj:IMember):Int {
		var r =  -1;
		
		return r;
	}// getChildIdGR()
	
	public static inline function delChildrenGR(o:IGroup) {
		
	}// delChildrenTree()

	public static inline function delChildGR(o:IGroup , obj:IMember) {
		
	}// delChildGR()
	
	public static inline function delChildAtGR(o:IGroup , pos:Int) {
		
	}// delChildAtGR()
}// abv.factory.TGroup

