package abv.io;

import abv.lib.comp.*;
import abv.ui.box.*;
import abv.ui.box.*;
import abv.ui.widget.*;
import abv.bus.*;
import abv.*;
import abv.lib.style.*;
import abv.lib.style.Style;
import abv.io.Screen;
import abv.lib.math.Point;

using abv.lib.CR;

@:dce
@:allow(abv.io.Screen)
class Terminal extends Object{

	public var width(default, null):Int;
	public var height(default, null):Int;
	var ro:DoData = null;
	var queue:Array<String> = [];
	var forms = new Map<String,DoData>();
	var context = Ctx2D;
	
	public function new(id:String)
	{
		super(id);
		msg = {accept:MD.ALL,action:new Map()}
//		context = Ctx2D;
	}// new()
	
	function getObjectsUnderPoint(x:Float,y:Float)
	{
		var r = new List<String>();
		var ro:DoData;
		for(el in queue){
			ro = forms[el];
			if(ro.o.visible && (x > ro.x)&&(x < ro.x+ro.o.width)&&
			(y > ro.y)&&(y < ro.y+ro.o.height)){ 
				r.push(ro.o.id); //trace(ro.o.id);
			}
		} 
		return r;
	}// getObjectsUnderPoint()
	
//	@:overload( function(li:List<Float> ) :Void {} )
	public function render(list:List<DoData>)
	{ 
		var ix = -1, oid = "", i = 0;
		var fill = queue.length == 0 ? true:false;
		for(el in list){
			oid = el.o.id;
			if(fill){
				queue.push(oid);
			}else if(i == 0){
				ix = queue.indexOf(oid);
				if(ix == -1){
					queue.push(oid);
					ix = queue.indexOf(oid);
				}
			}else{
				queue.remove(oid);
				queue.insert(ix+i,oid);	
			}
			forms.set(oid,el);
			i++;
		}

		var x:Float, y:Float;
		var o:Component, ctx:GraphicsContext;
		var style:StyleProps, sel = NORMAL;
		
		drawClear(); 
		
		for(el in queue){
			ro = forms[el];
			x = ro.x; y = ro.y;
			o = ro.o; ctx = ro.ctx;
			style = null; sel = NORMAL;

			if(Std.is(o,Button)){
				switch(cast(o, Button).states[0].text) {
					case Button.Hover:	sel = HOVER; 
				}
			}	

				o.style.state = sel;
			
			drawStart(); 
			
			if(ro.o.visible){
				if(style == null)drawShape();
				else if(style.background != null)drawShape();
				if(o.text.good())drawText();
			}
			
			drawEnd(); 
		}
		
		renderScreen(); 
		update();
	}// render()
	
	public function drawClear(){}

	public function drawStart(){}

	public function drawShape(){}

	public function drawText(){}

	public function drawEnd(){}

	public function renderScreen(){}

	public function resize(w:Float,h:Float)
	{
//		width = w; height = h;
	}// resize()

	public override function toString() 
	{
        return "Terminal";//("+"x: "+x+", y:"+y+", width:"+width+", height:"+height+")";
    }// toString()

}// abv.io.Terminal

