package abv.lib.style;
/**
 * Background
 **/
import abv.lib.style.BgPosition;

@:dce
class Background{

	public var color:Null<Float> = null; 
	public var image:Null<String> = null;  
	public var repeat:Null<Int> = null; 
	public var position:Null<BgPosition> = null; 
	
	public inline function new(){ }

	public function toString()
	{
		return '{color: $color,image: $image,position: $position,repeat: $repeat}';
	}// toString()

}// abv.lib.style.Background

