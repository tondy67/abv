package abv.style;
/**
 * Fill
 **/
import abv.math.Rect;
import abv.factory.Component;

@:dce
class Fill{

	public var color:Null<Color>  = null; 
	public var image:Null<String> = null;  
	public var repeat:Null<Int>   = null; 
	public var tile:Null<Rect>    = null; 
	public var size:Null<Float>   = null; 
	
	public inline function new(){ }

	public inline function set(color:Color=0,image="",tile:Rect=null,repeat=0,size=1.) 
	{ 
		this.color 	= color;
		this.image 	= image;
		this.tile 	= tile;
		this.repeat	= repeat;
		this.size	= size;
	}// set()

	public inline function copy(v:Fill) 
	{ 
		if(v == null) return;
		color 	= v.color;
		image 	= v.image;
		repeat	= v.repeat;
		tile 	= v.tile;
		size 	= v.size;
	}// copy()

	public function toString()
	{
		return '{color: $color,image: $image,size: $size,tile: $tile,repeat: $repeat}';
	}// toString()

}// abv.style.Fill

