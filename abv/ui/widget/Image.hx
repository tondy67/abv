package abv.ui.widget;
/**
 * 
 **/
import abv.lib.comp.Component;

@:dce
class Image extends Component{
	var x:Int;
	
	public function new(id:String)
	{
		super(id);
		_kind = "Image";
	}// new()

}// abv.ui.widget.Image

