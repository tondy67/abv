package abv.ui.box;

import abv.lib.math.Point;
import abv.lib.comp.Object;
/**
 * VBox
 **/
@:dce
class VBox extends Box{

	public function new(id:String,x=.0,y=.0,width=150.,height=200.)
	{
		super(id,x,y,width,height);
		placement.set(0,1);
	}// new()

	public override function toString() 
	{
		var s = Object.traceInherited?super.toString() + "\n     └>":"";  
		return '$s VBox(id: $id)';
    }// toString() 

}// abv.ui.box.VBox

