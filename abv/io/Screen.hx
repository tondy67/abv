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


typedef DoData = {o:Component,x:Float,y:Float,ctx:GraphicsContext}

enum GraphicsContext{
	Ctx3D;
	Ctx2D;
	Ctx1D;
}
 
@:dce
class Screen {


	static var terminals:Array<Terminal> = [];
	static var roots:Array<Root> = [];
//	var console:Box;
//	var conRoot:Root;
	static var ro = new List<DoData>();

	inline function new(){ };
	
	public static inline function render(obj:Component=null)
	{ 
		if(obj == null){
			for(r in roots){ 
				ro.clear();
				getDisplayList(r); 
				draw(r.context);
			}
		}else{  
			ro.clear();
			if(obj.parent != null)getDisplayList(obj.parent);
			else if(Std.is(obj,Container))getDisplayList(cast(obj,Container));
			draw(obj.root.context);
		}
	}// render()

	static inline function getDisplayList(o:Container)
	{  
		var child:Component;
		for (i in 0...o.numChildren){ 
			child = o.getChildAt(i); 
			ro.add({o:child,x:0,y:0,ctx:o.root.context});  
			if (Std.is(child,Container)){  
				getDisplayList(cast(child,Container)); 
			}
		} 
	}
	
	static function draw(ctx:GraphicsContext) 
	{ 
		var x:Float; var y:Float; var p:Container;
		var w:Float; var h:Float;
		var o:Component;
		
		for(dd in ro){
			o = dd.o; 
			dd.x = o.pos.x; dd.y = o.pos.y; p = o.parent;
 			w = o.width; h = o.height;
			while (p != null) { 
				dd.x += p.pos.x; 
				dd.y += p.pos.y; 
				p = p.parent; 
			};
		}
 
		for(to in terminals){
			to.context = ctx;
			to.render(ro); 
		}
	}// draw()

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

