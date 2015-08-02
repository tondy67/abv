package abv.lib.comp;

import abv.lib.anim.IAnim;
import abv.bus.*;
import abv.lib.math.Point;
import abv.lib.box.Container;
import abv.ui.Root;
import abv.lib.style.*;
import abv.lib.style.Style;

using abv.lib.CR;
//
@:dce
class Component extends MObject implements IAnim implements IStyle {

	public var style(get, never):Style;
	var _style = new Style();
	public function get_style() { return _style; }

// label, name, tile ...
	public var text(get,set):String;
	var _text = "";
	function get_text(){return _text;}
	function set_text(s:String){ return _text = s;}
//
	public var state(get,set):Int;
	var _state = 0;
	function get_state(){return _state;}
	function set_state(i:Int){ return _state = i;}

	public var parent(default,null):Container = null;

	public var root(get,set):Root;
	var _root:Root = null;
	function get_root(){ return _root;}
	function set_root(r:Root){ return _root = r;}
//
	public var visible(get,set):Bool;
	var _visible = true;
	function get_visible(){return _visible;};
	function set_visible(b:Bool){return _visible = b;};
//
// depth
	public var depth(get,set):Float;
	var _depth:Float;
	function get_depth(){return _depth * _scale;}
	function set_depth(f:Float){_depth = f/_scale; return f;}
// rotation
	public var rot(get,set):Point;
	var _rot = new Point();
	function get_rot(){return _rot;}
	function set_rot(p:Point){_rot.copy(p); return p;}
// transparency
	public var fade(get,set):Float;
	var _fade = 1.;
	function get_fade(){return _fade;};
	function set_fade(f:Float){return _fade = f;};
//
	public var color(get, set):Float;
	var _color = .0;
	function get_color() { return _color; }
	function set_color(c:Float) { return _color = c; }

	public function new(id:String)
	{
		super(id);
	}// new()

	public function moveTo(dest:Point)
	{
		moveBy(pos,dest.sub(pos));
	}// moveTo()
	
	public function moveBy(from:Point,delta:Point)
	{
		pos = from.add(delta);  
	}// moveBy()
	
	function draw(obj:Component){
		if (root == null) trace(CR.ERROR+"No Root?");  
		else root.draw(this);
	}// draw()

	override function dispatch(md:MD)
	{ 
		switch(md.msg){
			case MD.CLOSE: 
				visible = false;
				draw(this);
			case MD.OPEN: 
				visible = true;
				draw(this);
			case MD.MOVE: 
				pos.offset(md.f[0],md.f[1]);
				draw(this); 
		}
	}// dispatch

	public override function free() 
	{
//		delChildren(); 
		if(parent != null)parent.delChild(this);
    }// free() 

	public function resize()
	{
//		trace(id+" - resize: "+parent.id);
	}// resize()

	public override function toString() 
	{
		var pid:Null<String> = ""; try pid = parent.id catch(d:Dynamic){}; //trace(pid);
		var rid:Null<String> = ""; try rid = root.id catch(d:Dynamic){};
		var s = Object.traceInherited?super.toString() + "\n └>":""; 
		return '$s Component<IAnim>(id: $id, state: $state, parent: $pid'+
		', root: $rid, visible: $visible, text: $text, color: $color,fade: $fade, rot: ${rot.x})';
    }// toString() 

}// abv.lib.comp.Component

