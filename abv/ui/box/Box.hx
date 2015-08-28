package abv.ui.box;

import abv.lib.math.Point;
import abv.lib.box.Container;
import abv.bus.MD;
import abv.interfaces.IStyle;
import abv.lib.style.Style;
import abv.lib.comp.Object;
import abv.lib.comp.Component;


using abv.lib.math.MT;
using abv.lib.CC;

//
@:dce
class Box extends Container {

	public inline function new(id:String,x=.0,y=.0,width=200.,height=200.)
	{
		super(id);
		_pos.set(x,y);
		_width = width; _height = height;
//
		msg.accept = MD.MSG ;
	}// new()

	override function dispatch(md:MD)
	{ 
		super.dispatch(md);
		
		switch(md.msg){
			case MD.STATE: 
				visible = !visible; 
				draw(this);
		}
	}// dispatch

	
	public override function toString() 
	{
		var s = Object.traceInherited?super.toString() + "\n    └>":""; 
		return '$s Box<IStyle>(id: $id)';
    }// toString() 

}// abv.ui.box.Box

