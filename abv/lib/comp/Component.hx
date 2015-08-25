package abv.lib.comp;

import abv.interfaces.*;
import abv.bus.*;
import abv.lib.math.Point;
import abv.lib.box.Container;
import abv.ui.Root;
import abv.lib.style.*;
import abv.lib.style.Style;

using abv.lib.CC;
//
@:dce
class Component extends MObject implements IDraw {

	public var style(get, never):Style;
	var _style = new Style();
	public function get_style() { return _style; }

// label, name, tile ...
	public var text(get,set):String;
	var _text = "";
	function get_text(){return _text;}
	function set_text(s:String){ return _text = s;}

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
	public inline function new(id:String)
	{
		super(id);
	}// new()

	public override function moveBy(from:Point,delta:Point)
	{
		pos = from.add(delta);
		draw(this);  
	}// moveBy()
	
	public function draw(obj:Component){
		if (root == null) trace(ERROR+"No Root?");  
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
			case MD.NEW: 
				text = md.s;
				draw(this);
		}
	}// dispatch

	public override function free() 
	{
//		delChildren(); 
//		if(parent != null)parent.delChild(this);
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

