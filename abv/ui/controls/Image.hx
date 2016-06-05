package abv.ui.controls;
/**
 * 
 **/
import abv.factory.Component;

@:dce
class Image extends Component{
	
	public function new(id:String)
	{
		super(id);
		_kind = IMAGE;
	}// new()

}// abv.ui.controls.Image

