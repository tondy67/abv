package abv.anim;

import abv.cpu.Timer;
import abv.math.Point;
import abv.anim.*;

using abv.sys.ST;
//
@:dce
class Tween{

@:allow(abv.anim.Juggler)
	var run = true;
	var counter = 0;
	var ratio = .0;
	var duration:Float;
	var repeat:Int;
	var time = .0;
	var start = .0;
	var delay:Float;
	var mirror:Bool;

	var func:Point->Point->Void;
	var trans:String;
	var path:Array<Point>;
	var segm = 0;
	var from:Point;
	var to:Point;
		
	public function new(path:Array<Point>,func:Point->Point->Void,duration = 1.,trans=TS.LINEAR,repeat=1,delay=0,mirror=false)
	{
		if(path == null){
			ST.error("null path");
			run = false;
		}else if(path.length < 2){
			ST.error("no path: "+ path.length);
			run = false;
		}else if(func == null){
			ST.error("null func");
			run = false;
		}

		this.path = path;
		this.func = func;
		this.duration = duration; 
		this.trans = trans;
		this.repeat = repeat;
		this.delay = delay;
		this.mirror = mirror;
	}// new()

@:allow(abv.anim.Juggler)
	function update()
	{
		if(!run)return;
		var delta:Point;
		var r:Float;
 			
		if(start == 0)start = Timer.stamp();
		time = Timer.stamp() - start; 

		if((counter == 0)&&(delay > 0)){
			if(time < delay)return; else time -= delay;
		}
		
		ratio = time / duration; 
		if(ratio <= 1){
			segm = Math.floor(ratio * (path.length-1)); 
			from = path[segm].clone(); 
			to = path[segm+1].clone(); 
			delta = to.sub(from);  //trace(delta+" "+from+":"+to);
			r = TS.get(trans)(ratio); //trace(delta+" : "+r);
			delta.scale(r);    
			try func(from,delta) catch(e:Dynamic){ST.error(e);} 
		}
	
		if (time < duration) { 
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

	public function toString()
	{
		var s = 'Tween(duration: $duration, ratio: $ratio, trans: $trans)';
		return s;
	}// toString()

}// abv.anim.Tween

