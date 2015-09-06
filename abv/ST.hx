package abv;

#if flash
	typedef ST = abv.sys.flash.ST;
#elseif (js && gui)
	typedef ST = abv.sys.jsgui.ST;
#elseif (cpp||neko)
	typedef ST = abv.sys.cpp.ST;
#elseif (java && gui)
	typedef ST = abv.sys.javagui.ST;
#else
	typedef ST = abv.sys.others.ST;
#end

// abv.ST
