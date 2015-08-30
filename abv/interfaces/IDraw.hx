package abv.interfaces;
/**
 * 
 **/
import abv.lib.comp.Component;

interface IDraw extends IAnim extends IStyle{

	public var text(get,set):String;

	public function draw(obj:Component):Void;

}// abv.interfaces.IDraw

