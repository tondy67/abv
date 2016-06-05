package abv.io;

import abv.math.Point;
/**
 * Mouse
 **/
@:dce
class Input{

	public var click = false;
	public var start:Point;
	public var move:Point;
	public var delta:Point;
	public var last:Point;
	public var wheel = 0;
	public var keys:Array<Bool> = [];
	
	public function new()
	{
		start = new Point();
		move = new Point();
		delta = new Point();
		last = new Point();
	}// new()

	public function update()
	{
		if(move.eq(start))last.copy(start);
		if(click){
			delta = move.sub(last);
			last.copy(move);
		}else{
			delta.set(0,0);
		}; 
	}// update()
	
	public function toString() 
	{
        return 'Input(start: $start,click: $click,delta: $delta,move: $move,last: $last)';
    }// toString()

}// abv.io.Input

