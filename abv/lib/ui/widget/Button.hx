package abv.lib.ui.widget;

import abv.lib.math.Point;
import abv.bus.*;
import abv.lib.comp.Object;

typedef StateData = {text:String,?icon:String}
/**
 * 
 **/
@:dce
class Button extends Text {
	
	public static inline var Normal 	= "normal";
	public static inline var PRESSED 	= "pressed";
	public static inline var Disabled 	= "disabled";
	public static inline var Hover 		= "hover";
	public static inline var Focus 		= "focus";
	public static inline var CLICK 		= "click";

	public var states:Array<StateData>;

	var lastState:Int;
	
	public function new(id:String,label="Button",x=.0,y=.0,width=120.,height=40.)
	{
		super(id);
		_pos.set(x,y);
		_width = width; _height = height;

		msg.accept = MD.MOUSE_ENABLED | MD.KEY_ENABLED;
		state = 1;
		lastState = state;
		states = [{text:Normal},{text:label}];//new Map();
		text = label; 
		
//
	}// new()
	
	override function processExec(mdt:MD)
	{ //trace(mdt);
		switch(mdt.msg){
			case MD.MOUSE_OVER: 
				if(states[0].text != Disabled){
					states[0].text = Hover;
					draw(this);
				}
			case MD.MOUSE_OUT: 
				if(states[0].text != Disabled){
					states[0].text = states[lastState].text;
					draw(this);
				}
			case MD.CLICK: 
				state++;
				if(state > states.length-1)state = 1;
				text = states[state].text; 
				draw(this);
				//onState(cur);
				if(msg.action.exists(MD.STATE)&&(msg.action[MD.STATE] != null)){
					var m = msg.action[MD.STATE].clone();
					m.f[1] = state;
					MS.exec(m);
				}

		}
//trace(MD.msgMap[msg]);		
	}

	public override function free() 
	{
//		delChildren(); tF = null;
//		removeEventListener(MouseEvent.CLICK, onMouseClick);
//		if(parent != null)parent.delChild(this);
		super.free();
    }// free() 

	public override function toString() 
	{
		var s = Object.traceInherited?super.toString() + "\n    └>":"";
        return '$s Button(id: $id, state: $state)';
    }// toString() 

}// abv.lib.ui.widget.Button

