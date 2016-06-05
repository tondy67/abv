package abv.sys.engine.ui;

import abv.bus.*;
import abv.*;
import abv.lib.css.*;
import abv.io.View;
import abv.factory.Component;
import abv.lib.math.*;
import abv.io.*;
import abv.ui.Shape;

import abv.lib.Enums;

using abv.sys.ST;
using abv.lib.math.MT;
using abv.lib.css.Color;

@:dce
class View extends CView {

	public var listRender(default,null):Array<Int>;
	public var renderText(default,null):Array<String> = [];

	public function new(id:String)
	{
		super(id);
		listRender = new Array();
	}// new()

	function onMouseMove_(x:Int,y:Int) super.onMouseMove(x,y);
	

	function onMouseUp_(x:Int,y:Int) super.onMouseUp(x,y);


	function onMouseDown_(x:Int,y:Int) super.onMouseDown(x,y);

	function onClick_(x:Int,y:Int) super.onClick(x,y);
	
	function onKeyDown_(key:Int) super.onKeyDown(key);
 	
	function onKeyUp_(key:Int) super.onKeyUp(key);
 
	public override function render(list:List<Component>)
	{
		if(list.isEmpty())return;

		renderPages(list);
	}// render()

	public override function clear(root=-1)
	{ 
		listRender.clear(); 
	}// clearAD()

	public override function drawRect(width:Float, height:Float, topLeft:Point=null)
	{ 
		draw2list(shape);
	}// drawRect()

	public override function drawImage(src:String,topLeft:Point=null, tile:Rect = null)
	{
		draw2list(shape);
	}
	
	public override function drawText()
	{ 
		draw2list(shape);
	}// drawText()

	function draw2list(sp:Shape)
	{
		if(shape.visible)listRender = listRender.concat(export(sp));
	}
	
	function export(shape:Shape)
	{
		var COUNT 	= 0;
		var ID 		= 1;
		var X 		= 2;
		var Y 		= 3;
		var W 		= 4;
		var H 		= 5;
		var SCALE 	= 6;
		var COLOR_R	= 7;
		var COLOR_G	= 8;
		var COLOR_B	= 9;
		var COLOR_A	= 10;
		var ALPHA 	= 11;
		var BORDER	= 12;
		var BORDER_R= 13;
		var BORDER_G= 14;
		var BORDER_B= 15;
		var BORDER_A= 16;
		var BORDER_D= 17;
		var IMG		= 18;
		var TILE_X	= 19;
		var TILE_Y	= 20;
		var TILE_W	= 21;
		var TILE_H	= 22;
		var TEXT	= 23;
		var TEXT_R	= 24;
		var TEXT_G	= 25;
		var TEXT_B	= 26;
		var TEXT_A	= 27;
		var FONT	= 28;
		var SIZE	= 29;
		var VISIBLE	= 30;
		var CONTEXT	= 31;
		var KIND	= 32;
		var ROOT 	= 33;
		var PARENT 	= 34;
		var STYLE	= 35;

		var ix = -1;
		
		var r:Array<Int> = [];
		r[ID] = shape.id;
		r[X] = shape.x.i();
		r[Y] = shape.y.i();
		r[W] = shape.w.i();
		r[H] = shape.h.i();
		r[SCALE] = (shape.scale * 1000).i();
//
		r[COLOR_R] = shape.color.r;
		r[COLOR_G] = shape.color.g;
		r[COLOR_B] = shape.color.b;
		r[COLOR_A] = shape.color.a;
		r[ALPHA] = (shape.alpha * 1000).i();
//
		r[BORDER] = shape.border.width.i();
		r[BORDER_R] = shape.border.color.r;
		r[BORDER_G] = shape.border.color.g;
		r[BORDER_B] = shape.border.color.b;
		r[BORDER_A] = shape.border.color.a;
		r[BORDER_D] = shape.border.radius.i();

		r[IMG] = r[TILE_X] = r[TILE_Y] = r[TILE_W] = r[TILE_H] = -1;
		if(shape.image.src != ""){
			ix = renderText.indexOf(shape.image.src);
			if(ix == -1) ix = renderText.push(shape.image.src) - 1;
			r[IMG] = ix;
			if(shape.image.tile != null){
				r[TILE_X] = shape.image.tile.x.i();
				r[TILE_Y] = shape.image.tile.y.i();
				r[TILE_W] = shape.image.tile.w.i();
				r[TILE_H] = shape.image.tile.h.i();
			}
		}

  		r[TEXT] = -1;
		if(shape.text.src != ""){
			ix = renderText.indexOf(shape.text.src);
			if(ix == -1) ix = renderText.push(shape.text.src) - 1;
			r[TEXT] = ix;
			r[TEXT_R] = shape.text.color.r;
			r[TEXT_G] = shape.text.color.g;
			r[TEXT_B] = shape.text.color.b;
			r[TEXT_A] = shape.text.color.a;
		}
		
		r[VISIBLE] = shape.visible ? 1:0;
// hxcpp 'switch' not working here as static lib (x86)
		r[CONTEXT] = if(shape.context == CTX_1D) 1;
		else if(shape.context == CTX_3D) 3; 
		else 2;
		


		r[KIND] =  if(shape.kind == BOX)	1;
			else if(shape.kind == VBOX) 	2;
			else if(shape.kind == HBOX) 	3;
			else if(shape.kind == FBOX) 	4;
			else if(shape.kind == BUTTON) 	5;
			else if(shape.kind == LABEL) 	6;
			else if(shape.kind == IMAGE) 	7;
			else if(shape.kind == DIALOG) 	8;
			else if(shape.kind == POINT) 	9;
			else if(shape.kind == LINE) 	10;
			else if(shape.kind == TRIANGLE) 11;
			else if(shape.kind == CIRCLE) 	12;
			else if(shape.kind == ELLIPSE) 	13;
			else if(shape.kind == SHAPE) 	14;
			else 0;
		
		r[ROOT] = shape.root;
		r[PARENT] = shape.parent;
		//

		r[COUNT] = r.length;
		return r;
	}// export()
	
}// abv.sys.engine.ui.View

