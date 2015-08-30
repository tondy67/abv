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

using abv.lib.CC;

@:dce
@:allow(abv.io.Screen)
class Terminal extends Object{

	public var width(default, null):Int;
	public var height(default, null):Int;
	var ro:DoData = null;
	var queue:Array<String> = [];
	var forms = new Map<String,DoData>();
	
	public inline function new(id:String)
	{
		super(id);
		msg = {accept:MD.ALL,action:new Map()}
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
		var ix = CC.ERR, oid = "", i = 0;

		for(el in list){
			oid = el.o.id; 

			if(queue.length == 0){
				queue.push(oid);
			}else if(i == 0){
				ix = queue.indexOf(oid);
				if(ix == CC.ERR){
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

		drawClear(); 
		
		for(el in queue){
			ro = forms[el];
			
			drawStart(); 
			
			if(ro.o.visible){
				drawShape();
				if(ro.o.text.good())drawText();
			}
			
			drawEnd(); 
		}
		
		renderScreen(); 
		update();
	}// render()

	public function clear(l:List<Component>)
	{ 
		for(el in l){ 
			queue.remove(el.id);
			forms.remove(el.id); 
		}
	}// clear()
	
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

