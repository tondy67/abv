package abv.lib.style;

import abv.lib.comp.IObject;
import abv.lib.style.Style;

/**
 * IStyle
 **/
@:dce
interface IStyle extends IObject{

	public var style(get, never):Map<StyleState,Style>;

}// abv.lib.style.IStyle

