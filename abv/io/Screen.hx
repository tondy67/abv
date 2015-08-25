package abv.io;
/**
 * Screen
 **/
import abv.bus.*;
import abv.*;
import abv.ui.*;
import abv.lib.style.*;
import abv.lib.style.Style;
import abv.lib.comp.Component;
import abv.lib.box.Container;
import abv.ui.box.Box;
import abv.ui.widget.Button;
import abv.io.Terminal;


typedef DoData = {o:Component,x:Float,y:Float,ctx:Int}

@:dce
class Screen {


	static var terminals:Array<Terminal> = [];
	static var roots:Array<Root> = [];
//	var console:Box;
//	var conRoot:Root;

	inline function new(){ };
	
	public static inline function render(obj:Component=null)
	{ 
		var r = new List<Component>();
		if(obj == null){
			for(root in roots){ 
				r = root.getChildren(); 
				draw(r,root.context);
			}
		}else{  
			if(obj.parent != null)r = obj.parent.getChildren();
			else if(Std.is(obj,Container))r = cast(obj,Container).getChildren();
			draw(r, obj.root.context);
		}
	}// render()

	static function draw(rl:List<Component>,ctx:Int) 
	{ 
		if(rl.length == 0)return;

		var ro = new List<DoData>();
		var x:Float, y:Float; 
		var p:Container;

		for(el in rl){
			x = el.pos.x; y = el.pos.y; 
			p = el.parent; 

			while (p != null) { 
				x += p.pos.x; 
				y += p.pos.y; 
				p = p.parent; 
			};
			ro.add({o:el,x:x,y:y,ctx:ctx});  
		}

		for(to in terminals){
			to.render(ro); 
		}
	}// draw()

	public static inline function clear(obj:Component=null)
	{
		var r = new List<Component>();
		if(obj == null){
			for(root in roots)r = root.getChildren(); 
		}else if(Std.is(obj,Container)){
			r = cast(obj,Container).getChildren();
		}else{
			r.add(obj);  
		}
		
		for(to in terminals) to.clear(r); 

	}// clear()
	
	public static inline function addRoot(r:Root)
	{
		var l:Root = roots.pop();
		roots.push(r);
		if(l != null)roots.push(l);
	}// addRoot()
	
	public static inline function delRoot(r:Root)
	{
		roots.remove(r);
	}// delRoot()
	
	public static inline function addTerminal(t:Terminal)
	{
		terminals.push(t);
	}// addTerminal()
	
	public static inline function delTerminal(t:Terminal)
	{
		terminals.remove(t);
	}// delTerminal()

	public static function resize(w:Float,h:Float)
	{ 				
		for(r in roots)r.refresh(w,h);
//		console.width = 400; console.height = 200;
		for(t in terminals)t.resize(w,h);
		render();
	}// resize()

}// abv.io.Screen

