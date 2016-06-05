package abv.factory;
/**
 * 
 **/
import abv.ui.controls.Button.StateData;

interface IStates {

	public var state(get,set):Int;

	public var text(get,set):String;

	public var states:Array<StateData>;

}// abv.factory.IStates

