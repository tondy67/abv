package abv.factory;
/**
 * 
 **/
import abv.factory.Component;

interface IDraw extends IAnim extends IStyle{

	public var text(get,set):String;

	public function draw():Void;

}// abv.factory.IDraw

