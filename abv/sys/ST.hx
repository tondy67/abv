package abv.sys;

#if flash
typedef ST = abv.sys.flash.ST;
#elseif js
	#if gui
typedef ST = abv.sys.js.ST;
	#end
#elseif (cpp||neko)
typedef ST = abv.sys.cpp.ST;
#else
typedef ST = abv.sys.others.ST;
#end

// abv.sys.ST
