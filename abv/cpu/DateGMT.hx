package abv.cpu;
/**
 * DateGMT
 **/
 
using abv.sys.ST;

@:dce
class DateGMT{
	public var year(default,null):Int;
	public var month(default,null):Int;
	public var day(default,null):Int;
	public var hour(default,null):Int;
	public var min(default,null):Int;
	public var sec(default,null):Int;
	public var tz(default, null):Int;
	static inline var ms = 3600000;
	public var WeekDay(default,never):Map<String,Array<String>> = [
	"en" => ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"],
	];
	public var Month3(default,never):Map<String,Array<String>> = [
	"en" => ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"],
	];
	
	public function new(year=0, month=0, day=0, hour=0, min=0, sec=0, tz=0)
	{ 
		if (year == 0) {
			var n = now();
			set(n.year, n.month, n.day, n.hour, n.min, n.sec, n.tz);
		}else set(year, month, day, hour, min, sec, tz);
	}// new()

	public inline function set(year:Int, month:Int, day:Int, hour:Int, min:Int, sec:Int, tz:Int)
	{ 
		this.year = year;
		this.month = month;
		this.day = day;
		this.hour = hour;
		this.min = min;
		this.sec = sec;
		this.tz = tz;
	}// set()
	
	static public inline function now()
	{
		var n = Date.now(); 
		var y = n.getFullYear();
		var m = n.getMonth();
		var d = n.getDate();
		var h = n.getHours();
		var mn = n.getMinutes();
		var s = n.getSeconds();
		n = new Date(y, m, d, 0, 0, 0 );
		var t =  n.getTime(); 
		var z = Std.int(24 * Math.ceil(t / 24 / ms ) - t/ms);  
		return new DateGMT(y,m,d,h,mn,s,z);
	}// now()
		
	public inline function getDay()
	{
		var n = new Date(year, month, day, hour, min, sec);
		return n.getDay();
	}
	
	public inline function time()
	{
		return Date.now().getTime();
	}// time()

	public inline function utc()
	{
		var n = Date.fromTime(time() - tz * ms); 
		return new DateGMT(n.getFullYear(),n.getMonth(),n.getDate(),n.getHours(),n.getMinutes(),n.getSeconds(),0);
	}// utc()

	public function format(f:String,lg="en")
	{
		var s = "";
		var c = "";
		var len = f.length;
		var i = 0;
		while (i < len) {
			c = f.charAt(i);
			if (c == "%") {
				s += fc(f.charAt(i+1),lg);
				i += 2;
			}else {
				s += c;
				i++;
			}
			
		}
// %d/%b/%Y:%H:%M:%S		
// %a, %d %b %Y %H:%M:%S %z	
		return s;
	}// format()
	
	function fc(c:String,lg:String)
	{
		var s = "";
		switch(c) {
		case "a":
			s = WeekDay[lg][getDay()];
		case "b":
			s = Month3[lg][month];
		case "d":
			s = l(day);
		case "Y":
			s = ""+year;
		case "H":
			s = l(hour);
		case "M":
			s = l(min);
		case "S":
			s = l(sec);
		case "z":
			s = (tz >= 0?"+":"-") + l(tz) + "00";
			
		}
		return s;
	}// fc()
	
	inline function l(n:Int,c="0")
	{
		return StringTools.lpad(Std.string(n), c, 2);
		
	}// l()

	public static inline function dow(week:Array<String>=null)
	{
		var w = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"];
		if(week != null) w = week;
		return w[Date.now().getDay()];
	}
	
	public static inline function getMonth(months:Array<String>=null)
	{
		var m = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
		if(months != null) m = months;
		return m[Date.now().getMonth()];
	}
	
	public static inline function timezone()
	{
		var ms = 3600000;
		var now = Date.now();
		var y = now.getFullYear();
		var m = now.getMonth();
		var d = now.getDate();
		var n = new Date(y, m, d, 0, 0, 0 );
		var t =  n.getTime(); 
		return (24 * Math.ceil(t / 24 / ms ) - t/ms).i();  
	}// timezone();
	
	
	public function toString()
	{
		return year + "-" + l(month+1) + "-" + l(day) + " " + l(hour) + ":" + l(min) + ":" + l(sec);
		
	}// toString()
	
}// abv.cpu.DateGMT

