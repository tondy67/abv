package abv.lib.ui.widget;

import abv.lib.comp.Object;
import abv.lib.math.Point;
/**
 * 
 **/
@:dce
class Text extends Widget{
	
	public function new(id:String,label="Text",pos:Point=null,width=300.,height=150.)
	{
		super(id);
		if (pos != null) _pos.copy(pos);
		_width = width; _height = height;
		text = label;
	}// new()

	public override function toString() 
	{
		var s = Object.traceInherited?super.toString() + "\n   └>":"";
 		return '$s Text(id: $id,text: $text)';
    }// toString() 
    
}// abv.lib.ui.widget.Text

