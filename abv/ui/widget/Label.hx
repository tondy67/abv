package abv.ui.widget;
/**
 * Label
 **/
import abv.lib.comp.Object;
import abv.lib.math.Point;
import abv.lib.comp.Component;
import abv.lib.Enums;

@:dce
class Label extends Component{
	
	public function new(id:String,label="Label",pos:Point=null,width=300.,height=150.)
	{
		super(id);
		_kind = LABEL;
		if (pos != null) _pos.copy(pos);
		_width = width; _height = height;
		text = label;
	}// new()

	public override function toString() 
	{
		var s = Object.traceInherited?super.toString() + "\n   └>":"";
 		return '$s Label(id: $id,text: $text)';
    }// toString() 
    
}// abv.ui.widget.Label

