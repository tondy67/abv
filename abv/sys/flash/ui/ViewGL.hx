package abv.sys.flash.ui;

import abv.AM;
import abv.math.*;
import abv.factory.Component;
import abv.style.*;
import abv.factory.IView;
import abv.ui.CView;
import abv.sys.flash.AGALMiniAssembler;

import flash.display3D.Context3D;
import flash.display3D.Context3DProgramType;
import flash.display3D.Context3DVertexBufferFormat;
import flash.display3D.IndexBuffer3D;
import flash.display3D.Program3D;
import flash.display3D.VertexBuffer3D;
import flash.events.*;
import flash.Vector;
import flash.geom.Matrix3D;
import flash.geom.Vector3D;

using abv.sys.ST;

@:dce
class ViewGL extends View {

	var context3D:Context3D;
	var program:Program3D;
	var vertexbuffer:VertexBuffer3D;
	var indexbuffer:IndexBuffer3D;

	public function new(id:String)
	{
		super(id); 
		
		ready = false;
	}// new()

	override function addListeners()
	{  
		if((ctx == null)||(ctx.stage == null)){
			ST.error(ST.getText(20));
			return;
		}
		ctx.stage.stage3Ds[0].addEventListener( Event.CONTEXT3D_CREATE, initGL );
		ctx.stage.stage3Ds[0].requestContext3D();
//		ctx.stage.stage3Ds[0].addEventListener(MouseEvent.CLICK, onClick_);
		ctx.stage.stage3Ds[0].addEventListener(MouseEvent.MOUSE_UP, onMouseUp_);
		ctx.stage.stage3Ds[0].addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown_);
		ctx.stage.stage3Ds[0].addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove_);
		ctx.stage.stage3Ds[0].addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel_);
		ctx.stage.stage3Ds[0].addEventListener(MouseEvent.MOUSE_OVER, onMouseOver_);
		ctx.stage.stage3Ds[0].addEventListener(MouseEvent.MOUSE_OUT, onMouseOut_);
		ctx.stage.stage3Ds[0].addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown_);   
		ctx.stage.stage3Ds[0].addEventListener(KeyboardEvent.KEY_UP, onKeyUp_); 
	}// addListeners()

	function initGL(e:Event)
	{
			context3D = ctx.stage.stage3Ds[0].context3D;			
			context3D.configureBackBuffer(CC.WIDTH, CC.HEIGHT, 1, true);
			
			var vertices = Vector.ofArray([
				-0.1,-0.1,0, 1, 0, 0, // x, y, z, r, g, b
				-0.1, 0.1, 0, 0, 1, 0,
				0.1, 0.1, 0, 0, 0, 1]);
			
			// Create VertexBuffer3D. 3 vertices, of 6 Numbers each
			vertexbuffer = context3D.createVertexBuffer(3, 6);
			// Upload VertexBuffer3D to GPU. Offset 0, 3 vertices
			vertexbuffer.uploadFromVector(vertices, 0, 3);				
			
			var indices:Vector<UInt> = Vector.convert(Vector.ofArray([0, 1, 2]));
			
			// Create IndexBuffer3D. Total of 3 indices. 1 triangle of 3 vertices
			indexbuffer = context3D.createIndexBuffer(3);			
			// Upload IndexBuffer3D to GPU. Offset 0, count 3
			indexbuffer.uploadFromVector (indices, 0, 3);			
			
			var vertexShaderAssembler : AGALMiniAssembler = new AGALMiniAssembler();
			vertexShaderAssembler.assemble( Context3DProgramType.VERTEX,
				"m44 op, va0, vc0\n" + // pos to clipspace
				"mov v0, va1" // copy color
			);			
			
			var fragmentShaderAssembler : AGALMiniAssembler= new AGALMiniAssembler();
			fragmentShaderAssembler.assemble( Context3DProgramType.FRAGMENT,
				
				"mov oc, v0"
			);
			
			program = context3D.createProgram();
			program.upload( vertexShaderAssembler.agalcode, fragmentShaderAssembler.agalcode);
	}// initGL()
	
	override function delListeners()
	{  
		if((ctx == null)||(ctx.stage.stage3Ds[0] == null)){
			ST.error(ST.getText(20));
			return;
		}
		ctx.stage.stage3Ds[0].removeEventListener(Event.CONTEXT3D_CREATE, initGL );
//		ctx.stage.stage3Ds[0].removeEventListener(MouseEvent.CLICK, onClick_);
		ctx.stage.stage3Ds[0].removeEventListener(MouseEvent.MOUSE_UP, onMouseUp_);
		ctx.stage.stage3Ds[0].removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown_);
		ctx.stage.stage3Ds[0].removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove_);
		ctx.stage.stage3Ds[0].removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel_);
		ctx.stage.stage3Ds[0].removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver_);
		ctx.stage.stage3Ds[0].removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut_);
		ctx.stage.stage3Ds[0].removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown_);   
		ctx.stage.stage3Ds[0].removeEventListener(KeyboardEvent.KEY_UP, onKeyUp_); 
	}// delListeners()
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
			if (context3D == null) 	return;
			
			context3D.clear ( 1, 1, 1, 1 );
			
			// vertex position to attribute register 0
			context3D.setVertexBufferAt (0, vertexbuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			// color to attribute register 1
			context3D.setVertexBufferAt(1, vertexbuffer, 3, Context3DVertexBufferFormat.FLOAT_3);
			// assign shader program
			context3D.setProgram(program);
			
			var m:Matrix3D = new Matrix3D();
			m.appendRotation(abv.cpu.Timer.stamp()/40, Vector3D.Z_AXIS);
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, m, true);
			
			context3D.drawTriangles(indexbuffer);
			
			context3D.present();		
	}// drawRect()

	public override function drawImage()
	{
	}// drawImage()

	public override function drawText(s:String,font:Font)
	{ 
	}// drawText()

}// abv.sys.flash.ui.ViewGL

