package abv.lib;

import abv.lib.box.Container;
import abv.lib.ui.box.Box;
import abv.lib.comp.Component;
import abv.lib.Screen;
/**
 * 
 **/
@:dce
@:allow(abv.lib.Screen)
class Root extends Box{

	public var screen(default,null):Screen;
//	public var skin(default,null):Skin;
	var wdg:Map<String,Component> ;
	public var context(default,null) = Ctx2D;
	
	public function new(id:String,w:Float=100,h:Float=100)
	{
		super(id);
		screen = Screen.me;
		root = this;
		_pos.set(0,0); 
		width = w;
		height = h;
		wdg = new Map();
	}// new()

	override function draw(obj:Component)
	{
		if(root.screen == null)trace("No Screen?");  
		else screen.render(obj);
	}// draw()

	public function refresh(w:Float,h:Float)
	{
		_pos.set(0,0);
		width = w; height = h; 
		for(o in children)placeChild(o); // con???
//		trace(this.childSizes);
//		trace(this);
		resize();
	}// refresh()

}// abv.lib.Root

