package abv.ui.widget;
/**
 * Button
 **/
import abv.interfaces.*;
import abv.lib.math.Point;
import abv.bus.*;
import abv.lib.comp.Object;

using abv.lib.CC;

typedef StateData = {text:String,?icon:String}

@:dce
class Button extends Text implements IStates{
	
	public var states:Array<StateData>;

	public function new(id:String,label="Button",x=.0,y=.0,width=120.,height=40.)
	{
		super(id);
		_pos.set(x,y);
		_width = width; _height = height;

		msg.accept = MD.MOUSE_ENABLED | MD.KEY_ENABLED;
		states = [{text:label}];//new Map();
		text = label; 
		
//
	}// new()
	
	override function dispatch(md:MD)
	{ //trace(md);
		switch(md.msg){
			case MD.MOUSE_OVER: 
				if(style.state != DISABLED){
					style.state = HOVER;
					draw(this);
				}
			case MD.MOUSE_OUT: 
				if(style.state != DISABLED){
					style.state = NORMAL;
					draw(this);
				}
			case MD.CLICK: 
				state++;
				if(state > states.length-1)state = 0;
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

}// abv.ui.widget.Button

