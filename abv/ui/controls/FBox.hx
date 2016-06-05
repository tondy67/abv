package abv.ui.controls;
/**
 * FloatBox
 **/
import abv.math.Point;
import abv.factory.Object;

@:dce
class FBox extends Box{

	public var maxItems = 10;
	
	public function new(id:String,x=.0,y=.0,width=150.,height=200.)
	{
		super(id,x,y,width,height);
		_kind = FBOX;
		setPlacement();
	}// new()

	public override function resize() 
	{
		setPlacement(); 
		super.resize();
	}// resize()
	
	function setPlacement()
	{
		if(AM.ORIENTATION)placement = new Point(1,0);else placement = new Point(0,1);
	}// setPlacement()
	
	public override function toString() 
	{
		var s = Object.showInherited?super.toString() + "\n     └>":"";  
		return '$s FBox(id: $id)';
    }// toString() 

}// abv.ui.controls.FBox

