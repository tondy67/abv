/**
 * The browser part of abv-agent bundle
 * build: npm run dist
 */
"use strict";
// localStorage.ts.debug = 'abv:*';

(() => {
const abv = window.abv;
ts.debug('ttt');
//const clr = ['black','rgba(0, 0, 255, 0.2)','blue','rgba(0, 255,0,  0.2)','green','orange'];

const canvas = document.createElement("canvas");
canvas.id = 'canvas';
canvas.style.left = "0px"; 
canvas.style.top = "0px";
canvas.width = 1024; 
canvas.height = 624;
canvas.style.margin 	= "0px";
canvas.style.position 	= "fixed";
document.body.appendChild(canvas);
const ctx = canvas.getContext("2d");
const win = window;
	win.ctx = ctx;
const Node = abv.Node;
const Term1D = abv.Term1D;
const VTerm = abv.VTerm;
const Color = abv.Color;
const AM = abv.AM;

const $fps = 30;
const $m = 1;

class App extends AM
{
	constructor()
	{
		super();
	}
	
	create()
	{
		this.term = new VTerm();

		const root = new Node('root',0,0,790,690,Color.rgba(255, 255, 255, 55));
		const box1 = new Node('box1',10,20,100,80,Color.name('red'));
		root.addChild(box1);
		const box2 = new Node('box2',100,120,100,80,Color.name('green'));
		root.addChild(box2);
		const box3 = new Node('box3',16,25,50,40,Color.name('orange'));
		box1.addChild(box3);
		const box4 = new Node('box4',300,200,100,80,Color.name('blue'));
		root.addChild(box4);
		const box5 = new Node('box5',0,200,10,10,Color.name('gray'));
		root.addChild(box5);
		const box6 = new Node('box6',0,220,10,10,Color.name('gray'));
		root.addChild(box6);
		
		this.addLayer(root);
		
		const root2 = new Node('root2',350,70,190,150,Color.name('gray'));
		this.addLayer(root2);
	}
	
	update()
	{
		const w = 700;
		const r = Node.get('root');
		const b1 = Node.get('box1');
		if(b1.x < w) b1.x += $m; else b1.x = 0;
		const b4 = Node.get('box4');
		if(b4.y > $m) b4.y -= $m;
		const b5 = Node.get('box5');
		if(b5.x < w) b5.x += 1.5*$m; else b5.x = 0;
		const b6 = Node.get('box6');
		if(b6.x < w) b6.x += $m; else b6.x = 0;
		const r2 = Node.get('root2'); 
		if (r2.w > $m) r2.w -= $m;
		if (r2.h > $m) r2.h -= $m;
		this.render();
	}

}
const app = new App();
//app.run($fps);

const tty = new AM();
tty.term = new Term1D(); 
tty.term.onKeyDown = (e) =>{
		e.preventDefault(); //ts.debug(79,e.key,e.code);
		if(e.code === 'ArrowUp'){
			Node.get('box2').y -= $m;
		}else if(e.code === 'ArrowDown'){
			Node.get('box2').y += $m;
		}else if(e.code === 'ArrowLeft'){
			Node.get('box2').x -= $m;
		}else if(e.code === 'ArrowRight'){
			Node.get('box2').x += $m;
		}	
		}

//tty.term.onWheel = (e) =>{ console.log(e); }
tty.term.onMouseDown = (e) =>{ console.log(e); }
tty.term.onWheel = (e) =>{ console.log(e); };
//tty.term.delListeners();
//tty.term.addListeners();
//		win.addEventListener("keydown", tty.term.onKeyDown, false);



//ts.debug(app.term.layers);
tty.update = () => {
		app.update();
	//	tty.term.layers = app.term.layers;
		tty.term.fromArray(app.term.toArray());
		tty.render(); 
	}

tty.run($fps);


})();
