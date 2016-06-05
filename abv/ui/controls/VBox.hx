package abv.ui.controls;
/**
 * VBox
 **/
import abv.math.Point;
import abv.factory.Object;

@:dce
class VBox extends Box{

	public var maxRows = 10;

	public function new(id:String,x=.0,y=.0,width=150.,height=200.)
	{
		super(id,x,y,width,height);
		_kind = VBOX;
		placement = new Point(0,1);
	}// new()

	public override function toString() 
	{
		var s = Object.showInherited?super.toString() + "\n     └>":"";  
		return '$s VBox(id: $id)';
    }// toString() 

}// abv.ui.controls.VBox

