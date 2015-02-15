package abv.io;

import abv.lib.comp.*;
import abv.lib.ui.box.*;
import abv.lib.ui.box.*;
import abv.lib.ui.widget.*;
import abv.bus.*;
import abv.*;
import abv.lib.style.Style;
import abv.lib.style.IStyle;
import abv.lib.Color;
import abv.lib.Screen;
import abv.lib.math.Point;

using abv.CR;

@:dce
@:allow(abv.lib.Screen)
class Terminal implements IComm{

// unique id
	public var id(get, never):String;
	var _id:String = "Terminal";
	function get_id() { return _id; };
//
	public var sign(null,null):Int;
	public var msg(default,null):MsgProp;
//
	public var width(default, null):Int;
	public var height(default, null):Int;
	var ro:DoData = null;
	var queue:Array<String> = [];
	var forms = new Map<String,DoData>();
	var context = Ctx2D;
	
	public function new(id:String)
	{
		_id = id;
		msg = {accept:MD.ALL,action:new Map()}
		sign = MS.subscribe(this);
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
		var style:StyleProps, sel = Normal;
		
		drawClear(); 
		
		for(el in queue){
			ro = forms[el];
			x = ro.x; y = ro.y;
			o = ro.o; ctx = ro.ctx;
			style = null; sel = Normal;

			if(Std.is(o,Button)){
				switch(cast(o, Button).states[0].text) {
					case Button.Hover:	sel = Hover; 
				}
			}	

			if(Std.is(o,IStyle))ro.style = cast(o,IStyle).style[sel].export();
			
			drawStart(); 
			
			if(ro.o.visible){
				if(style == null)drawRect();
				else if(style.background != null)drawRect();
				if(o.text.good())drawText();
			}
			
			drawEnd(); 
		}
	}// render()
	
	public function drawClear(){}

	public function drawStart(){}

	public function drawRect(){}

	public function drawText(){}

	public function drawEnd(){}

	public function exec(mdt:MD)
	{ 
		if(!MS.isMsg(mdt,sign))return;
//
//		render(mdt);
	}// exec()

	public function resize(w:Float,h:Float)
	{
//		width = w; height = h;
	}// resize()

	public function toString() 
	{
        return "Terminal";//("+"x: "+x+", y:"+y+", width:"+width+", height:"+height+")";
    }// toString()

}// abv.io.Terminal

