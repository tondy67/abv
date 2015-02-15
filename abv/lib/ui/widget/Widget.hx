package abv.lib.ui.widget;

import abv.lib.comp.Object;
import abv.lib.comp.Component;
import abv.bus.*;
import abv.lib.style.*;
import abv.lib.style.Style;
/**
 * 
 **/
@:dce
class Widget extends Component implements IStyle {

	public var style(get, never):Map<StyleState,Style>;
	var _style:Map<StyleState,Style>;
	public function get_style() { return _style; }

	public function new(id:String)
	{
		super(id);
		color = 0x999999;
		_style = [Normal => new Style()];
	}// new()

	public override function resize()
	{
//		trace(id+" - resize");
	}// resize()
	public override function free() 
	{
		super.free();
    }// free() 

	public override function toString() 
	{
		var s = Object.traceInherited?super.toString() + "\n  └>":"";
		return '$s Widget<IStyle>(id: $id, color: 0x${StringTools.hex(Std.int(color))})';
    }// toString() 

}// abv.lib.ui.widget.Widget

