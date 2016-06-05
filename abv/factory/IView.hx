package abv.factory;
/** 
  *  
  **/
import abv.style.*;
import abv.math.*;

interface IView {

	public var ready(default , null):Bool;

	public var monitor(default , null):Int;
	public var layer(default , null):Int;
	public var shape(default , null):Int;
	public var stroke(default , null):Stroke;
	public var fill(default , null):Fill;
	public var cursor(default , null):Rect;

	public function setMonitor(id:Int):Void;

	public function setLayer(id:Int):Void;

	public function clearLayer(id:Int= - 1):Void;

	public function setShape(id:Int):Void;
	
	public function strokeStyle(color:Color = 0 ,  width:Float = 0 ,  radius:Float = 0):Void; 

	public function fillStyle(color:Color = 0 ,  image:String = "" , tile:Rect = null):Void; 

	public function moveTo(x:Float, y:Float, w:Float = 0, h:Float = 0):Void;

// Creates a quadratic Bézier curve
	public function curveTo(x:Float, y:Float):Void;

// Creates a cubic Bézier curve
	public function bezierTo(x:Float, y:Float):Void;

	public function lineTo(x:Float, y:Float):Void;

	public function drawCircle():Void;

	public function drawEllipse():Void;

	public function drawPolygon(path:Array<Point>):Void;

	public function drawRect():Void;

	public function drawImage():Void;

	public function drawText(s:String , font:Font):Void;
	
	public function render():Void;

	public function dispose():Void;

}// abv.factory.IView

