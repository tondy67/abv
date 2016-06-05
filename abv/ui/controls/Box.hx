package abv.ui.controls;

import abv.math.Point;
import abv.bus.MD;
import abv.factory.IStyle;
import abv.style.Style;
import abv.factory.Object;
import abv.factory.Component;
import abv.Enums;

using abv.math.MT;
using abv.sys.ST;

//
@:dce
class Box extends Component {

	var placement:Point = null;

	public inline function new(id:String,x=.0,y=.0,width=200.,height=200.)
	{
		super(id);
		_kind = BOX;
		_x = x; _y = y;
		_width = width; _height = height;
//
		msg.accept = MD.MSG ;
	}// new()

	override function dispatch(md:MD)
	{ //trace(md.from);
		super.dispatch(md);
	
		switch(md.msg){
			case MD.STATE:  	
				visible = !visible;  
				draw(); 
			case MD.OPEN: 
				visible = true; 
				draw();
			case MD.CLOSE: 
				visible = false; 
				draw(); 
		}
	}// dispatch

	public function placeChild(obj:Component)
	{ 
		if(children == null)return;
		if(placement == null)placement = new Point();

		if(obj == null){
			ST.error(ST.getText(20));
			return;
		}else if(obj.parent == null){
			ST.error("No parent",obj.name);
			return;
		}

/*		
		 if(children[obj.id] != null){
			ST.error("Intruder",obj.name);
			return;
		}
*/
		var c = 0, auto = .0;
		var child:Component;
		var pr = obj.parent; 
		var px = pr.x, py = pr.y;
		var pw = pr.width, ph = pr.height;
		var pp = pr.style.padding;  

		var style = obj.style; 
		if ((style.left == null)||(style.top == null)||
			(style.width == null)||(style.height == null)) return;	
			
		var x = style.left; 
		var y = style.top; 
		var w = style.width.val(pw);
		var h = style.height.val(ph);
		var m = style.margin; 
		var p = style.padding; 
		var ix = getChildID(obj);  

//if(pr.id == "mbox") trace(pr.style);
/**
 * |<-left->|<-margin->|<-padding->|<--width-->|<-padding->|<-margin->|
 **/
		if(x == 0){ 
			if(placement.x == 1){ 
				if(pp.left == CC.AUTO) c++;else x = pp.left.auto();

				for(i in 0...numChildren){
					child = children[i];
					m = child.style.margin;
					p = child.style.padding;
					if(m.left == CC.AUTO) c++;else x += m.left.auto();
					if(m.right == CC.AUTO) c++;else x += m.right.auto();
					if(p.left == CC.AUTO) c++;else x += p.left.auto();
					if(p.right == CC.AUTO) c++;else x += p.right.auto();
					x += style.width; 
				}

				if(pp.right == CC.AUTO) c++;else x += pp.right.auto();

				if(c > 0)auto = (pw - x)/c;

				if(ix == 0){
					child = children[0];
					m = child.style.margin;
					p = child.style.padding;
					x = pp.left.auto(auto) + m.left.auto(auto) + p.left.auto(auto);
				}else{
					child = children[ix-1];
					m = child.style.margin;
					p = child.style.padding;
					x = child.x + m.left.auto(auto) + p.left.auto(auto) +
						child.width + m.right.auto(auto) + p.right.auto(auto);
				}
			}else{
				x = (pw - pp.left - m.left - p.left - w - p.right - m.right - pp.right - 3)/2; 
			}
		}
		
		if(y == 0){
			c = 0; auto = 0;
			m = obj.style.margin; 
			pp = obj.parent.style.padding;
			ph = obj.parent.height;
			if(placement.y == 1){ 
				if(pp.top == CC.AUTO) c++;else y = pp.top.auto();

				for(i in 0...numChildren){
					child = children[i];
					m = child.style.margin;
					p = child.style.padding;
					if(m.top == CC.AUTO) c++;else y += m.top.auto();
					if(m.bottom == CC.AUTO) c++;else y += m.bottom.auto();
					if(p.top == CC.AUTO) c++;else y += p.top.auto();
					if(p.bottom == CC.AUTO) c++;else y += p.bottom.auto();
					y += style.height; 
				}

				if(pp.bottom == CC.AUTO) c++;else y += pp.bottom.auto();

				if(c > 0)auto = (ph - y)/c;

				if(ix == 0){
					child = children[0];
					m = child.style.margin;
					p = child.style.padding;
					y = pp.top.auto(auto) + m.top.auto(auto) + p.top.auto(auto);
				}else{
					child = children[ix-1];
					m = child.style.margin;
					p = child.style.padding;
					y = child.y + m.top.auto(auto) + p.top.auto(auto) +
						child.height + m.bottom.auto(auto) + p.bottom.auto(auto);
				}
			}else{
				y = (ph - pp.top - m.top - p.top - h - p.bottom - m.bottom - pp.bottom - 3)/2; 
			}
		}

		obj.x = x;
		obj.y = y;
		obj.width = obj.style.width = w; 
		obj.height = obj.style.height = h; 
	}// placeChild()
	
	public override function resize()
	{ 
		if(children == null)return;
		for(it in children){ 
			it.resize(); 
			placeChild(it); 
		}
	}// resize()

	public override function toString() 
	{
		var s = Object.showInherited?super.toString() + "\n    └>":""; 
		return '$s Box<IStyle>(id: $id)';
    }// toString() 

}// abv.ui.controls.Box

