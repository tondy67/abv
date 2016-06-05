package abv.sys.java.ui;

import abv.AM;
import abv.math.*;
import abv.factory.Component;
import abv.style.*;
import abv.factory.IView;
import abv.ui.CView;

@:dce
class ViewGL extends CView implements IView{

	public function new(id:String)
	{
		super(id); 
		ready = false;
	}// new()

/*	
	override function onMouseOver_(){};
	override function onMouseOut_(){};
	override function onMouseMove_(){};
	override function onMouseWheel_(){};
	override function onMouseUp_(){};
	override function onMouseDown_(){};
	override function onClick_(){};
	
	override function onKeyUp_()
	{
//		MS.exec(new MD(sign,"",MD.KEY_UP,[e.keyCode]));
	}// onKeyUp_()

	override function onKeyDown_()
	{ 
//		MS.exec(new MD(sign,"",MD.KEY_DOWN,[e.keyCode]));
	}// onKeyDown_()
*/	
	public override function setLayer(root:Int)
	{
	}// setLayer()

	public override function setShape(id:Int)
	{ 
	}// setShape()

	public override function drawPolygon(path:Array<Point>)
	{
	}// drawPolygon()

	public override function drawRect()
	{ 
	}// drawRect()

	public override function drawImage()
	{
	}// drawImage()

	public override function drawText(s:String,font:Font)
	{ 
	}// drawText()

	public override function toString() 
	{
        return "View"+super.toString();
    }// toString()

}// abv.sys.java.ui.ViewGL

