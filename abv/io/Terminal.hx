package abv.io;

import abv.lib.comp.*;
import abv.ui.box.*;
import abv.ui.widget.*;
import abv.bus.*;
import abv.*;
import abv.lib.style.*;
import abv.lib.style.Style;
import abv.io.Screen;
import abv.lib.math.Point;
import abv.lib.math.Rect;
import abv.ds.AMap;
import abv.ui.Shape;


using abv.lib.CC;
using abv.lib.style.Color;

@:dce
@:allow(abv.io.Screen)
class Terminal extends Object{

	public var ui = new Input(); 
	public var width(default, null):Int;
	public var height(default, null):Int;
	var roots = new AMap<Int,List<Component>>();
	var context = CC.CONTEXT;
	var shape = new Shape();
	var hovered = "";
	
	public inline function new(id:String)
	{
		super(id);
		msg = {accept:MD.ALL,action:new AMap()}
	}// new()
	
	public function init() { }
	
	function getObjectsUnderPoint(x:Float,y:Float)
	{
		var r = new List<Int>();
		for(list in roots.vals()){
			for(it in list){
				if(it.visible && (x > it.gX)&&(x < it.gX+it.width)&&
					(y > it.gY)&&(y < it.gY+it.height)){ 
						r.push(it.id); //trace(ro.o.id);
				}
			}  
		}
		return r;
	}// getObjectsUnderPoint()
	
	public dynamic function onFallback2D(){ trace("fallback to 2D");}

	inline function onMsg(to:Int,cmd:Int)
	{ 
		if(to > 0)MS.exec(new MD(id,MS.getName(to),cmd,[],"",[ui.delta]));
	}// onMsg()	

	public dynamic function onMouseMove(x:Int,y:Int){ mouseMove(x,y);}
	inline function mouseMove(x:Int,y:Int)
	{ 
		var l = getObjectsUnderPoint(x,y);
		if(l.length > 0){ 
			var t = l.first(); 
			if(ui.click){
				onMsg(t,MD.MOUSE_MOVE);
			}else if(MS.accept(t,MD.MOUSE_OVER)){
//				if(hovered != t)onMsg(hovered,MD.MOUSE_OUT);
//				hovered = t;
//				onMsg(hovered,MD.MOUSE_OVER); 
			}else if(hovered.good()){
//				onMsg(hovered,MD.MOUSE_OUT); 
//				hovered = "";
			}
		}
	}// mouseMove()
	
	public dynamic function onMouseWheel(delta = 0){ mouseWheel(delta);}
	inline function mouseWheel(delta = 0)ui.wheel = delta;

	public dynamic function onMouseUp(x:Int,y:Int){ mouseUp(x,y);}
	inline function mouseUp(x = 0,y = 0)ui.click = false;

	public dynamic function onMouseDown(x:Int,y:Int){ mouseDown(x,y);}
	inline function mouseDown(x = 0,y = 0)
	{ 
		var to = -1;
		var a = getObjectsUnderPoint(x,y);

		for(it in a){  
			if(MS.accept(it,MD.MOUSE_DOWN)){ 
				to = it;  
				break;
			}
		}
//
		ui.click = true; 
//		ui.start.set(e.clientX,e.clientY);  
		ui.move.copy(ui.start);
//
		if(to > 0) onMsg(to,MD.CLICK); 
	}// mouseDown
	
	public dynamic function onClick(x:Int,y:Int){ mouseClick(x,y);}
	inline function mouseClick(x:Int,y:Int)
	{ 
		var to = -1; 
		if(to != -1)onMsg(to,MD.CLICK); 
	}// mouseClick
	
	public dynamic function onKeyDown(key:Int){ keyDown(key);}
	inline function keyDown(key:Int)
	{ 
		ui.keys[key] = true; 
		MS.exec(new MD(id,"",MD.KEY_DOWN,[key]));  
	}// onKeyDown_()
	
	public dynamic function onKeyUp(key:Int){ keyUp(key);}
	inline function keyUp(key:Int)
	{
		ui.keys[key] = false;
		MS.exec(new MD(id,"",MD.KEY_UP,[key]));
	}// onKeyUp_()

	public function render(list:List<Component>)
	{ 
		if(list.isEmpty())return;

		var ix = CC.ERR, oid = "", i = 0;
		var root:Int;
		
try{
		root = list.first().root.id; //trace(root);
//		if(!root.good(FATAL + "no root: " + list.first().id))return;
	
		if(!roots.exists(root)) roots[root] = list;

		clearScreen(root); 
		renderList(list);
		renderScreen(); 

		update();
}catch(d:Dynamic){trace(d);};
	}// render()

	public function renderList(list:List<Component>)
	{ 
		for(ro in list)drawObject(ro);
	}// renderList

	public function drawObject(o:Component)
	{
		shape.copy(o);

		drawStart(); 
			
		if(shape.visible){
			if((shape.color.alpha > 0)||(shape.border.width > 0)){
				switch(shape.kind){
					case POINT: 	drawPoint();
					case LINE:		drawLine();
					case TRIANGLE:	drawTriangle();
					case CIRCLE:	drawCircle();
					case ELLIPSE:	drawEllipse();
					case SHAPE:		drawShape();
					default: 		drawRect();
				}
			}
			if(shape.image.src.good())drawImage();
			if(shape.text.src.good())drawText();
		}

		drawEnd(); 
	}// drawObject()

	public function clearScreen(root:Int){}

	public function drawStart(){}

	public function drawPoint(){}
	public function drawLine(){}
	public function drawTriangle(){}
	public function drawCircle(){}
	public function drawEllipse(){}
	public function drawShape(){}
	public function drawRect(){}

	public function drawImage(){}

	public function drawText(){}

	public function drawEnd(){}

	public function renderScreen(){}

	public function clearList(list:List<Component>)
	{ 
		if(list.isEmpty())return;
		var root = list.first().root.id;
		var rl = roots[root];
		for(el in list){ 
			rl.remove(el);
		}
	}// clearList()
	
	public function resize(w:Float,h:Float)
	{
//		width = w; height = h;
	}// resize()

	public override function toString() 
	{
        return "Terminal";//("+"x: "+x+", y:"+y+", width:"+width+", height:"+height+")";
    }// toString()

}// abv.io.Terminal

