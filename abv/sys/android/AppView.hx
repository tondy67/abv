package abv.sys.android;



import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color as ColorAndroid;
import android.graphics.Paint;
import android.graphics.Path;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.View;
import android.graphics.Path;
import android.graphics.Rect;
import android.graphics.RectF;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

using abv.sys.ST;
using abv.math.MT;
using abv.style.Color;
using abv.ds.TP;

class AppView extends View {

	var paint = new Paint();

//@:allow(abv.sys.android.SM)
//	var term:Terminal2D = null;
	
//	var shapes = new List<Shape>();
	var images = new Map<String,Bitmap>();

	public function new( context:Context,	attrs:AttributeSet) {
		super(context, attrs);

		paint.setAntiAlias(true);
		paint.setStrokeWidth(1.);
		
//		paint.setStyle(Paint.Style.STROKE);
//		paint.strokeJoin(Paint.Join.ROUND);
		update();
	}
	
@:overload
	override function onDraw(canvas:Canvas) 
	{
		var img:Bitmap = null;
		var rect = new RectF(0,0,0,0);
		var x:Float, y:Float, w:Float, h:Float, r:Float, scale:Float;
/*
        for(shape in shapes){ 
			x = shape.x;
			y = shape.y;
			w = shape.w;
			h = shape.h;
			r = shape.border.radius;
			scale = shape.scale;
			var c = shape.color; 
			
			if(shape.border.width > 0){
				var t = shape.border.width; 
				rect.set(x-t,y-t,x + w+2*t,y+h+2*t);
				c = shape.border.color; 
				paint.setColor(ColorAndroid.argb(c.a,c.r,c.g,c.b));
				canvas.drawRoundRect(rect , r+t, r+t, paint);
			}

			if(shape.color.alpha > 0){
				rect.set(x,y,x+w,y+h);
				c = shape.color; 
				paint.setColor(ColorAndroid.argb(c.a,c.r,c.g,c.b));
				canvas.drawRoundRect(rect, r, r, paint);
			}
			
			var src = shape.image.src; 
			if(src.good()){
				var tile = shape.image.tile;
				var name = src.basename(false); 
				name = src.dirname().replace(CC.RES,"").replace("/","_") + name; 
				var nameID = Reflect.field(abv.sys.android.R,name);
				var img:Bitmap = null;
				
				if(images.exists(src)){
					img = images[src]; 
				}else{
					try img = BitmapFactory.decodeResource(getResources(), nameID)
					catch(e:Dynamic){trace(ERROR+ "no img: " + d);}
					if(img != null)images.set(src,img);
				}
				
				if(img != null){ 
					if(tile == null){
						canvas.drawBitmap(img, x, y,paint);
					}else{
						var tx = tile.x.i();
						var ty = tile.y.i();
						var tw = tile.w.i();
						var th = tile.h.i();
						var src = new Rect(tx,ty,tx+tw,ty+th);
						var dst = new Rect(x.i(),y.i(),(x + (tw * scale)).i(),(y + (th * scale)).i());
						canvas.drawBitmap(img,  src, dst,paint);
					}
				}

			}

			if(shape.text.src.good()){
				c = shape.text.color; 
				paint.setColor(ColorAndroid.argb(c.a,c.r,c.g,c.b));
				canvas.drawText(shape.text.src,x+4,y+20,paint);
			}
		}
*/
	}// onDraw()

@:overload
	public override function onTouchEvent(event:MotionEvent) 
	{
		var x = event.getX();
		var y = event.getY();
/*			
		switch(event.getAction()) {
			case MotionEvent.ACTION_DOWN:
//				if(term != null) term.onMouseDown_(x,y);
			case MotionEvent.ACTION_MOVE:
//				if(term != null) term.onMouseMove_(x,y);
			case MotionEvent.ACTION_UP:
//				if(term != null) term.onMouseUp_(x,y);
			default: return false;
		}
*/
		invalidate();
		return true;
	}// onTouchEvent()
	
	public function redraw()
	{ 
//		shapes.add(shape);
	}
	
	public function clear()
	{
//		shapes.clear();
	}//
	
	public function update()
	{
		invalidate();
	}//
	
}// abv.sys.android.AppView

