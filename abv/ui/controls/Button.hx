package abv.ui.controls;
/**
 * Button
 **/
import abv.factory.*;
import abv.math.Point;
import abv.bus.*;
import abv.factory.Object;

using abv.sys.ST;

typedef StateData = {text:String,?icon:String}

@:dce
class Button extends Label implements IStates{
	
	public var states:Array<StateData>;

	public function new(id:String,label="Button",x=.0,y=.0,width=120.,height=40.)
	{
		super(id);
		_kind = BUTTON;
		_x = x;
		_y = y;
		_width = width; 
		_height = height;

		msg.accept = MD.MOUSE_ENABLED | MD.KEY_ENABLED;
		states = [{text:label}];//new Map();
		text = label; 
		
//
	}// new()
	
	override function dispatch(md:MD)
	{ 
		switch(md.msg){
			case MD.MOUSE_OVER: 
				if(style.state != DISABLED){
					style.state = HOVER;
					draw();
				}
			case MD.MOUSE_OUT: 
				if(style.state != DISABLED){
					style.state = NORMAL;
					draw();
				}
			case MD.CLOSE: 
				visible = false;
				draw();
			case MD.OPEN: 
				visible = true;
				draw();
			case MD.CLICK: 
				state++;

				if(state > states.length-1)state = 0;
				text = states[state].text; 
				draw();
 
				var m:MD;
				for(k in msg.action.keys()){
					m = msg.action[k].clone(); 
					if(k == MD.STATE) m.f[1] = state; 
					MS.call(m); 
				}

		}
	}

	public override function toString() 
	{
		var s = Object.showInherited?super.toString() + "\n    └>":"";
        return '$s Button(id: $id, state: $state)';
    }// toString() 

}// abv.ui.controls.Button

