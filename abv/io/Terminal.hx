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
import abv.lib.math.Rectangle;
import abv.ds.AMap;
import abv.ui.Shape;

using abv.lib.CC;
using abv.ds.DT;
using abv.lib.style.Color;

@:dce
@:allow(abv.io.Screen)
class Terminal extends Object{

	public var width(default, null):Int;
	public var height(default, null):Int;
	var roots = new AMap<String,List<Component>>();
	
	public inline function new(id:String)
	{
		super(id);
		msg = {accept:MD.ALL,action:new AMap()}
	}// new()
	
	function getObjectsUnderPoint(x:Float,y:Float)
	{
		var r = new List<String>();
		for(list in roots){
			for(el in list){
				if(el.visible && (x > el.gX)&&(x < el.gX+el.width)&&
					(y > el.gY)&&(y < el.gY+el.height)){ 
						r.push(el.id); //trace(ro.o.id);
				}
			}  
		}
		return r;
	}// getObjectsUnderPoint()
	
//?? @:overload( function(li:List<Float> ) :Void {} )
	public function render(list:List<Component>)
	{ 
		if(list.empty())return;

		var ix = CC.ERR, oid = "", i = 0;
		var root = list.first().root.id; 
		if(!root.good()){
			trace(FATAL + "no root: " + list.first().id);
			return;
		}
	
		if(!roots.exists(root)){
			roots.set(root,list);
		}

		clearScreen(root); 
		
		renderList(list);

		renderScreen(); 
		update();
	}// render()

	public function renderList(list:List<Component>)
	{
		for(ro in list)drawObject(ro);
	}// renderList

	public function drawObject(o:Component)
	{
		var shape = new Shape(o);

		drawStart(shape); 
			
		if(shape.visible){
			if((shape.color > 0)||(shape.border.width > 0))drawShape(shape);
			if(shape.image.src.good())drawImage(shape);
			if(shape.text.src.good())drawText(shape);
		}
			
		drawEnd(); 
	}// drawObject()

	public function clearScreen(root:String){}

	public function drawStart(shape:Shape){}

	public function drawShape(shape:Shape){}

	public function drawImage(shape:Shape){}

	public function drawText(shape:Shape){}

	public function drawEnd(){}

	public function renderScreen(){}

	public function clear(list:List<Component>)
	{ 
		if(list.empty())return;
		var root = list.first().root.id;
		var rl = roots[root];
		for(el in list){ 
			rl.remove(el);
		}
	}// clear()
	
	public function resize(w:Float,h:Float)
	{
//		width = w; height = h;
	}// resize()

	public override function toString() 
	{
        return "Terminal";//("+"x: "+x+", y:"+y+", width:"+width+", height:"+height+")";
    }// toString()

}// abv.io.Terminal

