package abv;

#if (flash && engine)
	typedef ST = abv.sys.flash.ST;
#elseif (ios || engine)
	typedef ST = abv.sys.engine.ST;
#elseif flash
	typedef ST = abv.sys.flash.ST;
#elseif (js && gui)
	typedef ST = abv.sys.jsgui.ST;
#elseif (cpp||neko)
	typedef ST = abv.sys.cpp.ST;
#elseif android
	typedef ST = abv.sys.android.ST;
#elseif (java && gui)
	typedef ST = abv.sys.javagui.ST;
#else
	typedef ST = abv.sys.none.ST;
#end

// abv.ST
