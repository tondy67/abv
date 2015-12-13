package abv.ui.control;
/**
 * InputText
 **/
@:dce
class InputText {


	public function new(id:String,label="Text",pos:Point=null,width=300.,height=150.)
	{
		super(id,label,pos,width,height);
		_kind = "InputText";
	}// new()

	public function toString()
	{
		var s = Object.traceInherited?super.toString() + "\n    └>":"";
 		return '$s InputText(id: $id,text: $text)';
	}// toString()

}// abv.ui.control.InputText

