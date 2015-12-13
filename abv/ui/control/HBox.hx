package abv.ui.control;

import abv.lib.math.Point;
import abv.lib.comp.Object;
/**
 * 
 **/
@:dce
class HBox extends Box{

	public var maxColumns = 10;
	
	public function new(id:String,x=.0,y=.0,width=150.,height=200.)
	{
		super(id,x,y,width,height); 
		_kind = HBOX;
		placement.set(1,0);
	}// new()

	public override function toString() 
	{
		var s = Object.traceInherited?super.toString() + "\n     └>":""; // ─
		return '$s HBox(id: $id)';
    }// toString() 

}// abv.ui.control.HBox
