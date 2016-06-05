package abv.math;

import openfl.geom.Matrix3D;
import openfl.geom.Vector3D;
import openfl.Vector;
//
class Matrix extends Matrix3D{

// TODO: rewrite
	public function new(a:Array<Float> = null)
	{
		var v = new Vector<Float>();
		if (a != null && a.length == 16)for (i in 0...16) v[i] = a[i];
		super(v);
	}// new()

	public override function clone()
	{
		var a:Array<Float> = [];
		for(f in this.rawData)a.push(f);
		return new Matrix(a);
	}

	public function load(a:Array<Float>)
	{
#if flash
		var v = new Vector<Float>();
		for (i in 0...a.length) v[i] = a[i];
		this.copyRawDataFrom(v);
#else
		for (i in 0...a.length) this.rawData[i] = a[i];
#end
	}

#if cpp
	static public function getAxisRotation (x:Float, y:Float, z:Float, degrees:Float):Matrix3D {
		
		var m = new Matrix3D ();
		
		var a1 = new Vector3D (x, y, z);
		var rad = -degrees * (Math.PI / 180);
		var c:Float = Math.cos (rad);
		var s:Float = Math.sin (rad);
		var t:Float = 1.0 - c;
		
		m.rawData[0] = c + a1.x * a1.x * t;
		m.rawData[5] = c + a1.y * a1.y * t;
		m.rawData[10] = c + a1.z * a1.z * t;
		
		var tmp1 = a1.x * a1.y * t;
		var tmp2 = a1.z * s;
		m.rawData[4] = tmp1 + tmp2;
		m.rawData[1] = tmp1 - tmp2;
		tmp1 = a1.x * a1.z * t;
		tmp2 = a1.y * s;
		m.rawData[8] = tmp1 - tmp2;
		m.rawData[2] = tmp1 + tmp2;
		tmp1 = a1.y * a1.z * t;
		tmp2 = a1.x*s;
		m.rawData[9] = tmp1 + tmp2;
		m.rawData[6] = tmp1 - tmp2;
		
		return m;
		
	}
	public override function appendRotation (degrees:Float, axis:Vector3D, pivotPoint:Vector3D = null):Void {
		
		var m = getAxisRotation (axis.x, axis.y, axis.z, degrees);
		
		if (pivotPoint != null){
			var p = pivotPoint;
            m.prependTranslation(-p.x, -p.y, -p.z); 
            m.appendTranslation(p.x, p.y, p.z); 
		}
		
		this.append (m);
		
	}
#end

}// abv.math.Matrix

