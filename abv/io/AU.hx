package abv.io;

#if flash
	typedef AU = abv.sys.flash.AU;
#elseif js
	typedef AU = abv.sys.js.AU;
#elseif android
	typedef AU = abv.sys.android.AU;
#elseif java
	typedef AU = abv.sys.java.AU;
#elseif (ios || engine)
	typedef AU = abv.sys.engine.AU;
#elseif (neko || cpp)
	typedef AU = abv.sys.cpp.AU;
#end
