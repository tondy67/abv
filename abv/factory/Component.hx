package abv.factory;

import abv.factory.*;
import abv.bus.*;
import abv.math.Point;
import abv.io.AD;
import abv.ui.Root;
import abv.style.*;
import abv.style.Style;
import abv.Enums;

using abv.math.MT;
using abv.sys.ST;
//
@:dce
class Component extends Object implements IAnim implements IDraw {

	var children:Array<Component> = null;
	public var numChildren(get,never):Int;
	function get_numChildren(){
		return children == null?-1:children.length;
	}


//@:allow(abv.ui.UI)
//	var styles:Map<String,Style>;
//
	public var visible(get,set):Bool;
	var _visible = true;
	function get_visible(){
		return _visible;
	}
	function set_visible(b:Bool){
		if(children != null)for(it in children)it.visible = b;
		return _visible = b;
	};
///
	public var kind(get, never):RenderKind;
	var _kind = RECT;
	public function get_kind()  return _kind;

	public var outline(get, set):Array<Point>;
	var _outline:Array<Point> = null;
	function get_outline()return _outline != null ? _outline.copy():null;
	function set_outline(v:Array<Point>)return _outline = v.copy();
	
	public var style(get, never):Style;
	var _style = new Style();
	public function get_style()  return _style;
// global coord
	public var gX = .0;
	public var gY = .0;
// label, name, tile ...
	public var text(get,set):String;
	var _text = "";
	function get_text() return _text;
	function set_text(s:String) return _text = s;

	public var parent(default,null):Component = null;

	public var root(get,set):Root;
	var _root:Root = null;
	function get_root() return _root;
	function set_root(r:Root){
		if(children != null)for(it in children) it.root = r;
		return _root = r;
	}
//
// position
	public var x(get,set):Float;
	var _x = .0;
	function get_x(){return _x;}
	function set_x(v:Float){return _x = v;}
	public var y(get,set):Float;
	var _y = .0;
	function get_y(){return _y;}
	function set_y(v:Float){return _y = v;}
	public var z(get,set):Float;
	var _z = .0;
	function get_z(){return _z;}
	function set_z(v:Float){return _z = v;}
// dim
	public var width(get,set):Float;
	var _width = .0;
	function get_width(){return _width;}
	function set_width(f:Float){return _width = f;}
	public var height(get,set):Float;
	var _height = .0;
	function get_height(){return _height;}
	function set_height(f:Float){return _height = f; }
	public var depth(get,set):Float;
	var _depth:Float;
	function get_depth(){return _depth * _scale;}
	function set_depth(f:Float){_depth = f/_scale; return f;}
// scaling
	public var scale(get,set):Float;
	var _scale = 1.;
	function get_scale(){return _scale;}
	function set_scale(f:Float){return _scale = f;}
// rotation
	public var rot(get,set):Point;
	var _rot = new Point();
	function get_rot(){return _rot;}
	function set_rot(p:Point){_rot.copy(p); return p;}
// transparency
	public var alpha(get,set):Float;
	var _alpha = 1.;
	function get_alpha(){return _alpha;};
	function set_alpha(f:Float){return _alpha = f <= 0 ? 0:f >= 1 ? 1: f;};
//
	public var color(get, set):Color;
	var _color = new Color();
	function get_color() { return _color; }
	function set_color(c:Color) { return _color = c; }
//
	public var state(get,set):Int;
	var _state = 0;
	function get_state(){return _state;}
	function set_state(i:Int){ return _state = i;}

	public inline function new(id:String,k:RenderKind=null)
	{
		super(id);
		if(k == null) k = RECT;
		_kind = k;
	}// new()
///
	public inline function has(obj:Component)
	{
		var r = false;
		if((children != null) && (obj != null)){
			if(children.indexOf(obj) != -1) r = true;
		}
		return r;
	}
	public function addChild(obj:Component)
	{
		var ix = -1;
		if(obj == null){
			ST.error(ST.getText(20),name); 
			return ix;
		}
		if(children == null)children = [];
		ix = children.indexOf(obj);
		if(ix != -1)ST.error(ST.getText(9),obj.name);
		else{
			obj.parent = this; 
			obj.root = root; 
			obj.visible = visible;
			ix = children.push(obj);
		}
		return ix;
	}// addChild()

	public function addChildAt(obj:Component, pos:Int)
	{
		if(children == null)children = [];
		if(obj == null){
			ST.error(ST.getText(20),name); 
			return;
		}
		if(pos < 0)pos = 0;
		else if(pos > numChildren-1)pos = numChildren - 1;
		children.remove(obj);
		children.insert(pos,obj);
	}// addChildAt()
	
	public inline function getChild(id:Int) 
	{
		var r:Component = null;
		if(children == null)return r;
		if((id >= 0)||(id < numChildren))r = children[id];
		return r;
	}// getChild()
	
	public function getChildByName(s:String) 
	{
		var r:Component = null;
		if(children == null)return r;
		for(it in children)if(it.name == s)r = it;
		return r;
	}// getChildByName()

	public inline function getChildID(obj:Component)
	{ 
		var r = -1;
		if(children != null)r = children.indexOf(obj);
		return r;
	}// getChildID()
	
	public function delChildren()
	{   
		if(children == null)return;
		for(it in children){ 
			it.dispose();
			it = null; 
		}
		children.clear();
	}// delChildren()

	public function delChild(obj:Component)
	{ 
		if ((children != null) && (obj != null)){
			children.remove(obj);
			obj.dispose();
			obj = null; 
		}
	}// delChild()
	
	public function delChildAt(i:Int)
	{
		if(children == null)return;
		if((i < 0)||(i > numChildren-1))return;
		delChild(children[i]);
	}// delChildAt()
	
	public function getChildren(r:List<Component> = null):List<Component>
	{
		if(r == null) r = new List<Component>();
		if(children == null)return r;
		for (it in children){ 
			r.add(it);  
			it.getChildren(r); 
		} 
		return r;
	}// getChildren()

	public function resize()
	{ 
		if(children == null)return;
		for(it in children){ 
			it.resize(); 
		}
	}// resize()

	public override function update() { 
		if(children == null)return;
		for(it in children)it.update();
	}//update()
	
	public override function dispose() 
	{
		if(children != null)delChildren();
		super.dispose();
    }// dispose() 
///	
	public function moveBy(from:Point,delta:Point)
	{
		x = from.x + delta.x;
		y = from.y + delta.y;
		draw();  
	}// moveBy()
	
	public function animBy(from:Point,delta:Point){ }

	public function setAction(act:Int,to:String,m:Int,customMsg=MD.NONE)
	{
		var md = new MD(this,to,m,[customMsg]);
		msg.action.set(act,md); //trace(msg.action);
	}// setAction()
	
	public function draw(){
		AD.render(this);
	}// draw()

	override function dispatch(md:MD)
	{ 
		switch(md.msg){
			case MD.CLOSE: 
				visible = false;
				draw();
			case MD.OPEN: 
				visible = true;
				draw(); 
			case MD.MOVE: 
				x += md.f[0];
				y += md.f[1];
				draw(); 
			case MD.NEW: 
				text = md.s;
				draw();
		}
	}// dispatch

// local to global coord.
	public inline function toScreen()
	{
		var X = x;
		var Y = y;
		var p = parent;

		while (p != null) { 
			X += p.x; 
			Y += p.y; 
			p = p.parent; 
		};
		
		gX = X;
		gY = Y;
	}// toScreen()

	public inline function getBounds()
	{ // TODO: getBounds()
		return {w:width,h:height,d:depth};
	}// getBounds()
	
	public override function toString() 
	{
		var pname = ""; try pname = parent.name catch(e:Dynamic){}; 
		var rname = ""; try rname = root.name catch(e:Dynamic){};
		var s = Object.showInherited?super.toString() + "\n └>":""; 
		return '$s Component<IAnim>(id: $name, x: $x, y: $y, width:$width, height: $height, scale: $scale, state: $state, parent: $pname'+
		', root: $rname, visible: $visible, text: $text, color: $color,alpha: $alpha, rot: ${rot.x})';
    }// toString() 

}// abv.factory.Component

