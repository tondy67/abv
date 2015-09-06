package abv.sys.javagui;

import abv.bus.*;
import abv.*;
import abv.lib.style.*;
import abv.io.*;
import abv.lib.comp.Component;
import abv.lib.math.Rectangle;
import abv.io.Screen;
import abv.ui.Shape;
import abv.ds.AMap;

import java.javax.swing.JPanel;
import java.awt.Graphics;
import java.awt.Toolkit;
import java.awt.Color as JavaColor;
import java.javax.swing.JFrame;
import java.awt.Dimension;
import java.javax.swing.JComponent;
import java.awt.event.KeyListener;
import java.awt.event.KeyEvent;
import java.awt.event.MouseListener;
import java.awt.event.MouseEvent;

using abv.lib.CC;
using abv.lib.math.MT;
using abv.lib.style.Color;

@:dce
class Terminal2D extends Terminal implements KeyListener implements MouseListener{

	var board = new Board();
	var panels = new AMap<String,APanel>();
	var rootPanel:JPanel;

	public var ui:Input;
	
	public function new()
	{
		super("Terminal2D");
		ui = new Input(); 

		board.setLayout(null);
		
//		panel = new APanel(); // java like init here
//		panel.setOpaque(false);
//		panel.setBounds(0,0,CC.WIDTH,CC.HEIGHT);

		rootPanel = new JPanel();
		rootPanel.setBounds(0,0,CC.WIDTH,CC.HEIGHT);
		rootPanel.addKeyListener(this);
		rootPanel.addMouseListener(this);
		rootPanel.setLayout(null);
		//rootPanel.setOpaque(false);

		board.add(rootPanel); // 

		rootPanel.requestFocus();

	}// new()

	function onMsg(oid:String,cmd:Int)
	{ 
		if(oid.good())MS.exec(new MD(sign,oid,cmd,[],"",[ui.delta]));
//LG.log(to+":"+MS.msgName(cmd));
	}// onMsg()	
	function onMouseMove(x=0,y=0)
	{ 
		var l = getObjectsUnderPoint(x,y); 
		if(l.length > 0){ 
			var t = l.first(); 
			if(ui.click){
				onMsg(t,MD.MOUSE_MOVE);
			}else if(MS.accept(t,MD.MOUSE_OVER)){
//				if(hovered != t)onMsg(hovered,MD.MOUSE_OUT);
//				hovered = t;
//				onMsg(hovered,MD.MOUSE_OVER); 
			}else {
//				onMsg(hovered,MD.MOUSE_OUT); 
//				hovered = "";
			}
		}
	}// onMouseMove()
	
	function onMouseWheel()ui.wheel = 0;
	function onMouseUp(x=0,y=0)ui.click = false;
	function onMouseDown(x=0,y=0)
	{ 
		var oid = "";
		var a = getObjectsUnderPoint(x,y); 

		for(o in a){  
			if(MS.accept(o,MD.MOUSE_DOWN)){ 
				oid = o; //trace(oid);
				break;
			}
		}
//
		ui.click = true; 
//		ui.start.set(e.clientX,e.clientY);  
		ui.move.copy(ui.start);
//
		if(oid.good()){ //trace(oid);
			onMsg(oid,MD.CLICK); 
		}
	}// onMouseDown
	
	function onClick()
	{ 
		var oid:String  = "";//cast(e.toElement,Element).id;
		if(oid.good())onMsg(oid,MD.CLICK); 
//LG.log(oid);
	}// onClick
	
	function onKeyUp(key:Int)
	{
		ui.keys[key] = false;
		MS.exec(new MD(sign,"",MD.KEY_UP,[key])); 
	}// onKeyUp()
	
	function onKeyDown(key:Int)
	{ 
		ui.keys[key] = true;
		MS.exec(new MD(sign,"",MD.KEY_DOWN,[key]));
	}// onKeyDown()
	
	public override function clearScreen(root:String)
	{
		if(!panels.exists(root)){ //trace(root);
			panels.set(root,new APanel());
			panels[root].setOpaque(false);
			panels[root].setBounds(0,0,CC.WIDTH,CC.HEIGHT);
			rootPanel.add(panels[root]);
		}
		panels[root].repaint();
		panels[root].clear();
//		rootPanel.repaint();
//		board.repaint();
	}// clearScreen()

	public override function drawStart(shape:Shape)
	{
//trace("drawStart");
	}// drawStart()

	public override function drawShape(shape:Shape)
	{ 
		panels[shape.root].redraw(shape);
//	trace(o.id+":"+ panel.getComponentCount());
	}// drawShape()

	public override function drawText(shape:Shape)
	{ 
		panels[shape.root].redraw(shape);
	}// drawText()

/*	function getTile(bm:BitmapData,rect:Rectangle,scale = 1.)
	{ 
		var sbm:BitmapData = null; 
		if(bm == null) return sbm; 
		if(rect == null){
			rect = new Rectangle(0,0,bm.width,bm.height);
		}
		var bd = new BitmapData(MT.closestPow2(rect.w.int()), MT.closestPow2(rect.h.int()), true, 0);
		var pos = new flash.geom.Point();
		var r = new flash.geom.Rectangle(rect.x,rect.y,rect.w,rect.h);
		bd.copyPixels(bm, r, pos, null, null, true);
		
		if(scale == 1){
			sbm = bd;
		}else{
			var m = new flash.geom.Matrix();
			m.scale(scale, scale);
			var w = (bd.width * scale).int(), h = (bd.height * scale).int();
			sbm = new BitmapData(w, h, true, 0x000000);
			sbm.draw(bd, m, null, null, null, true);
		}		
		return sbm;
	}// getTile()
*/

	public override function drawEnd()
	{
	}// drawEnd()

	
	public override function toString() 
	{
        return "Terminal2D";//("+"x: "+x+", y:"+y+", width:"+width+", height:"+height+")";
    }// toString()

// KeyListener happy
	public function keyTyped(e:KeyEvent) {
//		trace("key Typed " + e.getKeyChar());
	}

    public function keyPressed(e:KeyEvent) 
    {
		onKeyDown(e.getKeyCode());
    }	

    public function keyReleased(e:KeyEvent) 
    {
		onKeyUp(e.getKeyCode());
    }	
// MouseListener happy
	public function mouseClicked(e:MouseEvent) { }
	
	public function mouseEntered(e:MouseEvent)	{ }
	
	public function mouseExited(e:MouseEvent) {}
	
	public function mousePressed(e:MouseEvent)
	{ 
		onMouseDown(e.getX(),e.getY());
	}
	
	public function mouseReleased(e:MouseEvent)
	{ 
		onMouseUp(e.getX(),e.getY());
	}
	
}// abv.sys.javagui.Terminal2D

class APanel extends JPanel {
	
	public var id="";
	var x = 100;
	var y = 200;
	var width = 10;
	var height = 10;
	var radius = 1;
	var color:JavaColor = JavaColor.BLUE;

	var shapes = new List<Shape>();

@:overload
    public override function paintComponent( g:Graphics) 
    {
        super.paintComponent(g);
        
        for(shape in shapes){ 
			var c = shape.color.trgba(); 
			if(shape.border.width > 0){
				var t = shape.border.width; 
				c = shape.border.color.trgba(); 
				g.setColor(new JavaColor(c.r,c.g,c.b,c.a)); 
				g.fillRoundRect((shape.x-t).int(),(shape.y-t).int(),
					(shape.w+2*t).int(),(shape.h+2*t).int(),
					(shape.border.radius+t).int(),(shape.border.radius+t).int());
			}
			if(shape.color > 0){
				c = shape.color.trgba(); 
				g.setColor(new JavaColor(c.r,c.g,c.b,c.a)); 
				g.fillRoundRect(shape.x.int(),shape.y.int(),shape.w.int(),shape.h.int(),
					shape.border.radius.int(),shape.border.radius.int());
			}
			if(shape.text.src.good()){
				c = shape.text.color.trgba(); 
				g.setColor(new JavaColor(c.r,c.g,c.b,c.a)); 
				g.drawString(shape.text.src,shape.x.int()+4,shape.y.int()+20);
			}
		}

        Toolkit.getDefaultToolkit().sync(); 
    }
	public function redraw(shape:Shape)
	{
		shapes.add(shape);
	}
	
	public function clear()
	{
		shapes.clear();
	}//
	
}// abv.sys.javagui.Terminal2D.Board

class Board extends JFrame {
	
	public function  new()
	{
		super();

        setResizable(false);
        pack();
        setSize(CC.WIDTH,CC.HEIGHT);
		setTitle(CC.NAME);
        setLocationRelativeTo(null);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE); 
        setVisible(true); 
		
	}

}




