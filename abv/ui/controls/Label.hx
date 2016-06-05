package abv.ui.controls;
/**
 * Label
 **/
import abv.factory.Object;
import abv.math.Point;
import abv.factory.Component;
import abv.Enums;

@:dce
class Label extends Component{
	
	public function new(id:String,label="Label",pos:Point=null,width=300.,height=150.)
	{
		super(id);
		_kind = LABEL;
		if (pos != null){
			x = pos.x;
			y = pos.y;
		}
		_width = width; _height = height;
		text = label;
	}// new()

	public override function toString() 
	{
		var s = Object.showInherited?super.toString() + "\n   └>":"";
 		return '$s Label(id: $id)';
    }// toString() 
    
}// abv.ui.controls.Label

