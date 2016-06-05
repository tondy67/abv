package abv.style;
/**
 * BoxShadow
 **/
class BoxShadow{

	public var h:Null<Float> 		= null; 
	public var v:Null<Float> 		= null;  
	public var blur:Null<Float> 	= null;  
	public var spread:Null<Float> 	= null;  
	public var color:Null<Color> 	= null; 
	
	public inline function new(){ }

	public function toString()
	{
		return '{h: $h, v: $v, blur: $blur, spread: $spread, color: $color}';
	}// toString()

}// abv.style.BoxShadow

