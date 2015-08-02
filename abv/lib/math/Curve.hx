package abv.lib.math;
/**
 * 
 **/
import abv.lib.math.Point;
import abv.lib.anim.*;

@:dce
class Curve{
	
	inline function new(){}
	
	public static function quad(x:Float,y:Float,width:Float,height:Float,trans=Transitions.LINEAR,reverse=false,step=100)
	{
		var path:Array<Point> = [];
		var corner:Array<Point> = [new Point(x,y)];
		var cur:Float;
		var dir = reverse ? -1: 1;
		width = Math.abs(width); height = Math.abs(height);
		var length = 2*(width + height); 
		
		for(i in 0...step){
			cur = Transitions.get(trans)(i/step) * length;
			if(cur < width){
				corner[1] = new Point(x+ dir*cur,y);
				path.push(corner[1]);
			}else if(cur < (width+height)){
				corner[2] = new Point(corner[1].x,y+(cur-width));
				path.push(corner[2]);
			}else if(cur < (2*width+height)){
				corner[3] = new Point(corner[2].x-dir*(cur-width-height),corner[2].y);
				path.push(corner[3]);
			}else {
				path.push(new Point(corner[3].x,corner[3].y-(cur-2*width-height)));
			}
		}
		path.push(corner[0]);
		
		return path;
	}// quad()
	
	public static function circle(cp:Point,radius:Float,trans=Transitions.LINEAR,step=1000,reverse=false)
	{
		var q = 2*Math.PI/step;
		var path:Array<Point> = [];
		var ratio:Float;
		
		for(i in 0...step){
			ratio = reverse?1-i/step:i/step;
			path[i] = Point.polar(radius,Transitions.get(trans)(ratio)*2*Math.PI);
			path[i].offset(cp.x,cp.y);
		}
		
		return path;
	}
	
}// abv.lib.math.Curve

