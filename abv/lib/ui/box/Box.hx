package abv.lib.ui.box;

import abv.lib.math.Point;
import abv.lib.box.Container;
import abv.bus.MD;
import abv.lib.style.IStyle;
import abv.lib.style.Style;
import abv.lib.comp.Object;
import abv.lib.comp.Component;

using abv.lib.math.MT;

//
@:dce
class Box extends Container implements IStyle {

	public var style(get, never):Map<StyleState,Style>;
	var _style:Map<StyleState,Style>;
	public function get_style() { return _style; }
	public var childSizes(default,null):Array<Array<Float>> =[];
	var placement:Point;
	
	public function new(id:String,x=.0,y=.0,width=200.,height=200.)
	{
		super(id);
		_pos.set(x,y);
		_width = width; _height = height;
//
		msg.accept = MD.MSG ;
		_style = [Normal => new Style()];
		placement = new Point();
	}// new()

	override function processExec(mdt:MD)
	{ // LG.log(mdt+"|"+visible);
		super.processExec(mdt);
		
		switch(mdt.msg){
			case MD.STATE: 
				visible = !visible;
				draw(this);
		}
	}// processExec

	public function placeChild(obj:Component)
	{
		if(obj == null){LG.log("Null object!");return;}
		else if(obj.parent == null){LG.log("No parent!");return;}

		var style:Style = null;
		if(Std.is(obj,IStyle))style = cast(obj,IStyle).style[Normal];
		var x:Null<Float>;
		var y:Null<Float>;
		var w:Null<Float>;
		var h:Null<Float>;
		if(style == null){
			x = obj.pos.x; y = obj.pos.y;
			w = obj.width; h = obj.height;
		}else{
			var pr = obj.parent; 
			var pw = pr.width; var ph = pr.height;
			var ix = getChildIndex(obj);
			var m:Margin = style.margin; 
			if(m == null)m = { top:0, right:0, bottom:0, left:0 };
			var pp:Padding = cast(pr,IStyle).style[Normal].padding;
			if(pp == null)pp = { top:0, right:0, bottom:0, left:0 }; 

			x = style.left; y = style.top; 
			w = style.width; h = style.height; 
		
			if(w == null){
				if((m.left != CR.AUTO)&&(m.right != CR.AUTO)){
					w = pw - m.left.val(pw)- m.right.val(pw);
				}else w = pw / 2;
			}else{//trace(o.id+":"+w+"|"+p.id+":"+width);
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
	//if(obj.id =="btnmenu")trace(ix);
			if((ix > 0)&&(pr != obj.root)){
				var prev = children[ix-1];
				var ps = cast(prev,IStyle).style[Normal]; 
				var pm:Margin = ps.margin != null ?ps.margin:{top:0,right:0,bottom:0,left:0}; 
				var pd:Padding = ps.padding != null ?ps.padding:{top:0,right:0,bottom:0,left:0}; 
		//|<-left->|<-margin->|<-padding->|<--width-->|<-padding->|<-margin->|
				if(placement.x == 1){ 
					x = prev.pos.x +pm.left +pd.left +prev.width +pd.right +pm.right ;
				}
				if(placement.y == 1){
						y = prev.pos.y +pm.top +pd.top +prev.height +pd.bottom +pm.bottom ;
				}
			}
		}
		obj.pos.set(x,y); obj.width = w; obj.height = h;
//LG.log('${obj.id}->$x:$y:$w:$h');
		
	}//
	
	public override function toString() 
	{
		var s = Object.traceInherited?super.toString() + "\n    └>":""; 
		return '$s Box<IStyle>(id: $id)';
    }// toString() 

}// abv.lib.ui.box.Box

