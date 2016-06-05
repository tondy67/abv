package abv.ui.controls;
/**
 * Entry
 **/
import abv.factory.Component;

@:dce
class Entry  extends Component{


	public function new(id:String,label="Text",pos:Point=null,width=300.,height=150.)
	{
		super(id,label,pos,width,height);
		_kind = "Entry";
	}// new()

	public function toString()
	{
		var s = Object.traceInherited?super.toString() + "\n    └>":"";
 		return '$s Entry(id: $id,text: $text)';
	}// toString()

}// abv.ui.controls.Entry

