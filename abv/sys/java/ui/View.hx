package abv.sys.java.ui;

import abv.bus.*;
import abv.*;
import abv.style.*;
import abv.io.*;
import abv.factory.Component;
import abv.math.Rect;
import abv.ui.CView;


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
import java.awt.image.BufferedImage;
import java.io.File;
import java.javax.imageio.ImageIO;

using abv.sys.ST;
using abv.math.MT;
using abv.style.Color;

@:dce
class View extends CView implements KeyListener implements MouseListener{

	var board = new Board();
	var panels = new Map<Int,APanel>();
	var rootPanel:JPanel;

	public function new(id:String)
	{
		super(id);

		board.setLayout(null);
		
		rootPanel = new JPanel();
		rootPanel.setBounds(0,0,CC.WIDTH,CC.HEIGHT);
		rootPanel.addKeyListener(this);
		rootPanel.addMouseListener(this);
		rootPanel.setLayout(null);
		//rootPanel.setOpaque(false);

		board.add(rootPanel); // 

		rootPanel.requestFocus();
	}// new()

	function onMouseMove_(x:Int,y:Int)
	{ 
		var l = AD.getObjectsUnderPoint(x,y); 
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
	}// onMouseMove_()
	
	function onMouseWheel_()ui.wheel = 0;
	function onMouseUp_(x=0,y=0)ui.click = false;
	function onMouseDown_(x=0,y=0)
	{ 
		var oid = -1;
		var a = AD.getObjectsUnderPoint(x,y); 

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
		if(oid > 0){ //trace(oid);
			onMsg(oid,MD.CLICK); 
		}
	}// onMouseDown_
	
	function onClick_()
	{ 
		var oid = -1;//cast(e.toElement,Element).id;
		if(oid > 0)onMsg(oid,MD.CLICK); 
//LG.log(oid);
	}// onClick_
	
	function onKeyUp_(key:Int)
	{
		keyUp(key);
	}// onKeyUp_()
	
	function onKeyDown_(key:Int)
	{ 
		keyDown(key);
	}// onKeyDown_()
	
	public function clear(root:Int)
	{
/*		if(!panels.exists(root)){ //trace(root);
			panels.set(root,new APanel());
			panels[root].setOpaque(false);
			panels[root].setBounds(0,0,CC.WIDTH,CC.HEIGHT);
			rootPanel.add(panels[root]);
		}
		panels[root].repaint();
		panels[root].clear();
//		rootPanel.repaint();
//		board.repaint();  */
	}// clearAD()

	public override function drawRect()
	{ 
//		panels[shape.root].draw(shape);
//	trace(o.id+":"+ panel.getComponentCount());
	}// drawRect()

	public override function drawImage()
	{
//		panels[shape.root].draw(shape);
	}
	
	public override function drawText(s:String,font:Font)
	{ 
//		panels[shape.root].draw(shape);
	}// drawText()

/*	function getTile(bm:BitmapData,rect:Rect,scale = 1.)
	{ 
		var sbm:BitmapData = null; 
		if(bm == null) return sbm; 
		if(rect == null){
			rect = new Rect(0,0,bm.width,bm.height);
		}
		var bd = new BitmapData(MT.closestPow2(rect.w.i()), MT.closestPow2(rect.h.i()), true, 0);
		var pos = new flash.geom.Point();
		var r = new flash.geom.Rect(rect.x,rect.y,rect.w,rect.h);
		bd.copyPixels(bm, r, pos, null, null, true);
		
		if(scale == 1){
			sbm = bd;
		}else{
			var m = new flash.geom.Matrix();
			m.scale(scale, scale);
			var w = (bd.width * scale).i(), h = (bd.height * scale).i();
			sbm = new BitmapData(w, h, true, 0x000000);
			sbm.draw(bd, m, null, null, null, true);
		}		
		return sbm;
	}// getTile()
*/

// KeyListener  happy
	public function keyTyped(e:KeyEvent) {
//		trace("key Typed " + e.getKeyChar());
	}

    public function keyPressed(e:KeyEvent) 
    {
		onKeyDown_(e.getKeyCode());
    }	

    public function keyReleased(e:KeyEvent) 
    {
		onKeyUp_(e.getKeyCode());
    }	
// MouseListener happy
	public function mouseClicked(e:MouseEvent) { }
	
	public function mouseEntered(e:MouseEvent)	{ }
	
	public function mouseExited(e:MouseEvent) {}
	
	public function mousePressed(e:MouseEvent)
	{ 
		onMouseDown_(e.getX(),e.getY());
	}
	
	public function mouseReleased(e:MouseEvent)
	{ 
		onMouseUp_(e.getX(),e.getY());
	}
	
}// abv.sys.java.View

class APanel extends JPanel {
	
	public var id="";
	var x = 100;
	var y = 200;
	var width = 10;
	var height = 10;
	var radius = 1;
	var color:JavaColor = JavaColor.BLUE;

//	var shapes = new List<Shape>();
	var images = new Map<String,BufferedImage>();
	
@:overload
    public override function paintComponent( g:Graphics) 
    {
        super.paintComponent(g);
        
		var x:Int, y:Int, w:Int, h:Int, r:Int, scale:Int;
/*
        for(shape in shapes){ 
			x = shape.x.i();
			y = shape.y.i();
			w = shape.w.i();
			h = shape.h.i();
			r = shape.border.radius.i();
			scale = shape.scale.i();
			var c = shape.color; 
			if(shape.border.width > 0){
				var t = shape.border.width.i(); 
				c = shape.border.color; 
				g.setColor(new JavaColor(c.r, c.g, c.b, c.a)); 
				g.fillRoundRect(x-t, y-t, w+2*t, h+2*t, r+t, r+t);
			}

			if(shape.color.alpha > 0){
				c = shape.color; 
				g.setColor(new JavaColor(c.r, c.g, c.b, c.a)); 
				g.fillRoundRect(x, y, w, h, r, r);
			}

			var src = shape.image.src;
			if(src.good()){
				var tile = shape.image.tile;
				var img:BufferedImage = null;
				
				if(images.exists(src)){
					img = images[src]; 
				}else{
					try img = ImageIO.read(new File(src))
					catch(e:Dynamic){trace(ERROR+ "no img: " + d);}
					if(img != null)images.set(src,img);
				}
				
				if(img != null){ 
					if(tile == null){
						g.drawImage(img, x, y,null);
					}else{
						var tx = tile.x.i();
						var ty = tile.y.i();
						var tw = tile.w.i();
						var th = tile.h.i();
						g.drawImage(img, x, y, x + (tw * scale),y + (th * scale),
							tx, ty, tx + tw, ty + th,null);
					}
				}
			}

			if(shape.text.src.good()){
				c = shape.text.color; 
				g.setColor(new JavaColor(c.r, c.g, c.b, c.a)); 
				g.drawString(shape.text.src,x+4,y+20);
			}
		}
*/
        Toolkit.getDefaultToolkit().sync(); 
    }

	public function clear()
	{
//		shapes.clear();
	}//
	
}// abv.sys.java.ui.View.APanel

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

}// abv.sys.java.ui.View.Board




