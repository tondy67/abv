package abv.lib.style;

import abv.lib.comp.IObject;
import abv.lib.style.Style;

using abv.lib.CR;
/**
 * IStyle
 **/
@:dce
interface IStyle extends IObject{

	public var style(get, never):Style;

}// abv.lib.style.IStyle

