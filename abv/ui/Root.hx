package abv.ui;
/**
 * Root
 **/
import abv.lib.comp.Component;
import abv.lib.comp.Container;
import abv.lib.math.Point;
import abv.bus.*;
import abv.io.Screen;
import abv.ds.AMap;
import abv.ui.control.Box;
import abv.lib.Enums;


@:dce
@:allow(abv.io.Screen)
class Root extends Box{

	var hasRender = false;
	public var context = CTX_2D;
	
	public inline function new(id:String,width=100.,height=100.)
	{
		super(id);
		
		root = this;
		_pos.reset();
		this.width = width;
		this.height = height;
	}// new()

	override function draw(obj:Component)
	{
//		if(!hasRender)
		Screen.render(obj);
	}// draw()

	public override function delChild(obj:Component)
	{
		if (obj != null){
			Screen.clear(obj); 
			super.delChild(obj);
		}
	}// delChild()
	
	public override function resize()
	{
		if(!visible) return;
		_pos.reset();
		width = AM.WIDTH; 
		height = AM.HEIGHT; 
		super.resize(); 
	}// resize()

	public function build(path:String)
	{
		BU.build(this,path);
	}// build()


}// abv.ui.Root

