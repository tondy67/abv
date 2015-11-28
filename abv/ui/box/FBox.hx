package abv.ui.box;
/**
 * FloatBox
 **/
import abv.lib.math.Point;
import abv.lib.comp.Object;

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
		if(AM.ORIENTATION)placement.set(1,0);else placement.set(0,1);
	}// setPlacement()
	
	public override function toString() 
	{
		var s = Object.traceInherited?super.toString() + "\n     └>":"";  
		return '$s FBox(id: $id)';
    }// toString() 

}// abv.ui.box.FBox

