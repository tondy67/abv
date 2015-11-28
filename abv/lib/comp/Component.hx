package abv.lib.comp;

import abv.interfaces.*;
import abv.bus.*;
import abv.lib.math.Point;
import abv.lib.box.Container;
import abv.ui.Root;
import abv.lib.style.*;
import abv.lib.style.Style;
import abv.lib.Enums;

using abv.lib.CC;
//
@:dce
class Component extends MObject implements IDraw {

	public var kind(get, never):RenderKind;
	var _kind = RK_NONE;
	public function get_kind()  return _kind;
	
	public var outline(get, null):Array<Point>;
	var _outline:Array<Point> = [];
	public function get_outline()  return _outline.copy();
	
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

	public var parent(default,null):Container = null;

	public var root(get,set):Root;
	var _root:Root = null;
	function get_root() return _root;
	function set_root(r:Root) return _root = r;
//
	public var visible(get,set):Bool;
	var _visible = true;
	function get_visible() return _visible;
	function set_visible(b:Bool) return _visible = b;
//
	public inline function new(id:String)
	{
		super(id);
		outline.push(pos);
	}// new()

	public override function moveBy(from:Point,delta:Point)
	{
		pos = from.add(delta);
		draw(this);  
	}// moveBy()
	
	public function draw(obj:Component){
		if(!root.isNull(ERROR+" No Root?"))root.draw(this);
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

	public override function dispose() 
	{
		super.dispose();
    }// dispose() 

	public function resize()
	{
//		trace(id+" - resize: "+parent.id);
	}// resize()

// local to global coord.
	public inline function toScreen()
	{
		var x = pos.x;
		var y = pos.y;
		var p = parent;

		while (p != null) { 
			x += p.pos.x; 
			y += p.pos.y; 
			p = p.parent; 
		};
		
		gX = x;
		gY = y;
	}// toScreen()

	public inline function getBounds()
	{ // TODO: getBounds()
		return {w:width,h:height,d:depth};
	}// getBounds()
	
	public override function toString() 
	{
		var pid = 0; try pid = parent.id catch(d:Dynamic){}; //trace(pid);
		var rid = 0; try rid = root.id catch(d:Dynamic){};
		var s = Object.traceInherited?super.toString() + "\n └>":""; 
		return '$s Component<IAnim>(id: $name, state: $state, parent: $pid'+
		', root: $rid, visible: $visible, text: $text, color: $color,alpha: $alpha, rot: ${rot.x})';
    }// toString() 

}// abv.lib.comp.Component

