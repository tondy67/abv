package abv.lib.box;

import abv.lib.comp.Component;
import abv.lib.comp.Object;
import abv.ui.Root;

using abv.lib.CR;
/**
 * 
 **/
@:dce
class Container extends Component{

	var children:Array<Component> = [];
	var childrenMap:Map<String,Component> ;
	public var numChildren(get,never):Int;
	function get_numChildren() { return children.length; };
//
	override function set_visible(b:Bool){
		_visible = b;
		for(child in children)child.visible = b;
		return b;
	};
	override function set_root(r:Root){
		for(child in children) child.root = r;
		return _root = r;
	}

//	
	public function new(id:String)
	{
		super(id);
		childrenMap = new Map();
	}// new()

	public inline function has(obj:Component)
	{
		var r = true;
		if (obj == null)r = false;
		else if(!obj.id.good())r = false;
		else if(!childrenMap.exists(obj.id)) r = false;
		else if(childrenMap[obj.id] == null) r = false;
		return r;
	}
	
	public function addChild(obj:Component)
	{
		if(obj == null)trace(CR.ERROR+"Null Object");
		else if(!obj.id.good())trace(CR.ERROR+"No id");
		else if(childrenMap.exists(obj.id))trace(CR.ERROR+"Object: "+obj.id+" exist!");
		else{
			obj.parent = this; //trace(id+":"+root);
			obj.root = root; 
			obj.visible = visible;
			children.push(obj);
			childrenMap.set(obj.id,obj);
		}
	}// addChild()

	public function addChildAt(obj:Component, index:Int)
	{
		if (obj == null)return;
		else if((obj.id == null)||(obj.id == ""))return;
		else if(index < 0)index = 0;
		else if(index > numChildren-1)index = numChildren - 1;
		var cur = children.indexOf(obj);
		if(cur != -1)delChild(obj);
		children.insert(index,obj);
	}// addChildAt()
	
	public inline function getChildAt(i:Int) 
	{
		var obj:Component = null;
		if((i >= 0)||(i <= numChildren-1))obj = children[i];
		return obj;
	}// getChildAt()
	
	public function getChildByID(id:String) 
	{
		var obj:Component = null;
		if((id == null)||(id == ""))return obj;
		if(childrenMap.exists(id))obj = childrenMap[id];
		return obj;
	}// getChildByID()

	public inline function getChildIndex(obj:Component)
	{ 
		return children.indexOf(obj);
	}// getChildIndex()
	
	public inline function delChild(obj:Component)
	{
		if (obj != null){
			children.remove(obj);
			obj.free();
			obj = null;
		}
	}// delChild()
	
	public function delChildAt(i:Int)
	{
		if((i < 0)||(i > numChildren-1))return;
		delChild(children[i]);
	}// delChildAt()
	
	public override function resize()
	{
//		trace(id + ": "+width+":"+numChildren);
		for (child in children) child.resize();
	}// resize()

	public override function update() { 
		for(child in children)child.update();
	}//update()
	
	public override function toString() 
	{
		var s = Object.traceInherited?super.toString() + "\n   └>":""; // ─
		return '$s Container(id: $id, numChildren: $numChildren)';
    }// toString() 

}// abv.lib.ui.box.Container

