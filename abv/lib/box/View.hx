package abv.lib.box;

import abv.lib.comp.*;
import abv.lib.anim.IAnim;
#if flash
import flash.display.Sprite;
import flash.events.Event;
#elseif js
#else
import openfl.display.Sprite;
import openfl.events.Event;
#end
//
@:dce
#if js
class View {
	public function new()
	{
	}
}
#else
class View extends Sprite{

	public var id(default,null):String;
	var objects:Array<Animator> = [];
	
	public function new()
	{
		super();
	}// new()

	public inline function update(e:Event=null)
	{ 
		render();
	}// render()

	function render()
	{ 
	// override me
	}// render()

	public function removeAll()
	{
		for(obj in objects)obj = null;
#if (cpp||php) objects.splice(0,objects.length); #else untyped objects.length = 0; #end
	}// removeAll()
	
	public inline function addObject(obj:Animator)
	{
		objects.push(obj);
		processObject(obj);
	}// addObject()

	function processObject(obj:Animator)
	{
	// override me	
	}// processObject()
	
	public function resize(w:Int,h:Int)
	{
		for(obj in objects)obj.resize();
	}// resize

	public function free()
	{
		removeAll();
		if(parent != null)parent.removeChild(this);
	}// free()

	public override function toString() 
	{
		var s = "View(id:"+id+", objects: ";
		for(obj in objects)s += obj.id + ", ";
		s += ")";
        return s;
    }// toString() 

}// abv.lib.box.View
#end
