package abv.lib.box;
/**
 * 
 **/
import abv.lib.style.Style;
import abv.lib.comp.Component;
import abv.lib.comp.Object;
import abv.ui.Root;
import abv.lib.math.Point;
import abv.ds.AMap;
import abv.bus.MS;

using abv.lib.math.MT;
using abv.lib.CC;

@:dce
class Container extends Component{

	var children = new AMap<Int,Component>();
	public var numChildren(get,never):Int;
	function get_numChildren()  return children.length;

	var placement = new Point();

@:allow(abv.ui.BU)
	var styles:AMap<String,Style>;
//
	override function set_visible(b:Bool){
		_visible = b;
		for(it in children.vals())it.visible = b;
		return b;
	};
	override function set_root(r:Root){
		for(it in children.vals()) it.root = r;
		return _root = r;
	}

//	
	public inline function new(id:String)
	{
		super(id);
	}// new()

	public inline function has(obj:Component)
	{
		var r = true;
		if (obj == null)r = false;
		else if(obj.id == 0)r = false;
		else if(!children.exists(obj.id)) r = false;
		else if(children[obj.id] == null) r = false;
		return r;
	}
	
	public function addChild(obj:Component)
	{
		if(obj.isNull(" in "+name))return;
		else if(obj.id == 0)trace(ERROR+"No ID");
		else if(children.exists(obj.id))trace(ERROR+"Object: "+obj.name+" exist!");
		else{
			obj.parent = this; 
			obj.root = root; 
			obj.visible = visible;
			children[obj.id] = obj;
		}
	}// addChild()

	public function addChildAt(obj:Component, index:Int)
	{
		if(obj.isNull(" in "+name))return;
		else if(obj.id == 0)return;
		else if(index < 0)index = 0;
		else if(index > numChildren-1)index = numChildren - 1;
		children.setIndex(obj.id,obj,index);
	}// addChildAt()
	
	public inline function getChildAt(i:Int) 
	{
		var obj:Component = null;
		if((i >= 0)||(i < numChildren))obj = children.getIndex(i);
		return obj;
	}// getChildAt()
	
	public function getChildByID(id:String) 
	{
		var obj:Component = null;
		var ix = id.good() ? MS.getID(id):-1;
		if((ix != -1) && children.exists(ix))obj = children[ix];
		return obj;
	}// getChildByID()

	public inline function getChildIndex(obj:Component)
	{ 
		return children.indexOf(obj);
	}// getChildIndex()
	
	public function delChildren()
	{
		for(it in children.copy().vals())delChild(it);
	}// delChildren()

	public function delChild(obj:Component)
	{
		if (obj != null){
			children.remove(obj.id);
			obj.dispose();
			obj = null;
		}
	}// delChild()
	
	public function delChildAt(i:Int)
	{
		if((i < 0)||(i > numChildren-1))return;
		delChild(children.getIndex(i));
	}// delChildAt()
	
	public function getChildren()
	{
		var r = new List<Component>();
		var child:Component;
		for (i in 0...numChildren){ 
			child = getChildAt(i); 
			r.add(child);  
			if(Std.is(child,Container)) getChildrenR(cast(child,Container),r); 
		} 
		return r;
	}// getChildren()
	
	inline function getChildrenR(o:Container,r:List<Component>)
	{
		var child:Component;
		for (i in 0...o.numChildren){ 
			child = o.getChildAt(i); 
			r.add(child);  
			if(Std.is(child,Container))getChildrenR(cast(child,Container),r); 
		} 
	}// getChildrenR()

	public function placeChild(obj:Component)
	{ 
		if(obj.isNull())return;
		else if(obj.parent.isNull(ERROR+" No parent!: "+obj.name))return;
		else if(!children.exists(obj.id)){
			trace(ERROR+" Intruder!: "+obj.name);
			return;
		}

		var c = 0, auto = .0;
		var child:Component;
		var pr = obj.parent; 
		var px = pr.pos.x, py = pr.pos.y;
		var pw = pr.width, ph = pr.height;
		var pp = pr.style.padding;

		var style = obj.style; 
		var x = style.left; 
		var y = style.top; 
		var w = style.width.val(pw);
		var h = style.height.val(ph);
		var m = style.margin; 
		var p = style.padding; 
		var ix = getChildIndex(obj);  

//if(pr.id == "mbox") trace(pr.style);
/**
 * |<-left->|<-margin->|<-padding->|<--width-->|<-padding->|<-margin->|
 **/
		if(x == 0){ 
			if(placement.x == 1){ 
				if(pp.left == CC.AUTO) c++;else x = pp.left.auto();

				for(i in 0...numChildren){
					child = children.getIndex(i);
					m = child.style.margin;
					p = child.style.padding;
					if(m.left == CC.AUTO) c++;else x += m.left.auto();
					if(m.right == CC.AUTO) c++;else x += m.right.auto();
					if(p.left == CC.AUTO) c++;else x += p.left.auto();
					if(p.right == CC.AUTO) c++;else x += p.right.auto();
					x += style.width; 
				}

				if(pp.right == CC.AUTO) c++;else x += pp.right.auto();

				if(c > 0)auto = (pw - x)/c;

				if(ix == 0){
					child = children.getIndex(0);
					m = child.style.margin;
					p = child.style.padding;
					x = pp.left.auto(auto) + m.left.auto(auto) + p.left.auto(auto);
				}else{
					child = children.getIndex(ix-1);
					m = child.style.margin;
					p = child.style.padding;
					x = child.pos.x + m.left.auto(auto) + p.left.auto(auto) +
						child.width + m.right.auto(auto) + p.right.auto(auto);
				}
			}else{
				x = (pw - pp.left - m.left - p.left - w - p.right - m.right - pp.right - 3)/2; 
			}
		}
		
		
		if(y == 0){
			c = 0; auto = 0;
			m = obj.style.margin; 
			pp = obj.parent.style.padding;
			ph = obj.parent.height;
			if(placement.y == 1){ 
				if(pp.top == CC.AUTO) c++;else y = pp.top.auto();

				for(i in 0...numChildren){
					child = children.getIndex(i);
					m = child.style.margin;
					p = child.style.padding;
					if(m.top == CC.AUTO) c++;else y += m.top.auto();
					if(m.bottom == CC.AUTO) c++;else y += m.bottom.auto();
					if(p.top == CC.AUTO) c++;else y += p.top.auto();
					if(p.bottom == CC.AUTO) c++;else y += p.bottom.auto();
					y += style.height; 
				}

				if(pp.bottom == CC.AUTO) c++;else y += pp.bottom.auto();

				if(c > 0)auto = (ph - y)/c;

				if(ix == 0){
					child = children.getIndex(0);
					m = child.style.margin;
					p = child.style.padding;
					y = pp.top.auto(auto) + m.top.auto(auto) + p.top.auto(auto);
				}else{
					child = children.getIndex(ix-1);
					m = child.style.margin;
					p = child.style.padding;
					y = child.pos.y + m.top.auto(auto) + p.top.auto(auto) +
						child.height + m.bottom.auto(auto) + p.bottom.auto(auto);
				}
			}else{
				y = (ph - pp.top - m.top - p.top - h - p.bottom - m.bottom - pp.bottom - 3)/2; 
			}
		}

		obj.pos.set(x,y); 
		obj.width = obj.style.width = w; 
		obj.height = obj.style.height = h; 
	}// placeChild()

	public override function resize()
	{ 
		for(it in children.vals()){ 
			it.resize();
			placeChild(it); 
		}
	}// resize()

	public override function update() { 
		for(it in children.vals())it.update();
	}//update()
	
	public override function toString() 
	{
		var s = Object.traceInherited?super.toString() + "\n   └>":""; // ─
		return '$s Container(id: $name, numChildren: $numChildren)';
    }// toString() 

}// abv.lib.ui.box.Container

