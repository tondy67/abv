package abv.lib;

import abv.bus.*;
import abv.*;
import abv.lib.ui.*;
import abv.lib.style.*;
import abv.lib.style.Style;
import abv.lib.comp.Component;
import abv.lib.box.Container;
import abv.lib.ui.box.Box;
import abv.lib.ui.widget.Button;
import abv.io.Terminal;

typedef DoData = {o:Component,x:Float,y:Float,ctx:GraphicsContext,style:StyleProps}
/**
 * Screen
 **/
enum GraphicsContext{
	Ctx3D;
	Ctx2D;
	Ctx1D;
}
 
@:dce
class Screen extends Component{

// instance
	public static var me(get, null):Screen;
	static var _me:Screen;
	static function get_me():Screen 
	{
		if (_me == null)_me = new Screen();
		return _me;
	}
//
	var terminals:Array<Terminal> = [];
	var roots:Array<Root> = [];
	var console:Box;
	var conRoot:Root;
	var ro = new List<DoData>();
	
	public function new()
	{
		_id = "Screen";
		super(id);
		_me = this;
		initConsole();
	}// new()
	
	inline function initConsole()
	{
		console = new Box("console");
		console.text = "console";
		var st = new Style("console",true);
		st.color = 0x00EE00;
		st.background.color = 0.05; 
		console.style[Normal].apply(st); 
		console.msg.accept = MD.NONE; //trace(console.msg);

		conRoot = new Root("consoleRoot",1024,200);
		conRoot.context = Ctx1D;
		conRoot.addChild(console);
		addRoot(conRoot);
		
	}// initConsole()

	public inline function con(d:Dynamic)
	{
		console.text += "\n" + Std.string(d); 
		render(conRoot);
	}// con()
		
	public inline function render(obj:Component=null)
	{ 
		if(obj == null){
			for(r in roots){ 
				ro.clear();
				getDisplayList(r); 
				redraw(r.context);
			}
		}else{  
			ro.clear();
			if(obj.parent != null)getDisplayList(obj.parent);
			else if(Std.is(obj,Container))getDisplayList(cast(obj,Container));
			redraw(obj.root.context);
		}
	}// render()

	inline function getDisplayList(o:Container)
	{  
		var child:Component;
		for (i in 0...o.numChildren){ 
			child = o.getChildAt(i); 
			ro.add({o:child,x:0,y:0,ctx:o.root.context,style:null});  
			if (Std.is(child,Container)){  
				getDisplayList(cast(child,Container)); 
			}
		} 
	}
	
	function redraw(ctx:GraphicsContext) 
	{ 
		var x:Float; var y:Float; var p:Container;
		var w:Float; var h:Float;
		var obj:Component;
		
		for(dd in ro){
			obj = dd.o;
			dd.x = obj.pos.x; dd.y = obj.pos.y; p = obj.parent;
 			w = obj.width; h = obj.height;
			while (p != null) { 
				dd.x += p.pos.x; 
				dd.y += p.pos.y; 
				p = p.parent; 
			};
		}
 
		for(to in terminals){
			to.context = ctx;
			to.render(ro); // obj,x,y 
		}
	}// redraw()

	public inline function addRoot(r:Root)
	{
		var l:Root = roots.pop();
		roots.push(r);
		if(l != null)roots.push(l);
	}// addRoot()
	
	public inline function delRoot(r:Root)
	{
		roots.remove(r);
	}// delRoot()
	
	public inline function addTerminal(t:Terminal)
	{
		terminals.push(t);
	}// addTerminal()
	
	public inline function delTerminal(t:Terminal)
	{
		terminals.remove(t);
	}// delTerminal()

	public function refresh(w:Float,h:Float)
	{ //		trace(id + " - resize");
		width = w; height = h;
				
		for(r in roots)r.refresh(w,h);
		console.width = 400; console.height = 200;
		for(t in terminals)t.resize(w,h);
		render();
	}// refresh()

}// abv.lib.Screen

