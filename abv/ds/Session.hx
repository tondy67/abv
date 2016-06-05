package abv.ds;
/**
 * Session
 **/
using abv.sys.ST;

@:allow(abv.ds.Wallet)
class Session{

	var start:Float;
	var expire:Float;
	var data:MapSS;
		
	public function new(start:Float,expire:Float,data:MapSS)
	{
		this.start = start;
		this.expire = expire;
		this.data = data;
	}// new()

	public function toString()
	{
		return "Session()";
	}// toString()

}// abv.ds.Session

