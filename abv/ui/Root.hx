package abv.ui;
/**
 * Root
 **/
import abv.factory.Component;
import abv.math.Point;
import abv.bus.*;
import abv.io.AD;
import abv.ui.controls.Box;
import abv.Enums;


@:dce
class Root extends Box{

	public var context = 2;
@:allow(abv.io.AD)
	public var layer(default,null) = 0;
	
	public inline function new(id:String,width=100.,height=100.)
	{
		super(id);
		
		root = this;
		x = y = 0;
		this.width = width;
		this.height = height;
	}// new()

	public override function resize()
	{
		if(!visible) return;
		x = y = 0;
		width = AM.WIDTH; 
		height = AM.HEIGHT; 
		super.resize(); 
	}// resize()

	public function build(path:String)
	{
		UI.build(this,path);
	}// build()

	public override function toString()
	{
		return 'Root($name,id: $id)';
	}// toString()


}// abv.ui.Root

