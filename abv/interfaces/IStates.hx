package abv.interfaces;
/**
 * 
 **/
import abv.ui.widget.Button.StateData;

interface IStates {

	public var state(get,set):Int;

	public var text(get,set):String;

	public var states:Array<StateData>;

}// abv.interfaces.IStates

