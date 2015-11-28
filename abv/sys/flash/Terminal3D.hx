package abv.sys.flash;

import abv.ui.Shape;
import abv.lib.comp.Component;

@:dce
class Terminal3D extends Terminal2D{

	public function new()
	{
		super("Terminal3D");
		init();
	}// new()

	public override function init()
	{ 
		if(context == CTX_3D){
			trace("init 3D");
			if(!has3D()){
				trace("destroy 3D");
				context = CTX_2D;
				onFallback2D();
			}
		}

		if(context != CTX_3D) super.init();
	}// init()
	
	public function has3D()
	{ 
		return false;
	}// has3D()
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
//		MS.exec(new MD(id,"",MD.KEY_UP,[e.keyCode]));
	}// onKeyUp_()

	override function onKeyDown_()
	{ 
//		MS.exec(new MD(id,"",MD.KEY_DOWN,[e.keyCode]));
	}// onKeyDown_()
*/	
	public override function clearScreen(root:Int)
	{
		if(context != CTX_3D){
			super.clearScreen(root);
			return;
		}
		
	}// clearScreen()

	public override function drawStart()
	{ 
		if(context != CTX_3D){
			super.drawStart();
			return;
		}
		
	}// drawStart()

	public override function drawPoint()
	{
		if(context != CTX_3D){
			super.drawPoint();
			return;
		}
		
	}// drawPoint()

	public override function drawLine()
	{
		if(context != CTX_3D){
			super.drawLine();
			return;
		}
	}// drawLine()

	public override function drawTriangle()
	{
		if(context != CTX_3D){
			super.drawTriangle();
			return;
		}
		
	}// drawTriangle()

	public override function drawCircle()
	{
		if(context != CTX_3D){
			super.drawCircle();
			return;
		}
		
	}// drawCircle()

	public override function drawEllipse()
	{
		if(context != CTX_3D){
			super.drawEllipse();
			return;
		}
		
	}// drawEllipse()

	public override function drawShape()
	{
		if(context != CTX_3D){
			super.drawShape();
			return;
		}
	}// drawShape()

	public override function drawRect()
	{ 
		if(context != CTX_3D){
			super.drawRect();
			return;
		}
		
	}// drawRect()

	public override function drawImage()
	{
		if(context != CTX_3D){
			super.drawImage();
			return;
		}
		
	}// drawImage()

	public override function drawText()
	{ 
		if(context != CTX_3D){
			super.drawText();
			return;
		}
		
	}// drawText()

	public override function clearList(list:List<Component>)
	{ 
		if(context != CTX_3D){
			super.clearList(list); 
			return;
		}

	}// clearList()
	

	public override function drawEnd()
	{
		if(context != CTX_3D){
			super.drawEnd();
			return;
		}
		
	}// drawEnd()

	
	public override function toString() 
	{
        return "Terminal3D";
    }// toString()

}// abv.sys.flash.Terminal3D

