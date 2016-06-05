package abv.style;
/**
 * Font
 **/

@:dce
class Font{

	public var name:Null<String> = null;
	public var size:Null<Float> = null;
	public var style:Null<Int> = null;
	public var src:Null<String> = null;
	
	public inline function new(){ }

	public function toString()
	{
		return '{name: $name, size: $size,style: $style,src: $src}';
	}// toString()

}// abv.style.Font

