package abv.ui.control;
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
		_kind = IMAGE;
	}// new()

}// abv.ui.control.Image

