package abv.ui;
/**
 * ViewGL
 **/
#if (ios || engine)
	typedef ViewGL = abv.sys.engine.ui.ViewGL;
#elseif flash
	typedef ViewGL = abv.sys.flash.ui.ViewGL;
#elseif js
	typedef ViewGL = abv.sys.js.ui.ViewGL;
#elseif android
	typedef ViewGL = abv.sys.android.ui.ViewGL;
#elseif java
	typedef ViewGL = abv.sys.java.ui.ViewGL;
#elseif (neko || cpp)
	typedef ViewGL = abv.sys.cpp.ui.ViewGL;
#end

