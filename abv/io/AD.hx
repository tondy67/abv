package abv.io;
/**
 * AbstractDevice
 * http://learningwebgl.com/blog/?p=28
 * http://api.haxe.org/js/html/webgl/RenderingContext.html
 * http://lazyfoo.net/tutorials/SDL/50_SDL_and_opengl_2/
 * http://www.adobe.com/devnet/flashplayer/articles/hello-triangle.html
 **/
import abv.ui.Root;
import abv.style.*;
import abv.factory.Component;
import abv.math.*;
import abv.bus.MS;
import abv.factory.IView;

using abv.sys.ST;

@:dce
class AD {

	static inline var SET_MONITOR 	= 1;
	static inline var SET_LAYER		= 2;
	static inline var SET_SHAPE 	= 3;
	static inline var CLEAR 		= 4;
	static inline var SET_STROKE 	= 5;
	static inline var SET_FILL 		= 6;
	static inline var MOVE_TO 		= 7;
	static inline var LINE_TO		= 8;
	static inline var DRAW_RECT		= 9;
	static inline var DRAW_CIRCLE	= 10;
	static inline var DRAW_IMAGE	= 11; 
	static inline var DRAW_TEXT		= 12; 
	static inline var DRAW_POLYGON	= 13; 

	static inline var COUNT 	= 0;
	static inline var CMD 		= 1;
	static inline var ID	 	= 2;
	static inline var X 		= 2;
	static inline var Y 		= 3;
	static inline var W 		= 4;
	static inline var H 		= 5;
	static inline var COLOR_R	= 2;
	static inline var COLOR_G	= 3;
	static inline var COLOR_B	= 4;
	static inline var COLOR_A	= 5;
	static inline var WIDTH		= 6;
	static inline var RADIUS	= 7;
	static inline var FONT		= 3;
	static inline var SRC		= 6;
	static inline var TILE		= 5;
	static inline var PATH		= 2;
///
	static var monitor 	= 0;
	static var layer 	= 0;
	static var shape 	= -1;
///
	public static var roots:Array<Root> = [];
	static var renderList = new List<Component>();
	static var cmds = new Array<Int>();
	static var cmd = new Array<Int>();
	static var oup = new List<Int>();
 
	public inline function new(){ }

	public static inline function apply(obj:IView)
	{ 
		if(obj == null){
			ST.error(ST.getText(20));
			return;
		}

		var len = cmds.length; 
		var base = 0;
		var i = 0;
		var image:String;
		var tile:Rect;
		var cmd:Int;
		var p:Array<Point> = [];
		var w = 0, h = 0;
//obj.stroke.set();
//obj.fill.set();
		while(base < len){ 
			cmd = cmds[base+CMD]; 
			if(cmd == SET_SHAPE){ 
				obj.setShape(cmds[base+ID]);
			}else if(cmd == SET_STROKE){  
				obj.strokeStyle(Color.fromRgba(cmds[base+COLOR_R],
					cmds[base+COLOR_G],cmds[base+COLOR_B],cmds[base+COLOR_A]),
					cmds[base+WIDTH], cmds[base+RADIUS]);  
			}else if(cmd == SET_FILL){ 
				image = "";
				tile = null; 
				if(cmds[base] > SRC){
					image = ST.getText(cmds[base+SRC]);
					if(cmds[base] > TILE+X)tile = new Rect(cmds[base+TILE+X],
					cmds[base+TILE+Y],cmds[base+TILE+W],cmds[base+TILE+H]); 
				}
				obj.fillStyle(Color.fromRgba(cmds[base+COLOR_R],
					cmds[base+COLOR_G],cmds[base+COLOR_B],
					cmds[base+COLOR_A]),image,tile);
			}else if(cmd == MOVE_TO){ 
				if(cmds[base] > W){
					w = cmds[base+W];
					h = cmds[base+H];
				} 
				obj.moveTo(cmds[base+X],cmds[base+Y],w,h);
			}else if(cmd == DRAW_IMAGE){ 
				obj.drawImage();
			}else if(cmd == DRAW_RECT){   
				obj.drawRect();
			}else if(cmd == DRAW_TEXT){   
				obj.drawText(ST.getText(cmds[base+ID]), ST.getFont(cmds[base+FONT]));
			}else if(cmd == LINE_TO){ 
				obj.lineTo(cmds[base+X],cmds[base+Y]);
			}else if(cmd == DRAW_POLYGON){ 
				for(i in 0...cmds[base] - 2){
					if(i % 2 != 0) continue;
					p.push(new Point(cmds[base + PATH + i],cmds[base + PATH + i+1]));
				}
				obj.drawPolygon(p);
			}else if(cmd == CLEAR){   
				obj.clearLayer(cmds[base+ID]);
			}else if(cmd == SET_LAYER){  
				obj.setLayer(cmds[base+ID]);
			}else if(cmd == DRAW_CIRCLE){   
				obj.drawCircle();
			}else{
				ST.error(ST.getText(13),'cmd: $cmd');
			}
// next cmd		
			base = base + cmds[base]; 
// control
			i++; 
			if(i > len){
				ST.error(ST.getText(7));
				break;
			}
		}
		if(len > 0) obj.render();
	}// conv()

	public static inline function render(obj:Component)
	{ 
		renderList.add(obj);
	}// render()

	public static inline function update(?ppp:haxe.PosInfos)
	{ 
		var mode = 1;
		
		cmds.clear();

		for(it in roots)it.update();

		if(!renderList.isEmpty()){ 
			var rl = new List<Component>();
			var cl:List<Component>;
			var isChild = true;
			
			if(mode > 0){	
				for(it in roots){
					if(mode == 1){ 
						isChild = false;
						for(el in renderList){
							if(el.root.layer == it.layer){
								isChild = true;
								clearLayer(it.layer);
								break;
							}
						}
					}
					if(isChild) for(el in it.getChildren()) rl.add(el);
				}
			}else{
				for(it in renderList){		
					cl = it.getChildren();
					if(cl.isEmpty())rl.add(it);
					else for(el in cl) rl.add(el);
				}
			}
			
			for(it in rl){ 	
				if(!it.visible)continue; 
				it.toScreen();
				if(it.root.layer != layer) setLayer(it.root.layer);
				setShape(MS.getID(it.name));
				drawObject(it);
			}
///
			renderList.clear();
		}

		return cmds;
	}// update()

	public static inline function drawObject(obj:Component)
	{
		var r:Float;
		if(obj == null){
			ST.error(ST.getText(20));
		}else if(obj.style == null){
			ST.error(ST.getText(20),obj.name);
		}else{
			var color = obj.color;
			var alpha = .0;
			var stroke = new Stroke(0);
			var tile:Rect = null;
			var image = "";
//if(obj.name == "RECT")trace(obj.style);			
			if(obj.style.stroke != null)stroke = obj.style.stroke;

			if(obj.style.fill != null){
				if(obj.style.fill.image.good()){
					if(obj.style.fill.tile != null){
						tile = new Rect(-obj.style.fill.tile.x,
							-obj.style.fill.tile.y,obj.width,obj.height); 
					}
					image = obj.style.fill.image;  
				}
				color = obj.style.fill.color;// * _alpha;
			}


			strokeStyle(stroke.color,stroke.width,stroke.radius);
			fillStyle(color);
			
			
			switch (obj.kind){
				case LINE: 	
					moveTo(obj.gX,obj.gY);
					lineTo(obj.width,obj.height);
				case POLYGON: drawPolygon(obj.outline);
				case CIRCLE: 
					r = obj.width/2;
					moveTo(obj.gX+r,obj.gY+r,r);  
					drawCircle();
				default:
					moveTo(obj.gX,obj.gY,obj.width,obj.height);  
					drawRect();
			}
			
	///
			if(image.good()){ 
				fillStyle(color,image, tile);
				drawImage();
			}
			if(obj.text.good()){
				strokeStyle(obj.style.color); 
				drawText(obj.text,obj.style.font); 
			}
		}
	}// drawObject()
	
	public static inline function setMonitor(v:Int)
	{
		monitor = v;
		setCmd(SET_MONITOR,v);
	}// setMonitor()
	
	public static inline function setLayer(v:Int)
	{
		layer = v;
		setCmd(SET_LAYER,v);
	}// setLayer()
	
	public static inline function setShape(v:Int)
	{
		shape = v;
		setCmd(SET_SHAPE,v);
	}// setShape()

	public static inline function clearLayer(id=-1)
	{ 
		setCmd(CLEAR,id);
	}// clearLayer()
	
	static inline function setCmd(c:Int, v=-10)
	{
		cmd.clear();
		cmd[CMD] = c;
		if(v != -10)cmd[ID] = v;
		cmd[COUNT] = cmd.length; 
		cmds = cmds.concat(cmd);
	}// setCmd()

	public static inline function strokeStyle(color:Color = 0, width = .0, radius = .0) 
	{
		cmd.clear();
		cmd[CMD]	= SET_STROKE;
		cmd[COLOR_R] = color.r;
		cmd[COLOR_G] = color.g;
		cmd[COLOR_B] = color.b;
		cmd[COLOR_A] = color.a;
		cmd[WIDTH]	= width.i();
		cmd[RADIUS] = radius.i();
		cmd[COUNT] 	= cmd.length; 
		cmds 		= cmds.concat(cmd);
	}// strokeStyle()
	
	public static inline function fillStyle(color:Color = 0, image="",tile:Rect=null) 
	{// TODO: set size = scale
		cmd.clear();  
		cmd[CMD] 	= SET_FILL;
		cmd[COLOR_R] = color.r;
		cmd[COLOR_G] = color.g;
		cmd[COLOR_B] = color.b;
		cmd[COLOR_A] = color.a; 
		if(image.good()){
			cmd[SRC] = ST.setText(image); 
			if(tile != null){ 
				cmd[TILE+X] = tile.x.i();
				cmd[TILE+Y] = tile.y.i();
				cmd[TILE+W] = tile.w.i();
				cmd[TILE+H] = tile.h.i(); 
			}  
		}
		cmd[COUNT] 	= cmd.length; 
		cmds 	= cmds.concat(cmd);
	}// fillStyle()
	
// Creates a quadratic Bézier curve
	public static inline function curveTo(x:Float, y:Float){}
// Creates a cubic Bézier curve
	public static inline function bezierTo(x:Float, y:Float){}
// Moves the cursor to the specified point. 
	public static inline function moveTo(x:Float,y:Float,w=.0,h=.0)
	{
		cmd.clear();
		cmd[CMD] = MOVE_TO;
		cmd[X] 	= x.i();
		cmd[Y] 	= y.i();
		if((w > 0) || (h > 0)){
			cmd[W] 	= w.i();
			cmd[H] 	= h.i();
		}
		cmd[COUNT] = cmd.length; 
		cmds = cmds.concat(cmd);
	}// moveTo()

	public static inline function lineTo(x:Float,y:Float)
	{
		cmd.clear();
		cmd[CMD] = LINE_TO;
		cmd[X] 	= x.i();
		cmd[Y] 	= y.i();
		cmd[COUNT] = cmd.length; 
		cmds = cmds.concat(cmd);
	}
	public static inline function drawCircle()
	{
		setCmd(DRAW_CIRCLE);
	}//
	
	public static inline function drawEllipse(){}

	public static inline function drawPolygon(path:Array<Point>)
	{ 
		if (path == null) return;
		cmd.clear();
		cmd[CMD] = DRAW_POLYGON;
		for(i in 0...path.length){
			cmd.push(path[i].x.i());
			cmd.push(path[i].y.i());
		}
		cmd[COUNT] = cmd.length; 
		cmds = cmds.concat(cmd);
	}// drawPolygon()

	public static inline function drawRect() 
	{
		setCmd(DRAW_RECT);
	}// drawRect()

	public static inline function drawImage()
	{
		setCmd(DRAW_IMAGE);
	}// drawImage()

	public static inline function drawText(s:String,font:Font)
	{ 
		cmd.clear();
		cmd[CMD] 	= DRAW_TEXT;
		cmd[ID] 	= ST.setText(s);
		cmd[FONT] 	= ST.setFont(font);
		cmd[COUNT] 	= cmd.length; 
		cmds 	= cmds.concat(cmd);
	}// drawText()

///
	public static inline function getObjectsUnderPoint(x:Float,y:Float,all=false)
	{
		oup.clear();

		for(root in roots){
			if(!root.visible)continue;
			for(it in root.getChildren()){
				if(!it.visible)continue;
				if((x > it.gX)&&(x < it.gX+it.width)&&
					(y > it.gY)&&(y < it.gY+it.height)){ 
						oup.push(it.id); //trace(ro.o.id);
				}
			}  
		} 

		return oup;
	}// getObjectsUnderPoint()
	

///	
	public static inline function addRoot(r:Root)
	{
		if(r != null){
			var ix = roots.push(r); 
			r.layer = ix - 1;
		}
	}// addRoot()
	
	public static inline function delRoot(r:Root)
	{
		r.layer = 0;
		roots.remove(r);
	}// delRoot()
	
	public static function resize()
	{ 	
		for(it in roots){
			it.resize(); 
			render(it);
		}
	}// resize()

	public static inline function play(id:String)
	{ 
	}// play()
	

}// abv.io.AD

