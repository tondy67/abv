package abv.lib.anim;

import abv.lib.Timer;
import abv.lib.math.Point;
import abv.lib.anim.*;
//
typedef TweenObj = {name:String,from:Point,to:Point,trans:String}
typedef PathObj = {run:Bool,path:Array<Point>,time:Float,segm:Int,trans:String,tw:TweenObj}

@:dce
class Tween{
	public var run = true;
	var counter = 0;
	var ratio = .0;
	var key = 0;
	var tweens:List<TweenObj> = new List();
	public var target(default,null):IAnim; // Dynamic
	var duration:Float;
	var repeat:Int;
	var time = .0;
	var start = .0;
	var pathObj:PathObj;
	var delay:Float;
	var mirror:Bool;
		
	public function new(obj:IAnim,duration:Float,repeat=1,delay=0,mirror=false)
	{
		target = obj;
		this.duration = duration; //trace(duration);
		this.repeat = repeat;
		this.delay = delay;
		this.mirror = mirror;
		pathObj = {run:false,path:[],time:0,segm:-1,trans:"",tw:null};
	}// new()

	public function update()
	{
		var pt:Point;
		var r:Float;
		
		if((target == null)|| !run){
			run = false;
			return;
		}
		if(start == 0)start = Timer.stamp();
		time = Timer.stamp() - start; 
		if((counter == 0)&&(delay > 0)){
			if(time < delay)return; else time -= delay;
		}
		 
		for(tw in tweens){
			pt = tw.to.sub(tw.from); 
			ratio = pathObj.run? time/pathObj.time-pathObj.segm: time / duration; 
			r = Transitions.get(tw.trans)(ratio); 
			pt.scale(r);    
			if (tw.name == "move") { 
				target.rot.x = tw.from.angle(tw.to);
				target.pos = tw.from.add(pt);			
//if((r < .2)||(r > .8))trace(target.pos);
//				target.moveTo(tw.from.add(pt),true); 
			}else if(tw.name == "fade"){
				target.fade = tw.from.x+pt.x; 
			}else if(tw.name == "scale"){
				target.scale = tw.from.x+pt.x; //
			}else if(tw.name == "rot"){
//				target.rot = r; //trace(r);
			}
			
		}
		
		if (time < duration) { 
			if(pathObj.run) _path(); //trace(time);
			onUpdate();
		}else{
			onComplete();
			if(repeat == 1){
				run = false;
			}else {
				start = Timer.stamp();
				counter++;
				if ((repeat > 0) && (repeat < counter)) run = false;
			}
		}

	}// update()
	
	public dynamic function onUpdate(){};
	public dynamic function onComplete(){};
	
	public function move(to:Point,trans=Transitions.linear)
	{ 
		tweens.add({name:"move",from:target.pos,to:to,trans:trans});
	}// move()
	
	public function path(curve:Array<Point>,trans=Transitions.linear)
	{
		pathObj.run = true;
		pathObj.path = curve;
		pathObj.trans = trans;
		pathObj.time = duration / curve.length;
	}// path()
	function _path()
	{
		var segm = Math.floor(time/pathObj.time); 
		if(segm == pathObj.segm)return; //trace(time+"-"+segm +":"+pathObj.segm);
		pathObj.segm = segm;
		if(pathObj.tw != null)tweens.remove(pathObj.tw); 
		pathObj.tw = {name:"move",from:target.pos,to:pathObj.path[segm],trans:pathObj.trans};	
		tweens.add(pathObj.tw);
 // *Cfg.degree	
	}// _path()

	public function fade(to:Float,trans=Transitions.linear)
	{
		to = Math.abs(to);
		if(to > 1)to = 1;
		tweens.add({name:"fade",from:new Point(target.fade,0),to:new Point(to,0),trans:trans});
	}// fade()
	
	public function scale(to:Float,trans=Transitions.linear)
	{
		tweens.add({name:"scale",from:new Point(target.scale,0),to:new Point(to,0),trans:trans});
	}// scale()
	
	public function rotate(to:Point,trans=Transitions.linear)
	{
		tweens.add({name:"rot",from:target.rot,to:to,trans:trans});
	}// rotate()

	public function toString()
	{
		var s = "Tween(target: "+target.id+", duration: "+duration+"ms, ratio: "+ratio+", ";
		s += "tweens: ";
		for(tw in tweens)s += tw.name+", ";
		s += ")"; // 
		return s;
	}// toString()

}// abv.lib.anim.Tween

