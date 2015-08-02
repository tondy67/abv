package abv.ui.box;

import abv.lib.math.Point;
import abv.lib.box.Container;
import abv.bus.MD;
import abv.lib.style.IStyle;
import abv.lib.style.Style;
import abv.lib.comp.Object;
import abv.lib.comp.Component;


using abv.lib.math.MT;
using abv.lib.CR;

//
@:dce
class Box extends Container {

	public var childSizes(default,null):Array<Array<Float>> =[];
	var placement:Point;
	
	public function new(id:String,x=.0,y=.0,width=200.,height=200.)
	{
		super(id);
		_pos.set(x,y);
		_width = width; _height = height;
//
		msg.accept = MD.MSG ;

		placement = new Point();
	}// new()

	override function dispatch(md:MD)
	{ 
		super.dispatch(md);
		
		switch(md.msg){
			case MD.STATE: 
				visible = !visible;
				draw(this);
		}
	}// dispatch

	public function placeChild(obj:Component)
	{
		if(obj == null){trace(CR.ERROR+"Null object!");return;}
		else if(obj.parent == null){trace(CR.ERROR+obj.id+": No parent!");return;}

		var style = obj.style; 

		var x:Null<Float> = null;
		var y:Null<Float> = null;
		var w:Null<Float> = null;
		var h:Null<Float> = null;

		if(style == null){
			x = obj.pos.x; y = obj.pos.y;
			w = obj.width; h = obj.height;
		}else{
			var pr = obj.parent; 
			var pw = pr.width; var ph = pr.height;
			var ix = getChildIndex(obj);
			var pp:Padding = pr.style.padding;
			var m:Margin = null;

			m = style.margin; 

			if(m == null)m = { top:0, right:0, bottom:0, left:0 }; 
			if(pp == null)pp = { top:0, right:0, bottom:0, left:0 }; 

			x = style.left; y = style.top; 
			w = style.width; h = style.height; 

			if(w == null){
				if((m.left != CR.AUTO)&&(m.right != CR.AUTO)){
					w = pw - m.left.val(pw)- m.right.val(pw); 
				}else w = pw / 2;
			}else{
				w = w.val(pw);
			}
			if(w > pw)w = pw; 

			if(h == null){
				if((m.top != CR.AUTO)&&(m.bottom != CR.AUTO)){
					h = ph - m.top.val(ph)- m.bottom.val(ph);
				}else h = ph / 2;
			}else h = h.val(ph);
			if(h > ph)h = ph;


			if(x != null){}
			else if((m.left == CR.AUTO)&&(m.right == CR.AUTO)){x = pp.left+(pw-pp.left-pp.right-w)/2;}
			else if(m.left == CR.AUTO){x = pp.left+(pw-pp.right-w);}
			else if(m.right == CR.AUTO){x = pp.left+(pw-pp.right-w);}
			else {x = pp.left; }

			if(y != null){}
			else if((m.top == CR.AUTO)&&(m.bottom == CR.AUTO)){y = pp.top+(ph-pp.top-pp.bottom-h)/2;}
			else if(m.top == CR.AUTO){y = pp.top+(ph-pp.bottom-h);}
			else if(m.bottom == CR.AUTO){y = pp.top+(ph-pp.top-h);}
			else {y = pp.top;}
				
			if((ix > 0)&&(pr != obj.root)){
				var prev = children[ix-1]; 
				var ps = prev.style; 
				var pm:Margin = ps.margin != null ?ps.margin:{top:0,right:0,bottom:0,left:0}; 
				var pd:Padding = ps.padding != null ?ps.padding:{top:0,right:0,bottom:0,left:0}; 
/**
 * |<-left->|<-margin->|<-padding->|<--width-->|<-padding->|<-margin->|
 **/
				if(placement.x == 1){  
					x = prev.pos.x +pm.left +pd.left +prev.width +pd.right +pm.right ;
				}
				if(placement.y == 1){  
						y = prev.pos.y +pm.top +pd.top +prev.height +pd.bottom +pm.bottom ;
				}
			}
		}

		obj.pos.set(x,y); obj.width = w; obj.height = h;
	}// placeChild()
	
	public override function toString() 
	{
		var s = Object.traceInherited?super.toString() + "\n    └>":""; 
		return '$s Box<IStyle>(id: $id)';
    }// toString() 

}// abv.ui.box.Box

